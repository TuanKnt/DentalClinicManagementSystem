<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activeMenu" value="queue" scope="request" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KhÃ¡m LÃ¢m SÃ ng & SÆ¡ Äá»“ RÄƒng â€” ${patient.fullName} â€” Dr.Smile DCMS Dental Care</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        .exam-header-bar {
            background: white;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border);
            padding: 20px 24px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }
        .patient-summary {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .patient-initials {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--drsmile-navy) 0%, var(--drsmile-blue) 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            font-weight: 700;
        }
        .exam-nav-tabs {
            display: flex;
            gap: 8px;
            border-bottom: 2px solid var(--border);
            margin-bottom: 20px;
            background: white;
            border-radius: 10px 10px 0 0;
            padding: 0 16px;
        }
        .exam-tab-btn {
            padding: 14px 20px;
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
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .exam-tab-btn:hover {
            color: var(--primary);
        }
        .exam-tab-btn.active {
            color: var(--primary);
            border-bottom-color: var(--primary);
            font-weight: 700;
        }

        /* SVG Odontogram Styles */
        .odontogram-container {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--border);
            padding: 24px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 24px;
        }
        .arch-title {
            text-align: center;
            font-size: 13px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            margin: 10px 0 6px 0;
        }
        .teeth-row {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-bottom: 12px;
            flex-wrap: nowrap;
            overflow-x: auto;
            padding: 6px 0;
        }
        .quadrant-divider {
            width: 2px;
            background: #cbd5e1;
            margin: 0 8px;
            border-radius: 1px;
        }
        .tooth-box {
            display: flex;
            flex-direction: column;
            align-items: center;
            cursor: pointer;
            padding: 4px;
            border-radius: 6px;
            transition: all 0.15s ease;
            border: 1px solid transparent;
        }
        .tooth-box:hover {
            background: #f1f5f9;
            border-color: #cbd5e1;
        }
        .tooth-box.selected {
            background: #e0f2fe;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(0, 51, 102, 0.25);
        }
        .tooth-num {
            font-size: 12px;
            font-weight: 700;
            color: #334155;
            margin-bottom: 4px;
        }
        .tooth-svg {
            width: 44px;
            height: 44px;
        }
        .tooth-surface {
            fill: #f8fafc;
            stroke: #64748b;
            stroke-width: 1.2;
            cursor: pointer;
            transition: fill 0.15s ease, stroke 0.15s ease;
        }
        .tooth-surface:hover {
            fill: #e0f2fe;
            stroke: var(--drsmile-navy);
        }
        .tooth-surface.has-caries { fill: #ef4444 !important; stroke: #b91c1c; }
        .tooth-surface.has-filled { fill: #3b82f6 !important; stroke: #1d4ed8; }
        .tooth-surface.has-crown { fill: #8b5cf6 !important; stroke: #6d28d9; }
        .tooth-surface.has-rootcanal { fill: #f59e0b !important; stroke: #b45309; }
        .tooth-surface.has-missing { fill: #94a3b8 !important; stroke: #475569; }

        .palette-bar {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
            padding: 14px 18px;
            background: #f8fafc;
            border: 1px solid var(--border);
            border-radius: 8px;
            margin-top: 16px;
        }
        .condition-pill-btn {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 8px 14px;
            font-size: 13px;
            font-weight: 600;
            border-radius: 20px;
            border: 1px solid var(--border);
            background: white;
            cursor: pointer;
            transition: all 0.15s ease;
        }
        .condition-pill-btn:hover {
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .condition-pill-btn.active {
            border-color: currentColor;
            box-shadow: 0 0 0 2px currentColor;
        }
        .color-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
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
                <a href="${pageContext.request.contextPath}/">Trang chá»§</a>
                <span class="breadcrumb-separator">/</span>
                <a href="${pageContext.request.contextPath}/dentist/queue">HÃ ng Äá»£i KhÃ¡m</a>
                <span class="breadcrumb-separator">/</span>
                <span>KhÃ¡m LÃ¢m SÃ ng & SÆ¡ Äá»“ RÄƒng (LÆ°á»£t #${visit.visitId})</span>
            </div>

            <!-- Toast / Notifications -->
            <c:if test="${param.success eq 'started'}">
                <div class="alert-banner alert-banner-success">
                    <span class="alert-banner-icon">âœ“</span>
                    <div><strong>Báº¯t Ä‘áº§u khÃ¡m:</strong> Bá»‡nh nhÃ¢n Ä‘Ã£ vÃ o gháº¿. HÃ£y tiáº¿n hÃ nh kiá»ƒm tra sinh hiá»‡u vÃ  láº­p sÆ¡ Ä‘á»“ rÄƒng lÃ¢m sÃ ng.</div>
                </div>
            </c:if>
            <c:if test="${param.success eq 'vitals_saved'}">
                <div class="alert-banner alert-banner-success">
                    <span class="alert-banner-icon">âœ“</span>
                    <div><strong>ÄÃ£ cáº­p nháº­t sinh hiá»‡u:</strong> Chá»‰ sá»‘ tiá»n thá»§ thuáº­t vÃ  Ä‘Ã¡nh giÃ¡ nguy cÆ¡ cháº£y mÃ¡u Ä‘Ã£ Ä‘Æ°á»£c lÆ°u thÃ nh cÃ´ng.</div>
                </div>
            </c:if>
            <c:if test="${param.success eq 'exam_saved'}">
                <div class="alert-banner alert-banner-success">
                    <span class="alert-banner-icon">âœ“</span>
                    <div><strong>ÄÃ£ lÆ°u káº¿t quáº£ khÃ¡m:</strong> Cháº©n Ä‘oÃ¡n sÆ¡ bá»™, khÃ¡m ngoÃ i/trong miá»‡ng Ä‘Ã£ Ä‘Æ°á»£c lÆ°u trá»¯ vÃ o bá»‡nh Ã¡n.</div>
                </div>
            </c:if>
            <c:if test="${param.success eq 'operatory_updated'}">
                <div class="alert-banner alert-banner-success">
                    <span class="alert-banner-icon">âœ“</span>
                    <div><strong>ÄÃ£ Ä‘á»•i gháº¿ khÃ¡m:</strong> PhÃ¢n cÃ´ng vá»‹ trÃ­ gháº¿ nha khoa thÃ nh cÃ´ng.</div>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="alert-banner alert-banner-danger">
                    <span class="alert-banner-icon">!</span>
                    <div><strong>Lá»—i:</strong> ${param.error}</div>
                </div>
            </c:if>

            <!-- Patient Clinical Banner -->
            <div class="exam-header-bar">
                <div class="patient-summary">
                    <div class="patient-initials">
                        ${patient.fullName.substring(0, 1).toUpperCase()}
                    </div>
                    <div>
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <h2 style="margin: 0; font-size: 20px; color: var(--text-primary);">${patient.fullName}</h2>
                            <span class="badge-pill badge-Pending">MÃ£ BN: #${patient.patientId}</span>
                            <span class="badge-pill badge-Confirmed">${patient.gender} &bull; ${patient.dateOfBirth}</span>
                            <span class="badge-pill badge-Arrived">â— LÆ°á»£t #${visit.visitId}: ${visit.status}</span>
                        </div>
                        <div style="font-size: 13px; color: var(--text-muted); margin-top: 4px;">
                            SÄT: <code>${patient.phoneNumber}</code> &bull; Tiáº¿p Ä‘Ã³n lÃºc: <strong>${visit.checkInTime.toLocalTime().toString().substring(0, 5)}</strong> &bull; PhÃ¢n loáº¡i: <strong>${visit.visitType}</strong>
                        </div>
                    </div>
                </div>

                <!-- Chair Operatory & Visit Actions -->
                <div style="display: flex; align-items: center; gap: 12px;">
                    <form action="${pageContext.request.contextPath}/clinical/examination" method="POST" style="display: flex; align-items: center; gap: 6px; margin: 0;">
                        <input type="hidden" name="action" value="update_operatory" />
                        <input type="hidden" name="visitId" value="${visit.visitId}" />
                        <span style="font-size: 13px; font-weight: 600; color: var(--text-muted);">Gháº¿:</span>
                        <select name="operatory" class="form-control" style="width: 140px; padding: 6px 10px; font-size: 13px;" onchange="this.form.submit()">
                            <option value="Gháº¿ 1 - P.101" ${visit.operatory eq 'Gháº¿ 1 - P.101' ? 'selected' : ''}>Gháº¿ 1 - P.101</option>
                            <option value="Gháº¿ 2 - P.102" ${visit.operatory eq 'Gháº¿ 2 - P.102' ? 'selected' : ''}>Gháº¿ 2 - P.102</option>
                            <option value="Gháº¿ 3 - P.103" ${visit.operatory eq 'Gháº¿ 3 - P.103' ? 'selected' : ''}>Gháº¿ 3 - P.103</option>
                            <option value="Gháº¿ VIP - P.201" ${visit.operatory eq 'Gháº¿ VIP - P.201' ? 'selected' : ''}>Gháº¿ VIP - P.201</option>
                        </select>
                    </form>

                    <form action="${pageContext.request.contextPath}/clinical/examination" method="POST" style="margin: 0;" onsubmit="return confirm('Báº¡n cÃ³ cháº¯c cháº¯n muá»‘n hoÃ n thÃ nh lÆ°á»£t khÃ¡m nÃ y?');">
                        <input type="hidden" name="action" value="complete_visit" />
                        <input type="hidden" name="visitId" value="${visit.visitId}" />
                        <button type="submit" class="btn btn-success" style="padding: 9px 16px; font-size: 13px;">
                            HoÃ n ThÃ nh LÆ°á»£t KhÃ¡m
                        </button>
                    </form>
                </div>
            </div>

            <!-- Medical Alerts Warning -->
            <c:if test="${not empty patient.medicalAlerts || not empty patient.allergies}">
                <div style="background: #fef2f2; border: 1px solid #fecaca; border-left: 5px solid #ef4444; border-radius: 8px; padding: 12px 18px; margin-bottom: 20px; font-size: 13px;">
                    <strong style="color: #b91c1c;">Cáº¢NH BÃO Bá»†NH LÃ & Dá»Š á»¨NG:</strong>
                    <c:if test="${not empty patient.medicalAlerts}">
                        <span style="color: #991b1b; margin-left: 6px;">Bá»‡nh ná»n: <strong>${patient.medicalAlerts}</strong>.</span>
                    </c:if>
                    <c:if test="${not empty patient.allergies}">
                        <span style="color: #991b1b; margin-left: 6px;">Dá»‹ á»©ng: <strong>${patient.allergies}</strong>.</span>
                    </c:if>
                </div>
            </c:if>

            <!-- Navigation Tabs -->
            <div class="exam-nav-tabs">
                <button type="button" class="exam-tab-btn active" onclick="switchTab('chart', this)">
                    SÆ¡ Äá»“ RÄƒng FDI (Odontogram)
                </button>
                <button type="button" class="exam-tab-btn" onclick="switchTab('vitals', this)">
                    Sinh Hiá»‡u Tiá»n Thá»§ Thuáº­t
                </button>
                <button type="button" class="exam-tab-btn" onclick="switchTab('exam', this)">
                    KhÃ¡m & Cháº©n ÄoÃ¡n LÃ¢m SÃ ng
                </button>
                <button type="button" class="exam-tab-btn" onclick="switchTab('images', this)">
                    HÃ¬nh áº¢nh & Phim X-Quang (${empty visitAttachments ? 0 : visitAttachments.size()})
                </button>
            </div>

            <!-- TAB 1: INTERACTIVE SVG ODONTOGRAM -->
            <div id="tabContent-chart" class="tab-pane-content">
                <div class="odontogram-container">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                        <div>
                            <h3 style="margin: 0; font-size: 17px; color: var(--text-primary);">SÆ¡ Äá»“ RÄƒng NgÆ°á»i Lá»›n (Chuáº©n FDI 11â€“48)</h3>
                            <p style="margin: 4px 0 0 0; font-size: 13px; color: var(--text-muted);">
                                Nháº¥p vÃ o thÃ¢n rÄƒng hoáº·c tá»«ng máº·t rÄƒng (Nhai, Gáº§n, Xa, NgoÃ i, Trong) Ä‘á»ƒ ghi nháº­n bá»‡nh lÃ½ vÃ  thá»§ thuáº­t.
                            </p>
                        </div>
                        <div id="selectedToothInfo" style="font-weight: 700; color: var(--primary); font-size: 14px; background: #e0f2fe; padding: 6px 14px; border-radius: 20px;">
                            Äang chá»n: RÄƒng 36 (Máº·t Nhai)
                        </div>
                    </div>

                    <!-- Arch 1: Maxillary (HÃ m TrÃªn: Q1: 18..11 | Q2: 21..28) -->
                    <div class="arch-title">HÃ m TrÃªn (Maxillary Arch) â€” BÃªn Pháº£i &bull; BÃªn TrÃ¡i</div>
                    <div class="teeth-row">
                        <!-- Quadrant 1: 18 down to 11 -->
                        <c:forEach var="t" items="18,17,16,15,14,13,12,11">
                            <div class="tooth-box" id="tooth-box-${t}" onclick="selectTooth(${t}, 'Occlusal')">
                                <span class="tooth-num">${t}</span>
                                <svg class="tooth-svg" viewBox="0 0 50 50">
                                    <polygon class="tooth-surface tooth-${t}-surface-Buccal" points="5,5 45,5 35,15 15,15" onclick="event.stopPropagation(); selectTooth(${t}, 'Buccal');" title="RÄƒng ${t} - Máº·t NgoÃ i (Buccal)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Distal" points="5,5 15,15 15,35 5,45" onclick="event.stopPropagation(); selectTooth(${t}, 'Distal');" title="RÄƒng ${t} - Máº·t Xa (Distal)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Lingual" points="5,45 15,35 35,35 45,45" onclick="event.stopPropagation(); selectTooth(${t}, 'Lingual');" title="RÄƒng ${t} - Máº·t Trong (Lingual)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Mesial" points="45,5 35,15 35,35 45,45" onclick="event.stopPropagation(); selectTooth(${t}, 'Mesial');" title="RÄƒng ${t} - Máº·t Gáº§n (Mesial)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Occlusal" points="15,15 35,15 35,35 15,35" onclick="event.stopPropagation(); selectTooth(${t}, 'Occlusal');" title="RÄƒng ${t} - Máº·t Nhai (Occlusal)" />
                                </svg>
                            </div>
                        </c:forEach>

                        <div class="quadrant-divider"></div>

                        <!-- Quadrant 2: 21 up to 28 -->
                        <c:forEach var="t" items="21,22,23,24,25,26,27,28">
                            <div class="tooth-box" id="tooth-box-${t}" onclick="selectTooth(${t}, 'Occlusal')">
                                <span class="tooth-num">${t}</span>
                                <svg class="tooth-svg" viewBox="0 0 50 50">
                                    <polygon class="tooth-surface tooth-${t}-surface-Buccal" points="5,5 45,5 35,15 15,15" onclick="event.stopPropagation(); selectTooth(${t}, 'Buccal');" title="RÄƒng ${t} - Máº·t NgoÃ i (Buccal)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Mesial" points="5,5 15,15 15,35 5,45" onclick="event.stopPropagation(); selectTooth(${t}, 'Mesial');" title="RÄƒng ${t} - Máº·t Gáº§n (Mesial)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Lingual" points="5,45 15,35 35,35 45,45" onclick="event.stopPropagation(); selectTooth(${t}, 'Lingual');" title="RÄƒng ${t} - Máº·t Trong (Lingual)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Distal" points="45,5 35,15 35,35 45,45" onclick="event.stopPropagation(); selectTooth(${t}, 'Distal');" title="RÄƒng ${t} - Máº·t Xa (Distal)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Occlusal" points="15,15 35,15 35,35 15,35" onclick="event.stopPropagation(); selectTooth(${t}, 'Occlusal');" title="RÄƒng ${t} - Máº·t Nhai (Occlusal)" />
                                </svg>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Arch 2: Mandibular (HÃ m DÆ°á»›i: Q4: 48..41 | Q3: 31..38) -->
                    <div class="arch-title" style="margin-top: 20px;">HÃ m DÆ°á»›i (Mandibular Arch) â€” BÃªn Pháº£i &bull; BÃªn TrÃ¡i</div>
                    <div class="teeth-row">
                        <!-- Quadrant 4: 48 down to 41 -->
                        <c:forEach var="t" items="48,47,46,45,44,43,42,41">
                            <div class="tooth-box" id="tooth-box-${t}" onclick="selectTooth(${t}, 'Occlusal')">
                                <span class="tooth-num">${t}</span>
                                <svg class="tooth-svg" viewBox="0 0 50 50">
                                    <polygon class="tooth-surface tooth-${t}-surface-Lingual" points="5,5 45,5 35,15 15,15" onclick="event.stopPropagation(); selectTooth(${t}, 'Lingual');" title="RÄƒng ${t} - Máº·t Trong (Lingual)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Distal" points="5,5 15,15 15,35 5,45" onclick="event.stopPropagation(); selectTooth(${t}, 'Distal');" title="RÄƒng ${t} - Máº·t Xa (Distal)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Buccal" points="5,45 15,35 35,35 45,45" onclick="event.stopPropagation(); selectTooth(${t}, 'Buccal');" title="RÄƒng ${t} - Máº·t NgoÃ i (Buccal)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Mesial" points="45,5 35,15 35,35 45,45" onclick="event.stopPropagation(); selectTooth(${t}, 'Mesial');" title="RÄƒng ${t} - Máº·t Gáº§n (Mesial)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Occlusal" points="15,15 35,15 35,35 15,35" onclick="event.stopPropagation(); selectTooth(${t}, 'Occlusal');" title="RÄƒng ${t} - Máº·t Nhai (Occlusal)" />
                                </svg>
                            </div>
                        </c:forEach>

                        <div class="quadrant-divider"></div>

                        <!-- Quadrant 3: 31 up to 38 -->
                        <c:forEach var="t" items="31,32,33,34,35,36,37,38">
                            <div class="tooth-box" id="tooth-box-${t}" onclick="selectTooth(${t}, 'Occlusal')">
                                <span class="tooth-num">${t}</span>
                                <svg class="tooth-svg" viewBox="0 0 50 50">
                                    <polygon class="tooth-surface tooth-${t}-surface-Lingual" points="5,5 45,5 35,15 15,15" onclick="event.stopPropagation(); selectTooth(${t}, 'Lingual');" title="RÄƒng ${t} - Máº·t Trong (Lingual)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Mesial" points="5,5 15,15 15,35 5,45" onclick="event.stopPropagation(); selectTooth(${t}, 'Mesial');" title="RÄƒng ${t} - Máº·t Gáº§n (Mesial)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Buccal" points="5,45 15,35 35,35 45,45" onclick="event.stopPropagation(); selectTooth(${t}, 'Buccal');" title="RÄƒng ${t} - Máº·t NgoÃ i (Buccal)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Distal" points="45,5 35,15 35,35 45,45" onclick="event.stopPropagation(); selectTooth(${t}, 'Distal');" title="RÄƒng ${t} - Máº·t Xa (Distal)" />
                                    <polygon class="tooth-surface tooth-${t}-surface-Occlusal" points="15,15 35,15 35,35 15,35" onclick="event.stopPropagation(); selectTooth(${t}, 'Occlusal');" title="RÄƒng ${t} - Máº·t Nhai (Occlusal)" />
                                </svg>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Condition Palette Toolbar -->
                    <div class="palette-bar">
                        <span style="font-size: 13px; font-weight: 700; color: var(--text-primary); margin-right: 6px;">TÃ¬nh tráº¡ng Ã¡p dá»¥ng:</span>

                        <button type="button" class="condition-pill-btn active" style="color: #dc2626;" onclick="setCondition('Caries', this)">
                            <span class="color-dot" style="background: #ef4444;"></span> SÃ¢u rÄƒng (Caries)
                        </button>
                        <button type="button" class="condition-pill-btn" style="color: #2563eb;" onclick="setCondition('Filled', this)">
                            <span class="color-dot" style="background: #3b82f6;"></span> ÄÃ£ trÃ¡m (Filled)
                        </button>
                        <button type="button" class="condition-pill-btn" style="color: #7c3aed;" onclick="setCondition('Crown', this)">
                            <span class="color-dot" style="background: #8b5cf6;"></span> RÄƒng sá»© / MÃ£o (Crown)
                        </button>
                        <button type="button" class="condition-pill-btn" style="color: #d97706;" onclick="setCondition('RootCanal', this)">
                            <span class="color-dot" style="background: #f59e0b;"></span> Chá»¯a tá»§y (Root Canal)
                        </button>
                        <button type="button" class="condition-pill-btn" style="color: #475569;" onclick="setCondition('Missing', this)">
                            <span class="color-dot" style="background: #94a3b8;"></span> Máº¥t rÄƒng (Missing)
                        </button>
                        <button type="button" class="condition-pill-btn" style="color: #16a34a;" onclick="setCondition('Healthy', this)">
                            <span class="color-dot" style="background: #22c55e;"></span> RÄƒng lÃ nh (Healthy)
                        </button>

                        <div style="margin-left: auto; display: flex; gap: 8px;">
                            <input type="text" id="findingNoteInput" placeholder="Ghi chÃº thÃªm (VD: SÃ¢u Ä‘á»™ 2)" class="form-control" style="width: 200px; padding: 6px 10px; font-size: 12px;" />
                            <button type="button" class="btn btn-primary" style="padding: 6px 14px; font-size: 12px;" onclick="applyFindingAjax()">
                                LÆ°u RÄƒng
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Existing Tooth Findings List for Patient -->
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span>Báº£ng Ghi Nháº­n Chi Tiáº¿t TÃ¬nh Tráº¡ng RÄƒng Cá»§a Bá»‡nh NhÃ¢n</span>
                        </div>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-responsive">
                            <table class="data-table" id="findingsTable">
                                <thead>
                                    <tr>
                                        <th>RÄƒng (FDI)</th>
                                        <th>Máº·t RÄƒng</th>
                                        <th>Bá»‡nh LÃ½ / TÃ¬nh Tráº¡ng</th>
                                        <th>Ghi ChÃº</th>
                                        <th>LÆ°á»£t KhÃ¡m</th>
                                        <th style="text-align: right;">Thao TÃ¡c</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty toothFindings}">
                                            <tr id="emptyFindingsRow">
                                                <td colspan="6" style="text-align: center; color: var(--text-muted); padding: 24px;">
                                                    ChÆ°a cÃ³ phÃ¡t hiá»‡n báº¥t thÆ°á»ng nÃ o Ä‘Æ°á»£c lÆ°u cho bá»‡nh nhÃ¢n.
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="tf" items="${toothFindings}">
                                                <tr id="finding-row-${tf.findingId}">
                                                    <td><strong style="color: var(--primary);">RÄƒng ${tf.toothNumber}</strong></td>
                                                    <td><code>${empty tf.surface ? 'ThÃ¢n rÄƒng' : tf.surface}</code></td>
                                                    <td>
                                                        <span class="badge-pill ${tf.condition eq 'Caries' ? 'badge-Cancelled' : (tf.condition eq 'Healthy' ? 'badge-Confirmed' : 'badge-Pending')}">
                                                            ${tf.condition}
                                                        </span>
                                                    </td>
                                                    <td>${tf.notes}</td>
                                                    <td>#${tf.visitId}</td>
                                                    <td style="text-align: right;">
                                                        <button type="button" class="btn btn-secondary" style="padding: 4px 8px; font-size: 11px; color: var(--danger);" onclick="deleteFindingAjax(${tf.findingId})">
                                                            XÃ³a
                                                        </button>
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
            </div>

            <!-- TAB 2: PRE-TREATMENT ASSESSMENT & VITALS -->
            <div id="tabContent-vitals" class="tab-pane-content" style="display: none;">
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span>ÄÃ¡nh GiÃ¡ Tiá»n Thá»§ Thuáº­t & Dáº¥u Hiá»‡u Sinh Tá»“n</span>
                        </div>
                        <span class="badge-pill badge-Pending">TuÃ¢n thá»§ an toÃ n Ä‘iá»u trá»‹ nha khoa</span>
                    </div>
                    <div class="card-body" style="padding: 24px;">
                        <form action="${pageContext.request.contextPath}/clinical/examination" method="POST">
                            <input type="hidden" name="action" value="save_vitals" />
                            <input type="hidden" name="visitId" value="${visit.visitId}" />

                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 20px;">
                                <div class="form-group">
                                    <label class="form-label">Huyáº¿t Ã¡p (Blood Pressure)</label>
                                    <input type="text" name="bloodPressure" value="${assessment.bloodPressure}" placeholder="VD: 120/80 mmHg" class="form-control" />
                                    <span style="font-size: 11px; color: var(--text-muted); margin-top: 4px;">NgÆ°á»¡ng an toÃ n: < 140/90 mmHg</span>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Máº¡ch (Pulse - bpm)</label>
                                    <input type="number" name="pulse" value="${assessment.pulse}" placeholder="VD: 75" class="form-control" />
                                    <span style="font-size: 11px; color: var(--text-muted); margin-top: 4px;">BÃ¬nh thÆ°á»ng: 60 - 100 láº§n/phÃºt</span>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">ÄÆ°á»ng huyáº¿t mao máº¡ch (mmol/L)</label>
                                    <input type="text" name="bloodSugar" value="${assessment.bloodSugar}" placeholder="VD: 5.6" class="form-control" />
                                    <span style="font-size: 11px; color: var(--text-muted); margin-top: 4px;">Chá»‰ Ä‘á»‹nh trÆ°á»›c khi nhá»• rÄƒng/tiá»ƒu pháº«u</span>
                                </div>

                                <div class="form-group">
                                    <label class="form-label">ÄÃ¡nh giÃ¡ nguy cÆ¡ cháº£y mÃ¡u</label>
                                    <select name="bleedingRisk" class="form-control">
                                        <option value="Low" ${assessment.bleedingRisk eq 'Low' ? 'selected' : ''}>Tháº¥p (Low Risk)</option>
                                        <option value="Medium" ${assessment.bleedingRisk eq 'Medium' ? 'selected' : ''}>Trung bÃ¬nh (Medium Risk)</option>
                                        <option value="High" ${assessment.bleedingRisk eq 'High' ? 'selected' : ''}>Cao (High Risk - Tháº­n trá»ng pháº«u thuáº­t)</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label class="form-label">Ghi chÃº lÃ¢m sÃ ng tiá»n thá»§ thuáº­t</label>
                                <textarea name="assessmentNotes" rows="3" class="form-control" placeholder="Ghi nháº­n tiá»n sá»­ dÃ¹ng thuá»‘c chá»‘ng Ä‘Ã´ng mÃ¡u, tiá»n mÃª hoáº·c lÆ°u Ã½ Ä‘áº·c biá»‡t...">${assessment.assessmentNotes}</textarea>
                            </div>

                            <div style="background: #f8fafc; border: 1px solid var(--border); border-radius: 8px; padding: 14px 18px; margin-bottom: 24px; display: flex; align-items: center; gap: 12px;">
                                <input type="checkbox" id="medicalClearance" name="medicalClearance" value="true" ${assessment.medicalClearance ? 'checked' : ''} style="width: 18px; height: 18px;" />
                                <label for="medicalClearance" style="font-weight: 600; font-size: 14px; color: var(--text-primary); cursor: pointer; margin: 0;">
                                    XÃ¡c nháº­n bá»‡nh nhÃ¢n Ä‘á»§ Ä‘iá»u kiá»‡n sá»©c khá»e Ä‘á»ƒ thá»±c hiá»‡n can thiá»‡p thá»§ thuáº­t nha khoa (Medical Clearance)
                                </label>
                            </div>

                            <div style="display: flex; justify-content: flex-end;">
                                <button type="submit" class="btn btn-primary" style="padding: 10px 24px;">
                                    LÆ°u ÄÃ¡nh GiÃ¡ Sinh Hiá»‡u
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- TAB 3: EXAMINATION & DIAGNOSIS -->
            <div id="tabContent-exam" class="tab-pane-content" style="display: none;">
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span>KhÃ¡m LÃ¢m SÃ ng & Káº¿t Luáº­n Cháº©n ÄoÃ¡n</span>
                        </div>
                    </div>
                    <div class="card-body" style="padding: 24px;">
                        <form action="${pageContext.request.contextPath}/clinical/examination" method="POST">
                            <input type="hidden" name="action" value="save_exam" />
                            <input type="hidden" name="visitId" value="${visit.visitId}" />

                            <div class="form-group" style="margin-bottom: 20px;">
                                <label class="form-label">LÃ½ do Ä‘áº¿n khÃ¡m (Chief Complaint) *</label>
                                <input type="text" name="chiefComplaint" value="${examination.chiefComplaint}" placeholder="VD: Äau buá»‘t rÄƒng hÃ m dÆ°á»›i bÃªn trÃ¡i khi Äƒn Ä‘á»“ láº¡nh..." class="form-control" required />
                            </div>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                                <div class="form-group">
                                    <label class="form-label">KhÃ¡m ngoÃ i máº·t (Extraoral Examination)</label>
                                    <textarea name="extraoralExam" rows="3" class="form-control" placeholder="Máº·t cÃ¢n Ä‘á»‘i, khÃ´ng sÆ°ng ná» háº¡ch dÆ°á»›i hÃ m, khá»›p thÃ¡i dÆ°Æ¡ng hÃ m Ä‘Ã³ng má»Ÿ bÃ¬nh thÆ°á»ng...">${examination.extraoralExam}</textarea>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">KhÃ¡m trong miá»‡ng (Intraoral Examination)</label>
                                    <textarea name="intraoralExam" rows="3" class="form-control" placeholder="NiÃªm máº¡c há»“ng hÃ o, nÆ°á»›u viÃªm nháº¹ vÃ¹ng rÄƒng cá»‘i, vÃ´i rÄƒng máº£ng bÃ¡m Ä‘á»™ 2...">${examination.intraoralExam}</textarea>
                                </div>
                            </div>

                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                                <div class="form-group">
                                    <label class="form-label">Cháº©n Ä‘oÃ¡n sÆ¡ bá»™ (Provisional Diagnosis)</label>
                                    <input type="text" name="provisionalDiagnosis" value="${examination.provisionalDiagnosis}" placeholder="VD: ViÃªm tá»§y cáº¥p cÃ³ há»“i phá»¥c rÄƒng 36" class="form-control" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Cháº©n Ä‘oÃ¡n xÃ¡c Ä‘á»‹nh (Final Diagnosis)</label>
                                    <input type="text" name="finalDiagnosis" value="${examination.finalDiagnosis}" placeholder="VD: SÃ¢u rÄƒng ngÃ  sÃ¢u K02.1 - ViÃªm quanh chÃ³p máº¡n R36" class="form-control" />
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 24px;">
                                <label class="form-label">Lá»i dáº·n & HÆ°á»›ng xá»­ trÃ­ lÃ¢m sÃ ng</label>
                                <textarea name="clinicalNotes" rows="3" class="form-control" placeholder="Chá»‰ Ä‘á»‹nh chá»¥p X-quang cáº­n chÃ³p R36, giáº£i thÃ­ch phÃ¡c Ä‘á»“ Ä‘iá»u trá»‹ ná»™i nha hoáº·c trÃ¡m rÄƒng cho bá»‡nh nhÃ¢n...">${examination.clinicalNotes}</textarea>
                            </div>

                            <div style="display: flex; justify-content: flex-end;">
                                <button type="submit" class="btn btn-primary" style="padding: 10px 24px;">
                                    LÆ°u Bá»‡nh Ãn LÃ¢m SÃ ng
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- TAB 4: ATTACHMENTS & X-RAYS -->
            <div id="tabContent-images" class="tab-pane-content" style="display: none;">
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">
                            <span>Phim X-Quang & HÃ¬nh áº¢nh Trong Miá»‡ng LÆ°á»£t KhÃ¡m NÃ y</span>
                        </div>
                        <!-- Upload attachment form -->
                        <form action="${pageContext.request.contextPath}/clinical/attachments" method="POST" enctype="multipart/form-data" style="display: flex; gap: 8px; margin: 0;">
                            <input type="hidden" name="patientId" value="${patient.patientId}" />
                            <input type="hidden" name="visitId" value="${visit.visitId}" />
                            <input type="file" name="file" accept="image/*,.pdf" class="form-control" style="width: 240px; padding: 6px 10px; font-size: 12px;" required />
                            <select name="fileType" class="form-control" style="width: 140px; padding: 6px 10px; font-size: 12px;">
                                <option value="XRay">Phim X-Quang</option>
                                <option value="IntraoralPhoto">áº¢nh trong miá»‡ng</option>
                                <option value="PanoramicOPG">Phim Paronama</option>
                            </select>
                            <button type="submit" class="btn btn-primary" style="padding: 6px 12px; font-size: 12px;">
                                + Táº£i LÃªn Phim
                            </button>
                        </form>
                    </div>
                    <div class="card-body" style="padding: 20px;">
                        <c:choose>
                            <c:when test="${empty visitAttachments}">
                                <div class="empty-state" style="padding: 30px;">
                                    <h4>ChÆ°a cÃ³ phim X-quang hoáº·c hÃ¬nh áº£nh nÃ o cho lÆ°á»£t khÃ¡m nÃ y</h4>
                                    <p>Táº£i lÃªn phim X-quang cáº­n chÃ³p, panorama Ä‘á»ƒ phá»¥c vá»¥ cháº©n Ä‘oÃ¡n.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 16px;">
                                    <c:forEach var="att" items="${visitAttachments}">
                                        <div style="border: 1px solid var(--border); border-radius: 8px; overflow: hidden; background: white;">
                                            <div style="height: 140px; background: #0f172a; color: white; display: flex; align-items: center; justify-content: center; font-size: 16px; font-weight: 700; letter-spacing: 1px;">
                                                X-RAY
                                            </div>
                                            <div style="padding: 12px; font-size: 12px;">
                                                <div style="font-weight: 700; color: var(--text-primary);">${att.fileName}</div>
                                                <div style="color: var(--text-muted); margin-top: 4px;">Loáº¡i: <span class="badge-pill badge-Pending">${att.fileType}</span></div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>

<script>
    // State management for interactive odontogram
    var currentPatientId = ${patient.patientId};
    var currentVisitId = ${visit.visitId};
    var selectedTooth = 36;
    var selectedSurface = 'Occlusal';
    var selectedCondition = 'Caries';

    // Surface map for conditions on page load
    var existingFindings = [
        <c:forEach var="tf" items="${toothFindings}" varStatus="loop">
        {
            findingId: ${tf.findingId},
            toothNumber: ${tf.toothNumber},
            surface: '${tf.surface}',
            condition: '${tf.condition}',
            notes: '${tf.notes}'
        }${!loop.last ? ',' : ''}
        </c:forEach>
    ];

    function renderInitialFindings() {
        existingFindings.forEach(function(f) {
            paintSurface(f.toothNumber, f.surface, f.condition);
        });
    }

    function paintSurface(toothNum, surface, condition) {
        var cls = 'has-' + condition.toLowerCase();
        if (!surface || surface === '' || surface === 'null') {
            // Whole tooth
            var surfaces = ['Occlusal', 'Mesial', 'Distal', 'Buccal', 'Lingual'];
            surfaces.forEach(function(s) {
                var el = document.querySelector('.tooth-' + toothNum + '-surface-' + s);
                if (el) {
                    el.classList.remove('has-caries', 'has-filled', 'has-crown', 'has-rootcanal', 'has-missing');
                    el.classList.add(cls);
                }
            });
        } else {
            var el = document.querySelector('.tooth-' + toothNum + '-surface-' + surface);
            if (el) {
                el.classList.remove('has-caries', 'has-filled', 'has-crown', 'has-rootcanal', 'has-missing');
                el.classList.add(cls);
            }
        }
    }

    function selectTooth(toothNum, surface) {
        selectedTooth = toothNum;
        selectedSurface = surface || 'Occlusal';

        document.querySelectorAll('.tooth-box').forEach(function(b) {
            b.classList.remove('selected');
        });
        var targetBox = document.getElementById('tooth-box-' + toothNum);
        if (targetBox) {
            targetBox.classList.add('selected');
        }

        var surfaceNameVi = {
            'Occlusal': 'Máº·t Nhai',
            'Buccal': 'Máº·t NgoÃ i/MÃ¡',
            'Lingual': 'Máº·t Trong/LÆ°á»¡i',
            'Mesial': 'Máº·t Gáº§n',
            'Distal': 'Máº·t Xa'
        };

        var infoEl = document.getElementById('selectedToothInfo');
        if (infoEl) {
            infoEl.innerText = 'Äang chá»n: RÄƒng ' + toothNum + ' (' + (surfaceNameVi[selectedSurface] || selectedSurface) + ')';
        }
    }

    function setCondition(cond, btn) {
        selectedCondition = cond;
        document.querySelectorAll('.condition-pill-btn').forEach(function(b) {
            b.classList.remove('active');
        });
        btn.classList.add('active');
    }

    function applyFindingAjax() {
        var note = document.getElementById('findingNoteInput').value;

        var params = new URLSearchParams();
        params.append('action', 'add');
        params.append('patientId', currentPatientId);
        params.append('visitId', currentVisitId);
        params.append('toothNumber', selectedTooth);
        params.append('surface', selectedSurface);
        params.append('condition', selectedCondition);
        params.append('notes', note);

        fetch('${pageContext.request.contextPath}/clinical/odontogram-ajax', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: params.toString()
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                paintSurface(selectedTooth, selectedSurface, selectedCondition);

                // Prepend to findings table
                var tableBody = document.querySelector('#findingsTable tbody');
                var emptyRow = document.getElementById('emptyFindingsRow');
                if (emptyRow) emptyRow.remove();

                var tr = document.createElement('tr');
                tr.id = 'finding-row-' + data.findingId;
                tr.innerHTML = '<td><strong style="color: var(--primary);">RÄƒng ' + data.toothNumber + '</strong></td>' +
                               '<td><code>' + (data.surface || 'ThÃ¢n rÄƒng') + '</code></td>' +
                               '<td><span class="badge-pill badge-Cancelled">' + data.condition + '</span></td>' +
                               '<td>' + (data.notes || '') + '</td>' +
                               '<td>#' + currentVisitId + '</td>' +
                               '<td style="text-align: right;"><button type="button" class="btn btn-secondary" style="padding: 4px 8px; font-size: 11px; color: var(--danger);" onclick="deleteFindingAjax(' + data.findingId + ')">ðŸ—‘ï¸ XÃ³a</button></td>';
                tableBody.insertBefore(tr, tableBody.firstChild);

                document.getElementById('findingNoteInput').value = '';
            } else {
                alert('Lá»—i: ' + data.message);
            }
        })
        .catch(function(err) {
            alert('Lá»—i káº¿t ná»‘i mÃ¡y chá»§: ' + err);
        });
    }

    function deleteFindingAjax(findingId) {
        if (!confirm('XÃ¡c nháº­n xÃ³a ghi nháº­n nÃ y?')) return;

        var params = new URLSearchParams();
        params.append('action', 'delete');
        params.append('findingId', findingId);

        fetch('${pageContext.request.contextPath}/clinical/odontogram-ajax', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: params.toString()
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.success) {
                var row = document.getElementById('finding-row-' + findingId);
                if (row) row.remove();
                window.location.reload();
            } else {
                alert('Lá»—i khi xÃ³a: ' + data.message);
            }
        });
    }

    function switchTab(tabName, btn) {
        document.querySelectorAll('.exam-tab-btn').forEach(function(b) {
            b.classList.remove('active');
        });
        btn.classList.add('active');

        document.getElementById('tabContent-chart').style.display = (tabName === 'chart' ? 'block' : 'none');
        document.getElementById('tabContent-vitals').style.display = (tabName === 'vitals' ? 'block' : 'none');
        document.getElementById('tabContent-exam').style.display = (tabName === 'exam' ? 'block' : 'none');
        document.getElementById('tabContent-images').style.display = (tabName === 'images' ? 'block' : 'none');
    }

    // Auto open tab based on URL param
    window.addEventListener('DOMContentLoaded', function() {
        renderInitialFindings();
        selectTooth(36, 'Occlusal');

        var urlParams = new URLSearchParams(window.location.search);
        var tab = urlParams.get('tab');
        if (tab === 'vitals') {
            switchTab('vitals', document.querySelectorAll('.exam-tab-btn')[1]);
        } else if (tab === 'diagnosis') {
            switchTab('exam', document.querySelectorAll('.exam-tab-btn')[2]);
        } else if (tab === 'attachments') {
            switchTab('images', document.querySelectorAll('.exam-tab-btn')[3]);
        }
    });
</script>

</body>
</html>

