<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Hồ Sơ Bệnh Nhân — DCMS</title>
    <style>
        :root {
            --primary: #0284c7;
            --primary-hover: #0369a1;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --alert-red: #ef4444;
            --alert-bg: #fee2e2;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
        body { background-color: var(--bg); color: var(--text-main); display: flex; flex-direction: column; min-height: 100vh; }
        
        .navbar { background: #ffffff; border-bottom: 1px solid var(--border); padding: 14px 28px; display: flex; justify-content: space-between; align-items: center; }
        .nav-brand { font-size: 18px; font-weight: 700; color: var(--primary); display: flex; align-items: center; gap: 8px; text-decoration: none; }
        .nav-links a { color: var(--text-muted); text-decoration: none; font-size: 14px; margin-left: 20px; font-weight: 500; }
        .nav-links a:hover, .nav-links a.active { color: var(--primary); }

        .container { max-width: 1200px; width: 100%; margin: 30px auto; padding: 0 20px; }
        
        .header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .header-title h1 { font-size: 22px; font-weight: 700; color: var(--text-main); margin-bottom: 4px; }
        .header-title p { font-size: 13px; color: var(--text-muted); }

        .btn { padding: 10px 18px; border-radius: 8px; font-size: 14px; font-weight: 600; text-decoration: none; cursor: pointer; border: none; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s; }
        .btn-primary { background: var(--primary); color: white; }
        .btn-primary:hover { background: var(--primary-hover); }

        .search-card { background: white; padding: 18px 24px; border-radius: 12px; border: 1px solid var(--border); margin-bottom: 20px; display: flex; gap: 12px; }
        .search-input { flex: 1; padding: 10px 16px; border: 1px solid var(--border); border-radius: 8px; font-size: 14px; outline: none; }
        .search-input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.15); }

        .table-card { background: white; border-radius: 12px; border: 1px solid var(--border); overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; text-align: left; font-size: 14px; }
        th { background: #f8fafc; padding: 14px 18px; font-weight: 600; color: var(--text-muted); border-bottom: 1px solid var(--border); font-size: 13px; }
        td { padding: 14px 18px; border-bottom: 1px solid var(--border); vertical-align: middle; }
        tr:hover { background-color: #f1f5f9; }

        .badge-alert { background: var(--alert-bg); color: #b91c1c; font-size: 11px; font-weight: 600; padding: 3px 8px; border-radius: 4px; display: inline-block; margin-top: 4px; }
        .badge-gender { font-size: 12px; color: var(--text-muted); }

        .pagination { display: flex; justify-content: space-between; align-items: center; padding: 16px 20px; font-size: 13px; color: var(--text-muted); background: white; border-top: 1px solid var(--border); }
        .page-links a { padding: 6px 12px; border: 1px solid var(--border); border-radius: 6px; text-decoration: none; color: var(--text-main); margin-left: 4px; }
        .page-links a.active { background: var(--primary); color: white; border-color: var(--primary); }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">🦷 DCMS Clinic</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/reception/appointments">Lịch Hẹn</a>
        <a href="${pageContext.request.contextPath}/reception/patients" class="active">Hồ Sơ Bệnh Nhân</a>
        <a href="${pageContext.request.contextPath}/reception/checkin">Tiếp Đón / Check-in</a>
        <a href="${pageContext.request.contextPath}/logout">Đăng Xuất (${sessionScope.currentUser.fullName})</a>
    </div>
</nav>

<div class="container">
    <div class="header-section">
        <div class="header-title">
            <h1>Hồ Sơ Bệnh Nhân</h1>
            <p>Quản lý danh sách, tra cứu tiền sử bệnh lý và cảnh báo y tế</p>
        </div>
        <a href="${pageContext.request.contextPath}/reception/patients/create" class="btn btn-primary">
            <span>➕</span> Thêm Bệnh Nhân Mới
        </a>
    </div>

    <form action="${pageContext.request.contextPath}/reception/patients" method="GET" class="search-card">
        <input type="text" name="keyword" class="search-input" value="${keyword}" placeholder="🔍 Nhập số điện thoại, CCCD hoặc họ tên bệnh nhân để tìm kiếm nhanh..." />
        <button type="submit" class="btn btn-primary">Tìm Kiếm</button>
        <c:if test="${not empty keyword}">
            <a href="${pageContext.request.contextPath}/reception/patients" class="btn" style="background:#e2e8f0;color:#0f172a;">Xóa Bộ Lọc</a>
        </c:if>
    </form>

    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>Mã BN</th>
                    <th>Họ & Tên</th>
                    <th>Số Điện Thoại</th>
                    <th>Giới Tính / Ngày Sinh</th>
                    <th>Cảnh Báo Bệnh Lý / Dị Ứng</th>
                    <th>Địa Chỉ</th>
                    <th>Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty patientList}">
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                📭 Không tìm thấy hồ sơ bệnh nhân nào phù hợp.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${patientList}">
                            <tr>
                                <td><strong>#${p.patientId}</strong></td>
                                <td>
                                    <strong>${p.fullName}</strong>
                                    <c:if test="${not empty p.citizenId}">
                                        <div style="font-size: 11px; color: var(--text-muted);">CCCD: ${p.citizenId}</div>
                                    </c:if>
                                </td>
                                <td><code>${p.phone}</code></td>
                                <td>
                                    <span class="badge-gender">${p.gender}</span>
                                    <c:if test="${not empty p.dob}">
                                        <div style="font-size: 12px; color: var(--text-muted);">${p.dob}</div>
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${not empty p.medicalAlerts}">
                                        <span class="badge-alert">⚠️ Bệnh nền: ${p.medicalAlerts}</span>
                                    </c:if>
                                    <c:if test="${not empty p.allergies}">
                                        <span class="badge-alert">⚡ Dị ứng: ${p.allergies}</span>
                                    </c:if>
                                    <c:if test="${empty p.medicalAlerts && empty p.allergies}">
                                        <span style="color: var(--text-muted); font-size: 12px;">Bình thường</span>
                                    </c:if>
                                </td>
                                <td style="max-width: 200px; font-size: 13px;">${p.address}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/reception/patients/edit?id=${p.patientId}" style="color: var(--primary); text-decoration: none; font-weight: 600;">Sửa</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <div>Hiển thị ${patientList.size()} / ${totalCount} bệnh nhân</div>
                <div class="page-links">
                    <c:forEach begin="1" end="${totalPages}" var="pageIndex">
                        <a href="${pageContext.request.contextPath}/reception/patients?keyword=${keyword}&page=${pageIndex}" 
                           class="${pageIndex == currentPage ? 'active' : ''}">${pageIndex}</a>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>
</div>

</body>
</html>
