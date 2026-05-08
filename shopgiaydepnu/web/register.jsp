<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký</title>
    <link rel="stylesheet" href="css/Style.css">
    <style>
        /* mở rộng thêm cho form đăng ký rộng hơn */
        .login-container { width: 440px; }
    </style>
</head>
<body class="login-body">

<div class="login-container">
    <h2>ĐĂNG KÍ</h2>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
        <p style="color:var(--primary); font-size:13px; margin-bottom:14px;">⚠️ <%= error %></p>
    <% } %>

    <form method="post" action="UserServlet">
        <input type="hidden" name="action" value="register">

        <div class="input-group">
            <input type="text" name="accountName" required>
            <label>Họ và tên</label>
        </div>

        <div class="input-group">
            <input type="text" name="username" required>
            <label>Tên đăng nhập</label>
        </div>

        <div class="input-group">
            <input type="email" name="email" required>
            <label>Email</label>
        </div>

        <div class="input-group">
            <input type="text" name="phone">
            <label>Số điện thoại (tùy chọn)</label>
        </div>

        <div class="input-group">
            <input type="text" name="address">
            <label>Địa chỉ (tùy chọn)</label>
        </div>

        <div class="input-group">
            <input type="password" name="password" required>
            <label>Mật khẩu</label>
        </div>

        <div class="input-group">
            <input type="password" name="confirmPassword" required>
            <label>Xác nhận mật khẩu</label>
        </div>

        <button type="submit" class="login-btn">Đăng Ký</button>
    </form>

    <div class="register-link">
        Đã có tài khoản? <a href="UserServlet?action=login">Đăng nhập</a>
    </div>
    <div class="register-link" style="margin-top:8px;">
        <a href="ProductServlet">← Quay về trang chủ</a>
    </div>
</div>

</body>
</html>