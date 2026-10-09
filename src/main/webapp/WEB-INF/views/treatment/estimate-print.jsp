<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dự Toán Viện Phí #KH-${plan.planId} — ${plan.patientName} | DCMS Dr.Smile</title>
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
            font-size: 12.5px;
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

        .print-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            font-size: 13px;
        }

        .print-table th {
            background: #f1f5f9;
            color: var(--drsmile-navy);
            font-weight: 700;
            text-align: left;
            padding: 10px 12px;
            border: 1px solid #cbd5e1;
        }

        .print-table td {
            padding: 10px 12px;
            border: 1px solid #cbd5e1;
            vertical-align: middle;
        }

        .summary-box {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 30px;
        }

        .summary-table {
            width: 340px;
            border-collapse: collapse;
            font-size: 13.5px;
        }

        .summary-table td {
            padding: 6px 12px;
        }

        .summary-total-row {
            font-size: 16px;
            font-weight: 800;
            color: var(--drsmile-navy);
            border-top: 2px solid var(--drsmile-navy);
        }

        .signature-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            text-align: center;
            margin-top: 40px;
            font-size: 13.5px;
        }

        .signature-space {
            height: 80px;
        }

        .no-print-bar {
            max-width: 820px;
            margin: 0 auto 20px auto;
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
    <a href="${pageContext.request.contextPath}/treatment/plans/detail?id=${plan.planId}" class="btn btn-secondary" style="font-weight: 700;">
        <span>←</span> Quay Lại Kế Hoạch
    </a>
    <button onclick="window.print()" class="btn btn-drsmile" style="padding: 10px 24px;">
        <span>🖨</span> In Bảng Dự Toán (Print / PDF)
    </button>
</div>

<div class="print-page">
    <div class="print-header">
        <div>
            <h2 class="brand-title">DCMS DENTAL CARE — DR.SMILE</h2>
            <p class="brand-sub">
                Hệ thống Phòng Khám Nha Khoa Kỹ Thuật Số Chuẩn Y Khoa<br/>
                Địa chỉ: Tòa nhà Y Tế Dr.Smile, Giảng Võ, Ba Đình, Hà Nội<br/>
                Hotline 24/7: <strong>096 669 2286</strong> &bull; Website: dcms.vn
            </p>
        </div>
        <div style="text-align: right;">
            <div style="font-family: 'Inter', monospace; font-weight: 800; font-size: 15px; color: var(--drsmile-blue);">
                #KH-${plan.planId}
            </div>
            <div style="font-size: 12px; color: #64748b; margin-top: 4px;">
                Ngày lập: ${plan.createdAt}
            </div>
        </div>
    </div>

    <div class="doc-title-block">
        <h1>BẢNG DỰ TOÁN VIỆN PHÍ & LỘ TRÌNH ĐIỀU TRỊ</h1>
        <div style="font-size: 13px; color: #64748b; font-style: italic;">
            (Treatment Estimate & Multi-visit Clinical Plan)
        </div>
    </div>

    <div class="meta-grid-print">
        <div>
            <strong>Bệnh nhân:</strong> ${plan.patientName}
        </div>
        <div>
            <strong>Số điện thoại:</strong> ${plan.patientPhone}
        </div>
        <div>
            <strong>Bác sĩ phụ trách:</strong> ${plan.dentistName} (${plan.dentistSpecialization})
        </div>
        <div>
            <strong>Mục tiêu:</strong> ${plan.title}
        </div>
        <c:if test="${not empty plan.diagnosis}">
            <div style="grid-column: span 2;">
                <strong>Chẩn đoán lâm sàng:</strong> ${plan.diagnosis}
            </div>
        </c:if>
    </div>

    <!-- Procedure Items Table -->
    <table class="print-table">
        <thead>
            <tr>
                <th style="width: 5%; text-align: center;">STT</th>
                <th style="width: 12%; text-align: center;">Buổi Khám</th>
                <th style="width: 33%;">Thủ Thuật / Dịch Vụ</th>
                <th style="width: 15%;">Vị Trí Răng (FDI)</th>
                <th style="width: 6%; text-align: center;">SL</th>
                <th style="width: 14%; text-align: right;">Đơn Giá</th>
                <th style="width: 15%; text-align: right;">Thành Tiền</th>
            </tr>
        </thead>
        <tbody>
            <c:set var="idx" value="1" />
            <c:forEach var="item" items="${plan.items}">
                <tr>
                    <td style="text-align: center;">${idx}</td>
                    <td style="text-align: center; font-weight: 600;">Buổi ${item.priorityOrder}</td>
                    <td>
                        <strong>${item.serviceName}</strong>
                        <div style="font-size: 11px; color: #64748b;">${item.serviceCode}</div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty item.toothNumber and item.toothNumber > 0}">
                                Răng ${item.toothNumber} (${item.surface})
                            </c:when>
                            <c:otherwise>
                                Toàn hàm / Chung
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="text-align: center;">${item.quantity}</td>
                    <td style="text-align: right;">${item.formattedUnitPrice}</td>
                    <td style="text-align: right; font-weight: 700;">${item.formattedSubTotal}</td>
                </tr>
                <c:set var="idx" value="${idx + 1}" />
            </c:forEach>
        </tbody>
    </table>

    <div class="summary-box">
        <table class="summary-table">
            <tr>
                <td>Tổng chi phí niêm yết:</td>
                <td style="text-align: right; font-weight: 700;">${plan.formattedEstimatedCost}</td>
            </tr>
            <c:if test="${plan.totalDiscount > 0}">
                <tr>
                    <td>Ưu đãi / Chiết khấu:</td>
                    <td style="text-align: right; font-weight: 700; color: #16a34a;">- ${plan.formattedTotalDiscount}</td>
                </tr>
            </c:if>
            <tr class="summary-total-row">
                <td>TỔNG DỰ TOÁN:</td>
                <td style="text-align: right; color: var(--drsmile-blue);">${plan.formattedFinalEstimate}</td>
            </tr>
        </table>
    </div>

    <div style="background: #f8fafc; border-radius: 8px; border: 1px solid #e2e8f0; padding: 14px 18px; font-size: 12px; line-height: 1.6; color: #475569; margin-bottom: 30px;">
        <strong>* Lưu ý y khoa & Chính sách viện phí:</strong>
        <br/>1. Bảng báo giá trên là dự toán điều trị lâm sàng. Hóa đơn viện phí chỉ được lập dựa trên các thủ thuật đã thực tế hoàn tất tại ghế khám.
        <br/>2. Các chi phí phát sinh ngoài phác đồ (nếu có tổn thương mới phát hiện) sẽ được bác sĩ giải thích và thông qua bệnh nhân trước khi tiến hành.
        <br/>3. Cam kết bảo hành chính hãng theo chính sách điện tử của DCMS Dental Care Dr.Smile.
    </div>

    <div class="signature-grid">
        <div>
            <strong>BỆNH NHÂN / ĐẠI DIỆN</strong><br/>
            <span style="font-size: 12px; color: #64748b;">(Ký và ghi rõ họ tên)</span>
            <div class="signature-space"></div>
            <strong>${plan.patientName}</strong>
        </div>

        <div>
            <strong>BÁC SĨ ĐIỀU TRỊ CHÍNH</strong><br/>
            <span style="font-size: 12px; color: #64748b;">(Ký, đóng dấu y tế)</span>
            <div class="signature-space"></div>
            <strong>${plan.dentistName}</strong>
        </div>
    </div>
</div>

</body>
</html>
