<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Product"%>
<%
    Product product = (Product) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect("ProductServlet");
        return;
    }

    java.text.NumberFormat fmt = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));

    double displayPrice = (product.getDiscountPrice() != null && product.getDiscountPrice() > 0)
            ? product.getDiscountPrice() : product.getPrice();

    int stock = product.getStock();
    boolean outOfStock = stock <= 0;
    boolean lowStock   = stock > 0 && stock <= 5;
%>
<!DOCTYPE html>
<html>
    <head>
        <title><%= product.getName() %> - TTQ SHOP</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="css/Style.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600&display=swap" rel="stylesheet">
        <style>
            .detail-wrapper {
                max-width: 960px;
                margin: 40px auto 60px auto;
                padding: 0 20px;
                font-family: 'Poppins', sans-serif;
            }
            .btn-back {
                display: inline-block;
                margin-bottom: 20px;
                color: #e74c3c;
                text-decoration: none;
                font-size: 0.93rem;
                font-weight: 500;
            }
            .btn-back:hover { text-decoration: underline; }

            .detail-card {
                display: flex;
                gap: 48px;
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 6px 28px rgba(0,0,0,0.09);
                padding: 40px;
                align-items: flex-start;
            }
            /* Ảnh */
            .detail-img {
                flex: 0 0 340px;
                position: relative;
            }
            .detail-img img {
                width: 100%;
                border-radius: 12px;
                object-fit: cover;
            }
            .badge-wrap {
                position: absolute;
                top: 12px; left: 12px;
                display: flex; flex-direction: column; gap: 6px;
            }
            .badge-new {
                background: #2ecc71; color: #fff;
                padding: 4px 10px; border-radius: 20px;
                font-size: 0.78rem; font-weight: 700;
            }
            .badge-hot {
                background: #e67e22; color: #fff;
                padding: 4px 10px; border-radius: 20px;
                font-size: 0.78rem; font-weight: 700;
            }
            .badge-out {
                background: #95a5a6; color: #fff;
                padding: 4px 10px; border-radius: 20px;
                font-size: 0.78rem; font-weight: 700;
            }

            /* Thông tin */
            .detail-info { flex: 1; }
            .detail-info h1 {
                font-size: 1.6rem;
                font-weight: 700;
                color: #1a1a1a;
                margin-bottom: 10px;
                line-height: 1.3;
            }
            .detail-sku {
                color: #aaa; font-size: 0.85rem; margin-bottom: 16px;
            }

            /* Giá */
            .price-block { margin-bottom: 20px; }
            .price-original {
                color: #bbb; font-size: 1rem;
                text-decoration: line-through; margin-bottom: 2px;
            }
            .price-sale {
                color: #e74c3c; font-size: 1.8rem; font-weight: 700;
            }
            .price-normal {
                color: #e74c3c; font-size: 1.8rem; font-weight: 700;
            }

            /* Tồn kho */
            .stock-block {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 22px;
                padding: 12px 16px;
                border-radius: 10px;
                font-size: 0.93rem;
                font-weight: 500;
            }
            .stock-block.in-stock {
                background: #eafaf1;
                color: #1a7a40;
                border: 1.5px solid #a9dfbf;
            }
            .stock-block.low-stock {
                background: #fef9e7;
                color: #b7770d;
                border: 1.5px solid #f9e79f;
            }
            .stock-block.out-stock {
                background: #f8f9fa;
                color: #95a5a6;
                border: 1.5px solid #dce1e4;
            }
            .stock-dot {
                width: 10px; height: 10px;
                border-radius: 50%;
                flex-shrink: 0;
            }
            .in-stock  .stock-dot { background: #2ecc71; }
            .low-stock .stock-dot { background: #f1c40f; }
            .out-stock .stock-dot { background: #bdc3c7; }

            /* Mô tả */
            .detail-desc {
                color: #555; font-size: 0.93rem;
                line-height: 1.7; margin-bottom: 24px;
                border-top: 1px solid #f0f0f0;
                padding-top: 18px;
            }

            /* Form thêm giỏ */
            .add-form label {
                display: block;
                font-weight: 500; font-size: 0.92rem;
                color: #444; margin-bottom: 6px;
            }
            .add-form select,
            .add-form input[type=number] {
                padding: 10px 14px;
                border: 1.5px solid #e0e0e0;
                border-radius: 8px;
                font-size: 0.93rem;
                font-family: 'Poppins', sans-serif;
                background: #fafafa;
                margin-bottom: 16px;
                width: 180px;
            }
            .add-form select:focus,
            .add-form input:focus {
                border-color: #e74c3c; outline: none; background: #fff;
            }
            .btn-add-cart {
                display: inline-flex;
                align-items: center; gap: 8px;
                background: #e74c3c; color: #fff;
                border: none; padding: 13px 32px;
                border-radius: 8px; font-size: 1rem;
                font-weight: 600; cursor: pointer;
                transition: background 0.2s, transform 0.1s;
                margin-top: 4px;
            }
            .btn-add-cart:hover {
                background: #c0392b; transform: translateY(-1px);
            }
            .btn-add-cart:disabled {
                background: #bdc3c7; cursor: not-allowed;
                transform: none;
            }
            .out-of-stock-msg {
                display: inline-block;
                background: #f0f0f0; color: #999;
                padding: 13px 32px; border-radius: 8px;
                font-size: 1rem; font-weight: 600; margin-top: 4px;
            }

            @media (max-width: 700px) {
                .detail-card { flex-direction: column; gap: 24px; padding: 24px; }
                .detail-img { flex: none; width: 100%; }
            }
        </style>
    </head>
    <body>

        <jsp:include page="Header.jsp"/>
        <jsp:include page="menu.jsp"/>

        <div class="detail-wrapper">
            <a href="javascript:history.back()" class="btn-back">← Quay lại</a>

            <div class="detail-card">

                <%-- Ảnh sản phẩm --%>
                <div class="detail-img">
                    <img src="<%= product.getImage() %>" alt="<%= product.getName() %>">
                    <div class="badge-wrap">
                        <% if (product.isIsNew()) { %>
                        <span class="badge-new">MỚI</span>
                        <% } %>
                        <% if (product.isIsBestseller()) { %>
                        <span class="badge-hot">🔥 HOT</span>
                        <% } %>
                        <% if (outOfStock) { %>
                        <span class="badge-out">Hết hàng</span>
                        <% } %>
                    </div>
                </div>

                <%-- Thông tin --%>
                <div class="detail-info">
                    <h1><%= product.getName() %></h1>
                    <div class="detail-sku">Mã SP: <%= product.getSku() %></div>

                    <%-- Giá --%>
                    <div class="price-block">
                        <% if (product.getDiscountPrice() != null && product.getDiscountPrice() > 0) { %>
                        <div class="price-original"><%= fmt.format((long) product.getPrice()) %>đ</div>
                        <div class="price-sale"><%= fmt.format(product.getDiscountPrice().longValue()) %>đ</div>
                        <% } else { %>
                        <div class="price-normal"><%= fmt.format((long) product.getPrice()) %>đ</div>
                        <% } %>
                    </div>

                    <%-- Tồn kho --%>
                    <% if (outOfStock) { %>
                    <div class="stock-block out-stock">
                        <span class="stock-dot"></span>
                        Hết hàng — Sản phẩm tạm thời không có sẵn
                    </div>
                    <% } else if (lowStock) { %>
                    <div class="stock-block low-stock">
                        <span class="stock-dot"></span>
                        Sắp hết hàng — Chỉ còn <strong><%= stock %></strong> sản phẩm
                    </div>
                    <% } else { %>
                    <div class="stock-block in-stock">
                        <span class="stock-dot"></span>
                        Còn hàng — <strong><%= stock %></strong> sản phẩm có sẵn
                    </div>
                    <% } %>

                    <%-- Mô tả --%>
                    <% if (product.getDescription() != null && !product.getDescription().isEmpty()) { %>
                    <div class="detail-desc"><%= product.getDescription() %></div>
                    <% } %>

                    <%-- Form thêm giỏ --%>
                    <% if (!outOfStock) { %>
                    <form action="cart" method="post" class="add-form">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="productId" value="<%= product.getId() %>">

                        <label>Chọn Size:</label>
                        <select name="size" required>
                            <option value="">-- Chọn size --</option>
                            <% if (product.getSizes() != null) {
                                for (String s : product.getSizes()) { %>
                            <option value="<%= s %>"><%= s %></option>
                            <% } } %>
                        </select>

                        <label>Số lượng:</label>
                        <input type="number" name="quantity" value="1"
                               min="1" max="<%= stock %>" required>

                        <br>
                        <button type="submit" class="btn-add-cart">
                            🛒 Thêm vào giỏ hàng
                        </button>
                    </form>
                    <% } else { %>
                    <div class="out-of-stock-msg">😔 Sản phẩm tạm hết hàng</div>
                    <% } %>
                </div>

            </div>
        </div>

        <jsp:include page="Footer.jsp"/>

    </body>
</html>
