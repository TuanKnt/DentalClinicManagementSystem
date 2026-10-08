package com.dcms.service;

import com.dcms.dao.DentistScheduleDAO;
import com.dcms.model.DentistSchedule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalTime;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class DentistScheduleServiceTest {

    @Mock
    private DentistScheduleDAO scheduleDAO;

    private DentistScheduleService scheduleService;

    @BeforeEach
    public void setUp() {
        scheduleService = new DentistScheduleService(scheduleDAO);
    }

    @Test
    @DisplayName("TC_SCHED_01: Add Valid Dentist Schedule Success")
    public void testAddValidScheduleSuccess() {
        DentistSchedule schedule = new DentistSchedule();
        schedule.setDentistId(3);
        schedule.setDayOfWeek(1); // Monday
        schedule.setShiftStart(LocalTime.of(8, 0));
        schedule.setShiftEnd(LocalTime.of(17, 0));
        schedule.setAvailable(true);

        when(scheduleDAO.checkScheduleOverlap(3, 1, LocalTime.of(8, 0), LocalTime.of(17, 0), null))
                .thenReturn(false);
        when(scheduleDAO.createSchedule(any(DentistSchedule.class))).thenReturn(101);

        DentistSchedule created = scheduleService.addSchedule(schedule);

        assertNotNull(created);
        assertEquals(101, created.getScheduleId());
        verify(scheduleDAO, times(1)).createSchedule(schedule);
    }

    @Test
    @DisplayName("TC_SCHED_02: Reject Schedule When Overlap With Existing Shift")
    public void testRejectScheduleOverlap() {
        DentistSchedule schedule = new DentistSchedule();
        schedule.setDentistId(3);
        schedule.setDayOfWeek(1);
        schedule.setShiftStart(LocalTime.of(9, 0));
        schedule.setShiftEnd(LocalTime.of(12, 0));

        when(scheduleDAO.checkScheduleOverlap(3, 1, LocalTime.of(9, 0), LocalTime.of(12, 0), null))
                .thenReturn(true);

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
            scheduleService.addSchedule(schedule);
        });

        assertTrue(ex.getMessage().contains("bị trùng khung giờ"));
        verify(scheduleDAO, never()).createSchedule(any());
    }

    @Test
    @DisplayName("TC_SCHED_03: Reject Invalid Shift Times (End before Start)")
    public void testRejectInvalidShiftTimes() {
        DentistSchedule schedule = new DentistSchedule();
        schedule.setDentistId(3);
        schedule.setDayOfWeek(2);
        schedule.setShiftStart(LocalTime.of(17, 0));
        schedule.setShiftEnd(LocalTime.of(8, 0));

        IllegalArgumentException ex = assertThrows(IllegalArgumentException.class, () -> {
            scheduleService.addSchedule(schedule);
        });

        assertTrue(ex.getMessage().contains("Giờ kết thúc ca trực phải sau giờ bắt đầu"));
    }

    @Test
    @DisplayName("TC_SCHED_04: Reject Invalid Day of Week or Dentist ID")
    public void testRejectInvalidDayOrDentist() {
        DentistSchedule s1 = new DentistSchedule();
        s1.setDentistId(0);
        s1.setDayOfWeek(2);
        s1.setShiftStart(LocalTime.of(8, 0));
        s1.setShiftEnd(LocalTime.of(12, 0));

        assertThrows(IllegalArgumentException.class, () -> scheduleService.addSchedule(s1));

        DentistSchedule s2 = new DentistSchedule();
        s2.setDentistId(3);
        s2.setDayOfWeek(8); // Invalid day
        s2.setShiftStart(LocalTime.of(8, 0));
        s2.setShiftEnd(LocalTime.of(12, 0));

        assertThrows(IllegalArgumentException.class, () -> scheduleService.addSchedule(s2));
    }

    @Test
    @DisplayName("TC_SCHED_05: Delete Schedule Success")
    public void testDeleteScheduleSuccess() {
        when(scheduleDAO.deleteSchedule(55)).thenReturn(true);

        boolean result = scheduleService.deleteSchedule(55);

        assertTrue(result);
        verify(scheduleDAO, times(1)).deleteSchedule(55);
    }

    @Test
    @DisplayName("TC_SCHED_06: Toggle Schedule Availability Success")
    public void testToggleAvailabilitySuccess() {
        when(scheduleDAO.toggleAvailability(55, false)).thenReturn(true);

        boolean result = scheduleService.toggleAvailability(55, false);

        assertTrue(result);
        verify(scheduleDAO, times(1)).toggleAvailability(55, false);
    }

    @Test
    @DisplayName("TC_SCHED_07: List All Schedules and Filter By Dentist")
    public void testListSchedules() {
        DentistSchedule s = new DentistSchedule(1, 3, 1, LocalTime.of(8, 0), LocalTime.of(17, 0), true);
        when(scheduleDAO.listAllSchedulesWithDentist(3)).thenReturn(Arrays.asList(s));

        List<DentistSchedule> list = scheduleService.listAllSchedules(3);

        assertEquals(1, list.size());
        assertEquals(3, list.get(0).getDentistId());
    }
}
