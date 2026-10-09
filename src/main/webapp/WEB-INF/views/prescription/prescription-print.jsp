<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>In Đơn Thuốc Điện Tử #${prescription.prescriptionCode} | DCMS Dr.Smile</title>
    <style>
        @page {
            size: A4 portrait;
            margin: 15mm 15mm 15mm 15mm;
        }

        body {
            font-family: "Times New Roman", Times, serif;
            color: #000000;
            background: #ffffff;
            margin: 0;
            padding: 20px;
            font-size: 13.5pt;
            line-height: 1.45;
        }

        .no-print-bar {
            background: #f1f5f9;
            border: 1px solid #cbd5e1;
            padding: 12px 24px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }

        .btn-print {
            background: #003366;
            color: #ffffff;
            border: none;
            padding: 9px 20px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-back {
            background: #ffffff;
            color: #475569;
            border: 1px solid #cbd5e1;
            padding: 9px 16px;
            border-radius: 6px;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        @media print {
            .no-print-bar {
                display: none !important;
            }
            body {
                padding: 0;
            }
        }

        /* Official Clinic Letterhead */
        .clinic-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 2px solid #003366;
            padding-bottom: 12px;
            margin-bottom: 18px;
        }

        .clinic-info h2 {
            margin: 0 0 4px 0;
            font-size: 16pt;
            font-weight: bold;
            color: #003366;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .clinic-info p {
            margin: 2px 0;
            font-size: 11pt;
            color: #333333;
        }

        .rx-meta-box {
            text-align: right;
            font-size: 11pt;
        }

        .rx-meta-box .rx-code {
            font-size: 14pt;
            font-weight: bold;
            color: #003366;
            letter-spacing: 1px;
        }

        /* Document Title */
        .doc-title-box {
            text-align: center;
            margin: 15px 0 20px 0;
        }

        .doc-title-box h1 {
            margin: 0;
            font-size: 19pt;
            font-weight: bold;
            text-transform: uppercase;
            color: #003366;
            letter-spacing: 1px;
        }

        .doc-title-box .motto {
            font-style: italic;
            font-size: 11.5pt;
            color: #555555;
            margin-top: 4px;
        }

        /* Patient Info Grid */
        .patient-section {
            margin-bottom: 18px;
            border: 1px solid #d1d5db;
            padding: 12px 16px;
            border-radius: 4px;
        }

        .info-row {
            display: flex;
            margin-bottom: 6px;
            font-size: 12.5pt;
        }

        .info-row:last-child {
            margin-bottom: 0;
        }

        .info-col {
            flex: 1;
        }

        .info-label {
            font-weight: bold;
        }

        .allergy-warning {
            color: #b91c1c;
            font-weight: bold;
        }

        /* Prescription Table */
        .rx-table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
        }

        .rx-table th {
            border: 1px solid #000000;
            padding: 8px 10px;
            font-weight: bold;
            font-size: 12pt;
            background-color: #f3f4f6;
            text-align: left;
        }

        .rx-table td {
            border: 1px solid #000000;
            padding: 8px 10px;
            font-size: 12pt;
            vertical-align: top;
        }

        .med-name {
            font-weight: bold;
            font-size: 12.5pt;
        }

        .med-ingredient {
            font-style: italic;
            font-size: 11pt;
            color: #444444;
        }

        .med-dosage {
            margin-top: 4px;
            font-size: 11.5pt;
        }

        /* Doctor's Advice Box */
        .advice-box {
            margin-top: 15px;
            border-left: 3px solid #003366;
            padding-left: 12px;
            font-size: 12pt;
        }

        .advice-box h4 {
            margin: 0 0 4px 0;
            font-size: 12pt;
            text-transform: uppercase;
            color: #003366;
        }

        /* Signature Section */
        .signature-section {
            display: flex;
            justify-content: space-between;
            margin-top: 35px;
            page-break-inside: avoid;
        }

        .signature-box {
            width: 45%;
            text-align: center;
            font-size: 12pt;
        }

        .signature-date {
            font-style: italic;
            margin-bottom: 6px;
        }

        .signature-title {
            font-weight: bold;
            text-transform: uppercase;
        }

        .signature-space {
            height: 70px;
        }

        .signature-name {
            font-weight: bold;
            font-size: 12.5pt;
        }

        .footer-note {
            margin-top: 35px;
            font-size: 10pt;
            color: #666666;
            text-align: center;
            border-top: 1px dashed #cccccc;
            padding-top: 8px;
        }
    </style>
