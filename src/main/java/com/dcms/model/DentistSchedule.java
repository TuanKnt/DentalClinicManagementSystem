package com.dcms.model;

import java.io.Serializable;
import java.time.LocalTime;

/**
 * DentistSchedule represents working shifts of a dentist across days of the week.
 * DayOfWeek: 1 = Monday ... 7 = Sunday
 */
public class DentistSchedule implements Serializable {
    private static final long serialVersionUID = 1L;

    private int scheduleId;
    private int dentistId;
    private int dayOfWeek;
    private LocalTime shiftStart;
    private LocalTime shiftEnd;
    private boolean isAvailable;

    public DentistSchedule() {
    }

    public DentistSchedule(int scheduleId, int dentistId, int dayOfWeek, LocalTime shiftStart, LocalTime shiftEnd, boolean isAvailable) {
        this.scheduleId = scheduleId;
        this.dentistId = dentistId;
        this.dayOfWeek = dayOfWeek;
        this.shiftStart = shiftStart;
        this.shiftEnd = shiftEnd;
        this.isAvailable = isAvailable;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getDentistId() {
        return dentistId;
    }

    public void setDentistId(int dentistId) {
        this.dentistId = dentistId;
    }

    public int getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(int dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public LocalTime getShiftStart() {
        return shiftStart;
    }

    public void setShiftStart(LocalTime shiftStart) {
        this.shiftStart = shiftStart;
    }

    public LocalTime getShiftEnd() {
        return shiftEnd;
    }

    public void setShiftEnd(LocalTime shiftEnd) {
        this.shiftEnd = shiftEnd;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean available) {
        isAvailable = available;
    }

    private String dentistName;
    private String specialization;
    private String roomNumber;

    public String getDentistName() {
        return dentistName;
    }

    public void setDentistName(String dentistName) {
        this.dentistName = dentistName;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getDayOfWeekName() {
        switch (dayOfWeek) {
            case 1: return "Thứ Hai";
            case 2: return "Thứ Ba";
            case 3: return "Thứ Tư";
            case 4: return "Thứ Năm";
            case 5: return "Thứ Sáu";
            case 6: return "Thứ Bảy";
            case 7: return "Chủ Nhật";
            default: return "Thứ " + dayOfWeek;
        }
    }

    public String getShiftTimeFormatted() {
        if (shiftStart == null || shiftEnd == null) return "";
        return shiftStart.toString().substring(0, 5) + " – " + shiftEnd.toString().substring(0, 5);
    }

    @Override
    public String toString() {
        return "DentistSchedule{" +
                "scheduleId=" + scheduleId +
                ", dentistId=" + dentistId +
                ", dayOfWeek=" + dayOfWeek +
                ", shiftStart=" + shiftStart +
                ", shiftEnd=" + shiftEnd +
                ", isAvailable=" + isAvailable +
                '}';
    }
}
