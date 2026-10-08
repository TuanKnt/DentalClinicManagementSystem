<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="app-sidebar">
    <a href="${pageContext.request.contextPath}/" class="sidebar-brand">
        <div class="brand-icon">
            <img src="${pageContext.request.contextPath}/assets/images/dcms-dental-mark.svg" alt="DCMS Dental Care" />
        </div>
        <div class="brand-info">
            <span class="brand-name">DCMS Dental Care</span>
            <span class="brand-badge">Dr.Smile Inspired</span>
        </div>
    </a>

    <div class="sidebar-menu">
        <div class="menu-category">Tiếp Đón & Lịch Hẹn</div>
        <a href="${pageContext.request.contextPath}/reception/calendar" 
           class="nav-item ${activeMenu == 'calendar' ? 'active' : ''}">
            <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></svg></span>
            <span>Lịch Dạng Calendar</span>
        </a>
        <a href="${pageContext.request.contextPath}/reception/appointments" 
           class="nav-item ${activeMenu == 'appointments' ? 'active' : ''}">
            <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01"/></svg></span>
            <span>Danh Sách Lịch Hẹn</span>
        </a>
        <a href="${pageContext.request.contextPath}/reception/checkin" 
           class="nav-item ${activeMenu == 'checkin' ? 'active' : ''}">
            <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4M10 17l5-5-5-5M15 12H3"/></svg></span>
            <span>Tiếp Đón & Check-in</span>
        </a>
        <a href="${pageContext.request.contextPath}/reception/walkin" 
           class="nav-item ${activeMenu == 'walkin' ? 'active' : ''}">
            <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="5" r="3"/><path d="m9 20 3-6 3 6M6 12h12"/></svg></span>
            <span>Khách Vãng Lai</span>
        </a>
        <a href="${pageContext.request.contextPath}/reception/schedules" 
           class="nav-item ${activeMenu == 'schedules' ? 'active' : ''}">
            <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg></span>
            <span>Lịch Trực Bác Sĩ</span>
        </a>

        <div class="menu-category">Bệnh Nhân & Hồ Sơ</div>
        <a href="${pageContext.request.contextPath}/reception/patients" 
           class="nav-item ${activeMenu == 'patients' ? 'active' : ''}">
            <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></svg></span>
            <span>Hồ Sơ Bệnh Nhân</span>
        </a>
        <a href="${pageContext.request.contextPath}/reception/patients/create" 
           class="nav-item ${activeMenu == 'patient_create' ? 'active' : ''}">
            <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg></span>
            <span>Thêm Bệnh Nhân Mới</span>
        </a>

        <div class="menu-category">Khu Khám Lâm Sàng</div>
        <a href="${pageContext.request.contextPath}/dentist/dashboard" 
           class="nav-item ${activeMenu == 'dentist_dashboard' ? 'active' : ''}">
            <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/></svg></span>
            <span>Bàn Làm Việc Bác Sĩ</span>
        </a>
        <a href="${pageContext.request.contextPath}/dentist/queue" 
           class="nav-item ${activeMenu == 'queue' ? 'active' : ''}">
            <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 18v3M20 18v3M4 11h16M6 11V6a3 3 0 0 1 6 0v5M18 11V8a2 2 0 0 0-2-2"/></svg></span>
            <span>Hàng Đợi Ghế Khám</span>
        </a>

        <div class="menu-category">Hệ Thống</div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" 
           class="nav-item ${activeMenu == 'admin_dashboard' ? 'active' : ''}">
            <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="9"/><rect x="14" y="3" width="7" height="5"/><rect x="14" y="12" width="7" height="9"/><rect x="3" y="16" width="7" height="5"/></svg></span>
            <span>Tổng Quan Quản Trị</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item" style="color: rgba(239, 68, 68, 0.7);">
            <span class="nav-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4M16 17l5-5-5-5M21 12H9"/></svg></span>
            <span>Đăng Xuất</span>
        </a>
    </div>

    <div class="sidebar-user">
        <c:set var="u" value="${sessionScope.currentUser}" />
        <c:set var="displayName" value="${not empty u.fullName ? u.fullName : (not empty sessionScope.fullName ? sessionScope.fullName : 'Nhân Viên')}" />
        <c:set var="displayRole" value="${not empty u.roleName ? u.roleName : (not empty sessionScope.role ? sessionScope.role : 'Staff')}" />

        <div class="user-avatar">
            ${displayName.substring(0, 1).toUpperCase()}
        </div>
        <div class="user-details">
            <div class="user-name" title="${displayName}">
                ${displayName}
            </div>
            <span class="user-role-badge">${displayRole}</span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout-icon" title="Đăng xuất">
            ⏻
        </a>
    </div>
</aside>
