<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Category"%>
<%
    // Lấy categories từ attribute do ProductServlet set sẵn
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>

<div class="menu">

    <button onclick="toggleMenu()" class="menu-btn">
        <img src="img/menu.png"> Danh mục
    </button>

    <div class="menu-main">
        <a href="ProductServlet" class="menu-link category">
            <img src="img/trangchu.png"> Trang chủ
        </a>
        <a href="ProductServlet?action=new" class="menu-link category">
            <img src="img/hangmoi.png"> Hàng mới
        </a>
        <a href="ProductServlet?action=bestseller" class="menu-link category">
            <img src="img/banchay.png"> Bán chạy
        </a>
        <a href="ProductServlet?action=discount" class="menu-link category">
            <img src="img/giamgia.png"> Giảm giá
        </a>
        <button class="menu-link contact" onclick="openContact()">
            <img src="img/lienhe.png"> Liên hệ
        </button>
    </div>

</div>

<!-- MENU CON - DANH MỤC TỪ DATABASE -->
<div id="subMenu" class="submenu">
    <p><b>DANH MỤC SẢN PHẨM</b></p>
    <% if (categories != null) {
        for (Category c : categories) { %>
            <a href="ProductServlet?action=filter&categoryId=<%= c.getId() %>"><%= c.getName() %></a>
    <%  }
    } %>
</div>

<script>
function toggleMenu() {
    var x = document.getElementById("subMenu");
    x.style.display = (x.style.display === "block") ? "none" : "block";
}
</script>
