<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activeMenu" value="patients" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Bệnh Án 360° — ${patient.fullName} — Dr.Smile DCMS Dental Care</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css?v=3.0">
    <style>
        .patient-hero {
            background: white;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border);
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: var(--shadow-sm);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            position: relative;
            overflow: hidden;
        }
        .patient-hero::after {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: var(--drsmile-gradient);
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
            background: var(--drsmile-gradient);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            font-weight: 700;
            box-shadow: 0 4px 16px rgba(0, 51, 102, 0.25);
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
            background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%);
            border: 1px solid #fde68a;
            border-left: 5px solid #f59e0b;
            padding: 16px 20px;
            border-radius: var(--radius-md);
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
            border-bottom: 2px solid var(--border);
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
            transition: all var(--transition-normal);
            text-decoration: none;
        }
        .profile-tab-btn:hover {
            color: var(--drsmile-blue);
        }
        .profile-tab-btn.active {
            color: var(--drsmile-navy);
            border-bottom-color: var(--drsmile-blue);
        }
        .attachment-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 16px;
        }
        .attachment-card {
            background: white;
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            overflow: hidden;
            box-shadow: var(--shadow-xs);
            transition: all var(--transition-normal);
        }
        .attachment-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
            border-color: rgba(0, 82, 204, 0.15);
        }
        .attachment-preview {
            height: 140px;
            background: linear-gradient(135deg, #f8fafc 0%, #f0f7fd 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: var(--text-muted);
            border-bottom: 1px solid var(--border);
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
                    <span class="alert-banner-icon">✓</span>
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
                            <span>Ngày sinh: <strong>${patient.dateOfBirth}</strong></span>
                            <span>SĐT: <code>${patient.phoneNumber}</code></span>
                            <c:if test="${not empty patient.email}">
                                <span>Email: ${patient.email}</span>
                            </c:if>
                            <span>Địa chỉ: ${empty patient.address ? 'Chưa cập nhật' : patient.address}</span>
                        </div>
                        <c:if test="${not empty patient.emergencyContact}">
                            <div style="margin-top: 6px; font-size: 12px; color: var(--text-muted);">
                                Liên hệ khẩn cấp: <strong>${patient.emergencyContact}</strong>
                            </div>
                        </c:if>
                    </div>
                </div>

                <div style="display: flex; gap: 10px;">
                    <a href="${pageContext.request.contextPath}/reception/walkin?patientId=${patient.patientId}" class="btn btn-secondary">
                        Tiếp Nhận Khám Ngay
                    </a>
                    <a href="${pageContext.request.contextPath}/reception/appointments/create?patientId=${patient.patientId}" class="btn btn-primary">
                        Đặt Lịch Hẹn
                    </a>
                </div>
            </div>

            <!-- Medical Alerts Banner -->
            <div class="clinical-alert-bar">
                <div class="clinical-alert-icon">!</div>
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
                <a href="#tab-visits" class="profile-tab-btn active">Lịch Sử Các Đợt Khám (${empty visitHistory ? 0 : visitHistory.size()})</a>
                <a href="#tab-odontogram" class="profile-tab-btn">Tình Trạng Sơ Đồ Răng (${empty toothFindings ? 0 : toothFindings.size()})</a>
                <a href="#tab-attachments" class="profile-tab-btn">Phim X-Quang & Hình Ảnh (${empty attachments ? 0 : attachments.size()})</a>
            </div>

            <!-- Section 1: Visit History Timeline -->
            <div class="card" id="tab-visits" style="margin-bottom: 24px;">
                <div class="card-header">
                    <div class="card-title">
                        <span>Danh Sách Các Đợt Khám Bệnh Thực Tế (Visits)</span>
                    </div>
                    <span class="badge-pill badge-Confirmed">● ${empty visitHistory ? 0 : visitHistory.size()} Lượt khám</span>
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="table-custom">
                            <thead>
                                <tr>
                                    <th style="width: 90px;">Mã Lượt</th>
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
                                            <td colspan="8" style="text-align: center; color: var(--text-muted); padding: 40px;">
                                                Bệnh nhân chưa có lượt khám thực tế nào tại phòng khám.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="v" items="${visitHistory}">
                                            <tr>
                                                <td><span class="badge-code">#${v.visitId}</span></td>
                                                <td>${v.checkInTime.toLocalDate()} <strong>${v.checkInTime.toLocalTime().toString().substring(0, 5)}</strong></td>
                                                <td><span class="badge-code">BS-${v.primaryDentistId}</span></td>
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
                                                    <span class="badge-pill badge-${v.status}">● ${v.status}</span>
                                                </td>
                                                <td style="max-width: 220px; font-size: 12.5px; color: var(--text-muted);">${v.notes}</td>
                                                <td style="text-align: right;">
                                                    <a href="${pageContext.request.contextPath}/clinical/examination?visitId=${v.visitId}" class="btn-action-outline">
                                                        Xem Lâm Sàng &rarr;
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
                        <span>Tình Trạng Chi Tiết Các Răng (FDI Odontogram Record)</span>
                    </div>
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="table-custom">
                            <thead>
                                <tr>
                                    <th style="width: 120px;">Số Răng (FDI)</th>
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
                                            <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 40px;">
                                                Chưa có ghi nhận bất thường nào trên sơ đồ răng của bệnh nhân.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="tf" items="${toothFindings}">
                                            <tr>
                                                <td><span class="badge-code" style="color: var(--drsmile-navy); font-weight: 700; font-size: 13px;">Răng ${tf.toothNumber}</span></td>
                                                <td><span class="badge-code">${empty tf.surface ? 'Toàn bộ thân răng' : tf.surface}</span></td>
                                                <td>
                                                    <span class="badge-pill ${tf.condition eq 'Caries' ? 'badge-Cancelled' : (tf.condition eq 'Healthy' ? 'badge-Confirmed' : 'badge-Pending')}">
                                                        ${tf.condition}
                                                    </span>
                                                </td>
                                                <td>${tf.notes}</td>
                                                <td><span class="badge-code">#${tf.visitId}</span></td>
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
                        <span>Thư Viện Phim X-Quang & Hình Ảnh Nha Khoa</span>
                    </div>
                    <div>
                        <!-- Add Attachment Quick Modal Form Trigger -->
                        <form action="${pageContext.request.contextPath}/clinical/attachments" method="POST" enctype="multipart/form-data" style="display: flex; gap: 8px; margin: 0;">
                            <input type="hidden" name="patientId" value="${patient.patientId}" />
                            <input type="hidden" name="returnUrl" value="/reception/patients/detail?id=${patient.patientId}" />
                            <input type="file" name="file" accept="image/*,.pdf" class="form-control" style="width: 240px; padding: 6px 10px; font-size: 12px;" required />
                            <select name="fileType" class="form-control" style="width: 140px; padding: 6px 10px; font-size: 12px;">
                                <option value="XRay">Phim X-Quang</option>
                                <option value="IntraoralPhoto">Ảnh trong miệng</option>
                                <option value="PanoramicOPG">Phim Paronama</option>
                                <option value="Document">Tài liệu / Đơn</option>
                            </select>
                            <button type="submit" class="btn btn-primary" style="padding: 6px 12px; font-size: 12px;">
                                + Thêm Phim
                            </button>
                        </form>
                    </div>
                </div>
                <div class="card-body" style="padding: 20px;">
                    <c:choose>
                        <c:when test="${empty attachments}">
                            <div class="empty-state" style="padding: 30px;">
                                <h4>Chưa có hình ảnh hoặc phim X-quang đính kèm</h4>
                                <p>Sử dụng biểu mẫu phía trên để tải lên phim cận chóp, panorama hoặc hình ảnh trong miệng của bệnh nhân.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="attachment-grid">
                                <c:forEach var="att" items="${attachments}">
                                    <div class="attachment-card">
                                        <div class="attachment-preview" style="font-size: 13px; font-weight: 700; letter-spacing: 0.5px;">
                                            <c:choose>
                                                <c:when test="${att.fileType eq 'XRay'}">X-RAY</c:when>
                                                <c:when test="${att.fileType eq 'IntraoralPhoto'}">PHOTO</c:when>
                                                <c:when test="${att.fileType eq 'PanoramicOPG'}">PANORAMA</c:when>
                                                <c:otherwise>DOC</c:otherwise>
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
