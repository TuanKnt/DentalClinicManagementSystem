package com.dcms.controller;

import com.google.gson.Gson;
import com.dcms.model.ToothFinding;
import com.dcms.model.User;
import com.dcms.service.ClinicalService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * AJAX endpoint for asynchronous odontogram dental chart operations.
 * Supports loading findings for a patient/visit, recording surface findings, and removing findings.
 */
@WebServlet(name = "OdontogramAjaxServlet", urlPatterns = {"/clinical/odontogram-ajax"})
public class OdontogramAjaxServlet extends HttpServlet {

    private final ClinicalService clinicalService;
    private final Gson gson;

    public OdontogramAjaxServlet() {
        this.clinicalService = new ClinicalService();
        this.gson = new Gson();
    }

    public OdontogramAjaxServlet(ClinicalService clinicalService) {
        this.clinicalService = clinicalService;
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        String patientIdParam = request.getParameter("patientId");
        String visitIdParam = request.getParameter("visitId");

        List<ToothFinding> findings;
        if (visitIdParam != null && !visitIdParam.trim().isEmpty()) {
            try {
                int visitId = Integer.parseInt(visitIdParam.trim());
                findings = clinicalService.getToothFindingsByVisit(visitId);
            } catch (NumberFormatException e) {
                sendErrorResponse(response, "Mã lượt khám không hợp lệ");
                return;
            }
        } else if (patientIdParam != null && !patientIdParam.trim().isEmpty()) {
            try {
                int patientId = Integer.parseInt(patientIdParam.trim());
                findings = clinicalService.getToothFindingsByPatient(patientId);
            } catch (NumberFormatException e) {
                sendErrorResponse(response, "Mã bệnh nhân không hợp lệ");
                return;
            }
        } else {
            sendErrorResponse(response, "Cần cung cấp patientId hoặc visitId");
            return;
        }

        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(findings));
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            handleDeleteFinding(request, response);
            return;
        }

        // Default action: add / record tooth finding
        handleAddFinding(request, response);
    }

    private void handleAddFinding(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            int visitId = Integer.parseInt(request.getParameter("visitId"));
            int toothNumber = Integer.parseInt(request.getParameter("toothNumber"));
            String surface = request.getParameter("surface");
            String condition = request.getParameter("condition");
            String notes = request.getParameter("notes");

            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
            Integer recordedBy = (currentUser != null) ? currentUser.getUserId() : null;

            ToothFinding finding = new ToothFinding();
            finding.setPatientId(patientId);
            finding.setVisitId(visitId);
            finding.setToothNumber(toothNumber);
            finding.setSurface(surface != null ? surface.trim() : null);
            finding.setCondition(condition != null ? condition.trim() : ToothFinding.COND_CARIES);
            finding.setNotes(notes != null ? notes.trim() : "");
            finding.setRecordedBy(recordedBy);

            int findingId = clinicalService.recordToothFinding(finding);

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("findingId", findingId);
            result.put("toothNumber", toothNumber);
            result.put("surface", finding.getSurface());
            result.put("condition", finding.getCondition());
            result.put("notes", finding.getNotes());

            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(result));
                out.flush();
            }
        } catch (Exception e) {
            sendErrorResponse(response, e.getMessage());
        }
    }

    private void handleDeleteFinding(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int findingId = Integer.parseInt(request.getParameter("findingId"));
            boolean deleted = clinicalService.removeToothFinding(findingId);

            Map<String, Object> result = new HashMap<>();
            result.put("success", deleted);
            result.put("findingId", findingId);

            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(result));
                out.flush();
            }
        } catch (Exception e) {
            sendErrorResponse(response, e.getMessage());
        }
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(error));
            out.flush();
        }
    }
}
