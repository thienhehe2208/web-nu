<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Product, model.User"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    List<Product> products = (List<Product>) request.getAttribute("products");
    if (products == null) products = new ArrayList<>();
    java.text.NumberFormat fmt = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý sản phẩm - TTQ ADMIN</title>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Poppins', sans-serif; background: #f4f6fb; display: flex; min-height: 100vh; }
        .sidebar { width: 230px; background: #1a1a2e; color: #fff; display: flex; flex-direction: column; flex-shrink: 0; }
        .sidebar-logo { padding: 24px 20px; font-size: 1.2rem; font-weight: 700; border-bottom: 1px solid rgba(255,255,255,0.08); color: #e74c3c; }
        .sidebar-logo span { color: #fff; font-weight: 300; }
        .sidebar nav { flex: 1; padding: 16px 0; }
        .sidebar nav a { display: flex; align-items: center; gap: 10px; padding: 12px 20px; color: #bbb; text-decoration: none; font-size: 0.93rem; transition: all 0.2s; border-left: 3px solid transparent; }
        .sidebar nav a:hover, .sidebar nav a.active { background: rgba(231,76,60,0.12); color: #fff; border-left-color: #e74c3c; }
        .sidebar-footer { padding: 16px 20px; border-top: 1px solid rgba(255,255,255,0.08); font-size: 0.82rem; color: #888; }
        .sidebar-footer a { color: #e74c3c; text-decoration: none; }
        .main { flex: 1; display: flex; flex-direction: column; }
        .topbar { background: #fff; padding: 16px 32px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 1px 8px rgba(0,0,0,0.06); }
        .topbar h1 { font-size: 1.2rem; font-weight: 600; color: #222; }
        .content { padding: 32px; }
        .btn-add { background: #e74c3c; color: #fff; padding: 10px 22px; border-radius: 8px; text-decoration: none; font-size: 0.93rem; font-weight: 600; }
        .btn-add:hover { background: #c0392b; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.06); margin-top: 20px; }
        thead { background: #1a1a2e; color: #fff; }
        th { padding: 14px 16px; text-align: left; font-size: 0.88rem; font-weight: 600; }
        td { padding: 12px 16px; border-bottom: 1px solid #f0f0f0; font-size: 0.88rem; color: #333; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        td img { width: 48px; height: 48px; object-fit: cover; border-radius: 6px; }
        .badge-new { background: #eafaf1; color: #1a7a40; padding: 2px 8px; border-radius: 10px; font-size: 0.78rem; font-weight: 600; }
        .badge-hot { background: #fef5e7; color: #b7770d; padding: 2px 8px; border-radius: 10px; font-size: 0.78rem; font-weight: 600; }
        .stock-low { color: #e67e22; font-weight: 600; }
        .stock-out { color: #e74c3c; font-weight: 600; }
        .btn-edit { background: #3498db; color: #fff; padding: 5px 12px; border-radius: 6px; text-decoration: none; font-size: 0.82rem; font-weight: 600; margin-right: 4px; }
        .btn-edit:hover { background: #2176ae; }
        .btn-del { background: #e74c3c; color: #fff; padding: 5px 12px; border-radius: 6px; text-decoration: none; font-size: 0.82rem; font-weight: 600; }
        .btn-del:hover { background: #c0392b; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="sidebar-logo">TTQ <span>ADMIN</span></div>
    <nav>
        <a href="${pageContext.request.contextPath}/admin/index">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products" class="active">📦 Sản phẩm</a>
        <a href="${pageContext.request.contextPath}/admin/orders">🛒 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/admin/users">👥 Người dùng</a>
        <a href="${pageContext.request.contextPath}/admin/contacts">💬 Góp ý</a>
    </nav>
    <div class="sidebar-footer">
        👤 <%= loggedUser != null ? loggedUser.getAccountName() : "" %><br>
        <a href="${pageContext.request.contextPath}/ProductServlet">← Về trang chủ</a>
    </div>
</div>
<div class="main">
    <div class="topbar">
        <h1>Quản lý sản phẩm (<%= products.size() %> sản phẩm)</h1>
        <a href="${pageContext.request.contextPath}/admin/product-add" class="btn-add">+ Thêm sản phẩm</a>
    </div>
    <div class="content">
        <table>
            <thead>
                <tr>
                    <th>ID</th><th>Ảnh</th><th>Tên sản phẩm</th><th>SKU</th>
                    <th>Giá</th><th>Tồn kho</th><th>Nhãn</th><th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <% for (Product p : products) { %>
                <tr>
                    <td>#<%= p.getId() %></td>
                    <td><img src="${pageContext.request.contextPath}/<%= p.getImage() %>" alt="<%= p.getName() %>"></td>
                    <td><b><%= p.getName() %></b></td>
                    <td><%= p.getSku() %></td>
                    <td>
                        <% if (p.getDiscountPrice() != null && p.getDiscountPrice() > 0) { %>
                        <del style="color:#bbb;font-size:0.8rem"><%= fmt.format((long)p.getPrice()) %>đ</del><br>
                        <span style="color:#e74c3c;font-weight:600"><%= fmt.format(p.getDiscountPrice().longValue()) %>đ</span>
                        <% } else { %>
                        <%= fmt.format((long)p.getPrice()) %>đ
                        <% } %>
                    </td>
                    <td class="<%= p.getStock() == 0 ? "stock-out" : p.getStock() <= 5 ? "stock-low" : "" %>">
                        <%= p.getStock() == 0 ? "Hết hàng" : p.getStock() + " cái" %>
                    </td>
                    <td>
                        <% if (p.isIsNew()) { %><span class="badge-new">MỚI</span><% } %>
                        <% if (p.isIsBestseller()) { %><span class="badge-hot">HOT</span><% } %>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/product-edit?id=<%= p.getId() %>" class="btn-edit">Sửa</a>
                        <a href="${pageContext.request.contextPath}/admin/product-delete?id=<%= p.getId() %>"
                           onclick="return confirm('Xóa sản phẩm này?')" class="btn-del">Xóa</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
