<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biên Bản Cam Kết Điều Trị #KH-${plan.planId} — ${plan.patientName} | DCMS Dr.Smile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css?v=3.2">
    <style>
        body {
            background: #f1f5f9;
            color: #0f172a;
            font-family: 'Plus Jakarta Sans', system-ui, -apple-system, sans-serif;
            padding: 30px 15px;
            margin: 0;
        }

        .print-page {
            max-width: 820px;
            margin: 0 auto;
            background: #ffffff;
            padding: 45px 50px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            border: 1px solid #e2e8f0;
        }

        .print-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 2px solid var(--drsmile-navy);
            padding-bottom: 20px;
            margin-bottom: 24px;
        }

        .brand-title {
            font-size: 22px;
            font-weight: 800;
            color: var(--drsmile-navy);
            letter-spacing: -0.5px;
            margin: 0 0 4px 0;
        }

        .brand-sub {
            font-size: 12px;
            color: #64748b;
            line-height: 1.5;
            margin: 0;
        }

        .doc-title-block {
            text-align: center;
            margin: 25px 0 20px 0;
        }

        .doc-title-block h1 {
            font-size: 20px;
            font-weight: 800;
            color: var(--drsmile-navy);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin: 0 0 6px 0;
        }

        .meta-grid-print {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px 24px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 16px 20px;
            margin-bottom: 24px;
            font-size: 13.5px;
        }

        .meta-line {
            display: flex;
            align-items: baseline;
            gap: 6px;
        }

        .meta-label {
            color: #64748b;
            font-size: 13px;
            min-width: 140px;
        }

        .meta-value {
            font-weight: 700;
            color: #0f172a;
        }

        .terms-box {
            background: #ffffff;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 18px 20px;
            margin-bottom: 24px;
            font-size: 13px;
            line-height: 1.7;
            color: #334155;
        }

        .terms-box ol {
            margin: 8px 0 0 0;
            padding-left: 20px;
        }

        .terms-box li {
            margin-bottom: 6px;
        }

        .print-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 24px;
            font-size: 13px;
        }

        .print-table th {
            background: #003366;
            color: #ffffff;
            padding: 10px 12px;
            text-align: left;
            font-weight: 700;
            border: 1px solid #003366;
        }

        .print-table td {
            padding: 9px 12px;
            border: 1px solid #e2e8f0;
            color: #1e293b;
        }

        .print-table tbody tr:nth-child(even) {
            background: #f8fafc;
        }

        .signature-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            margin-top: 40px;
            text-align: center;
        }

        .sig-title {
            font-weight: 700;
            font-size: 14px;
            color: var(--drsmile-navy);
            margin-bottom: 4px;
        }

        .sig-sub {
            font-size: 12px;
            color: #64748b;
            font-style: italic;
        }

        .sig-space {
            height: 80px;
        }

        .sig-name {
            font-weight: 700;
            font-size: 14px;
            color: #0f172a;
        }

        .no-print-bar {
            max-width: 820px;
            margin: 0 auto 16px auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        @media print {
            body {
                background: #ffffff;
                padding: 0;
            }
            .print-page {
                box-shadow: none;
                border: none;
                padding: 0;
                max-width: 100%;
            }
            .no-print-bar {
                display: none !important;
            }
        }
    </style>
</head>
<body>

<div class="no-print-bar">
    <a href="${pageContext.request.contextPath}/treatment/plans/detail?id=${plan.planId}" class="btn btn-secondary" style="font-size: 13px; font-weight: 600; text-decoration: none;">
        <span>← Quay lại chi tiết phác đồ</span>
    </a>
    <button onclick="window.print()" class="btn btn-drsmile" style="font-size: 13.5px; font-weight: 700; cursor: pointer;">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="vertical-align: middle; margin-right: 4px;">
            <polyline points="6 9 6 2 18 2 18 9"></polyline>
            <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
            <rect x="6" y="14" width="12" height="8"></rect>
        </svg>
        In Bản Cam Kết Điều Trị
    </button>
</div>

<div class="print-page">
    <div class="print-header">
        <div>
            <div class="brand-title">HỆ THỐNG NHA KHOA DR.SMILE</div>
            <div class="brand-sub">
                Cơ sở 1: Núi Trúc, Ba Đình, Hà Nội &bull; Cơ sở 2: Phố Huế, Hai Bà Trưng, Hà Nội<br>
                Hotline 24/7: 096 669 2286 / 1900 888 999 &bull; Website: drsmile.vn
            </div>
        </div>
        <div style="text-align: right;">
            <div style="font-size: 11px; color: #64748b; text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px;">Mã Phác Đồ</div>
            <div style="font-family: 'Inter', monospace; font-size: 17px; font-weight: 800; color: var(--drsmile-navy);">
                #KH-${plan.planId}
            </div>
            <div style="font-size: 11.5px; color: #0284c7; font-weight: 600; margin-top: 2px;">
                Mẫu Consent: BM-04/BYT
            </div>
        </div>
    </div>

    <div class="doc-title-block">
        <h1>BẢN CAM KẾT ĐỒNG THUẬN ĐIỀU TRỊ NHA KHOA</h1>
        <div style="font-size: 13px; color: #475569; font-style: italic;">
            (Informed Consent Form &bull; Quy chế Chuyên môn Khám Chữa Bệnh Răng Hàm Mặt)
        </div>
    </div>

    <div class="meta-grid-print">
        <div class="meta-line">
            <span class="meta-label">Họ và tên bệnh nhân:</span>
            <span class="meta-value">${plan.patientName}</span>
        </div>
        <div class="meta-line">
            <span class="meta-label">Bác sĩ điều trị:</span>
            <span class="meta-value">${plan.dentistName} (${plan.dentistSpecialization})</span>
        </div>
        <div class="meta-line">
            <span class="meta-label">Số điện thoại:</span>
            <span class="meta-value">${plan.patientPhone}</span>
        </div>
        <div class="meta-line">
            <span class="meta-label">Trạng thái đồng thuận:</span>
            <span class="meta-value" style="color: #0284c7;">
                ${plan.status eq 'Accepted' ? 'Đồng Ý Toàn Bộ Phác Đồ' : (plan.status eq 'PartiallyAccepted' ? 'Đồng Ý Một Phần Phác Đồ' : plan.statusDisplayName)}
            </span>
        </div>
        <c:if test="${not empty patient.citizenId}">
            <div class="meta-line">
                <span class="meta-label">Số CCCD / Định danh:</span>
                <span class="meta-value">${patient.citizenId}</span>
            </div>
        </c:if>
        <c:if test="${not empty plan.patientConsentDate}">
            <div class="meta-line">
                <span class="meta-label">Thời gian ký xác nhận:</span>
                <span class="meta-value">${plan.patientConsentDate}</span>
            </div>
        </c:if>
    </div>

    <c:if test="${not empty plan.diagnosis}">
        <div style="background: #f1f5f9; border-left: 4px solid #003366; padding: 10px 16px; margin-bottom: 20px; font-size: 13px;">
            <strong>Chẩn Đoán Lâm Sàng &amp; Chỉ Định:</strong> ${plan.diagnosis}
        </div>
    </c:if>

    <div style="font-weight: 700; font-size: 14px; color: var(--drsmile-navy); margin-bottom: 8px;">
        1. Danh Mục Các Thủ Thuật Nha Khoa Thống Nhất Thực Hiện:
    </div>

    <table class="print-table">
        <thead>
            <tr>
                <th style="width: 8%; text-align: center;">STT</th>
                <th style="width: 14%; text-align: center;">Buổi Hẹn</th>
                <th style="width: 38%;">Tên Thủ Thuật / Dịch Vụ</th>
                <th style="width: 22%;">Vị Trí Răng (Chuẩn FDI)</th>
                <th style="width: 18%; text-align: right;">Dự Toán Chi Phí</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${plan.items}" varStatus="status">
                <tr>
                    <td style="text-align: center;">${status.index + 1}</td>
                    <td style="text-align: center; font-weight: 600;">Buổi ${item.priorityOrder}</td>
                    <td>
                        <strong>${item.serviceName}</strong>
                        <div style="font-size: 11px; color: #64748b;">${item.serviceCode}</div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty item.toothNumber and item.toothNumber > 0}">
                                Răng #${item.toothNumber} (${item.surface})
                            </c:when>
                            <c:otherwise>
                                <em>Toàn hàm / Chung</em>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="text-align: right; font-weight: 600;">
                        ${item.formattedSubTotal}
                    </td>
                </tr>
            </c:forEach>
        </tbody>
        <tfoot>
            <tr style="background: #f8fafc; font-weight: 700;">
                <td colspan="4" style="text-align: right; padding: 10px 12px;">Tổng Dự Toán Chi Phí Phác Đồ:</td>
                <td style="text-align: right; color: var(--drsmile-navy); font-size: 14px; padding: 10px 12px;">
                    ${plan.formattedFinalEstimate}
                </td>
            </tr>
        </tfoot>
    </table>

    <div style="font-weight: 700; font-size: 14px; color: var(--drsmile-navy); margin-bottom: 8px;">
        2. Các Điều Khoản Đồng Thuận Y Khoa (Informed Consent Terms):
    </div>

    <div class="terms-box">
        <ol>
            <li><strong>Tư vấn minh bạch:</strong> Tôi xác nhận đã được Bác sĩ phụ trách giải thích cặn kẽ, đầy đủ về tình trạng răng miệng hiện tại, chẩn đoán, mục đích, lợi ích, rủi ro có thể gặp phải và các phương án điều trị thay thế.</li>
            <li><strong>Đồng ý tự nguyện:</strong> Tôi tự nguyện đồng thuận thực hiện các thủ thuật nha khoa được nêu trong phác đồ điều trị này và đồng ý cho phép Bác sĩ điều chỉnh kỹ thuật can thiệp khi có diễn biến phát sinh cần thiết vì lợi ích lâm sàng.</li>
            <li><strong>Tuân thủ y đức &amp; dặn dò:</strong> Tôi cam kết tuân thủ đúng các hướng dẫn chuyên môn của Bác sĩ trước, trong và sau điều trị; uống thuốc theo đúng đơn chỉ định và giữ gìn vệ sinh răng miệng theo phác đồ.</li>
            <li><strong>Tái khám đúng hẹn:</strong> Tôi đồng ý phối hợp đến khám theo đúng lịch hẹn các buổi điều trị đã ấn định để đảm bảo kết quả phục hồi tốt nhất.</li>
            <li><strong>Minh bạch tài chính:</strong> Tôi đã nắm rõ khung dự toán chi phí và hiểu rằng hóa đơn thu tiền chỉ xuất dựa trên các thủ thuật thực tế đã hoàn thành tại ghế khám.</li>
        </ol>

        <c:if test="${not empty plan.consentNotes}">
            <div style="margin-top: 12px; padding-top: 10px; border-top: 1px dashed #cbd5e1; font-weight: 600; color: #003366;">
                Ghi chú cam kết đặc biệt: <em>"${plan.consentNotes}"</em>
            </div>
        </c:if>
    </div>

    <div class="signature-grid">
        <div>
            <div class="sig-title">ĐẠI DIỆN BỆNH NHÂN / NGƯỜI GIÁM HỘ</div>
            <div class="sig-sub">(Ký, ghi rõ họ tên và cam kết tự nguyện)</div>
            <div class="sig-space"></div>
            <div class="sig-name">${plan.patientName}</div>
        </div>
        <div>
            <div class="sig-title">BÁC SĨ ĐIỀU TRỊ PHỤ TRÁCH</div>
            <div class="sig-sub">(Ký, ghi rõ họ tên và xác nhận tư vấn)</div>
            <div class="sig-space"></div>
            <div class="sig-name">${plan.dentistName}</div>
        </div>
    </div>

    <div style="margin-top: 35px; border-top: 1px solid #e2e8f0; padding-top: 12px; font-size: 11px; color: #94a3b8; text-align: center;">
        Bản cam kết này được lập thành 02 bản có giá trị pháp lý như nhau: 01 bản lưu trong Hồ sơ Bệnh án DCMS, 01 bản giao Bệnh nhân lưu giữ.
    </div>
</div>

</body>
</html>
