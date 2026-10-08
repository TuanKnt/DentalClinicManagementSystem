package com.dcms.service;

import com.dcms.dao.AppointmentDAO;
import com.dcms.dao.DentistScheduleDAO;
import com.dcms.model.Appointment;
import com.dcms.model.DentistSchedule;
import com.dcms.service.exception.AppointmentConflictException;
import com.dcms.service.exception.DentistNotAvailableException;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

/**
 * AppointmentService handles business invariants and validations for dental appointments.
 * NON-NEGOTIABLE RULE: Appointment != Visit.
 */
public class AppointmentService {

    private final AppointmentDAO appointmentDAO;
    private final DentistScheduleDAO scheduleDAO;

    public AppointmentService() {
        this.appointmentDAO = new AppointmentDAO();
        this.scheduleDAO = new DentistScheduleDAO();
    }

    public AppointmentService(AppointmentDAO appointmentDAO, DentistScheduleDAO scheduleDAO) {
        this.appointmentDAO = appointmentDAO;
        this.scheduleDAO = scheduleDAO;
    }

    /**
     * Books a new appointment with schedule verification and overlap checking.
     * @param appt appointment entity
     * @return saved appointment with generated ID
     */
    public Appointment bookAppointment(Appointment appt) {
        validateAppointmentInput(appt);

        // 1. Check if dentist is scheduled to work on that day of week & shift
        int dayOfWeek = appt.getAppointmentDate().getDayOfWeek().getValue(); // 1=Mon .. 7=Sun
        boolean isWorking = scheduleDAO.isDentistWorking(
                appt.getDentistId(), dayOfWeek, appt.getStartTime(), appt.getEndTime()
        );
        if (!isWorking) {
            String dayName = (dayOfWeek == 7 ? "Chủ Nhật" : ("Thứ " + (dayOfWeek + 1)));
            if (!scheduleDAO.hasAnySchedule(appt.getDentistId())) {
                throw new DentistNotAvailableException(
                        "Bác sĩ hiện chưa được thiết lập ca trực nào trong hệ thống. " +
                        "Vui lòng vào menu 'Lịch Trực Bác Sĩ' để cấu hình ca trực trước khi đặt hẹn."
                );
            }
            List<DentistSchedule> dayShifts = scheduleDAO.listSchedulesByDentistAndDay(appt.getDentistId(), dayOfWeek);
            if (dayShifts == null || dayShifts.isEmpty()) {
                throw new DentistNotAvailableException(
                        "Bác sĩ không có lịch trực vào " + dayName + ". " +
                        "Vui lòng chọn ngày khám khác hoặc đổi bác sĩ điều trị."
                );
            }
            StringBuilder shiftsText = new StringBuilder();
            for (DentistSchedule s : dayShifts) {
                if (shiftsText.length() > 0) shiftsText.append(", ");
                shiftsText.append(s.getShiftStart()).append(" - ").append(s.getShiftEnd());
            }
            throw new DentistNotAvailableException(
                    "Bác sĩ không có ca trực nhận hẹn vào khung giờ " + appt.getStartTime() + " - " +
                    appt.getEndTime() + " (" + dayName + "). Khung giờ trực của bác sĩ vào " + dayName + " là: " + shiftsText + "."
            );
        }

        // 2. Overlap conflict checking (Strict Domain Invariant)
        int conflicts = appointmentDAO.countConflicts(
                appt.getDentistId(), appt.getAppointmentDate(),
                appt.getStartTime(), appt.getEndTime(), null
        );
        if (conflicts > 0) {
            throw new AppointmentConflictException(
                    "Khung giờ " + appt.getStartTime() + " - " + appt.getEndTime() +
                    " ngày " + appt.getAppointmentDate() + " của Bác sĩ đã bị trùng với lịch hẹn khác."
            );
        }

        if (appt.getStatus() == null || appt.getStatus().trim().isEmpty()) {
            appt.setStatus(Appointment.STATUS_PENDING);
        }

        int id = appointmentDAO.create(appt);
        if (id <= 0) {
            throw new RuntimeException("Lỗi hệ thống: Không thể lưu lịch hẹn vào cơ sở dữ liệu");
        }
        appt.setAppointmentId(id);
        return appt;
    }

    /**
     * Cancels an appointment with stated reason.
     * Rule: Cannot cancel if patient already arrived or completed.
     */
    public boolean cancelAppointment(int appointmentId, String reason) {
        Appointment appt = appointmentDAO.findById(appointmentId);
        if (appt == null) {
            throw new IllegalArgumentException("Không tìm thấy lịch hẹn với mã: " + appointmentId);
        }

        if (!appt.canBeCancelled()) {
            throw new IllegalStateException("Không thể hủy lịch hẹn đã tiếp đón (Arrived) hoặc đã hoàn thành (Completed)");
        }

        String cancelReason = (reason != null && !reason.trim().isEmpty()) ? reason.trim() : "Khách yêu cầu hủy";
        return appointmentDAO.cancelWithReason(appointmentId, cancelReason);
    }

