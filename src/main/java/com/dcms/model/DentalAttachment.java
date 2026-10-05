package com.dcms.model;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * DentalAttachment entity representing radiographic imaging (X-Ray), intraoral photos,
 * and diagnostic documents linked to a patient and/or visit (BF-02).
 */
public class DentalAttachment implements Serializable {
    private static final long serialVersionUID = 1L;

    public static final String TYPE_XRAY = "XRay";
    public static final String TYPE_XRAY_PANORAMA = "X-Ray Panorama";
    public static final String TYPE_PERIAPICAL = "Periapical";
    public static final String TYPE_INTRAORAL_PHOTO = "IntraoralPhoto";
    public static final String TYPE_DOCUMENT = "Document";

    private int attachmentId;
    private int patientId;
    private Integer visitId;
    private String fileName;
    private String fileType; // X-Ray Panorama, Periapical, IntraoralPhoto, Document
    private String filePath;
    private String notes;
    private Integer uploadedBy;
    private LocalDateTime uploadedAt;

    public Integer getUploadedBy() {
        return uploadedBy;
    }

    public void setUploadedBy(Integer uploadedBy) {
        this.uploadedBy = uploadedBy;
    }

    public DentalAttachment() {
        this.uploadedAt = LocalDateTime.now();
    }

    public DentalAttachment(int patientId, Integer visitId, String fileName, String fileType, String filePath, String notes) {
        this.patientId = patientId;
        this.visitId = visitId;
        this.fileName = fileName;
        this.fileType = fileType;
        this.filePath = filePath;
        this.notes = notes;
        this.uploadedAt = LocalDateTime.now();
    }

    public int getAttachmentId() {
        return attachmentId;
    }

    public void setAttachmentId(int attachmentId) {
        this.attachmentId = attachmentId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public Integer getVisitId() {
        return visitId;
    }

    public void setVisitId(Integer visitId) {
        this.visitId = visitId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }
}
