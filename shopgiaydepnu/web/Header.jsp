<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="header">

    <!-- LOGO -->
    <div class="logo">
        <img src="img/logo.png">
        <span>TTQ SHOP</span>
    </div>

    <!-- THANH TÌM KIẾM -->
    <div class="header-search">
        <form action="ProductServlet" method="get">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm...">
            <button type="submit">🔍</button>
        </form>
    </div>

    <!-- RIGHT -->
    <div class="header-right">
        <a class="btn" href="DangNhap.jsp">Đăng nhập</a>
        <a class="btn" href="DangKy.jsp">Đăng ký</a>

        <!-- CART (chưa có giỏ hàng) -->
        <a class="cart-btn" href="GioHang.jsp">
            <img src="img/giohang.png" class="cart-icon">
            <span class="cart-count">0</span>
        </a>
    </div>

</div>
