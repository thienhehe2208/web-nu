<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class="menu">

    <!-- MENU CHÍNH -->
    <div class="menu-main">

        <a href="ProductServlet" class="menu-link">
            <img src="img/trangchu.png">
            <span>Trang chủ</span>
        </a>

        <a href="ProductServlet?action=new" class="menu-link">
            <img src="img/hangmoi.png">
            <span>Hàng mới</span>
        </a>

        <a href="ProductServlet?action=bestseller" class="menu-link">
            <img src="img/banchay.png">
            <span>Bán chạy</span>
        </a>

        <a href="ProductServlet?action=discount" class="menu-link">
            <img src="img/giamgia.png">
            <span>Giảm giá</span>
        </a>

        <button class="menu-link contact-btn" onclick="openContact()">
            <img src="img/lienhe.png">
            <span>Liên hệ</span>
        </button>

    </div>

</div>