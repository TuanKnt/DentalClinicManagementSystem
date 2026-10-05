<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="activeMenu" value="patients" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Bệnh Án 360° — ${patient.fullName} — DCMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        .patient-hero {
            background: white;
            border-radius: 12px;
            border: 1px solid var(--border-color);
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }
        .patient-hero-left {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .patient-big-avatar {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary) 0%, #0284c7 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            font-weight: 700;
            box-shadow: 0 4px 10px rgba(14, 165, 233, 0.3);
        }
        .patient-meta-tags {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
            margin-top: 6px;
            font-size: 13px;
            color: var(--text-muted);
        }
        .clinical-alert-bar {
            background: #fffbeb;
            border: 1px solid #fde68a;
            border-left: 5px solid #f59e0b;
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .clinical-alert-icon {
            font-size: 24px;
        }
        .profile-tabs {
            display: flex;
            gap: 8px;
            border-bottom: 2px solid var(--border-color);
            margin-bottom: 20px;
        }
        .profile-tab-btn {
            padding: 12px 20px;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-muted);
            background: transparent;
            border: none;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            margin-bottom: -2px;
            transition: all 0.2s ease;
            text-decoration: none;
        }
        .profile-tab-btn.active {
            color: var(--primary);
            border-bottom-color: var(--primary);
        }
        .attachment-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 16px;
        }
        .attachment-card {
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            transition: transform 0.2s ease;
        }
        .attachment-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }
        .attachment-preview {
            height: 140px;
            background: #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: var(--text-muted);
            border-bottom: 1px solid var(--border-color);
        }
        .attachment-info {
            padding: 12px;
            font-size: 12px;
        }
    </style>
</head>
<body>

