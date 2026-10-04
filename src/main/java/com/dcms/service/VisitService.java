package com.dcms.service;

import com.dcms.dao.AppointmentDAO;
import com.dcms.dao.VisitDAO;
import com.dcms.model.Appointment;
import com.dcms.model.Visit;

import java.time.LocalDateTime;
import java.util.List;

/**
 * VisitService implements core domain rules for Patient encounters and Clinic Reception.
 * ENFORCES NON-NEGOTIABLE RULE 1:
 * - Appointment != Visit
 * - An Appointment cannot become a Visit without explicit Check-in.
 * - Walk-in patients create a Visit directly without an Appointment.
 */
public class VisitService {

    private final VisitDAO visitDAO;
    private final AppointmentDAO appointmentDAO;

    public VisitService() {
        this.visitDAO = new VisitDAO();
        this.appointmentDAO = new AppointmentDAO();
    }

    public VisitService(VisitDAO visitDAO, AppointmentDAO appointmentDAO) {
        this.visitDAO = visitDAO;
        this.appointmentDAO = appointmentDAO;
    }

    /**
     * Checks in a scheduled patient when they physically arrive at the clinic.
     * Transitions Appointment status to 'Arrived' and spawns a new Visit in 'Waiting' status.
     * @param appointmentId valid appointment ID
     * @return created Visit entity
     */
    public Visit checkInPatient(int appointmentId) {
        Appointment appt = appointmentDAO.findById(appointmentId);
        if (appt == null) {
            throw new IllegalArgumentException("Không tìm thấy lịch hẹn với mã: " + appointmentId);
        }

        if (Appointment.STATUS_ARRIVED.equalsIgnoreCase(appt.getStatus())) {
            throw new IllegalStateException("Lịch hẹn này đã được tiếp đón (Check-in) trước đó!");
        }

        if (!appt.canBeCheckedIn()) {
            throw new IllegalStateException(
                    "Không thể check-in lịch hẹn đang ở trạng thái: " + appt.getStatus() +
                    " (Chỉ cho phép tiếp đón lịch hẹn Pending hoặc Confirmed)"
            );
        }

        // 1. Transition Appointment status to Arrived
        boolean updated = appointmentDAO.updateStatus(appointmentId, Appointment.STATUS_ARRIVED);
        if (!updated) {
            throw new RuntimeException("Không thể cập nhật trạng thái lịch hẹn sang Arrived");
        }

        // 2. Instantiate and persist new Visit in Waiting status
        Visit visit = new Visit();
        visit.setPatientId(appt.getPatientId());
        visit.setPrimaryDentistId(appt.getDentistId());
        visit.setAppointmentId(appt.getAppointmentId()); // Linked
        visit.setCheckInTime(LocalDateTime.now());
        visit.setStatus(Visit.STATUS_WAITING);
        visit.setVisitType(Visit.TYPE_SCHEDULED);
        visit.setNotes(appt.getReason() != null ? "Lịch hẹn: " + appt.getReason() : "Tiếp đón theo lịch hẹn");

        int visitId = visitDAO.create(visit);
        if (visitId <= 0) {
            throw new RuntimeException("Lỗi hệ thống: Không thể khởi tạo lượt khám thực tế (Visit)");
        }
        visit.setVisitId(visitId);
        return visit;
    }

    /**
     * Registers a Walk-in or Emergency patient without prior appointment.
     * NON-NEGOTIABLE RULE: AppointmentId MUST be null.
     */
    public Visit createWalkInVisit(int patientId, int dentistId, String visitType, String notes) {
        if (patientId <= 0) {
            throw new IllegalArgumentException("Vui lòng chọn bệnh nhân");
        }
        if (dentistId <= 0) {
            throw new IllegalArgumentException("Vui lòng chọn bác sĩ phụ trách");
        }

        String type = (visitType != null && !visitType.trim().isEmpty()) ? visitType.trim() : Visit.TYPE_WALK_IN;

        Visit visit = new Visit();
        visit.setPatientId(patientId);
        visit.setPrimaryDentistId(dentistId);
        visit.setAppointmentId(null); // MANDATORY: NULL for walk-ins
        visit.setCheckInTime(LocalDateTime.now());
        visit.setStatus(Visit.STATUS_WAITING);
        visit.setVisitType(type);
        visit.setNotes(notes != null ? notes.trim() : "Khách vãng lai");

        int visitId = visitDAO.create(visit);
        if (visitId <= 0) {
            throw new RuntimeException("Lỗi hệ thống: Không thể khởi tạo lượt khám vãng lai");
        }
        visit.setVisitId(visitId);
        return visit;
    }

    public List<Visit> getTodayWaitingQueue(Integer dentistId) {
        return visitDAO.getWaitingQueue(dentistId);
    }

    public boolean startExamination(int visitId) {
        Visit v = visitDAO.findById(visitId);
        if (v == null) {
            throw new IllegalArgumentException("Không tìm thấy lượt khám với mã: " + visitId);
        }
        if (!Visit.STATUS_WAITING.equalsIgnoreCase(v.getStatus())) {
            throw new IllegalStateException("Lượt khám không ở trạng thái Waiting để bắt đầu");
        }
        return visitDAO.updateStatus(visitId, Visit.STATUS_IN_PROGRESS);
    }

    public boolean completeVisit(int visitId) {
        Visit v = visitDAO.findById(visitId);
        if (v == null) {
            throw new IllegalArgumentException("Không tìm thấy lượt khám với mã: " + visitId);
        }
        return visitDAO.updateStatus(visitId, Visit.STATUS_COMPLETED);
    }

    public Visit getVisitById(int visitId) {
        return visitDAO.findById(visitId);
    }
}