</head>
<body>

    <div class="no-print-bar">
        <div>
            <strong style="color: #003366; font-size: 15px;">Phiếu Đơn Thuốc Điện Tử #${prescription.prescriptionCode}</strong>
            <div style="font-size: 13px; color: #64748b; margin-top: 2px;">
                Bệnh nhân: ${prescription.patientName} | Bác sĩ: BS. ${prescription.dentistName}
            </div>
        </div>
        <div style="display: flex; gap: 10px;">
            <a href="${pageContext.request.contextPath}/prescription/form?visitId=${prescription.visitId}" class="btn-back">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Quay Lại Kê Đơn
            </a>
            <button onclick="window.print()" class="btn-print">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="6 9 6 2 18 2 18 9"></polyline>
                    <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                    <rect x="6" y="14" width="12" height="8"></rect>
                </svg>
                In Đơn Thuốc (Print)
            </button>
        </div>
    </div>

    <!-- Official Header -->
    <div class="clinic-header">
        <div class="clinic-info">
            <h2>Nha Khoa Quốc Tế DCMS — Dr.Smile Inspired</h2>
            <p><strong>Cơ sở 1:</strong> Số 41 Núi Trúc, P. Kim Mã, Q. Ba Đình, Hà Nội</p>
            <p><strong>Cơ sở 2:</strong> Số 123 Phố Huế, Q. Hai Bà Trưng, Hà Nội</p>
            <p><strong>Hotline 24/7:</strong> 096 669 2286 | <strong>Giấy phép BYT:</strong> CCHN-001234/BYT</p>
        </div>
        <div class="rx-meta-box">
            <div class="rx-code">MÃ ĐƠN: #${prescription.prescriptionCode}</div>
            <div>Mã lượt khám: #${prescription.visitId}</div>
            <div>Ngày kê: <fmt:formatDate value="${prescription.issuedAt}" pattern="dd/MM/yyyy HH:mm" /></div>
        </div>
    </div>

    <!-- Title -->
    <div class="doc-title-box">
        <h1>ĐƠN THUỐC ĐIỆN TỬ</h1>
        <div class="motto">"Khám kỹ lưỡng – Tư vấn rõ ràng – Điều trị nhẹ nhàng – Bảo hành thấu đáo"</div>
    </div>

    <!-- Patient Information Section -->
    <div class="patient-section">
        <div class="info-row">
            <div class="info-col">
                <span class="info-label">Họ và tên người bệnh:</span> <strong>${prescription.patientName}</strong>
            </div>
            <div class="info-col" style="flex: 0.6;">
                <span class="info-label">Giới tính:</span> ${prescription.patientGender}
            </div>
            <div class="info-col" style="flex: 0.8;">
                <span class="info-label">Ngày sinh:</span> ${prescription.patientDob}
            </div>
        </div>
        <div class="info-row">
            <div class="info-col">
                <span class="info-label">Địa chỉ:</span> ${prescription.patientAddress}
            </div>
            <div class="info-col" style="flex: 0.8;">
                <span class="info-label">Điện thoại:</span> ${prescription.patientPhone}
            </div>
        </div>
        <div class="info-row">
            <div class="info-col">
                <span class="info-label">Tiền sử dị ứng:</span>
                <c:choose>
                    <c:when test="${not empty prescription.patientAllergies}">
                        <span class="allergy-warning">${prescription.patientAllergies}</span>
                    </c:when>
                    <c:otherwise>
                        <span>Không ghi nhận tiền sử dị ứng</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="info-row">
            <div class="info-col">
                <span class="info-label">Chẩn đoán:</span> <strong>${prescription.diagnosis}</strong>
            </div>
        </div>
    </div>

    <!-- Medicines Table -->
    <table class="rx-table">
        <thead>
            <tr>
                <th style="width: 8%; text-align: center;">STT</th>
                <th style="width: 52%;">Tên Thuốc &amp; Hàm Lượng / Cách Dùng</th>
                <th style="width: 20%; text-align: center;">Số Lượng</th>
                <th style="width: 20%; text-align: center;">Thời Gian Dùng</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${prescription.items}" varStatus="status">
                <tr>
                    <td style="text-align: center; font-weight: bold;">${status.index + 1}</td>
                    <td>
                        <div class="med-name">${item.medicineName}</div>
                        <c:if test="${not empty item.activeIngredient}">
                            <div class="med-ingredient">(Hoạt chất: ${item.activeIngredient})</div>
                        </c:if>
                        <div class="med-dosage">
                            <strong>Cách dùng:</strong> ${item.dosage}
                        </div>
                        <c:if test="${not empty item.notes}">
                            <div style="font-size: 11pt; color: #555; margin-top: 2px;">
                                <em>Ghi chú: ${item.notes}</em>
                            </div>
                        </c:if>
                    </td>
                    <td style="text-align: center; font-weight: bold;">
                        ${item.quantity} ${item.unit}
                    </td>
                    <td style="text-align: center;">
                        ${item.durationDays} ngày
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Doctor's Advice -->
    <div class="advice-box">
        <h4>Lời Dặn Của Bác Sĩ Điều Trị:</h4>
        <p style="margin: 0;">${prescription.advice}</p>
    </div>

    <!-- Signatures -->
    <div class="signature-section">
        <div class="signature-box">
            <div class="signature-date">&nbsp;</div>
            <div class="signature-title">Người Bệnh / Người Nhận Thuốc</div>
            <div style="font-size: 10.5pt; color: #555;">(Ký và ghi rõ họ tên)</div>
            <div class="signature-space"></div>
            <div class="signature-name">${prescription.patientName}</div>
        </div>

        <div class="signature-box">
            <div class="signature-date">
                Hà Nội, ngày <fmt:formatDate value="${prescription.issuedAt}" pattern="dd" />
                tháng <fmt:formatDate value="${prescription.issuedAt}" pattern="MM" />
                năm <fmt:formatDate value="${prescription.issuedAt}" pattern="yyyy" />
            </div>
            <div class="signature-title">Bác Sĩ Khám Bệnh</div>
            <div style="font-size: 10.5pt; color: #555;">(Ký và ghi rõ họ tên)</div>
            <div class="signature-space"></div>
            <div class="signature-name">BS. ${prescription.dentistName}</div>
            <div style="font-size: 11pt; color: #444;">Số CCHN: ${prescription.dentistLicense}</div>
        </div>
    </div>

    <div class="footer-note">
        * Lưu ý: Khám lại ngay nếu có dấu hiệu sốt, dị ứng hoặc diễn biến bất thường. Đơn thuốc này có giá trị theo đúng đợt điều trị.
    </div>

</body>
</html>
