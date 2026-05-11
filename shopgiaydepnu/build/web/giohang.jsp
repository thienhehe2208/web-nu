<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Cart, model.CartItem, model.Product, model.User"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    List<CartItem> items      = (List<CartItem>) request.getAttribute("items");
    Map<Integer, Product> productMap = (Map<Integer, Product>) request.getAttribute("productMap");
    Double total              = (Double) request.getAttribute("total");
    String successMsg         = (String) request.getAttribute("successMsg");
    String orderError         = (String) request.getAttribute("orderError");

    if (items == null) items = new ArrayList<>();
    if (total  == null) total = 0.0;

    java.text.NumberFormat fmt = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Giỏ Hàng - TTQ SHOP</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="css/Style.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600&display=swap" rel="stylesheet">
        <style>
            .cart-wrapper {
                max-width: 900px;
                margin: 40px auto 60px auto;
                font-family: 'Poppins', sans-serif;
                padding: 0 16px;
            }
            .cart-wrapper h2 {
                font-size: 1.6rem; font-weight: 600; color: #222;
                margin-bottom: 24px;
                border-left: 4px solid #e74c3c; padding-left: 12px;
            }
            .msg-success {
                background: #eafaf1; border: 1.5px solid #2ecc71;
                color: #1a7a40; border-radius: 8px;
                padding: 14px 18px; margin-bottom: 20px; text-align: center;
            }
            .msg-error {
                background: #fdecea; border: 1.5px solid #e74c3c;
                color: #c0392b; border-radius: 8px;
                padding: 14px 18px; margin-bottom: 20px; text-align: center;
            }
            .msg-warning {
                background: #fef9e7; border: 1.5px solid #f9e79f;
                color: #b7770d; border-radius: 6px;
                padding: 6px 10px; margin-top: 6px;
                font-size: 0.82rem; display: inline-block;
            }
            /* Bảng giỏ hàng */
            .cart-table {
                width: 100%; border-collapse: collapse;
                background: #fff; border-radius: 12px;
                overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.07);
                margin-bottom: 32px;
            }
            .cart-table thead { background: #e74c3c; color: #fff; }
            .cart-table th {
                padding: 14px 16px; text-align: left;
                font-weight: 600; font-size: 0.9rem;
            }
            .cart-table td {
                padding: 14px 16px; border-bottom: 1px solid #f0f0f0;
                vertical-align: middle; font-size: 0.93rem; color: #333;
            }
            .cart-table tr:last-child td { border-bottom: none; }
            .cart-table img {
                width: 60px; height: 60px;
                object-fit: cover; border-radius: 8px;
            }
            .qty-form { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; }
            .qty-form input[type=number] {
                width: 56px; padding: 6px 8px;
                border: 1.5px solid #e0e0e0; border-radius: 6px;
                font-size: 0.93rem; text-align: center;
            }
            .btn-update {
                background: #3498db; color: #fff; border: none;
                padding: 6px 12px; border-radius: 6px;
                cursor: pointer; font-size: 0.82rem; font-weight: 600;
            }
            .btn-update:hover { background: #2176ae; }
            .btn-remove {
                background: #e74c3c; color: #fff; border: none;
                padding: 6px 12px; border-radius: 6px;
                cursor: pointer; font-size: 0.82rem; font-weight: 600;
                text-decoration: none; display: inline-block;
            }
            .btn-remove:hover { background: #c0392b; }
            .price-sale { color: #e74c3c; font-weight: 600; }
            /* Tồn kho inline */
            .stock-ok   { color: #2ecc71; font-size: 0.82rem; font-weight: 500; }
            .stock-low  { color: #e67e22; font-size: 0.82rem; font-weight: 500; }
            .stock-out  { color: #e74c3c; font-size: 0.82rem; font-weight: 600; }
            /* Tổng tiền */
            .cart-summary {
                text-align: right; font-size: 1.1rem;
                font-weight: 600; color: #222; margin-bottom: 32px;
            }
            .cart-summary span { color: #e74c3c; font-size: 1.3rem; }
            /* Form đặt hàng */
            .order-form {
                background: #fff; border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.07);
                padding: 32px 36px;
            }
            .order-form h3 {
                font-size: 1.2rem; font-weight: 600; color: #222;
                margin-bottom: 20px;
                border-left: 4px solid #e74c3c; padding-left: 10px;
            }
            .order-form .form-group { margin-bottom: 18px; }
            .order-form label {
                display: block; font-weight: 500;
                margin-bottom: 6px; color: #444; font-size: 0.93rem;
            }
            .order-form input {
                width: 100%; padding: 11px 14px;
                border: 1.5px solid #e0e0e0; border-radius: 8px;
                font-size: 0.95rem; font-family: 'Poppins', sans-serif;
                box-sizing: border-box; background: #fafafa;
                transition: border 0.2s;
            }
            .order-form input:focus { border-color: #e74c3c; outline: none; background: #fff; }
            .error-msg { color: #e74c3c; font-size: 0.84rem; margin-top: 4px; }
            .btn-order {
                width: 100%; padding: 14px;
                background: #e74c3c; color: #fff;
                border: none; border-radius: 8px;
                font-size: 1rem; font-weight: 600; cursor: pointer;
                margin-top: 8px; transition: background 0.2s, transform 0.1s;
            }
            .btn-order:hover { background: #c0392b; transform: translateY(-1px); }
            .empty-cart {
                text-align: center; padding: 60px 0;
                color: #aaa; font-size: 1.1rem;
            }
            .empty-cart a {
                display: inline-block; margin-top: 16px;
                background: #e74c3c; color: #fff;
                padding: 10px 28px; border-radius: 24px;
                text-decoration: none; font-weight: 600; font-size: 0.95rem;
            }
            .btn-back {
                display: inline-block; margin-bottom: 20px;
                color: #e74c3c; text-decoration: none;
                font-size: 0.93rem; font-weight: 500;
            }
            .btn-back:hover { text-decoration: underline; }
            /* Row hết hàng */
            tr.row-out-stock { background: #fafafa; opacity: 0.7; }
        </style>
    </head>
    <body>

        <jsp:include page="Header.jsp"/>
        <jsp:include page="menu.jsp"/>

        <div class="cart-wrapper">
            <a href="ProductServlet" class="btn-back">← Tiếp tục mua sắm</a>
            <h2>🛒 Giỏ Hàng Của Bạn</h2>

            <% if (successMsg != null) { %>
            <div class="msg-success"><%= successMsg %></div>
            <% } %>
            <% if (orderError != null) { %>
            <div class="msg-error"><%= orderError %></div>
            <% } %>

            <% if (items.isEmpty()) { %>
            <div class="empty-cart">
                🛒 Giỏ hàng của bạn đang trống!<br>
                <a href="ProductServlet">Mua sắm ngay</a>
            </div>
            <% } else { %>

            <table class="cart-table">
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Tên</th>
                        <th>Size</th>
                        <th>Đơn giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                        <th>Xóa</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (CartItem item : items) {
                        Product p = productMap != null ? productMap.get(item.getProductId()) : null;
                        double unitPrice = 0;
                        int stock = 0;
                        boolean outOfStock = false;
                        boolean lowStock   = false;
                        if (p != null) {
                            unitPrice = (p.getDiscountPrice() != null && p.getDiscountPrice() > 0)
                                    ? p.getDiscountPrice() : p.getPrice();
                            stock = p.getStock();
                            outOfStock = stock <= 0;
                            lowStock   = stock > 0 && stock <= 5;
                        }
                        double subTotal = unitPrice * item.getQuantity();
                    %>
                    <tr class="<%= outOfStock ? "row-out-stock" : "" %>">
                        <td>
                            <% if (p != null) { %>
                            <img src="<%= p.getImage() %>" alt="<%= p.getName() %>">
                            <% } %>
                        </td>
                        <td>
                            <%= p != null ? p.getName() : "Sản phẩm không tồn tại" %>
                            <br>
                            <% if (outOfStock) { %>
                            <span class="stock-out">⚠️ Hết hàng</span>
                            <% } else if (lowStock) { %>
                            <span class="stock-low">⚡ Chỉ còn <%= stock %> sản phẩm</span>
                            <% } else { %>
                            <span class="stock-ok">✔ Còn <%= stock %> sản phẩm</span>
                            <% } %>
                        </td>
                        <td><%= item.getSize() %></td>
                        <td class="price-sale"><%= fmt.format((long) unitPrice) %>đ</td>
                        <td>
                            <% if (!outOfStock) { %>
                            <form action="cart" method="post" class="qty-form">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="cartItemId" value="<%= item.getId() %>">
                                <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                                <input type="number" name="quantity"
                                       value="<%= item.getQuantity() %>"
                                       min="1" max="<%= stock %>">
                                <button type="submit" class="btn-update">Cập nhật</button>
                            </form>
                            <% if (item.getQuantity() > stock) { %>
                            <div class="msg-warning">⚠️ Vượt quá tồn kho, hãy cập nhật lại!</div>
                            <% } %>
                            <% } else { %>
                            <span style="color:#bbb"><%= item.getQuantity() %></span>
                            <% } %>
                        </td>
                        <td class="price-sale"><%= fmt.format((long) subTotal) %>đ</td>
                        <td>
                            <a href="cart?action=remove&cartItemId=<%= item.getId() %>"
                               onclick="return confirm('Xóa sản phẩm này khỏi giỏ hàng?')"
                               class="btn-remove">Xóa</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <div class="cart-summary">
                Tổng tiền: <span><%= fmt.format(total.longValue()) %>đ</span>
            </div>

            <%-- Form đặt hàng --%>
            <div class="order-form">
                <h3>📦 Thông Tin Đặt Hàng</h3>
                <form action="cart" method="post">
                    <input type="hidden" name="action" value="order">

                    <div class="form-group">
                        <label>Họ và tên <span style="color:#e74c3c">*</span></label>
                        <input type="text" name="customerName" maxlength="100"
                               value="<%= loggedUser != null ? loggedUser.getAccountName() : "" %>"
                               placeholder="Nhập họ tên người nhận" required>
                        <% if (request.getAttribute("nameError") != null) { %>
                        <div class="error-msg"><%= request.getAttribute("nameError") %></div>
                        <% } %>
                    </div>

                    <div class="form-group">
                        <label>Số điện thoại <span style="color:#e74c3c">*</span></label>
                        <input type="text" name="customerPhone" maxlength="11"
                               placeholder="0xxx xxx xxx" required>
                        <% if (request.getAttribute("phoneError") != null) { %>
                        <div class="error-msg"><%= request.getAttribute("phoneError") %></div>
                        <% } %>
                    </div>

                    <div class="form-group">
                        <label>Địa chỉ giao hàng <span style="color:#e74c3c">*</span></label>
                        <input type="text" name="customerAddress" maxlength="255"
                               placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành" required>
                        <% if (request.getAttribute("addressError") != null) { %>
                        <div class="error-msg"><%= request.getAttribute("addressError") %></div>
                        <% } %>
                    </div>

                    <button type="submit" class="btn-order">
                        🛍️ Đặt Hàng (<%= fmt.format(total.longValue()) %>đ)
                    </button>
                </form>
            </div>

            <% } %>
        </div>

        <jsp:include page="Footer.jsp"/>

    </body>
</html>
