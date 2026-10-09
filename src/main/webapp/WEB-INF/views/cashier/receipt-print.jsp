<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biên Lai Thu Tiền #${invoice.invoiceCode} — DCMS Dental Care Dr.Smile</title>
    <style>
        @page {
            size: A4 portrait;
            margin: 15mm;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            color: #0f172a;
            background: #f1f5f9;
            margin: 0;
            padding: 24px;
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
        }

        .no-print-bar {
            max-width: 800px;
            margin: 0 auto 20px auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            font-size: 14px;
            font-weight: 600;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            border: 1px solid transparent;
            transition: all 0.2s;
        }

        .btn-drsmile {
            background: #003366;
            color: #ffffff;
        }

        .btn-drsmile:hover {
            background: #0a2540;
        }

        .btn-secondary {
            background: #ffffff;
            color: #475569;
            border-color: #cbd5e1;
        }

        .btn-secondary:hover {
            background: #f8fafc;
        }

        .receipt-card {
            max-width: 800px;
            margin: 0 auto;
            background: #ffffff;
            padding: 40px 48px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
            border-radius: 8px;
            box-sizing: border-box;
        }

        .receipt-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 2px solid #003366;
            padding-bottom: 20px;
            margin-bottom: 24px;
        }

        .clinic-brand {
            font-size: 20px;
            font-weight: 800;
            color: #003366;
            margin: 0 0 6px 0;
            letter-spacing: -0.3px;
        }

        .clinic-sub {
            font-size: 12.5px;
            color: #475569;
            line-height: 1.5;
            margin: 0;
        }

        .receipt-meta {
            text-align: right;
            font-size: 13px;
        }

        .receipt-title {
            text-align: center;
            margin: 24px 0 20px 0;
        }

        .receipt-title h1 {
            font-size: 22px;
            font-weight: 800;
            color: #003366;
            margin: 0 0 6px 0;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .receipt-title p {
            font-size: 13px;
            color: #64748b;
            margin: 0;
            font-style: italic;
        }

        .patient-info-grid {
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

        .info-item {
            display: flex;
            align-items: baseline;
        }

        .info-label {
            width: 140px;
            color: #64748b;
            flex-shrink: 0;
        }

        .info-value {
            font-weight: 600;
            color: #0f172a;
        }

        .receipt-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            margin-bottom: 24px;
        }

        .receipt-table th {
            background: #f1f5f9;
            color: #003366;
            font-weight: 700;
            text-align: left;
            padding: 10px 12px;
            border-top: 1px solid #cbd5e1;
            border-bottom: 1px solid #cbd5e1;
        }

        .receipt-table td {
            padding: 10px 12px;
            border-bottom: 1px solid #e2e8f0;
            color: #1e293b;
        }

        .totals-section {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 24px;
        }

        .totals-table {
            width: 320px;
            font-size: 13.5px;
        }

        .totals-row {
            display: flex;
            justify-content: space-between;
            padding: 6px 0;
            color: #475569;
        }

        .totals-row.grand-total {
            border-top: 2px solid #003366;
            margin-top: 6px;
            padding-top: 10px;
            font-size: 16px;
            font-weight: 800;
            color: #003366;
        }

        .signatures-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            text-align: center;
            margin-top: 36px;
            padding-top: 20px;
            font-size: 13px;
        }

        .sig-title {
            font-weight: 700;
            color: #003366;
            margin-bottom: 4px;
        }

        .sig-sub {
            font-size: 11.5px;
            color: #94a3b8;
            font-style: italic;
            margin-bottom: 60px;
        }

        .sig-name {
            font-weight: 700;
            color: #1e293b;
        }

        @media print {
            body {
                background: #ffffff;
                padding: 0;
            }
            .no-print-bar {
                display: none !important;
            }
            .receipt-card {
                box-shadow: none;
                border: none;
                padding: 0;
            }
        }
    </style>
