<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kê Đơn Thuốc Điện Tử | DCMS Dr.Smile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        :root {
            --drsmile-navy: #003366;
            --drsmile-teal: #007acc;
            --drsmile-gold: #c59b27;
            --drsmile-bg: #f8fafc;
        }

        body {
            background-color: var(--drsmile-bg);
            color: #1e293b;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            margin: 0;
            padding: 0;
        }

        .header-strip {
            background: linear-gradient(135deg, var(--drsmile-navy) 0%, #0a2540 100%);
            color: #ffffff;
            padding: 20px 32px;
            box-shadow: 0 4px 12px rgba(0, 51, 102, 0.15);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .header-title-box h1 {
            margin: 0 0 4px 0;
            font-size: 20px;
            font-weight: 700;
            letter-spacing: -0.3px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .header-subtitle {
            margin: 0;
            font-size: 13px;
            color: #94a3b8;
        }

        .main-container {
            max-width: 1240px;
            margin: 24px auto;
            padding: 0 20px 40px;
        }

        .meta-strip {
            background: #ffffff;
            border-radius: var(--radius-md);
            padding: 18px 24px;
            border: 1px solid rgba(0, 51, 102, 0.08);
            box-shadow: 0 2px 8px rgba(0, 51, 102, 0.04);
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }

        .meta-strip-label {
            font-size: 11.5px;
            color: var(--text-secondary);
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 2px;
        }

        .meta-strip-val {
            font-size: 14px;
            color: var(--drsmile-navy);
            font-weight: 700;
        }

        .allergy-alert {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-left: 5px solid #dc2626;
            border-radius: 8px;
            padding: 14px 18px;
            margin-bottom: 24px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .allergy-alert-title {
            color: #991b1b;
            font-weight: 700;
            font-size: 14px;
            margin-bottom: 2px;
        }

        .allergy-alert-text {
            color: #b91c1c;
            font-size: 13px;
            margin: 0;
        }

        .card-panel {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid rgba(0, 51, 102, 0.08);
            box-shadow: 0 4px 16px rgba(0, 51, 102, 0.04);
            padding: 24px;
            margin-bottom: 24px;
        }

        .panel-heading {
            font-size: 16px;
            font-weight: 700;
            color: var(--drsmile-navy);
            margin: 0 0 16px 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 12px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 6px;
        }

        .form-control {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 13.5px;
            color: #1e293b;
            box-sizing: border-box;
            outline: none;
            transition: border-color 0.15s ease;
        }

        .form-control:focus {
            border-color: var(--drsmile-teal);
            box-shadow: 0 0 0 3px rgba(0, 122, 204, 0.15);
        }

        .table-custom {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            margin-top: 10px;
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
            letter-spacing: 0.5px;
        }

        .table-custom td {
            padding: 10px 12px;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }

        .btn-add-item {
            background: #f0f7fd;
            color: var(--drsmile-teal);
            border: 1px dashed var(--drsmile-teal);
            padding: 10px 18px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-top: 12px;
            transition: all 0.2s;
        }

        .btn-add-item:hover {
            background: #e0f2fe;
        }

        .btn-danger-outline {
            background: #fff;
            color: #ef4444;
            border: 1px solid #fca5a5;
            border-radius: 4px;
            padding: 5px 8px;
            cursor: pointer;
            transition: all 0.15s;
        }

        .btn-danger-outline:hover {
            background: #fee2e2;
        }

        .template-chip {
            background: #f1f5f9;
            color: #475569;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            border: 1px solid #e2e8f0;
            transition: all 0.15s;
        }

        .template-chip:hover {
            background: #e2e8f0;
            color: var(--drsmile-navy);
        }

        .action-bar {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 24px;
        }

        .btn-primary-action {
            background: var(--drsmile-navy);
            color: #ffffff;
            border: none;
            padding: 12px 24px;
            border-radius: 6px;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 12px rgba(0, 51, 102, 0.2);
            transition: background 0.2s;
        }

        .btn-primary-action:hover {
            background: #002244;
        }

        .btn-secondary-action {
            background: #ffffff;
            color: #475569;
            border: 1px solid #cbd5e1;
            padding: 12px 20px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-secondary-action:hover {
            background: #f8fafc;
        }

        .error-banner {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #f87171;
            padding: 12px 16px;
            border-radius: 6px;
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
        <div class="header-title-box">
            <h1>
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/>
                    <path d="M12 5v14"/>
                    <path d="M5 12h14"/>
                </svg>
                Kê Đơn Thuốc Điện Tử (E-Prescription)
            </h1>
            <p class="header-subtitle">DCMS Dental Care — Dr.Smile Inspired | Kho Dược & Kê Đơn Lâm Sàng</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/clinical/procedures?visitId=${visit.visitId}" class="btn-secondary-action" style="color: #fff; background: rgba(255,255,255,0.1); border-color: rgba(255,255,255,0.3);">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Quay Lại Ghế Khám
            </a>
        </div>
    </div>

    <div class="main-container">

        <c:if test="${not empty param.error}">
            <div class="error-banner">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                <span>${param.error}</span>
            </div>
        </c:if>

        <c:if test="${not empty existingRx}">
            <div style="background: #f0fdf4; border: 1px solid #86efac; border-radius: 8px; padding: 14px 18px; margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between;">
                <div>
                    <strong style="color: #166534; font-size: 14px;">Buổi khám này đã có đơn thuốc điện tử: #${existingRx.prescriptionCode}</strong>
                    <div style="font-size: 12.5px; color: #15803d; margin-top: 2px;">
                        Ngày phát hành: <fmt:formatDate value="${existingRx.issuedAt}" pattern="dd/MM/yyyy HH:mm" /> | Bác sĩ: ${existingRx.dentistName}
                    </div>
                </div>
                <div style="display: flex; gap: 8px;">
                    <a href="${pageContext.request.contextPath}/prescription/view?id=${existingRx.prescriptionId}" class="btn-secondary-action" style="padding: 7px 12px; font-size: 13px;">
                        Xem Chi Tiết
                    </a>
                    <a href="${pageContext.request.contextPath}/prescription/print?id=${existingRx.prescriptionId}" target="_blank" class="btn-primary-action" style="padding: 7px 14px; font-size: 13px;">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="6 9 6 2 18 2 18 9"></polyline>
                            <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                            <rect x="6" y="14" width="12" height="8"></rect>
                        </svg>
                        In Đơn Thuốc
                    </a>
                </div>
            </div>
        </c:if>

        <!-- Patient & Visit Meta Strip -->
        <div class="meta-strip">
            <div>
                <div class="meta-strip-label">Bệnh Nhân</div>
                <div class="meta-strip-val">${patient.fullName}</div>
                <div style="font-size: 12px; color: #64748b; margin-top: 2px;">${patient.phone} | ${patient.gender}</div>
            </div>
            <div>
                <div class="meta-strip-label">Mã Buổi Khám</div>
                <div class="meta-strip-val">Visit #${visit.visitId}</div>
                <div style="font-size: 12px; color: #64748b; margin-top: 2px;">Ghế: ${visit.operatory}</div>
            </div>
            <div>
                <div class="meta-strip-label">Bác Sĩ Điều Trị</div>
                <div class="meta-strip-val">BS. ${dentist.fullName}</div>
                <div style="font-size: 12px; color: #64748b; margin-top: 2px;">CCHN: ${dentist.licenseNumber}</div>
            </div>
            <div>
                <div class="meta-strip-label">Thời Gian Tiếp Đón</div>
                <div class="meta-strip-val">
                    ${visit.checkInTime.toLocalDate()} ${visit.checkInTime.toLocalTime().toString().substring(0, 5)}
                </div>
            </div>
        </div>

        <!-- Allergy Alert if any -->
        <c:if test="${not empty patient.allergies or not empty patient.medicalAlerts}">
            <div class="allergy-alert">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="2">
                    <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/>
                    <line x1="12" y1="9" x2="12" y2="13"/>
                    <line x1="12" y1="17" x2="12.01" y2="17"/>
                </svg>
                <div>
                    <div class="allergy-alert-title">LƯU Ý CẢNH BÁO TIỀN SỬ DỊ ỨNG & BỆNH TOÀN THÂN:</div>
                    <div class="allergy-alert-text">
                        <c:if test="${not empty patient.allergies}">
                            <strong>Dị ứng thuốc/thực phẩm:</strong> ${patient.allergies}<br/>
                        </c:if>
                        <c:if test="${not empty patient.medicalAlerts}">
                            <strong>Cảnh báo y tế:</strong> ${patient.medicalAlerts}
                        </c:if>
                    </div>
                </div>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/prescription/save" method="POST" id="prescriptionForm">
            <input type="hidden" name="visitId" value="${visit.visitId}"/>

            <!-- Clinical Diagnosis & General Advice -->
            <div class="card-panel">
                <div class="panel-heading">
                    <span>1. Chẩn Đoán & Lời Dặn Của Bác Sĩ</span>
                    <div style="display: flex; gap: 6px;">
                        <span class="template-chip" onclick="applyTemplate('nhorang')">Mẫu: Sau Nhổ Răng</span>
                        <span class="template-chip" onclick="applyTemplate('dieutrituy')">Mẫu: Sau Chữa Tủy</span>
                        <span class="template-chip" onclick="applyTemplate('implant')">Mẫu: Sau Cấy Implant</span>
                        <span class="template-chip" onclick="applyTemplate('viemnuou')">Mẫu: Viêm Nướu / Nha Chu</span>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="diagnosis">Chẩn Đoán Lâm Sàng <span style="color:#ef4444;">*</span></label>
                        <input type="text" id="diagnosis" name="diagnosis" class="form-control" required
                               placeholder="VD: Viêm quanh chóp răng 46 / Sau nhổ răng khôn 38"
                               value="Viêm quanh cuống răng / Phục hồi sau thủ thuật nha khoa" />
                    </div>
                    <div class="form-group">
                        <label for="advice">Lời Dặn Bác Sĩ & Chế Độ Sinh Hoạt <span style="color:#ef4444;">*</span></label>
                        <input type="text" id="advice" name="advice" class="form-control" required
                               placeholder="Lời dặn uống thuốc, vệ sinh, kiêng khem..."
                               value="Uống thuốc đúng liều lượng, sau khi ăn no. Kiêng đồ cay nóng, rượu bia. Tái khám theo lịch hẹn." />
                    </div>
                </div>
            </div>

            <!-- Medicines Prescription Table -->
            <div class="card-panel">
                <div class="panel-heading">
                    <span>2. Danh Sách Thuốc Kê Đơn (E-Prescription Items)</span>
                    <span style="font-size: 13px; font-weight: 500; color: #64748b;">
                        Hỗ trợ tra cứu hoạt chất & tự động điền liều lượng
                    </span>
                </div>

                <table class="table-custom" id="medicinesTable">
                    <thead>
                        <tr>
                            <th style="width: 28%;">Tên Thuốc & Hoạt Chất</th>
                            <th style="width: 12%;">Số Lượng</th>
                            <th style="width: 10%;">Đơn Vị</th>
                            <th style="width: 32%;">Hướng Dẫn Liều Dùng (Dosage)</th>
                            <th style="width: 10%;">Ngày Dùng</th>
                            <th style="width: 8%; text-align: center;">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody id="medicineListBody">
                        <!-- Initial row -->
                        <tr class="medicine-row" id="row-0">
                            <td>
                                <select name="medicineId" class="form-control med-select" required onchange="onMedicineChange(this, 0)">
                                    <option value="">-- Chọn thuốc trong danh mục --</option>
                                    <c:forEach var="med" items="${medicines}">
                                        <option value="${med.medicineId}"
                                                data-ingredient="${med.activeIngredient}"
                                                data-unit="${med.unit}"
                                                data-instructions="${med.usageInstructions}"
                                                data-price="${med.unitPrice}">
                                            ${med.medicineName} (${med.activeIngredient})
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="med-info" style="font-size: 11.5px; color: #64748b; margin-top: 3px;"></div>
                            </td>
                            <td>
                                <input type="number" name="quantity" class="form-control" min="1" value="10" required />
                            </td>
                            <td>
                                <span class="unit-badge" style="font-weight: 600; color: var(--drsmile-navy);">Viên</span>
                            </td>
                            <td>
                                <input type="text" name="dosage" class="form-control med-dosage" required
                                       placeholder="VD: Uống 1 viên x 2 lần/ngày sau khi ăn" />
                            </td>
                            <td>
                                <input type="number" name="durationDays" class="form-control" min="1" max="30" value="5" />
                            </td>
                            <td style="text-align: center;">
                                <button type="button" class="btn-danger-outline" onclick="removeRow(this)" title="Xóa dòng thuốc">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="3 6 5 6 21 6"></polyline>
                                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                    </svg>
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <button type="button" class="btn-add-item" onclick="addNewMedicineRow()">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                    </svg>
                    Thêm Thuốc Khác Vào Đơn
                </button>
            </div>

            <!-- Action Bar -->
            <div class="action-bar">
                <a href="${pageContext.request.contextPath}/dentist/queue" class="btn-secondary-action">
                    Hủy Bỏ
                </a>
                <button type="submit" class="btn-primary-action">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                        <polyline points="17 21 17 13 7 13 7 21"></polyline>
                        <polyline points="7 3 7 8 15 8"></polyline>
                    </svg>
                    Xác Nhận Kê Đơn &amp; Lưu Hệ Thống
                </button>
            </div>
        </form>

    </div>

    <!-- Hidden Template Select for JS dynamic clone -->
    <select id="medSelectTemplate" style="display: none;">
        <option value="">-- Chọn thuốc trong danh mục --</option>
        <c:forEach var="med" items="${medicines}">
            <option value="${med.medicineId}"
                    data-ingredient="${med.activeIngredient}"
                    data-unit="${med.unit}"
                    data-instructions="${med.usageInstructions}"
                    data-price="${med.unitPrice}">
                ${med.medicineName} (${med.activeIngredient})
            </option>
        </c:forEach>
    </select>

    <script>
        let rowCounter = 1;

        function onMedicineChange(selectEl, rowIndex) {
            const selectedOpt = selectEl.options[selectEl.selectedIndex];
            const row = selectEl.closest('tr');
            const unitEl = row.querySelector('.unit-badge');
            const dosageInput = row.querySelector('.med-dosage');
            const infoEl = row.querySelector('.med-info');

            if (selectedOpt && selectedOpt.value) {
                const unit = selectedOpt.getAttribute('data-unit') || 'Viên';
                const instructions = selectedOpt.getAttribute('data-instructions') || '';
                const ingredient = selectedOpt.getAttribute('data-ingredient') || '';

                if (unitEl) unitEl.textContent = unit;
                if (dosageInput && (!dosageInput.value || dosageInput.value.trim() === '')) {
                    dosageInput.value = instructions;
                }
                if (infoEl) {
                    infoEl.textContent = 'Hoạt chất: ' + ingredient;
                }
            } else {
                if (unitEl) unitEl.textContent = 'Viên';
                if (infoEl) infoEl.textContent = '';
            }
        }

        function addNewMedicineRow() {
            const tbody = document.getElementById('medicineListBody');
            const templateOptions = document.getElementById('medSelectTemplate').innerHTML;
            const newIndex = rowCounter++;

            const tr = document.createElement('tr');
            tr.className = 'medicine-row';
            tr.id = 'row-' + newIndex;

            tr.innerHTML = `
                <td>
                    <select name="medicineId" class="form-control med-select" required onchange="onMedicineChange(this, ` + newIndex + `)">
                        ` + templateOptions + `
                    </select>
                    <div class="med-info" style="font-size: 11.5px; color: #64748b; margin-top: 3px;"></div>
                </td>
                <td>
                    <input type="number" name="quantity" class="form-control" min="1" value="10" required />
                </td>
                <td>
                    <span class="unit-badge" style="font-weight: 600; color: var(--drsmile-navy);">Viên</span>
                </td>
                <td>
                    <input type="text" name="dosage" class="form-control med-dosage" required
                           placeholder="VD: Uống 1 viên x 2 lần/ngày sau khi ăn" />
                </td>
                <td>
                    <input type="number" name="durationDays" class="form-control" min="1" max="30" value="5" />
                </td>
                <td style="text-align: center;">
                    <button type="button" class="btn-danger-outline" onclick="removeRow(this)" title="Xóa dòng thuốc">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="3 6 5 6 21 6"></polyline>
                            <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                        </svg>
                    </button>
                </td>
            `;

            tbody.appendChild(tr);
        }

        function removeRow(btn) {
            const tbody = document.getElementById('medicineListBody');
            const rows = tbody.querySelectorAll('.medicine-row');
            if (rows.length <= 1) {
                alert('Đơn thuốc phải có ít nhất 1 loại thuốc.');
                return;
            }
            btn.closest('tr').remove();
        }

        function applyTemplate(type) {
            const diag = document.getElementById('diagnosis');
            const advice = document.getElementById('advice');

            if (type === 'nhorang') {
                diag.value = 'Theo dõi sau nhổ răng khôn / Tiểu phẫu răng hàm';
                advice.value = 'Cắn gạc 30-45 phút. Không súc miệng mạnh hoặc khạc nhổ trong 24h đầu. Chườm lạnh má ngoài 24h đầu. Uống thuốc theo toa.';
            } else if (type === 'dieutrituy') {
                diag.value = 'Viêm tủy cấp / Viêm quanh cuống răng sau nội nha';
                advice.value = 'Tránh nhai thức ăn cứng bên răng điều trị. Uống thuốc giảm đau khi cần. Tái khám hoàn tất trám/bọc răng sứ theo hẹn.';
            } else if (type === 'implant') {
                diag.value = 'Hậu phẫu cấy ghép trụ Implant nha khoa';
                advice.value = 'Chườm đá ngày đầu, chườm ấm ngày thứ 2. Ăn thức ăn mềm nguội. Không hút thuốc lá trong 2 tuần. Vệ sinh nhẹ nhàng bằng nước súc miệng chuyên dụng.';
            } else if (type === 'viemnuou') {
                diag.value = 'Viêm nướu phì đại / Viêm nha chu mạn tính';
                advice.value = 'Sử dụng chỉ nha khoa và nước súc miệng hàng ngày. Đánh răng đúng cách bằng bàn chải lông mềm. Uống thuốc đủ liệu trình 5-7 ngày.';
            }
        }
    </script>
</body>
</html>
