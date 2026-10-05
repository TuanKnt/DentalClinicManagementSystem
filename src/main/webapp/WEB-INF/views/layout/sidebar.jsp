<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<aside class="app-sidebar">
    <a href="${pageContext.request.contextPath}/" class="sidebar-brand">
        <div class="brand-icon">🦷</div>
        <div class="brand-info">
            <span class="brand-name">DCMS Clinic</span>
            <span class="brand-badge">Dental System</span>
        </div>
    </a>

    <div class="sidebar-menu">
        <div class="menu-category">Tiếp Đón & Lịch Hẹn</div>
        <a href="${pageContext.request.contextPath}/reception/calendar" 
           class="nav-item ${activeMenu == 'calendar' ? 'active' : ''}">
            <span class="nav-icon">📆</span>
            <span>Lịch Dạng Calendar</span>
        </a>
        <a href="${pageContext.request.contextPath}/reception/appointments" 
           class="nav-item ${activeMenu == 'appointments' ? 'active' : ''}">
            <span class="nav-icon">📅</span>
            <span>Danh Sách Lịch Hẹn</span>
        </a>
        <a href="${pageContext.request.contextPath}/reception/checkin" 
           class="nav-item ${activeMenu == 'checkin' ? 'active' : ''}">
            <span class="nav-icon">🚪</span>
            <span>Tiếp Đón & Check-in</span>
        </a>
        <a href="${pageContext.request.contextPath}/reception/walkin" 
           class="nav-item ${activeMenu == 'walkin' ? 'active' : ''}">
            <span class="nav-icon">🚶</span>
            <span>Khách Vãng Lai</span>
        </a>

        <div class="menu-category">Bệnh Nhân & Hồ Sơ</div>
        <a href="${pageContext.request.contextPath}/reception/patients" 
           class="nav-item ${activeMenu == 'patients' ? 'active' : ''}">
            <span class="nav-icon">👥</span>
            <span>Hồ Sơ Bệnh Nhân</span>
        </a>
        <a href="${pageContext.request.contextPath}/reception/patients/create" 
           class="nav-item ${activeMenu == 'patient_create' ? 'active' : ''}">
            <span class="nav-icon">➕</span>
            <span>Thêm Bệnh Nhân Mới</span>
        </a>

        <div class="menu-category">Khu Khám Lâm Sàng</div>
        <a href="${pageContext.request.contextPath}/dentist/dashboard" 
           class="nav-item ${activeMenu == 'dentist_dashboard' ? 'active' : ''}">
            <span class="nav-icon">🩺</span>
            <span>Bàn Làm Việc Bác Sĩ</span>
        </a>
        <a href="${pageContext.request.contextPath}/dentist/queue" 
           class="nav-item ${activeMenu == 'queue' ? 'active' : ''}">
            <span class="nav-icon">💺</span>
            <span>Hàng Đợi Ghế Khám</span>
        </a>

        <div class="menu-category">Hệ Thống</div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" 
           class="nav-item ${activeMenu == 'admin_dashboard' ? 'active' : ''}">
            <span class="nav-icon">📊</span>
            <span>Tổng Quan Quản Trị</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item" style="color: var(--danger);">
            <span class="nav-icon">🔒</span>
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