</head>
<body>

<div class="no-print-bar">
    <a href="${pageContext.request.contextPath}/cashier/billing" class="btn btn-secondary">
        Quay Lại Bàn Thu Ngân
    </a>
    <button onclick="window.print()" class="btn btn-drsmile">
        In Biên Lai (Print / PDF)
    </button>
</div>

<div class="receipt-card">
    <div class="receipt-header">
        <div>
            <h2 class="clinic-brand">DCMS DENTAL CARE — DR.SMILE</h2>
            <p class="clinic-sub">
                Hệ thống Phòng Khám Nha Khoa Kỹ Thuật Số Chuẩn Y Khoa<br/>
                Địa chỉ: Tòa nhà Y Tế Dr.Smile, Giảng Võ, Ba Đình, Hà Nội<br/>
                Hotline: 096 669 2286 &bull; Website: dcms.vn
            </p>
        </div>
        <div class="receipt-meta">
            <div>Mã Hóa Đơn: <strong>#${invoice.invoiceCode}</strong></div>
            <div style="margin-top: 4px; color: #64748b;">Mã Lượt Khám: #${invoice.visitId}</div>
            <div style="margin-top: 4px; color: #64748b;">Ngày lập: <c:out value="${invoice.createdAt}" /></div>
        </div>
    </div>

    <div class="receipt-title">
        <h1>BIÊN LAI THU TIỀN VIỆN PHÍ</h1>
        <p>Phiếu thu xác nhận chi phí thực hiện thủ thuật nha khoa tại phòng khám</p>
    </div>

    <div class="patient-info-grid">
        <div class="info-item">
            <span class="info-label">Họ và tên bệnh nhân:</span>
            <span class="info-value"><c:out value="${invoice.patientName}" /></span>
        </div>
        <div class="info-item">
            <span class="info-label">Số điện thoại:</span>
            <span class="info-value"><c:out value="${invoice.patientPhone}" /></span>
        </div>
        <div class="info-item">
            <span class="info-label">CCCD / Định danh:</span>
            <span class="info-value"><c:out value="${invoice.patientCitizenId != null ? invoice.patientCitizenId : 'Chưa cập nhật'}" /></span>
        </div>
        <div class="info-item">
            <span class="info-label">Địa chỉ cư trú:</span>
            <span class="info-value"><c:out value="${invoice.patientAddress != null ? invoice.patientAddress : 'Hà Nội'}" /></span>
        </div>
        <div class="info-item">
            <span class="info-label">Bác sĩ điều trị:</span>
            <span class="info-value"><c:out value="${invoice.dentistName}" /></span>
        </div>
        <div class="info-item">
            <span class="info-label">Ghế khám điều trị:</span>
            <span class="info-value"><c:out value="${invoice.operatory}" /></span>
        </div>
    </div>

    <!-- Bảng Kê Chi Tiết Thủ Thuật Thực Tế Đã Làm -->
    <table class="receipt-table">
        <thead>
            <tr>
                <th style="width: 40px; text-align: center;">STT</th>
                <th style="width: 100px;">Mã Dịch Vụ</th>
                <th>Tên Thủ Thuật / Dịch Vụ Thực Hiện</th>
                <th style="width: 110px; text-align: center;">Vị Trí Răng</th>
                <th style="width: 60px; text-align: center;">SL</th>
                <th style="width: 120px; text-align: right;">Đơn Giá</th>
                <th style="width: 130px; text-align: right;">Thành Tiền</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty invoice.procedures}">
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 20px; color: #64748b;">
                            Chi phí điều trị theo hóa đơn #${invoice.invoiceCode}
                        </td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="p" items="${invoice.procedures}" varStatus="status">
                        <tr>
                            <td style="text-align: center;">${status.index + 1}</td>
                            <td><span style="font-family: monospace; font-weight: 600;">${p.serviceCode}</span></td>
                            <td style="font-weight: 600;">
                                <c:out value="${p.serviceName}" />
                                <c:if test="${not empty p.clinicalNotes}">
                                    <div style="font-size: 11.5px; color: #64748b; font-weight: normal; margin-top: 2px;">
                                        Ghi chú: <c:out value="${p.clinicalNotes}" />
                                    </div>
                                </c:if>
                            </td>
                            <td style="text-align: center;">
                                <c:choose>
                                    <c:when test="${not empty p.toothNumber}">
                                        Răng #${p.toothNumber} <c:if test="${not empty p.surface}">(${p.surface})</c:if>
                                    </c:when>
                                    <c:otherwise>Toàn hàm</c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align: center;">${p.quantity}</td>
                            <td style="text-align: right;">${p.formattedPrice}</td>
                            <td style="text-align: right; font-weight: 700;">${p.formattedSubTotal}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <!-- Tổng Hợp Viện Phí & Thanh Toán -->
    <div class="totals-section">
        <div class="totals-table">
            <div class="totals-row">
                <span>Tổng chi phí thủ thuật:</span>
                <span style="font-weight: 600;">${invoice.formattedTotalAmount}</span>
            </div>
            <c:if test="${invoice.discountAmount gt 0}">
                <div class="totals-row" style="color: #059669;">
                    <span>Giảm trừ / Chiết khấu:</span>
                    <span>- ${invoice.formattedDiscountAmount}</span>
                </div>
            </c:if>
            <div class="totals-row">
                <span>Tổng tiền sau giảm trừ:</span>
                <span style="font-weight: 700; color: #003366;">${invoice.formattedFinalAmount}</span>
            </div>
            <div class="totals-row" style="color: #0284c7;">
                <span>Tổng tiền đã thanh toán:</span>
                <span style="font-weight: 700;">${invoice.formattedPaidAmount}</span>
            </div>
            <div class="totals-row grand-total">
                <span>Số tiền còn lại (Nợ):</span>
                <span>${invoice.formattedBalanceAmount}</span>
            </div>
        </div>
    </div>

    <!-- Lịch Sử Các Lần Thu Tiền -->
    <c:if test="${not empty invoice.payments}">
        <div style="margin-bottom: 24px;">
            <div style="font-size: 13px; font-weight: 700; color: #003366; margin-bottom: 8px;">
                Chi Tiết Lịch Sử Ghi Nhận Thanh Toán
            </div>
            <table class="receipt-table" style="margin-bottom: 0;">
                <thead>
                    <tr>
                        <th style="width: 120px;">Mã Phiếu Thu</th>
                        <th style="width: 160px;">Thời Gian</th>
                        <th style="width: 140px;">Phương Thức</th>
                        <th>Ghi Chú</th>
                        <th style="width: 130px; text-align: right;">Số Tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="pay" items="${invoice.payments}">
                        <tr>
                            <td style="font-family: monospace; font-weight: 600;">${pay.paymentCode}</td>
                            <td><c:out value="${pay.paidAt}" /></td>
                            <td>${pay.paymentMethodDisplayName}</td>
                            <td><c:out value="${pay.notes}" /></td>
                            <td style="text-align: right; font-weight: 700; color: #059669;">${pay.formattedAmount}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <!-- Chữ Ký Xác Nhận -->
    <div class="signatures-grid">
        <div>
            <div class="sig-title">NGƯỜI NỘP TIỀN</div>
            <div class="sig-sub">(Ký và ghi rõ họ tên)</div>
            <div class="sig-name"><c:out value="${invoice.patientName}" /></div>
        </div>
        <div>
            <div class="sig-title">THU NGÂN VIỆN PHÍ</div>
            <div class="sig-sub">(Ký, đóng dấu và ghi rõ họ tên)</div>
            <div class="sig-name"><c:out value="${invoice.cashierName}" /></div>
        </div>
    </div>
</div>

</body>
</html>
