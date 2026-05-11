<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Contact, model.User"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    List<Contact> contacts = (List<Contact>) request.getAttribute("contacts");
    if (contacts == null) contacts = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Góp ý - TTQ ADMIN</title>
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
        td { padding: 12px 16px; border-bottom: 1px solid #f0f0f0; font-size: 0.88rem; color: #333; vertical-align: top; }
        tr:last-child td { border-bottom: none; }
        .msg-cell { max-width: 300px; white-space: pre-wrap; word-break: break-word; }
        .btn-del { background: #e74c3c; color: #fff; padding: 5px 12px; border-radius: 6px; text-decoration: none; font-size: 0.82rem; font-weight: 600; }
        .btn-del:hover { background: #c0392b; }
        .empty { text-align: center; padding: 60px; color: #aaa; font-size: 1rem; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="sidebar-logo">TTQ <span>ADMIN</span></div>
    <nav>
        <a href="${pageContext.request.contextPath}/admin/index">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products">📦 Sản phẩm</a>
        <a href="${pageContext.request.contextPath}/admin/orders">🛒 Đơn hàng</a>
        <a href="${pageContext.request.contextPath}/admin/users">👥 Người dùng</a>
        <a href="${pageContext.request.contextPath}/admin/contacts" class="active">💬 Góp ý</a>
    </nav>
    <div class="sidebar-footer">
        👤 <%= loggedUser != null ? loggedUser.getAccountName() : "" %><br>
        <a href="${pageContext.request.contextPath}/ProductServlet">← Về trang chủ</a>
    </div>
</div>
<div class="main">
    <div class="topbar">
        <h1>Góp ý khách hàng (<%= contacts.size() %> tin nhắn)</h1>
    </div>
    <div class="content">
        <% if (contacts.isEmpty()) { %>
        <div class="empty">📭 Chưa có góp ý nào!</div>
        <% } else { %>
        <table>
            <thead>
                <tr><th>ID</th><th>Họ tên</th><th>Email</th><th>SĐT</th><th>Nội dung</th><th>Ngày gửi</th><th>Xóa</th></tr>
            </thead>
            <tbody>
                <% for (Contact c : contacts) { %>
                <tr>
                    <td>#<%= c.getId() %></td>
                    <td><b><%= c.getName() %></b></td>
                    <td><%= c.getEmail() %></td>
                    <td><%= c.getPhone() != null ? c.getPhone() : "" %></td>
                    <td class="msg-cell"><%= c.getMessage() %></td>
                    <td><%= c.getCreatedAt() %></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/contact-delete?id=<%= c.getId() %>"
                           onclick="return confirm('Xóa góp ý này?')" class="btn-del">Xóa</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>
</body>
</html>