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

    @Override
    public String toString() {
        return "DentistSchedule{" +
                "dentistId=" + dentistId +
                ", dayOfWeek=" + dayOfWeek +
                ", shiftStart=" + shiftStart +
                ", shiftEnd=" + shiftEnd +
                '}';
    }
}
