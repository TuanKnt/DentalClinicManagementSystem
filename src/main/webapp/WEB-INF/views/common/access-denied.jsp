<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Truy Cập Bị Từ Chối (403) — DCMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        body {
            background-color: var(--bg-app);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 24px;
        }

        .error-card {
            background: #ffffff;
            max-width: 520px;
            width: 100%;
            border-radius: var(--radius-xl);
            border: 1px solid var(--border);
            box-shadow: var(--shadow-lg);
            padding: 44px 36px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .error-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(135deg, #ef4444 0%, #f97316 100%);
        }

        .error-icon-box {
            width: 64px;
            height: 64px;
            border-radius: var(--radius-xl);
            background: var(--danger-light);
            color: var(--danger);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            margin-bottom: 20px;
        }

        .error-card h1 {
            font-size: 22px;
            font-weight: 800;
            color: var(--text-primary);
            letter-spacing: -0.4px;
            margin-bottom: 8px;
        }

        .error-card p {
            color: var(--text-secondary);
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 28px;
        }

        .role-pill {
            display: inline-block;
            background: var(--danger-light);
            color: var(--danger);
            border: 1px solid var(--danger-border);
            font-size: 12px;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: var(--radius-full);
            margin-bottom: 16px;
        }
    </style>
</head>
<body>

<div class="error-card">
    <div class="error-icon-box">🚫</div>
    <div class="role-pill">Mã Lỗi: 403 Forbidden</div>
    <h1>Truy Cập Bị Từ Chối</h1>
    <p>
        Tài khoản của bạn với vai trò <strong>[${sessionScope.currentUser != null ? sessionScope.currentUser.roleName : sessionScope.role}]</strong> 
        không được phân quyền truy cập vào chức năng hoặc đường dẫn: 
        <br/>
        <code style="background: #f1f5f9; padding: 4px 8px; border-radius: 6px; font-weight: 700; display: inline-block; margin-top: 6px; color: var(--danger);">
            ${requiredPath}
        </code>
    </p>

    <div style="display: flex; gap: 12px; justify-content: center;">
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
            <span>🏠</span> Về Bàn Làm Việc
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">
            <span>🔒</span> Đăng Xuất
        </a>
    </div>
</div>

</body>
</html>
