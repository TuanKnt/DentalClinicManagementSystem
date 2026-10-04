<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập — Hệ Thống Quản Lý Phòng Khám Nha Khoa (DCMS)</title>
    <style>
        :root {
            --primary: #0284c7;
            --primary-hover: #0369a1;
            --primary-light: #e0f2fe;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --error-bg: #fef2f2;
            --error-border: #fecaca;
            --error-text: #b91c1c;
            --success-bg: #f0fdf4;
            --success-border: #bbf7d0;
            --success-text: #15803d;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; }
        body {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 50%, #f8fafc 100%);
            color: var(--text-main);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 24px;
        }

        .login-card {
            background: var(--card-bg);
            border-radius: 20px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.08), 0 8px 10px -6px rgba(0, 0, 0, 0.04);
            border: 1px solid var(--border);
            max-width: 440px;
            width: 100%;
            padding: 40px;
            transition: all 0.3s ease;
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo-icon {
            width: 56px;
            height: 56px;
            background: var(--primary-light);
            color: var(--primary);
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin-bottom: 16px;
        }

        h2 {
            font-size: 22px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 6px;
        }

        p.desc {
            font-size: 14px;
            color: var(--text-muted);
        }

        .alert {
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 13px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-error {
            background-color: var(--error-bg);
            border: 1px solid var(--error-border);
            color: var(--error-text);
        }

        .alert-success {
            background-color: var(--success-bg);
            border: 1px solid var(--success-border);
            color: var(--success-text);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-main);
            margin-bottom: 8px;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px 16px;
            border-radius: 10px;
            border: 1px solid var(--border);
            font-size: 14px;
            outline: none;
            transition: all 0.2s ease;
            background-color: #f8fafc;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            border-color: var(--primary);
            background-color: #ffffff;
            box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.15);
        }

        .btn-submit {
            width: 100%;
            padding: 12px 18px;
            border-radius: 10px;
            border: none;
            background-color: var(--primary);
            color: #ffffff;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s ease, transform 0.1s ease;
            margin-top: 6px;
        }

        .btn-submit:hover {
            background-color: var(--primary-hover);
        }

        .btn-submit:active {
            transform: scale(0.99);
        }

        .demo-accounts {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px dashed var(--border);
            font-size: 12px;
            color: var(--text-muted);
        }

        .demo-accounts h4 {
            font-size: 12px;
            font-weight: 700;
            color: var(--text-main);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .account-chip {
            display: inline-block;
            background: #f1f5f9;
            padding: 4px 8px;
            border-radius: 6px;
            margin: 2px 4px 2px 0;
            cursor: pointer;
            border: 1px solid #e2e8f0;
            font-family: monospace;
        }

        .account-chip:hover {
            background: #e2e8f0;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="header">
        <div class="logo-icon">🦷</div>
        <h2>Đăng Nhập Hệ Thống</h2>
        <p class="desc">Phòng Khám Nha Khoa DCMS</p>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">
            <span>⚠️</span>
            <div>${errorMessage}</div>
        </div>
    </c:if>

    <c:if test="${param.loggedOut eq 'true'}">
        <div class="alert alert-success">
            <span>✅</span>
            <div>Bạn đã đăng xuất khỏi hệ thống an toàn.</div>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="POST">
        <div class="form-group">
            <label for="username">Tên đăng nhập / Tài khoản</label>
            <input type="text" id="username" name="username" value="${enteredUsername}" placeholder="Nhập tài khoản" required autofocus />
        </div>

        <div class="form-group">
            <label for="password">Mật khẩu</label>
            <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required />
        </div>

        <button type="submit" class="btn-submit">Đăng Nhập</button>
    </form>

    <div class="demo-accounts">
        <h4>Tài khoản mẫu thử nghiệm (Mật khẩu: 123456)</h4>
        <div>
            <span class="account-chip" onclick="fillAccount('letan01', '123456')">letan01 (Lễ tân)</span>
            <span class="account-chip" onclick="fillAccount('bacsi_hung', '123456')">bacsi_hung (Nha sĩ)</span>
            <span class="account-chip" onclick="fillAccount('admin', '123456')">admin (Quản trị)</span>
        </div>
    </div>
</div>

<script>
    function fillAccount(u, p) {
        document.getElementById('username').value = u;
        document.getElementById('password').value = p;
    }
</script>

</body>
</html>
