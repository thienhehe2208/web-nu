<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.User"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    List<User> users = (List<User>) request.getAttribute("users");
    if (users == null) users = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý người dùng - TTQ ADMIN</title>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Poppins', sans-serif; background: #f4f6fb; display: flex; min-height: 100vh; }
        .sidebar { width: 230px; background: #1a1a2e; color: #fff; display: flex; flex-direction: column; flex-shrink: 0; }
        .sidebar-logo { padding: 24px 20px; font-size: 1.2rem; font-weight: 700; border-bottom: 1px solid rgba(255,255,255,0.08); color: #e74c3c; }
        .sidebar-logo span { color: #fff; font-weight: 300; }
        .sidebar nav { flex: 1; padding: 16px 0; }
        .sidebar nav a { display: flex; align-items: center; gap: 10px; padding: 12px 20px; color: #bbb; text-decoration: none; font-size: 0.93rem; border-left: 3px solid transparent; transition: all 0.2s; }
        .sidebar nav a:hover, .sidebar nav a.active { background: rgba(231,76,60,0.12); color: #fff; border-left-color: #e74c3c; }
        .sidebar-footer { padding: 16px 20px; border-top: 1px solid rgba(255,255,255,0.08); font-size: 0.82rem; color: #888; }
        .sidebar-footer a { color: #e74c3c; text-decoration: none; }
        .main { flex: 1; display: flex; flex-direction: column; }
        .topbar { background: #fff; padding: 16px 32px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 1px 8px rgba(0,0,0,0.06); }
        .topbar h1 { font-size: 1.2rem; font-weight: 600; color: #222; }
        .content { padding: 32px; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.06); }
        thead { background: #1a1a2e; color: #fff; }
        th { padding: 14px 16px; text-align: left; font-size: 0.88rem; font-weight: 600; }
        td { padding: 12px 16px; border-bottom: 1px solid #f0f0f0; font-size: 0.88rem; color: #e74c3c; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        .badge-admin { background: #fdecea; color: #c0392b; padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 700; }
        .badge-user  { background: #eaf4fb; color: #1a5276; padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .role-form select { padding: 5px 8px; border: 1.5px solid #e0e0e0; border-radius: 6px; font-size: 0.82rem; font-family: 'Poppins', sans-serif; }
        .role-form button { background: #3498db; color: #fff; border: none; padding: 5px 10px; border-radius: 6px; cursor: pointer; font-size: 0.82rem; font-weight: 600; margin-left: 4px; }
        .btn-del { background: #e74c3c; color: #fff; padding: 5px 12px; border-radius: 6px; text-decoration: none; font-size: 0.82rem; font-weight: 600; border: none; cursor: pointer; }
        .btn-del:hover { background: #c0392b; }
        .self-row { background: #fffbea; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="sidebar-logo">TTQ <span>ADMIN</span></div>
    <nav>
        <a href="${pageContext.request.contextPath}/admin/index">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products">📦 Sản phẩm</a>
        <a href="${pageContext.request.contextPath}/admin/orders">🛒 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/admin/users" class="active">👥 Người dùng</a>
        <a href="${pageContext.request.contextPath}/admin/contacts">💬 Góp ý</a>
    </nav>
    <div class="sidebar-footer">
        👤 <%= loggedUser != null ? loggedUser.getAccountName() : "" %><br>
        <a href="${pageContext.request.contextPath}/ProductServlet">← Về trang chủ</a>
    </div>
</div>
<div class="main">
    <div class="topbar">
        <h1>Quản lý người dùng (<%= users.size() %> tài khoản)</h1>
    </div>
    <div class="content">
        <table>
            <thead>
                <tr><th>ID</th><th>Tên</th><th>Username</th><th>Email</th><th>SĐT</th><th>Role</th><th>Đổi role</th><th>Xóa</th></tr>
            </thead>
            <tbody>
                <% for (User u : users) {
                    boolean isSelf = (loggedUser != null && u.getId() == loggedUser.getId());
                %>
                <tr class="<%= isSelf ? "self-row" : "" %>">
                    <td>#<%= u.getId() %></td>
                    <td><b><%= u.getAccountName() %></b> <%= isSelf ? "<span style='color:#e67e22;font-size:0.78rem'>(bạn)</span>" : "" %></td>
                    <td><%= u.getUsername() %></td>
                    <td><%= u.getEmail() != null ? u.getEmail() : "" %></td>
                    <td><%= u.getPhone() != null ? u.getPhone() : "" %></td>
                    <td><span class="<%= "admin".equals(u.getRole()) ? "badge-admin" : "badge-user" %>"><%= u.getRole() %></span></td>
                    <td>
                        <% if (!isSelf) { %>
                        <form action="${pageContext.request.contextPath}/admin/user-role" method="post" class="role-form" style="display:inline-flex;align-items:center">
                            <input type="hidden" name="id" value="<%= u.getId() %>">
                            <select name="role">
                                <option value="user"  <%= "user".equals(u.getRole())  ? "selected" : "" %>>user</option>
                                <option value="admin" <%= "admin".equals(u.getRole()) ? "selected" : "" %>>admin</option>
                            </select>
                            <button type="submit">Lưu</button>
                        </form>
                        <% } else { %> — <% } %>
                    </td>
                    <td>
                        <% if (!isSelf && !"admin".equals(u.getRole())) { %>
                        <a href="${pageContext.request.contextPath}/admin/user-delete?id=<%= u.getId() %>"
                           onclick="return confirm('Xóa tài khoản <%= u.getUsername() %>?')"
                           class="btn-del">Xóa</a>
                        <% } else { %> — <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
