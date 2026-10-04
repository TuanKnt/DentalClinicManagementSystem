package com.dcms.controller;

import com.dcms.model.Patient;
import com.dcms.service.PatientService;
import com.dcms.service.exception.PatientValidationException;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

/**
 * PatientServlet handles patient record administration (CRUD & Search).
 */
@WebServlet(name = "PatientServlet", urlPatterns = {
        "/reception/patients",
        "/reception/patients/create",
        "/reception/patients/edit",
        "/reception/patients/search-ajax"
})
public class PatientServlet extends HttpServlet {

    private PatientService patientService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        this.patientService = new PatientService();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        if ("/reception/patients/search-ajax".equals(servletPath)) {
            handleAjaxSearch(request, response);
            return;
        }

        if ("/reception/patients/create".equals(servletPath)) {
            request.getRequestDispatcher("/WEB-INF/views/receptionist/patient-form.jsp").forward(request, response);
            return;
        }

        if ("/reception/patients/edit".equals(servletPath)) {
            handleShowEdit(request, response);
            return;
        }

        // Default: list / search page
        handleList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String servletPath = request.getServletPath();

        if ("/reception/patients/edit".equals(servletPath)) {
            handleUpdate(request, response);
            return;
        }

        handleCreate(request, response);
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        int page = 1;
        int pageSize = 10;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Math.max(1, Integer.parseInt(pageParam));
            } catch (NumberFormatException ignored) {}
        }

        List<Patient> list = patientService.searchPatients(keyword, page, pageSize);
        int total = patientService.countPatients(keyword);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("patientList", list);
        request.setAttribute("keyword", keyword);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", total);

        request.getRequestDispatcher("/WEB-INF/views/receptionist/patient-list.jsp").forward(request, response);
    }

    private void handleAjaxSearch(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        String keyword = request.getParameter("q");
        List<Patient> list = patientService.searchPatients(keyword, 1, 10);
        response.getWriter().write(gson.toJson(list));
    }

    private void handleShowEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        try {
            int patientId = Integer.parseInt(idParam);
            Patient patient = patientService.getPatientById(patientId);
            if (patient == null) {
                response.sendRedirect(request.getContextPath() + "/reception/patients?error=notfound");
                return;
            }
            request.setAttribute("patient", patient);
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/WEB-INF/views/receptionist/patient-form.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/reception/patients");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Patient patient = extractPatientFromRequest(request);

        try {
            patientService.createPatient(patient);
            response.sendRedirect(request.getContextPath() + "/reception/patients?success=created");
        } catch (PatientValidationException ex) {
            request.setAttribute("errorMessage", ex.getMessage());
            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/WEB-INF/views/receptionist/patient-form.jsp").forward(request, response);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Patient patient = extractPatientFromRequest(request);
        String idParam = request.getParameter("patientId");

        try {
            patient.setPatientId(Integer.parseInt(idParam));
            patientService.updatePatient(patient);
            response.sendRedirect(request.getContextPath() + "/reception/patients?success=updated");
        } catch (Exception ex) {
            request.setAttribute("errorMessage", ex.getMessage());
            request.setAttribute("patient", patient);
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/WEB-INF/views/receptionist/patient-form.jsp").forward(request, response);
        }
    }

    private Patient extractPatientFromRequest(HttpServletRequest request) {
        Patient p = new Patient();
        p.setFullName(request.getParameter("fullName"));
        p.setGender(request.getParameter("gender"));
        p.setPhone(request.getParameter("phone"));
        p.setCitizenId(request.getParameter("citizenId"));
        p.setAddress(request.getParameter("address"));
        p.setMedicalAlerts(request.getParameter("medicalAlerts"));
        p.setAllergies(request.getParameter("allergies"));
        p.setEmergencyContact(request.getParameter("emergencyContact"));

        String dobStr = request.getParameter("dob");
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                p.setDob(LocalDate.parse(dobStr.trim()));
            } catch (DateTimeParseException ignored) {}
        }
        return p;
    }
}