<div class="app-shell">
    <!-- Reusable Sidebar -->
    <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

    <div class="app-main">
        <!-- Reusable Header -->
        <jsp:include page="/WEB-INF/views/layout/header.jsp" />

        <main class="page-content">
            <!-- Breadcrumbs -->
            <div class="breadcrumb-trail">
                <a href="${pageContext.request.contextPath}/">Trang chủ</a>
                <span class="breadcrumb-separator">/</span>
                <a href="${pageContext.request.contextPath}/reception/patients">Hồ Sơ Bệnh Nhân</a>
                <span class="breadcrumb-separator">/</span>
                <span>Hồ Sơ Bệnh Án 360° (${patient.fullName})</span>
            </div>

            <!-- Toast / Success Messages -->
            <c:if test="${param.success eq 'attachment_added'}">
                <div class="alert-banner alert-banner-success">
                    <span class="alert-banner-icon">📎</span>
                    <div><strong>Thành công:</strong> Đã lưu trữ tài liệu / hình ảnh nha khoa vào hồ sơ bệnh nhân.</div>
                </div>
            </c:if>

            <!-- Patient Hero Banner -->
            <div class="patient-hero">
                <div class="patient-hero-left">
                    <div class="patient-big-avatar">
                        ${patient.fullName.substring(0, 1).toUpperCase()}
                    </div>
                    <div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <h1 style="margin: 0; font-size: 22px; color: var(--text-primary);">${patient.fullName}</h1>
                            <span class="badge-pill badge-Pending" style="font-size: 12px;">Mã BN: #${patient.patientId}</span>
                            <span class="badge-pill badge-Confirmed">${patient.gender}</span>
                        </div>
                        <div class="patient-meta-tags">
                            <span>🎂 Ngày sinh: <strong>${patient.dateOfBirth}</strong></span>
                            <span>📞 SĐT: <code>${patient.phoneNumber}</code></span>
                            <c:if test="${not empty patient.email}">
                                <span>✉️ ${patient.email}</span>
                            </c:if>
                            <span>🏠 ${empty patient.address ? 'Chưa cập nhật địa chỉ' : patient.address}</span>
                        </div>
                        <c:if test="${not empty patient.emergencyContact}">
                            <div style="margin-top: 6px; font-size: 12px; color: var(--text-muted);">
                                🚨 Liên hệ khẩn cấp: <strong>${patient.emergencyContact}</strong>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/reception/walkin?patientId=${patient.patientId}" class="btn btn-secondary">
                        <span>🚶</span> Tiếp Nhận Khám Ngay
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/appointments/create?patientId=${patient.patientId}" class="btn btn-primary">
                        <span>📅</span> Đặt Lịch Hẹn
                    </a>
                </div>
            </div>

            <!-- Medical Alerts Banner -->
            <div class="clinical-alert-bar">
                <div class="clinical-alert-icon">⚠️</div>
                <div style="flex: 1;">
                    <div style="font-weight: 700; color: #b45309; font-size: 14px;">Cảnh Báo Lâm Sàng & Tiền Sử Bệnh Lý</div>
                    <div style="font-size: 13px; color: #92400e; margin-top: 2px;">
                        <strong>Bệnh nền toàn thân:</strong> ${empty patient.medicalAlerts ? 'Không ghi nhận bệnh lý đặc biệt' : patient.medicalAlerts} &bull;
                        <strong>Dị ứng thuốc/thức ăn:</strong> ${empty patient.allergies ? 'Không có tiền sử dị ứng' : patient.allergies}
                    </div>
                </div>
            </div>

            <!-- Tabs Navigation -->
            <div class="profile-tabs">
                <a href="#tab-visits" class="profile-tab-btn active">📋 Lịch Sử Các Đợt Khám (${empty visitHistory ? 0 : visitHistory.size()})</a>
                <a href="#tab-odontogram" class="profile-tab-btn">🦷 Tình Trạng Sơ Đồ Răng (${empty toothFindings ? 0 : toothFindings.size()})</a>
                <a href="#tab-attachments" class="profile-tab-btn">📷 Phim X-Quang & Hình Ảnh (${empty attachments ? 0 : attachments.size()})</a>
            </div>

            <!-- Section 1: Visit History Timeline -->
            <div class="card" id="tab-visits" style="margin-bottom: 24px;">
                <div class="card-header">
                    <div class="card-title">
                        <span>📋</span>
                        <span>Danh Sách Các Đợt Khám Bệnh Thực Tế (Visits)</span>
                    </div>
                    <span class="badge-pill badge-Confirmed">● ${empty visitHistory ? 0 : visitHistory.size()} Lượt khám</span>
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Mã Lượt</th>
                                    <th>Thời Gian Tiếp Đón</th>
                                    <th>Bác Sĩ Điều Trị</th>
                                    <th>Ghế Khám / Phòng</th>
                                    <th>Phân Loại</th>
                                    <th>Trạng Thái</th>
                                    <th>Ghi Chú</th>
                                    <th style="text-align: right;">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty visitHistory}">
                                        <tr>
                                            <td colspan="8" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                                Bệnh nhân chưa có lượt khám thực tế nào tại phòng khám.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="v" items="${visitHistory}">
                                            <tr>
                                                <td><strong>#${v.visitId}</strong></td>
                                                <td>${v.checkInTime.toLocalDate()} <strong>${v.checkInTime.toLocalTime().toString().substring(0, 5)}</strong></td>
                                                <td>BS-${v.primaryDentistId}</td>
                                                <td>
                                                    <span class="badge-pill badge-Pending">
                                                        ${empty v.operatory ? 'Chưa chỉ định' : v.operatory}
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge-pill ${v.visitType eq 'Emergency' ? 'badge-Cancelled' : (v.visitType eq 'Scheduled' ? 'badge-Confirmed' : 'badge-Pending')}">
                                                        ${v.visitType}
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge-pill badge-${v.status}">${v.status}</span>
                                                </td>
                                                <td style="max-width: 220px; font-size: 12px; color: var(--text-muted);">${v.notes}</td>
                                                <td style="text-align: right;">
                                                    <a href="${pageContext.request.contextPath}/clinical/examination?visitId=${v.visitId}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 12px;">
                                                        🩺 Xem Lâm Sàng &rarr;
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Section 2: Tooth Findings Odontogram Summary -->
            <div class="card" id="tab-odontogram" style="margin-bottom: 24px;">
                <div class="card-header">
                    <div class="card-title">
                        <span>🦷</span>
                        <span>Tình Trạng Chi Tiết Các Răng (FDI Odontogram Record)</span>
                    </div>
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Số Răng (FDI)</th>
                                    <th>Mặt Răng</th>
                                    <th>Tình Trạng Lâm Sàng</th>
                                    <th>Ghi Chú Điều Trị</th>
                                    <th>Mã Lượt Khám</th>
                                    <th>Ngày Ghi Nhận</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty toothFindings}">
                                        <tr>
                                            <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                                Chưa có ghi nhận bất thường nào trên sơ đồ răng của bệnh nhân.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="tf" items="${toothFindings}">
                                            <tr>
                                                <td><strong style="color: var(--primary); font-size: 15px;">Răng ${tf.toothNumber}</strong></td>
                                                <td><code>${empty tf.surface ? 'Toàn bộ thân răng' : tf.surface}</code></td>
                                                <td>
                                                    <span class="badge-pill ${tf.condition eq 'Caries' ? 'badge-Cancelled' : (tf.condition eq 'Healthy' ? 'badge-Confirmed' : 'badge-Pending')}">
                                                        ${tf.condition}
                                                    </span>
                                                </td>
                                                <td>${tf.notes}</td>
                                                <td>#${tf.visitId}</td>
                                                <td>${tf.createdAt}</td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Section 3: Dental Attachments & Images -->
            <div class="card" id="tab-attachments">
                <div class="card-header">
                    <div class="card-title">
                        <span>📷</span>
                        <span>Thư Viện Phim X-Quang & Hình Ảnh Nha Khoa</span>
                    </div>
                    <div>
                        <!-- Add Attachment Quick Modal Form Trigger -->
                        <form action="${pageContext.request.contextPath}/clinical/attachments" method="POST" style="display: flex; gap: 8px; margin: 0;">
                            <input type="hidden" name="patientId" value="${patient.patientId}" />
                            <input type="hidden" name="returnUrl" value="/reception/patients/detail?id=${patient.patientId}" />
                            <input type="text" name="fileName" placeholder="Tên phim (VD: X-quang răng 36)" class="form-control" style="width: 220px; padding: 6px 10px; font-size: 12px;" required />
                            <select name="fileType" class="form-control" style="width: 140px; padding: 6px 10px; font-size: 12px;">
                                <option value="XRay">Phim X-Quang</option>
                                <option value="IntraoralPhoto">Ảnh trong miệng</option>
                                <option value="PanoramicOPG">Phim Paronama</option>
                                <option value="Document">Tài liệu / Đơn</option>
                            </select>
                            <button type="submit" class="btn btn-primary" style="padding: 6px 12px; font-size: 12px;">
                                ➕ Thêm Phim
                            </button>
                        </form>
                    </div>
                </div>
                <div class="card-body" style="padding: 20px;">
                    <c:choose>
                        <c:when test="${empty attachments}">
                            <div class="empty-state" style="padding: 30px;">
                                <span class="empty-state-icon">🖼️</span>
                                <h4>Chưa có hình ảnh hoặc phim X-quang đính kèm</h4>
                                <p>Sử dụng biểu mẫu phía trên để tải lên phim cận chóp, panorama hoặc hình ảnh trong miệng của bệnh nhân.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="attachment-grid">
                                <c:forEach var="att" items="${attachments}">
                                    <div class="attachment-card">
                                        <div class="attachment-preview">
                                            <c:choose>
                                                <c:when test="${att.fileType eq 'XRay'}">🩻</c:when>
                                                <c:when test="${att.fileType eq 'IntraoralPhoto'}">📸</c:when>
                                                <c:when test="${att.fileType eq 'PanoramicOPG'}">🦷</c:when>
                                                <c:otherwise>📄</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="attachment-info">
                                            <div style="font-weight: 700; color: var(--text-primary); font-size: 13px; margin-bottom: 2px;">
                                                ${att.fileName}
                                            </div>
                                            <div style="color: var(--text-muted); font-size: 11px;">
                                                Loại: <span class="badge-pill badge-Pending" style="font-size: 10px;">${att.fileType}</span>
                                            </div>
                                            <div style="color: var(--text-muted); font-size: 11px; margin-top: 4px;">
                                                Ngày: ${att.uploadedAt}
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>

</body>
</html>
