<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    Integer totalProducts = (Integer) request.getAttribute("totalProducts");
    Integer totalUsers    = (Integer) request.getAttribute("totalUsers");
    Integer totalOrders   = (Integer) request.getAttribute("totalOrders");
    if (totalProducts == null) totalProducts = 0;
    if (totalUsers    == null) totalUsers    = 0;
    if (totalOrders   == null) totalOrders   = 0;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - TTQ SHOP</title>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Poppins', sans-serif; background: #f4f6fb; display: flex; min-height: 100vh; }

        /* SIDEBAR */
        .sidebar {
            width: 230px; background: #1a1a2e; color: #fff;
            display: flex; flex-direction: column; padding: 0; flex-shrink: 0;
        }
        .sidebar-logo {
            padding: 24px 20px; font-size: 1.2rem; font-weight: 700;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            color: #e74c3c; letter-spacing: 1px;
        }
        .sidebar-logo span { color: #fff; font-weight: 300; }
        .sidebar nav { flex: 1; padding: 16px 0; }
        .sidebar nav a {
            display: flex; align-items: center; gap: 10px;
            padding: 12px 20px; color: #bbb; text-decoration: none;
            font-size: 0.93rem; transition: all 0.2s; border-left: 3px solid transparent;
        }
        .sidebar nav a:hover, .sidebar nav a.active {
            background: rgba(231,76,60,0.12); color: #fff;
            border-left-color: #e74c3c;
        }
        .sidebar-footer {
            padding: 16px 20px; border-top: 1px solid rgba(255,255,255,0.08);
            font-size: 0.82rem; color: #888;
        }
        .sidebar-footer a { color: #e74c3c; text-decoration: none; }

        /* MAIN */
        .main { flex: 1; display: flex; flex-direction: column; }
        .topbar {
            background: #fff; padding: 16px 32px;
            display: flex; align-items: center; justify-content: space-between;
            box-shadow: 0 1px 8px rgba(0,0,0,0.06);
        }
        .topbar h1 { font-size: 1.2rem; font-weight: 600; color: #222; }
        .topbar .admin-info { font-size: 0.88rem; color: #888; }
        .topbar .admin-info b { color: #e74c3c; }

        .content { padding: 32px; }

        /* STAT CARDS */
        .stat-grid {
            display: grid; grid-template-columns: repeat(3, 1fr);
            gap: 20px; margin-bottom: 32px;
        }
        .stat-card {
            background: #fff; border-radius: 12px;
            padding: 24px 28px; box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            display: flex; align-items: center; gap: 18px;
        }
        .stat-icon {
            width: 54px; height: 54px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.6rem;
        }
        .stat-icon.red   { background: #fdecea; }
        .stat-icon.blue  { background: #eaf4fb; }
        .stat-icon.green { background: #eafaf1; }
        .stat-info h3 { font-size: 1.8rem; font-weight: 700; color: #222; }
        .stat-info p  { font-size: 0.85rem; color: #888; margin-top: 2px; }

        /* QUICK LINKS */
        .quick-links {
            display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px;
        }
        .quick-card {
            background: #fff; border-radius: 12px;
            padding: 20px 24px; box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            text-decoration: none; color: #222;
            transition: transform 0.15s, box-shadow 0.15s;
            border-left: 4px solid #e74c3c;
        }
        .quick-card:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(0,0,0,0.1); }
        .quick-card h3 { font-size: 1rem; font-weight: 600; margin-bottom: 4px; }
        .quick-card p  { font-size: 0.84rem; color: #888; }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <div class="sidebar-logo">TTQ <span>ADMIN</span></div>
    <nav>
        <a href="${pageContext.request.contextPath}/admin/index" class="active">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products">📦 Sản phẩm</a>
        <a href="${pageContext.request.contextPath}/admin/orders">🛒 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/admin/users">👥 Người dùng</a>
        <a href="${pageContext.request.contextPath}/admin/contacts">💬 Góp ý</a>
    </nav>
    <div class="sidebar-footer">
        👤 <%= loggedUser != null ? loggedUser.getAccountName() : "" %><br>
        <a href="${pageContext.request.contextPath}/ProductServlet">← Về trang chủ</a>
    </div>
</div>

<!-- MAIN -->
<div class="main">
    <div class="topbar">
        <h1>Dashboard</h1>
        <div class="admin-info">Xin chào, <b><%= loggedUser != null ? loggedUser.getAccountName() : "" %></b></div>
    </div>
    <div class="content">

        <!-- THỐNG KÊ -->
        <div class="stat-grid">
            <div class="stat-card">
                <div class="stat-icon red">📦</div>
                <div class="stat-info">
                    <h3><%= totalProducts %></h3>
                    <p>Sản phẩm</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon blue">🛒</div>
                <div class="stat-info">
                    <h3><%= totalOrders %></h3>
                    <p>Đơn hàng</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">👥</div>
                <div class="stat-info">
                    <h3><%= totalUsers %></h3>
                    <p>Người dùng</p>
                </div>
            </div>
        </div>

        <!-- QUICK LINKS -->
        <div class="quick-links">
            <a href="${pageContext.request.contextPath}/admin/products" class="quick-card">
                <h3>Quản lý sản phẩm</h3>
                <p>Thêm, sửa, xóa sản phẩm</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="quick-card">
                <h3>Quản lý đơn hàng</h3>
                <p>Xem và cập nhật trạng thái đơn</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/users" class="quick-card">
                <h3>Quản lý người dùng</h3>
                <p>Xem danh sách và phân quyền</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/contacts" class="quick-card">
                <h3>Quản lý mục góp ý</h3>
                <p>Xem danh sách và phân quyền</p>
            </a>
        </div>

    </div>
</div>

</body>
</html>
