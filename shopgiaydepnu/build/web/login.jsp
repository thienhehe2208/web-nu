<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng Nhập</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="login-body">

<div class="login-container">
    <h2>🔐 Đăng Nhập</h2>

    <% String error = (String) request.getAttribute("error"); %>
    <% String success = (String) request.getAttribute("success"); %>
    <% if (error != null) { %>
        <p style="color:var(--primary); font-size:13px; margin-bottom:14px;">⚠️ <%= error %></p>
    <% } %>
    <% if (success != null) { %>
        <p style="color:#27ae60; font-size:13px; margin-bottom:14px;">✅ <%= success %></p>
    <% } %>

    <form method="post" action="UserServlet">
        <input type="hidden" name="action" value="login">

        <div class="input-group">
            <input type="text" name="username" required>
            <label>Tên đăng nhập</label>
        </div>

        <div class="input-group">
            <input type="password" name="password" required>
            <label>Mật khẩu</label>
        </div>

        <button type="submit" class="login-btn">Đăng Nhập</button>
    </form>

    <div class="register-link">
        Chưa có tài khoản? <a href="UserServlet?action=register">Đăng ký ngay</a>
    </div>
    <div class="register-link" style="margin-top:8px;">
        <a href="ProductServlet">← Quay về trang chủ</a>
    </div>
</div>

</body>
</html>