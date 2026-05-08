<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
%>
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

        <button type="submit">
            <img src="img/timkiem.png" alt="Search">
        </button>
    </form>
</div>
    <!-- RIGHT -->
    <div class="header-right">
        <% if (loggedUser != null) { %>
            <span style="color:#fff; font-size:13px;">
                👤 <b><%= loggedUser.getAccountName() %></b>
            </span>
            <a class="btn" href="UserServlet?action=logout">Đăng xuất</a>
        <% } else { %>
            <a class="btn" href="UserServlet?action=login">Đăng nhập</a>
            <a class="btn" href="UserServlet?action=register">Đăng ký</a>
        <% } %>

        <a class="cart-btn" href="GioHang.jsp">
            <img src="img/giohang.png" class="cart-icon">
            <span class="cart-count">0</span>
        </a>
    </div>
</div>