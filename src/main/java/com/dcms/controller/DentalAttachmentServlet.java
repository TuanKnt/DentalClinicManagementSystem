package com.dcms.controller;

import com.dcms.model.DentalAttachment;
import com.dcms.model.User;
import com.dcms.service.ClinicalService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller handling dental image and document attachments (X-rays, Intraoral photos, CBCT/OPG).
 */
@WebServlet(name = "DentalAttachmentServlet", urlPatterns = {"/clinical/attachments"})
public class DentalAttachmentServlet extends HttpServlet {

    private final ClinicalService clinicalService;

    public DentalAttachmentServlet() {
        this.clinicalService = new ClinicalService();
    }

    public DentalAttachmentServlet(ClinicalService clinicalService) {
        this.clinicalService = clinicalService;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("delete".equalsIgnoreCase(action)) {
            handleDelete(request, response);
            return;
        }

        // Add attachment
        handleAddAttachment(request, response);
    }

    private void handleAddAttachment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String patientIdParam = request.getParameter("patientId");
        String visitIdParam = request.getParameter("visitId");
        String fileType = request.getParameter("fileType");
        String fileName = request.getParameter("fileName");
        String filePath = request.getParameter("filePath");
        String notes = request.getParameter("notes");
        String returnUrl = request.getParameter("returnUrl");

        try {
            int patientId = Integer.parseInt(patientIdParam.trim());
            Integer visitId = (visitIdParam != null && !visitIdParam.trim().isEmpty())
                    ? Integer.parseInt(visitIdParam.trim())
                    : null;

            if (fileName == null || fileName.trim().isEmpty()) {
                fileName = "Hinh_Anh_Nha_Khoa_" + System.currentTimeMillis();
            }
            if (filePath == null || filePath.trim().isEmpty()) {
                // If not provided, fallback to standard mock placeholder or uploaded image asset
                filePath = "assets/images/dental-sample-xray.jpg";
            }
            if (fileType == null || fileType.trim().isEmpty()) {
                fileType = DentalAttachment.TYPE_XRAY;
            }

            HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
            Integer uploadedBy = (currentUser != null) ? currentUser.getUserId() : null;

            DentalAttachment attachment = new DentalAttachment();
            attachment.setPatientId(patientId);
            attachment.setVisitId(visitId);
            attachment.setFileType(fileType.trim());
            attachment.setFileName(fileName.trim());
            attachment.setFilePath(filePath.trim());
            attachment.setNotes(notes != null ? notes.trim() : "");
            attachment.setUploadedBy(uploadedBy);

            clinicalService.addAttachment(attachment);

            if (returnUrl != null && !returnUrl.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + returnUrl + (returnUrl.contains("?") ? "&" : "?") + "success=attachment_added");
            } else if (visitId != null) {
                response.sendRedirect(request.getContextPath() + "/clinical/examination?visitId=" + visitId + "&tab=attachments&success=attachment_added");
            } else {
                response.sendRedirect(request.getContextPath() + "/reception/patients/detail?id=" + patientId + "&success=attachment_added");
            }
        } catch (Exception ex) {
            if (returnUrl != null && !returnUrl.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + returnUrl + (returnUrl.contains("?") ? "&" : "?") + "error=" + java.net.URLEncoder.encode(ex.getMessage(), "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/reception/patients?error=" + java.net.URLEncoder.encode(ex.getMessage(), "UTF-8"));
            }
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String attachmentIdParam = request.getParameter("attachmentId");
        String returnUrl = request.getParameter("returnUrl");

        try {
            int attachmentId = Integer.parseInt(attachmentIdParam.trim());
            clinicalService.removeAttachment(attachmentId);

            if (returnUrl != null && !returnUrl.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + returnUrl + (returnUrl.contains("?") ? "&" : "?") + "success=attachment_deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/reception/patients");
            }
        } catch (Exception ex) {
            response.sendRedirect(request.getContextPath() + "/reception/patients?error=" + java.net.URLEncoder.encode(ex.getMessage(), "UTF-8"));
        }
    }
}
