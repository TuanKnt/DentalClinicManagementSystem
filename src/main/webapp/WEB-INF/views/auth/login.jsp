<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập — Hệ Thống Quản Lý Phòng Khám Nha Khoa (DCMS)</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/theme.css">
    <style>
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: radial-gradient(circle at 15% 20%, rgba(0, 82, 204, 0.08) 0%, transparent 40%),
                        radial-gradient(circle at 85% 80%, rgba(0, 168, 204, 0.08) 0%, transparent 40%),
                        #f0f7fd;
            padding: 24px;
        }

        .login-wrapper {
            width: 100%;
            max-width: 440px;
        }

        .login-card {
            background: #ffffff;
            border-radius: var(--radius-xl);
            border: 2px solid #e0f2fe;
            box-shadow: 0 20px 45px -10px rgba(0, 51, 102, 0.12);
            padding: 40px;
            position: relative;
            overflow: hidden;
        }

        .login-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: var(--drsmile-gradient);
        }

        .login-brand {
            text-align: center;
            margin-bottom: 28px;
        }

        .login-logo {
            width: 60px;
            height: 60px;
            background: var(--drsmile-gradient);
            border-radius: var(--radius-lg);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            box-shadow: 0 8px 20px rgba(0, 51, 102, 0.25);
            margin-bottom: 14px;
            color: #ffffff;
        }

        .login-brand h1 {
            font-size: 22px;
            font-weight: 800;
            color: var(--drsmile-navy);
            letter-spacing: -0.4px;
            margin-bottom: 6px;
        }

        .login-brand p {
            font-size: 13px;
            color: var(--text-secondary);
        }

        .back-home-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            color: var(--drsmile-blue);
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 18px;
            transition: color var(--transition-fast);
        }
        .back-home-link:hover {
            color: var(--drsmile-navy);
            text-decoration: underline;
        }

        .demo-roles {
            margin-top: 28px;
            padding-top: 20px;
            border-top: 1px dashed var(--border);
        }

        .demo-roles-title {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--text-muted);
            margin-bottom: 10px;
            text-align: center;
        }

        .demo-chips-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 8px;
        }

        .demo-chip {
            padding: 8px 6px;
            background: #f8fafc;
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            text-align: center;
            cursor: pointer;
            transition: all var(--transition-fast);
        }

        .demo-chip:hover {
            background: var(--primary-light);
            border-color: #bae6fd;
            transform: translateY(-1px);
        }

        .demo-chip-role {
            font-size: 12px;
            font-weight: 700;
            color: var(--text-primary);
            display: block;
        }

        .demo-chip-user {
            font-size: 11px;
            font-family: monospace;
            color: var(--primary);
        }
    </style>
</head>
<body>

<div class="login-wrapper">
    <div style="margin-bottom: 12px;">
        <a href="${pageContext.request.contextPath}/" class="back-home-link">
            <span>←</span> Quay lại trang chủ Nha khoa Dr.Smile
        </a>
    </div>

    <div class="login-card">
        <div class="login-brand">
            <div class="login-logo">🦷</div>
            <h1>Nha Khoa Dr.Smile</h1>
            <p>Cổng Tác Nghiệp Nội Bộ DCMS &bull; Bác Sĩ & Cán Bộ Phòng Khám</p>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert-banner alert-banner-danger" style="margin-bottom: 20px; padding: 10px 14px; font-size: 13px;">
                <span class="alert-banner-icon">⚠️</span>
                <div>${errorMessage}</div>
            </div>
        </c:if>

        <c:if test="${param.loggedOut eq 'true'}">
            <div class="alert-banner alert-banner-success" style="margin-bottom: 20px; padding: 10px 14px; font-size: 13px;">
                <span class="alert-banner-icon">✅</span>
                <div>Bạn đã đăng xuất an toàn khỏi hệ thống Dr.Smile DCMS.</div>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="POST">
            <div class="form-group" style="margin-bottom: 16px;">
                <label for="username" class="form-label required">Tài Khoản / Tên Đăng Nhập</label>
                <input type="text" 
                       id="username" 
                       name="username" 
                       class="form-control" 
                       value="${enteredUsername}" 
                       placeholder="Nhập tên đăng nhập" 
                       required 
                       autofocus />
            </div>

            <div class="form-group" style="margin-bottom: 24px;">
                <label for="password" class="form-label required">Mật Khẩu</label>
                <input type="password" 
                       id="password" 
                       name="password" 
                       class="form-control" 
                       placeholder="Nhập mật khẩu" 
                       required />
            </div>

            <button type="submit" class="btn btn-drsmile" style="width: 100%; padding: 12px; font-size: 14.5px;">
                <span>🔐</span> Đăng Nhập Vào Hệ Thống
            </button>
        </form>

        <div class="demo-roles">
            <div class="demo-roles-title">Tài khoản demo thử nghiệm (MK: 123456)</div>
            <div class="demo-chips-grid">
                <div class="demo-chip" onclick="fillAccount('letan01', '123456')" title="Nhấn để điền tài khoản Lễ tân">
                    <span class="demo-chip-role">👩‍💼 Lễ Tân</span>
                    <span class="demo-chip-user">letan01</span>
                </div>
                <div class="demo-chip" onclick="fillAccount('bacsi_hung', '123456')" title="Nhấn để điền tài khoản Nha sĩ">
                    <span class="demo-chip-role">👨‍⚕️ Nha Sĩ</span>
                    <span class="demo-chip-user">bacsi_hung</span>
                </div>
                <div class="demo-chip" onclick="fillAccount('admin', '123456')" title="Nhấn để điền tài khoản Quản trị">
                    <span class="demo-chip-role">⚙️ Quản Trị</span>
                    <span class="demo-chip-user">admin</span>
                </div>
            </div>
        </div>
    </div>

    <div style="text-align: center; margin-top: 20px; font-size: 12px; color: var(--text-muted);">
        Nha Khoa Dr.Smile &bull; DCMS System &bull; Nhóm G3_SE2064
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
