<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Order, model.OrderDetail, model.Product, model.User"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    List<Order> orders       = (List<Order>) request.getAttribute("orders");
    Order order              = (Order) request.getAttribute("order");
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("details");
    Map<Integer, Product> productMap = (Map<Integer, Product>) request.getAttribute("productMap");
    boolean isDetail = (order != null);
    if (orders == null) orders = new ArrayList<>();
    java.text.NumberFormat fmt = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));

    String[] statusOptions = {"Chờ xác nhận", "Đang giao", "Hoàn thành", "Hủy"};
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý đơn hàng - TTQ ADMIN</title>
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
        .btn-back { color: #e74c3c; text-decoration: none; font-size: 0.9rem; font-weight: 500; display: inline-block; margin-bottom: 16px; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 12px rgba(0,0,0,0.06); }
        thead { background: #1a1a2e; color: #fff; }
        th { padding: 14px 16px; text-align: left; font-size: 0.88rem; font-weight: 600; }
        td { padding: 12px 16px; border-bottom: 1px solid #f0f0f0; font-size: 0.88rem; color: #333; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        td img { width: 48px; height: 48px; object-fit: cover; border-radius: 6px; }
        .badge-status { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .status-cho  { background: #fef9e7; color: #b7770d; }
        .status-dang { background: #eaf4fb; color: #1a5276; }
        .status-hoan { background: #eafaf1; color: #1a7a40; }
        .status-huy  { background: #fdecea; color: #c0392b; }
        .btn-detail { background: #3498db; color: #fff; padding: 5px 12px; border-radius: 6px; text-decoration: none; font-size: 0.82rem; font-weight: 600; }
        .btn-detail:hover { background: #2176ae; }
        .status-form select { padding: 5px 8px; border: 1.5px solid #e0e0e0; border-radius: 6px; font-size: 0.82rem; font-family: 'Poppins', sans-serif; }
        .status-form button { background: #2ecc71; color: #fff; border: none; padding: 5px 10px; border-radius: 6px; cursor: pointer; font-size: 0.82rem; font-weight: 600; margin-left: 4px; }
        .price-red { color: #e74c3c; font-weight: 600; }
        .detail-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); padding: 24px; margin-bottom: 20px; }
        .detail-card h3 { font-size: 1rem; font-weight: 600; color: #444; margin-bottom: 12px; border-bottom: 1px solid #f0f0f0; padding-bottom: 8px; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px 32px; font-size: 0.9rem; color: #555; }
        .info-grid span { color: #222; font-weight: 500; }
        .total-row { text-align: right; font-size: 1rem; font-weight: 600; padding-top: 12px; color: #222; }
        .total-row span { color: #e74c3c; font-size: 1.1rem; }
    </style>
</head>
<body>
<div class="sidebar">
    <div class="sidebar-logo">TTQ <span>ADMIN</span></div>
    <nav>
        <a href="${pageContext.request.contextPath}/admin/index">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/products">📦 Sản phẩm</a>
        <a href="${pageContext.request.contextPath}/admin/orders" class="active">🛒 Đơn hàng</a>
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
        <h1><%= isDetail ? "Chi tiết đơn #" + order.getId() : "Quản lý đơn hàng (" + orders.size() + " đơn)" %></h1>
    </div>
    <div class="content">

    <% if (isDetail) { %>
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn-back">← Quay lại danh sách</a>

        <div class="detail-card">
            <h3>Thông tin giao hàng</h3>
            <div class="info-grid">
                <div>Người nhận: <span><%= order.getCustomerName() %></span></div>
                <div>Điện thoại: <span><%= order.getCustomerPhone() %></span></div>
                <div>Địa chỉ: <span><%= order.getCustomerAddress() %></span></div>
                <div>Ngày đặt: <span><%= order.getCreatedAt() %></span></div>
            </div>
            <div style="margin-top:16px">
                <form action="${pageContext.request.contextPath}/admin/order-status" method="post" class="status-form" style="display:inline-flex;align-items:center;gap:8px">
                    <input type="hidden" name="id" value="<%= order.getId() %>">
                    Trạng thái:
                    <select name="status">
                        <% for (String s : statusOptions) { %>
                        <option value="<%= s %>" <%= s.equals(order.getStatus()) ? "selected" : "" %>><%= s %></option>
                        <% } %>
                    </select>
                    <button type="submit">Cập nhật</button>
                </form>
            </div>
        </div>

        <div class="detail-card">
            <h3>Sản phẩm đã đặt</h3>
            <table>
                <thead><tr><th>Ảnh</th><th>Tên</th><th>Size</th><th>Đơn giá</th><th>SL</th><th>Thành tiền</th></tr></thead>
                <tbody>
                    <% if (details != null) for (OrderDetail d : details) {
                        Product pd = productMap != null ? productMap.get(d.getProductId()) : null; %>
                    <tr>
                        <td><% if (pd != null) { %><img src="${pageContext.request.contextPath}/<%= pd.getImage() %>"><% } %></td>
                        <td><%= pd != null ? pd.getName() : "SP #" + d.getProductId() %></td>
                        <td><%= d.getSize() %></td>
                        <td class="price-red"><%= fmt.format((long)d.getPrice()) %>đ</td>
                        <td><%= d.getQuantity() %></td>
                        <td class="price-red"><%= fmt.format((long)(d.getPrice()*d.getQuantity())) %>đ</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <div class="total-row">Tổng: <span><%= fmt.format((long)order.getTotalMoney()) %>đ</span></div>
        </div>

    <% } else { %>
        <table>
            <thead>
                <tr><th>ID</th><th>Khách hàng</th><th>SĐT</th><th>Tổng tiền</th><th>Trạng thái</th><th>Ngày đặt</th><th>Thao tác</th></tr>
            </thead>
            <tbody>
                <% for (Order o : orders) {
                    String st = o.getStatus();
                    String stClass = "status-cho";
                    if (st != null) {
                        if (st.contains("Đang")) stClass = "status-dang";
                        else if (st.contains("Hoàn")) stClass = "status-hoan";
                        else if (st.contains("Hủy")) stClass = "status-huy";
                    }
                %>
                <tr>
                    <td>#<%= o.getId() %></td>
                    <td><b><%= o.getCustomerName() %></b></td>
                    <td><%= o.getCustomerPhone() %></td>
                    <td class="price-red"><%= fmt.format((long)o.getTotalMoney()) %>đ</td>
                    <td><span class="badge-status <%= stClass %>"><%= st %></span></td>
                    <td><%= o.getCreatedAt() %></td>
                    <td><a href="${pageContext.request.contextPath}/admin/order-detail?id=<%= o.getId() %>" class="btn-detail">Xem chi tiết</a></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
    </div>
</div>
</body>
</html>
