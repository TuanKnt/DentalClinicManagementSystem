package com.dcms.service;

import com.dcms.dao.DentistScheduleDAO;
import com.dcms.model.DentistSchedule;

import java.time.LocalTime;
import java.util.List;

/**
 * Service handling business invariants and management for Dentist Work Schedules (UC37).
 */
public class DentistScheduleService {

    private final DentistScheduleDAO scheduleDAO;

    public DentistScheduleService() {
        this.scheduleDAO = new DentistScheduleDAO();
    }

    public DentistScheduleService(DentistScheduleDAO scheduleDAO) {
        this.scheduleDAO = scheduleDAO;
    }

    public List<DentistSchedule> listAllSchedules(Integer dentistId) {
        return scheduleDAO.listAllSchedulesWithDentist(dentistId);
    }

    public List<DentistSchedule> listSchedulesByDentist(int dentistId) {
        return scheduleDAO.listSchedulesByDentist(dentistId);
    }

    public DentistSchedule addSchedule(DentistSchedule schedule) {
        validateScheduleInput(schedule);

        boolean overlap = scheduleDAO.checkScheduleOverlap(
                schedule.getDentistId(),
                schedule.getDayOfWeek(),
                schedule.getShiftStart(),
                schedule.getShiftEnd(),
                null
        );

        if (overlap) {
            throw new IllegalArgumentException(
                    "Bác sĩ đã có ca trực bị trùng khung giờ vào " + schedule.getDayOfWeekName()
                    + " (" + schedule.getShiftTimeFormatted() + "). Vui lòng chọn khung giờ khác!"
            );
        }

        int id = scheduleDAO.createSchedule(schedule);
        if (id <= 0) {
            throw new RuntimeException("Lỗi hệ thống: Không thể lưu ca trực của bác sĩ vào cơ sở dữ liệu");
        }
        schedule.setScheduleId(id);
        return schedule;
    }

    public boolean deleteSchedule(int scheduleId) {
        if (scheduleId <= 0) {
            throw new IllegalArgumentException("Mã ca trực không hợp lệ");
        }
        return scheduleDAO.deleteSchedule(scheduleId);
    }

    public boolean toggleAvailability(int scheduleId, boolean isAvailable) {
        if (scheduleId <= 0) {
            throw new IllegalArgumentException("Mã ca trực không hợp lệ");
        }
        return scheduleDAO.toggleAvailability(scheduleId, isAvailable);
    }

    private void validateScheduleInput(DentistSchedule schedule) {
        if (schedule == null) {
            throw new IllegalArgumentException("Dữ liệu ca trực không được để trống");
        }
        if (schedule.getDentistId() <= 0) {
            throw new IllegalArgumentException("Vui lòng chọn bác sĩ phụ trách ca trực");
        }
        if (schedule.getDayOfWeek() < 1 || schedule.getDayOfWeek() > 7) {
            throw new IllegalArgumentException("Thứ trong tuần không hợp lệ (chỉ từ Thứ Hai đến Chủ Nhật)");
        }
        LocalTime start = schedule.getShiftStart();
        LocalTime end = schedule.getShiftEnd();
        if (start == null || end == null) {
            throw new IllegalArgumentException("Giờ bắt đầu và giờ kết thúc ca trực là bắt buộc");
        }
        if (!end.isAfter(start)) {
            throw new IllegalArgumentException("Giờ kết thúc ca trực phải sau giờ bắt đầu");
        }
    }
}
