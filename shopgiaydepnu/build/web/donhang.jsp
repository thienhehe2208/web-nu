<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Order, model.OrderDetail, model.Product, model.User"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");

    // Danh sách đơn hàng (action=list)
    List<Order> orders = (List<Order>) request.getAttribute("orders");

    // Chi tiết đơn hàng (action=detail)
    Order order = (Order) request.getAttribute("order");
    List<OrderDetail> details = (List<OrderDetail>) request.getAttribute("details");
    Map<Integer, Product> productMap = (Map<Integer, Product>) request.getAttribute("productMap");

    boolean isDetail = (order != null);

    java.text.NumberFormat fmt = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Đơn Hàng - TTQ SHOP</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="css/Style.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600&display=swap" rel="stylesheet">
        <style>
            .order-wrapper {
                max-width: 900px;
                margin: 40px auto 60px auto;
                padding: 0 16px;
                font-family: 'Poppins', sans-serif;
            }
            .order-wrapper h2 {
                font-size: 1.6rem; font-weight: 600; color: #222;
                margin-bottom: 24px;
                border-left: 4px solid #e74c3c; padding-left: 12px;
            }
            .btn-back {
                display: inline-block; margin-bottom: 20px;
                color: #e74c3c; text-decoration: none;
                font-size: 0.93rem; font-weight: 500;
            }
            .btn-back:hover { text-decoration: underline; }

            /* ===== DANH SÁCH ĐƠN HÀNG ===== */
            .order-list { display: flex; flex-direction: column; gap: 16px; }
            .order-card {
                background: #fff; border-radius: 12px;
                box-shadow: 0 3px 16px rgba(0,0,0,0.07);
                padding: 20px 24px;
                display: flex; align-items: center;
                justify-content: space-between; flex-wrap: wrap; gap: 12px;
            }
            .order-card-left { flex: 1; }
            .order-card-left h3 {
                font-size: 1rem; font-weight: 600;
                color: #222; margin-bottom: 6px;
            }
            .order-card-left p {
                font-size: 0.88rem; color: #888; margin: 2px 0;
            }
            .order-card-left .total {
                color: #e74c3c; font-weight: 600; font-size: 1rem;
                margin-top: 6px;
            }
            .btn-detail {
                background: #e74c3c; color: #fff;
                padding: 9px 22px; border-radius: 8px;
                text-decoration: none; font-size: 0.9rem;
                font-weight: 600; white-space: nowrap;
                transition: background 0.2s;
            }
            .btn-detail:hover { background: #c0392b; }

            /* Badge trạng thái */
            .badge-status {
                display: inline-block;
                padding: 3px 12px; border-radius: 20px;
                font-size: 0.8rem; font-weight: 600; margin-left: 8px;
            }
            .status-cho    { background: #fef9e7; color: #b7770d; border: 1px solid #f9e79f; }
            .status-dang   { background: #eaf4fb; color: #1a5276; border: 1px solid #aed6f1; }
            .status-hoan   { background: #eafaf1; color: #1a7a40; border: 1px solid #a9dfbf; }
            .status-huy    { background: #fdecea; color: #c0392b; border: 1px solid #f5b7b1; }

            .empty-order {
                text-align: center; padding: 60px 0;
                color: #aaa; font-size: 1.05rem;
            }
            .empty-order a {
                display: inline-block; margin-top: 16px;
                background: #e74c3c; color: #fff;
                padding: 10px 28px; border-radius: 24px;
                text-decoration: none; font-weight: 600;
            }

            /* ===== CHI TIẾT ĐƠN HÀNG ===== */
            .detail-card {
                background: #fff; border-radius: 12px;
                box-shadow: 0 3px 16px rgba(0,0,0,0.07);
                padding: 28px 32px; margin-bottom: 24px;
            }
            .detail-card h3 {
                font-size: 1.05rem; font-weight: 600; color: #444;
                margin-bottom: 14px; border-bottom: 1px solid #f0f0f0;
                padding-bottom: 10px;
            }
            .info-grid {
                display: grid; grid-template-columns: 1fr 1fr;
                gap: 10px 32px; font-size: 0.93rem; color: #555;
            }
            .info-grid span { color: #222; font-weight: 500; }

            .detail-table {
                width: 100%; border-collapse: collapse;
                font-size: 0.93rem;
            }
            .detail-table th {
                background: #fafafa; padding: 12px 14px;
                text-align: left; font-weight: 600; color: #555;
                border-bottom: 2px solid #f0f0f0;
            }
            .detail-table td {
                padding: 12px 14px; border-bottom: 1px solid #f5f5f5;
                vertical-align: middle; color: #333;
            }
            .detail-table tr:last-child td { border-bottom: none; }
            .detail-table img {
                width: 52px; height: 52px;
                object-fit: cover; border-radius: 6px;
            }
            .price-red { color: #e74c3c; font-weight: 600; }

            .order-total-row {
                text-align: right; padding: 16px 0 0 0;
                font-size: 1.05rem; font-weight: 600; color: #222;
            }
            .order-total-row span { color: #e74c3c; font-size: 1.2rem; }
        </style>
    </head>
    <body>

        <jsp:include page="Header.jsp"/>
        <jsp:include page="menu.jsp"/>

        <div class="order-wrapper">

            <% if (isDetail) { %>
            <%-- ========== TRANG CHI TIẾT ĐƠN HÀNG ========== --%>
            <a href="OrderServlet" class="btn-back">← Quay lại danh sách đơn hàng</a>
            <h2>📋 Chi Tiết Đơn Hàng #<%= order.getId() %></h2>

            <%-- Thông tin đơn --%>
            <div class="detail-card">
                <h3>Thông tin giao hàng</h3>
                <div class="info-grid">
                    <div>Người nhận: <span><%= order.getCustomerName() %></span></div>
                    <div>Điện thoại: <span><%= order.getCustomerPhone() %></span></div>
                    <div>Địa chỉ: <span><%= order.getCustomerAddress() %></span></div>
                    <div>Ngày đặt: <span><%= order.getCreatedAt() %></span></div>
                    <div>Trạng thái:
                        <%
                            String st = order.getStatus();
                            String stClass = "status-cho";
                            if (st != null) {
                                if (st.contains("Đang")) stClass = "status-dang";
                                else if (st.contains("Hoàn")) stClass = "status-hoan";
                                else if (st.contains("Hủy")) stClass = "status-huy";
                            }
                        %>
                        <span class="badge-status <%= stClass %>"><%= st %></span>
                    </div>
                </div>
            </div>

            <%-- Sản phẩm trong đơn --%>
            <div class="detail-card">
                <h3>Sản phẩm đã đặt</h3>
                <table class="detail-table">
                    <thead>
                        <tr>
                            <th>Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Size</th>
                            <th>Đơn giá</th>
                            <th>SL</th>
                            <th>Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (details != null) {
                            for (OrderDetail d : details) {
                                Product p = productMap != null ? productMap.get(d.getProductId()) : null;
                                double subTotal = d.getPrice() * d.getQuantity();
                        %>
                        <tr>
                            <td>
                                <% if (p != null) { %>
                                <img src="<%= p.getImage() %>" alt="<%= p.getName() %>">
                                <% } %>
                            </td>
                            <td><%= p != null ? p.getName() : "SP #" + d.getProductId() %></td>
                            <td><%= d.getSize() %></td>
                            <td class="price-red"><%= fmt.format((long) d.getPrice()) %>đ</td>
                            <td><%= d.getQuantity() %></td>
                            <td class="price-red"><%= fmt.format((long) subTotal) %>đ</td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
                <div class="order-total-row">
                    Tổng cộng: <span><%= fmt.format((long) order.getTotalMoney()) %>đ</span>
                </div>
            </div>

            <% } else { %>
            <%-- ========== TRANG DANH SÁCH ĐƠN HÀNG ========== --%>
            <a href="ProductServlet" class="btn-back">← Về trang chủ</a>
            <h2>📦 Đơn Hàng Của Tôi</h2>

            <% if (orders == null || orders.isEmpty()) { %>
            <div class="empty-order">
                📭 Bạn chưa có đơn hàng nào!<br>
                <a href="ProductServlet">Mua sắm ngay</a>
            </div>
            <% } else { %>
            <div class="order-list">
                <% for (Order o : orders) {
                    String st = o.getStatus();
                    String stClass = "status-cho";
                    if (st != null) {
                        if (st.contains("Đang")) stClass = "status-dang";
                        else if (st.contains("Hoàn")) stClass = "status-hoan";
                        else if (st.contains("Hủy")) stClass = "status-huy";
                    }
                %>
                <div class="order-card">
                    <div class="order-card-left">
                        <h3>
                            Đơn #<%= o.getId() %>
                            <span class="badge-status <%= stClass %>"><%= st %></span>
                        </h3>
                        <p>📅 <%= o.getCreatedAt() %></p>
                        <p>📍 <%= o.getCustomerAddress() %></p>
                        <p class="total"><%= fmt.format((long) o.getTotalMoney()) %>đ</p>
                    </div>
                    <a href="OrderServlet?action=detail&id=<%= o.getId() %>" class="btn-detail">
                        Xem chi tiết →
                    </a>
                </div>
                <% } %>
            </div>
            <% } %>
            <% } %>

        </div>

        <jsp:include page="Footer.jsp"/>

    </body>
</html>
