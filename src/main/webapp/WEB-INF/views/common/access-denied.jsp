<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Truy Cập Bị Từ Chối (403) — Nha Khoa Dr.Smile DCMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        body {
            background: 
                radial-gradient(ellipse at 30% 30%, rgba(239, 68, 68, 0.04) 0%, transparent 50%),
                radial-gradient(ellipse at 70% 70%, rgba(0, 51, 102, 0.04) 0%, transparent 50%),
                var(--bg-app);
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
            border: 1px solid rgba(0, 51, 102, 0.08);
            box-shadow: 0 20px 50px -12px rgba(0, 51, 102, 0.12);
            padding: 48px 40px;
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
            background: linear-gradient(135deg, #ef4444 0%, #f97316 50%, #fbbf24 100%);
        }

        .error-icon-box {
            width: 72px;
            height: 72px;
            border-radius: var(--radius-xl);
            background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
            color: var(--danger);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 34px;
            margin-bottom: 20px;
            box-shadow: 0 4px 16px rgba(239, 68, 68, 0.12);
        }

        .error-card h1 {
            font-size: 22px;
            font-weight: 800;
            color: var(--drsmile-navy);
            letter-spacing: -0.4px;
            margin-bottom: 8px;
        }

        .error-card p {
            color: var(--text-secondary);
            font-size: 14px;
            line-height: 1.7;
            margin-bottom: 28px;
        }

        .role-pill {
            display: inline-block;
            background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
            color: var(--danger);
            border: 1px solid var(--danger-border);
            font-size: 12px;
            font-weight: 700;
            padding: 5px 14px;
            border-radius: var(--radius-full);
            margin-bottom: 16px;
            letter-spacing: 0.2px;
        }

        .error-path-code {
            background: linear-gradient(135deg, #f8fafc 0%, #f0f7fd 100%);
            padding: 6px 12px;
            border-radius: var(--radius-sm);
            font-weight: 700;
            display: inline-block;
            margin-top: 6px;
            color: var(--danger);
            font-size: 13px;
            border: 1px solid var(--border);
        }

        .error-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
        }

        .error-footer {
            margin-top: 28px;
            padding-top: 20px;
            border-top: 1px solid var(--border-light);
            font-size: 12px;
            color: var(--text-muted);
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
        <code class="error-path-code">${requiredPath}</code>
    </p>

    <div class="error-actions">
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
            <span>🏠</span> Về Bàn Làm Việc
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">
            <span>🔒</span> Đăng Xuất
        </a>
    </div>

    <div class="error-footer">
        Nha Khoa Dr.Smile — DCMS System &bull; Liên hệ Quản trị viên nếu cần hỗ trợ phân quyền.
    </div>
</div>

</body>
</html>
