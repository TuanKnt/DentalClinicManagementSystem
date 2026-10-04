<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Truy Cập Bị Từ Chối (403) — DCMS</title>
    <style>
        :root {
            --error: #ef4444;
            --primary: #0284c7;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; }
        body { background-color: var(--bg); display: flex; align-items: center; justify-content: center; min-height: 100vh; padding: 24px; }
        .box { background: var(--card-bg); max-width: 500px; width: 100%; border-radius: 16px; border: 1px solid var(--border); box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05); padding: 40px; text-align: center; }
        .icon { font-size: 48px; margin-bottom: 16px; }
        h1 { font-size: 22px; color: var(--text-main); margin-bottom: 8px; font-weight: 700; }
        p { color: var(--text-muted); font-size: 14px; line-height: 1.6; margin-bottom: 24px; }
        .role-badge { display: inline-block; background: #fee2e2; color: #b91c1c; font-size: 12px; font-weight: 600; padding: 4px 10px; border-radius: 6px; margin-bottom: 16px; }
        .btn-group { display: flex; gap: 12px; justify-content: center; }
        .btn { padding: 10px 20px; border-radius: 8px; text-decoration: none; font-size: 14px; font-weight: 600; cursor: pointer; border: 1px solid transparent; transition: all 0.2s; }
        .btn-primary { background: var(--primary); color: white; }
        .btn-primary:hover { background: #0369a1; }
        .btn-outline { background: white; border-color: var(--border); color: var(--text-main); }
        .btn-outline:hover { background: #f1f5f9; }
    </style>
</head>
<body>

<div class="box">
    <div class="icon">🚫</div>
    <div class="role-badge">Lỗi 403 — Không Đủ Quyền Truy Cập</div>
    <h1>Truy Cập Bị Từ Chối</h1>
    <p>
        Tài khoản của bạn với vai trò <strong>[${sessionScope.currentUser.roleName}]</strong> 
        không có quyền truy cập vào đường dẫn: <code>${requiredPath}</code>.
    </p>

    <div class="btn-group">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Về Trang Chủ Của Tôi</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline">Đăng Xuất</a>
    </div>
</div>

</body>
</html>