    public boolean confirmAppointment(int appointmentId) {
        Appointment appt = appointmentDAO.findById(appointmentId);
        if (appt == null) {
            throw new IllegalArgumentException("Không tìm thấy lịch hẹn với mã: " + appointmentId);
        }
        if (!Appointment.STATUS_PENDING.equalsIgnoreCase(appt.getStatus())) {
            throw new IllegalStateException("Chỉ có thể xác nhận lịch hẹn đang ở trạng thái 'Pending'");
        }
        return appointmentDAO.updateStatus(appointmentId, Appointment.STATUS_CONFIRMED);
    }

    /**
     * Moves a pending/confirmed appointment to a new slot while preserving its
     * appointment ID and audit timestamps. Arrived/completed/cancelled visits
     * are immutable from the scheduling screen.
     */
    public boolean rescheduleAppointment(int appointmentId, LocalDate newDate,
                                         LocalTime newStart, LocalTime newEnd) {
        Appointment appt = appointmentDAO.findById(appointmentId);
        if (appt == null) {
            throw new IllegalArgumentException("Không tìm thấy lịch hẹn với mã: " + appointmentId);
        }
        if (!appt.canBeRescheduled()) {
            throw new IllegalStateException("Chỉ có thể đổi lịch hẹn đang Pending hoặc Confirmed");
        }
        if (newDate == null || newStart == null || newEnd == null) {
            throw new IllegalArgumentException("Ngày và khung giờ mới là bắt buộc");
        }
        if (newDate.isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Không thể chuyển lịch về ngày trong quá khứ");
        }
        if (newDate.equals(LocalDate.now()) && !newStart.isAfter(LocalTime.now())) {
            throw new IllegalArgumentException("Khung giờ mới trong ngày hôm nay đã qua");
        }
        if (!newEnd.isAfter(newStart)) {
            throw new IllegalArgumentException("Giờ kết thúc phải sau giờ bắt đầu");
        }

        int dayOfWeek = newDate.getDayOfWeek().getValue();
        if (!scheduleDAO.isDentistWorking(appt.getDentistId(), dayOfWeek, newStart, newEnd)) {
            String dayName = (dayOfWeek == 7 ? "Chủ Nhật" : ("Thứ " + (dayOfWeek + 1)));
            throw new DentistNotAvailableException("Bác sĩ không có ca trực nhận hẹn vào khung giờ "
                    + newStart + " - " + newEnd + " (" + dayName + ")");
        }

        int conflicts = appointmentDAO.countConflicts(appt.getDentistId(), newDate, newStart, newEnd, appointmentId);
        if (conflicts > 0) {
            throw new AppointmentConflictException("Khung giờ mới đã bị trùng với lịch hẹn khác của bác sĩ");
        }
        if (!appointmentDAO.updateSchedule(appointmentId, newDate, newStart, newEnd)) {
            throw new RuntimeException("Không thể cập nhật khung giờ lịch hẹn");
        }
        return true;
    }

    public Appointment getAppointmentById(int appointmentId) {
        return appointmentDAO.findById(appointmentId);
    }

    public List<Appointment> getAppointmentsForDate(LocalDate date, Integer dentistId) {
        if (date == null) {
            date = LocalDate.now();
        }
        return appointmentDAO.listAppointmentsByDate(date, dentistId);
    }

    private void validateAppointmentInput(Appointment appt) {
        if (appt == null) {
            throw new IllegalArgumentException("Dữ liệu lịch hẹn không được để trống");
        }
        if (appt.getPatientId() <= 0) {
            throw new IllegalArgumentException("Vui lòng chọn bệnh nhân");
        }
        if (appt.getDentistId() <= 0) {
            throw new IllegalArgumentException("Vui lòng chọn bác sĩ phụ trách");
        }
        if (appt.getAppointmentDate() == null) {
            throw new IllegalArgumentException("Ngày hẹn không được để trống");
        }
        if (appt.getAppointmentDate().isBefore(LocalDate.now())) {
            throw new IllegalArgumentException("Không thể đặt lịch hẹn trong quá khứ");
        }
        if (appt.getStartTime() == null || appt.getEndTime() == null) {
            throw new IllegalArgumentException("Giờ bắt đầu và kết thúc là bắt buộc");
        }
        if (!appt.getEndTime().isAfter(appt.getStartTime())) {
            throw new IllegalArgumentException("Giờ kết thúc phải sau giờ bắt đầu");
        }
        if (appt.getAppointmentDate().isEqual(LocalDate.now())
                && !appt.getEndTime().isAfter(LocalTime.now())) {
            throw new IllegalArgumentException("Khung giờ hẹn đã ở trong quá khứ");
        }
    }
}
