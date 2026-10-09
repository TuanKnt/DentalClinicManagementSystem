<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đơn Thuốc #${prescription.prescriptionCode} | DCMS Dr.Smile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        :root {
            --drsmile-navy: #003366;
            --drsmile-teal: #007acc;
            --drsmile-bg: #f8fafc;
        }

        body {
            background-color: var(--drsmile-bg);
            color: #1e293b;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            margin: 0;
            padding: 0;
        }

        .header-strip {
            background: linear-gradient(135deg, var(--drsmile-navy) 0%, #0a2540 100%);
            color: #ffffff;
            padding: 20px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .header-strip h1 {
            margin: 0 0 4px 0;
            font-size: 20px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .main-container {
            max-width: 1100px;
            margin: 24px auto;
            padding: 0 20px 40px;
        }

        .card-panel {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid rgba(0, 51, 102, 0.08);
            box-shadow: 0 4px 16px rgba(0, 51, 102, 0.04);
            padding: 24px;
            margin-bottom: 24px;
        }

        .meta-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #f1f5f9;
        }

        .meta-label {
            font-size: 12px;
            color: #64748b;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 2px;
        }

        .meta-val {
            font-size: 14.5px;
            color: var(--drsmile-navy);
            font-weight: 700;
        }

        .table-custom {
            width: 100%;
            border-collapse: collapse;
            font-size: 13.5px;
            margin: 16px 0;
        }

        .table-custom th {
            background: #f8fafc;
            color: var(--drsmile-navy);
            font-weight: 700;
            text-align: left;
            padding: 10px 12px;
            border-bottom: 2px solid #e2e8f0;
            font-size: 12px;
            text-transform: uppercase;
        }

        .table-custom td {
            padding: 12px;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }

        .btn-action-group {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 24px;
        }

        .btn-primary {
            background: var(--drsmile-navy);
            color: #ffffff;
            border: none;
            padding: 11px 22px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }

        .btn-secondary {
            background: #ffffff;
            color: #475569;
            border: 1px solid #cbd5e1;
            padding: 11px 18px;
            border-radius: 6px;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .success-box {
            background: #f0fdf4;
            border: 1px solid #86efac;
            color: #166534;
            border-radius: 6px;
            padding: 12px 16px;
            margin-bottom: 20px;
            font-size: 13.5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
</head>
<body>

    <div class="header-strip">
        <div>
            <h1>
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                    <line x1="16" y1="13" x2="8" y2="13"></line>
                    <line x1="16" y1="17" x2="8" y2="17"></line>
                    <polyline points="10 9 9 9 8 9"></polyline>
                </svg>
                Chi Tiết Đơn Thuốc #${prescription.prescriptionCode}
            </h1>
            <p style="margin: 0; font-size: 13px; color: #94a3b8;">Hệ Thống Quản Lý Kê Đơn Điện Tử DCMS</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/dentist/queue" class="btn-secondary" style="color: #fff; background: rgba(255,255,255,0.1); border-color: rgba(255,255,255,0.3);">
                Quay Lại Danh Sách Khám
            </a>
        </div>
    </div>

    <div class="main-container">

        <c:if test="${param.msg eq 'created'}">
            <div class="success-box">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
                <span>Đơn thuốc điện tử đã được phát hành thành công và lưu vào hồ sơ bệnh án!</span>
            </div>
        </c:if>

        <div class="card-panel">
            <div class="meta-grid">
                <div>
                    <div class="meta-label">Mã Đơn Thuốc</div>
                    <div class="meta-val">#${prescription.prescriptionCode}</div>
                </div>
                <div>
                    <div class="meta-label">Bệnh Nhân</div>
                    <div class="meta-val">${prescription.patientName}</div>
                    <div style="font-size: 12px; color: #64748b;">${prescription.patientPhone}</div>
                </div>
                <div>
                    <div class="meta-label">Bác Sĩ Kê Đơn</div>
                    <div class="meta-val">BS. ${prescription.dentistName}</div>
                    <div style="font-size: 12px; color: #64748b;">CCHN: ${prescription.dentistLicense}</div>
                </div>
                <div>
                    <div class="meta-label">Thời Gian Kê</div>
                    <div class="meta-val">
                        <fmt:formatDate value="${prescription.issuedAt}" pattern="dd/MM/yyyy HH:mm" />
                    </div>
                </div>
            </div>

            <div>
                <strong style="color: #334155; font-size: 13.5px;">Chẩn đoán lâm sàng:</strong>
                <p style="margin: 4px 0 16px 0; color: var(--drsmile-navy); font-weight: 600; font-size: 14.5px;">
                    ${prescription.diagnosis}
                </p>
            </div>

            <table class="table-custom">
                <thead>
                    <tr>
                        <th style="width: 8%; text-align: center;">STT</th>
                        <th style="width: 32%;">Tên Thuốc</th>
                        <th style="width: 25%;">Hoạt Chất</th>
                        <th style="width: 15%; text-align: center;">Số Lượng</th>
                        <th style="width: 20%;">Cách Dùng &amp; Liều Lượng</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${prescription.items}" varStatus="status">
                        <tr>
                            <td style="text-align: center; font-weight: bold;">${status.index + 1}</td>
                            <td><strong style="color: var(--drsmile-navy);">${item.medicineName}</strong></td>
                            <td style="color: #64748b; font-style: italic;">${item.activeIngredient}</td>
                            <td style="text-align: center; font-weight: bold;">${item.quantity} ${item.unit}</td>
                            <td>${item.dosage}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div style="background: #f8fafc; border-left: 3px solid var(--drsmile-teal); padding: 12px 16px; border-radius: 4px; margin-top: 16px;">
                <strong style="color: var(--drsmile-navy); font-size: 13px;">Lời dặn của Bác sĩ:</strong>
                <p style="margin: 4px 0 0 0; font-size: 13.5px; color: #334155;">${prescription.advice}</p>
            </div>

            <div class="btn-action-group">
                <a href="${pageContext.request.contextPath}/clinical/procedures?visitId=${prescription.visitId}" class="btn-secondary">
                    Về Ghế Khám
                </a>
                <a href="${pageContext.request.contextPath}/prescription/print?id=${prescription.prescriptionId}" target="_blank" class="btn-primary">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="6 9 6 2 18 2 18 9"></polyline>
                        <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                        <rect x="6" y="14" width="12" height="8"></rect>
                    </svg>
                    In Đơn Thuốc (Print)
                </a>
            </div>
        </div>

    </div>

</body>
</html>
