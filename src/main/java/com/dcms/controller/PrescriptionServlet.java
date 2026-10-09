package com.dcms.controller;

import com.dcms.dao.DentistDAO;
import com.dcms.dao.PatientDAO;
import com.dcms.dao.VisitDAO;
import com.dcms.model.Dentist;
import com.dcms.model.Medicine;
import com.dcms.model.Patient;
import com.dcms.model.Prescription;
import com.dcms.model.PrescriptionItem;
import com.dcms.model.User;
import com.dcms.model.Visit;
import com.dcms.service.PrescriptionService;
import com.dcms.service.exception.BusinessRuleViolationException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Controller for Electronic Prescriptions & Clinical Printing (UC27, UC28).
 * Managed by Kiên (Pharmacy & E-Prescriptions).
 */
@WebServlet(name = "PrescriptionServlet", urlPatterns = {
        "/prescription/form",
        "/prescription/save",
        "/prescription/view",
        "/prescription/print",
        "/prescription/list",
        "/prescription/cancel"
})
public class PrescriptionServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PrescriptionServlet.class.getName());

    private PrescriptionService prescriptionService;
    private VisitDAO visitDAO;
    private PatientDAO patientDAO;
    private DentistDAO dentistDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.prescriptionService = new PrescriptionService();
        this.visitDAO = new VisitDAO();
        this.patientDAO = new PatientDAO();
        this.dentistDAO = new DentistDAO();
    }

    public PrescriptionServlet() {
        super();
    }

    // Constructor for testing / dependency injection
    public PrescriptionServlet(PrescriptionService prescriptionService, VisitDAO visitDAO,
                               PatientDAO patientDAO, DentistDAO dentistDAO) {
        this.prescriptionService = prescriptionService;
        this.visitDAO = visitDAO;
        this.patientDAO = patientDAO;
        this.dentistDAO = dentistDAO;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/prescription/form":
                showPrescriptionForm(request, response);
                break;
            case "/prescription/print":
                showPrescriptionPrint(request, response);
                break;
            case "/prescription/view":
                showPrescriptionDetail(request, response);
                break;
            case "/prescription/list":
                showPrescriptionList(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/dentist/queue");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/prescription/save":
                handleSavePrescription(request, response);
                break;
            case "/prescription/cancel":
                handleCancelPrescription(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/dentist/queue");
                break;
        }
    }

    private void showPrescriptionForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String visitIdParam = request.getParameter("visitId");
        if (visitIdParam == null || visitIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dentist/queue?error=" +
                    URLEncoder.encode("Thiếu mã lượt khám bệnh.", StandardCharsets.UTF_8));
            return;
        }

        try {
            int visitId = Integer.parseInt(visitIdParam.trim());
            Visit visit = visitDAO.findById(visitId);
            if (visit == null) {
                response.sendRedirect(request.getContextPath() + "/dentist/queue?error=" +
                        URLEncoder.encode("Buổi khám #" + visitId + " không tồn tại.", StandardCharsets.UTF_8));
                return;
            }

            Patient patient = patientDAO.findById(visit.getPatientId());
            Dentist dentist = dentistDAO.findById(visit.getPrimaryDentistId());
            List<Medicine> medicines = prescriptionService.getActiveMedicines();
            Prescription existingRx = prescriptionService.getPrescriptionByVisit(visitId);

            request.setAttribute("visit", visit);
            request.setAttribute("patient", patient);
            request.setAttribute("dentist", dentist);
            request.setAttribute("medicines", medicines);
            request.setAttribute("existingRx", existingRx);

            request.getRequestDispatcher("/WEB-INF/views/prescription/prescription-form.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/dentist/queue?error=" +
                    URLEncoder.encode("Mã lượt khám không hợp lệ.", StandardCharsets.UTF_8));
        }
    }

    private void handleSavePrescription(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        String visitIdParam = request.getParameter("visitId");
        String diagnosis = request.getParameter("diagnosis");
        String advice = request.getParameter("advice");

        String[] medicineIds = request.getParameterValues("medicineId");
        String[] quantities = request.getParameterValues("quantity");
        String[] dosages = request.getParameterValues("dosage");
        String[] durations = request.getParameterValues("durationDays");
        String[] notes = request.getParameterValues("notes");

        int visitId;
        try {
            visitId = Integer.parseInt(visitIdParam != null ? visitIdParam.trim() : "-1");
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/dentist/queue?error=" +
                    URLEncoder.encode("Mã lượt khám không hợp lệ.", StandardCharsets.UTF_8));
            return;
        }

        int dentistId = (currentUser != null) ? currentUser.getUserId() : 3;

        List<PrescriptionItem> items = new ArrayList<>();
        if (medicineIds != null && quantities != null && dosages != null) {
            for (int i = 0; i < medicineIds.length; i++) {
                try {
                    int medId = Integer.parseInt(medicineIds[i].trim());
                    int qty = Integer.parseInt(quantities[i].trim());
                    String dsg = dosages[i] != null ? dosages[i].trim() : "";
                    int dur = (durations != null && i < durations.length && !durations[i].trim().isEmpty())
                            ? Integer.parseInt(durations[i].trim()) : 5;
                    String nt = (notes != null && i < notes.length) ? notes[i].trim() : "";

                    if (medId > 0 && qty > 0) {
                        PrescriptionItem item = new PrescriptionItem();
                        item.setMedicineId(medId);
                        item.setQuantity(qty);
                        item.setDosage(dsg);
                        item.setDurationDays(dur);
                        item.setNotes(nt);
                        items.add(item);
                    }
                } catch (NumberFormatException ignored) {}
            }
        }

        try {
            Prescription createdRx = prescriptionService.issuePrescription(visitId, dentistId, diagnosis, advice, items);
            response.sendRedirect(request.getContextPath() + "/prescription/view?id=" + createdRx.getPrescriptionId() + "&msg=created");
        } catch (BusinessRuleViolationException brv) {
            response.sendRedirect(request.getContextPath() + "/prescription/form?visitId=" + visitId +
                    "&error=" + URLEncoder.encode(brv.getMessage(), StandardCharsets.UTF_8));
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error issuing prescription for visit: " + visitId, ex);
            response.sendRedirect(request.getContextPath() + "/prescription/form?visitId=" + visitId +
                    "&error=" + URLEncoder.encode("Lỗi hệ thống: " + ex.getMessage(), StandardCharsets.UTF_8));
        }
    }

    private void showPrescriptionPrint(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã đơn thuốc.");
            return;
        }

        try {
            int prescriptionId = Integer.parseInt(idParam.trim());
            Prescription prescription = prescriptionService.getPrescriptionDetail(prescriptionId);
            request.setAttribute("prescription", prescription);
            request.getRequestDispatcher("/WEB-INF/views/prescription/prescription-print.jsp").forward(request, response);
        } catch (BusinessRuleViolationException brv) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, brv.getMessage());
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã đơn thuốc không hợp lệ.");
        }
    }

    private void showPrescriptionDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/dentist/queue");
            return;
        }

        try {
            int prescriptionId = Integer.parseInt(idParam.trim());
            Prescription prescription = prescriptionService.getPrescriptionDetail(prescriptionId);
            request.setAttribute("prescription", prescription);
            request.getRequestDispatcher("/WEB-INF/views/prescription/prescription-view.jsp").forward(request, response);
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/dentist/queue?error=" +
                    URLEncoder.encode("Không tìm thấy đơn thuốc: " + ex.getMessage(), StandardCharsets.UTF_8));
        }
    }

    private void showPrescriptionList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String patientIdParam = request.getParameter("patientId");
        if (patientIdParam != null && !patientIdParam.trim().isEmpty()) {
            try {
                int patientId = Integer.parseInt(patientIdParam.trim());
                List<Prescription> list = prescriptionService.getPrescriptionsByPatient(patientId);
                Patient patient = patientDAO.findById(patientId);
                request.setAttribute("prescriptions", list);
                request.setAttribute("patient", patient);
                request.getRequestDispatcher("/WEB-INF/views/prescription/prescription-list.jsp").forward(request, response);
                return;
            } catch (NumberFormatException ignored) {}
        }
        response.sendRedirect(request.getContextPath() + "/dentist/queue");
    }

    private void handleCancelPrescription(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        String reason = request.getParameter("reason");
        try {
            int id = Integer.parseInt(idParam.trim());
            prescriptionService.cancelPrescription(id, reason);
            response.sendRedirect(request.getContextPath() + "/prescription/view?id=" + id + "&msg=cancelled");
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/dentist/queue?error=" +
                    URLEncoder.encode("Không thể hủy đơn thuốc: " + ex.getMessage(), StandardCharsets.UTF_8));
        }
    }
}
