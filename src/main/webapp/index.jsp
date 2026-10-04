<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dental Clinic Management System (DCMS)</title>
    <style>
        :root {
            --primary: #0284c7;
            --primary-dark: #0369a1;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --success: #10b981;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; }
        body { background-color: var(--bg); color: var(--text-main); display: flex; align-items: center; justify-content: center; min-height: 100vh; padding: 20px; }
        .container { background: var(--card-bg); border-radius: 16px; box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.01); border: 1px solid var(--border); max-width: 600px; width: 100%; padding: 40px; text-align: center; }
        .logo { width: 64px; height: 64px; background: #e0f2fe; color: var(--primary); border-radius: 16px; display: inline-flex; align-items: center; justify-content: center; font-size: 32px; margin-bottom: 20px; }
        h1 { font-size: 24px; font-weight: 700; margin-bottom: 8px; color: var(--text-main); }
        p.subtitle { color: var(--text-muted); font-size: 15px; margin-bottom: 28px; line-height: 1.5; }
        .badge { display: inline-block; background: #dcfce7; color: #15803d; font-size: 13px; font-weight: 600; padding: 6px 14px; border-radius: 9999px; margin-bottom: 24px; }
        .grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-top: 24px; }
        .card-link { display: block; padding: 16px; border-radius: 12px; border: 1px solid var(--border); background: #f8fafc; text-decoration: none; color: var(--text-main); font-weight: 500; font-size: 14px; transition: all 0.2s ease; }
        .card-link:hover { border-color: var(--primary); background: #f0f9ff; color: var(--primary-dark); transform: translateY(-2px); }
        .footer { margin-top: 32px; font-size: 12px; color: var(--text-muted); border-top: 1px solid var(--border); padding-top: 16px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">🦷</div>
        <div class="badge">● Hệ thống sẵn sàng (Iteration 1)</div>
        <h1>Dental Clinic Management System</h1>
        <p class="subtitle">Hệ thống Quản lý Phòng khám Nha khoa — Chuẩn kiến trúc MVC (Java Servlet + JSP + Microsoft SQL Server)</p>
        
        <div class="grid">
            <a href="login" class="card-link">🔑 Đăng nhập hệ thống</a>
            <a href="reception/appointments" class="card-link">📅 Quản lý Lịch hẹn (Lễ tân)</a>
            <a href="reception/checkin" class="card-link">🚪 Tiếp đón & Check-in</a>
            <a href="reception/patients" class="card-link">👥 Hồ sơ Bệnh nhân</a>
        </div>

        <div class="footer">
            Dự án SWP — Nhóm G3_SE2064 | Tuân thủ triệt để Baseline v2.0
        </div>
    </div>
</body>
</html>
