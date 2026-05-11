<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Product, model.Category, model.User"%>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    Product p = (Product) request.getAttribute("product");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    boolean isEdit = (p != null);
    List<String> existingSizes = (p != null && p.getSizes() != null) ? p.getSizes() : new ArrayList<>();
    String[] allSizes = {"34","35","36","37","38","39","40","41","42"};
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= isEdit ? "Sửa" : "Thêm" %> sản phẩm - TTQ ADMIN</title>
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
        .form-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.06); padding: 32px; max-width: 700px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: 500; font-size: 0.92rem; color: #444; margin-bottom: 6px; }
        .form-group input[type=text],
        .form-group input[type=number],
        .form-group select,
        .form-group textarea {
            width: 100%; padding: 10px 14px; border: 1.5px solid #e0e0e0;
            border-radius: 8px; font-size: 0.93rem; font-family: 'Poppins', sans-serif;
            background: #fafafa; transition: border 0.2s;
        }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color: #e74c3c; outline: none; background: #fff; }
        .form-group textarea { min-height: 100px; resize: vertical; }
        .checkbox-group { display: flex; gap: 20px; align-items: center; }
        .checkbox-group label { display: flex; align-items: center; gap: 6px; font-weight: 400; cursor: pointer; }
        .sizes-grid { display: flex; gap: 10px; flex-wrap: wrap; }
        .size-item { display: flex; align-items: center; gap: 4px; }
        .size-item input { width: auto; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .btn-save { background: #e74c3c; color: #fff; border: none; padding: 12px 32px; border-radius: 8px; font-size: 0.97rem; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        .btn-save:hover { background: #c0392b; }
        .btn-cancel { display: inline-block; margin-left: 12px; color: #888; text-decoration: none; font-size: 0.93rem; }
        .btn-cancel:hover { color: #444; }
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
        <h1><%= isEdit ? "Sửa sản phẩm" : "Thêm sản phẩm mới" %></h1>
    </div>
    <div class="content">
        <div class="form-card">
            <form action="${pageContext.request.contextPath}/admin/<%= isEdit ? "product-edit" : "product-add" %>" method="post">
                <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= p.getId() %>">
                <% } %>

                <div class="form-row">
                    <div class="form-group">
                        <label>Tên sản phẩm *</label>
                        <input type="text" name="name" value="<%= isEdit ? p.getName() : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label>SKU *</label>
                        <input type="text" name="sku" value="<%= isEdit ? p.getSku() : "" %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Danh mục *</label>
                    <select name="categoryId" required>
                        <option value="">-- Chọn danh mục --</option>
                        <% if (categories != null) for (Category c : categories) { %>
                        <option value="<%= c.getId() %>" <%= isEdit && p.getCategoryId() == c.getId() ? "selected" : "" %>><%= c.getName() %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Giá gốc (đ) *</label>
                        <input type="number" name="price" value="<%= isEdit ? (long)p.getPrice() : "" %>" min="0" required>
                    </div>
                    <div class="form-group">
                        <label>Giá sale (đ) — để trống nếu không giảm</label>
                        <input type="number" name="discountPrice"
                               value="<%= isEdit && p.getDiscountPrice() != null ? p.getDiscountPrice().longValue() : "" %>" min="0">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Tồn kho *</label>
                        <input type="number" name="stock" value="<%= isEdit ? p.getStock() : 0 %>" min="0" required>
                    </div>
                    <div class="form-group">
                        <label>Đường dẫn ảnh *</label>
                        <input type="text" name="image" value="<%= isEdit ? p.getImage() : "" %>" placeholder="img/ten-anh.jpg" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Mô tả</label>
                    <textarea name="description"><%= isEdit && p.getDescription() != null ? p.getDescription() : "" %></textarea>
                </div>

                <div class="form-group">
                    <label>Size có sẵn</label>
                    <div class="sizes-grid">
                        <% for (String size : allSizes) {
                            boolean checked = existingSizes.contains(size);
                        %>
                        <div class="size-item">
                            <input type="checkbox" name="sizes" value="<%= size %>" id="size_<%= size %>" <%= checked ? "checked" : "" %>>
                            <label for="size_<%= size %>"><%= size %></label>
                        </div>
                        <% } %>
                    </div>
                </div>

                <div class="form-group">
                    <label>Nhãn</label>
                    <div class="checkbox-group">
                        <label>
                            <input type="checkbox" name="isNew" <%= isEdit && p.isIsNew() ? "checked" : "" %>>
                            Hàng mới
                        </label>
                        <label>
                            <input type="checkbox" name="isBestseller" <%= isEdit && p.isIsBestseller() ? "checked" : "" %>>
                            Bán chạy
                        </label>
                    </div>
                </div>

                <button type="submit" class="btn-save"><%= isEdit ? "Lưu thay đổi" : "Thêm sản phẩm" %></button>
                <a href="${pageContext.request.contextPath}/admin/products" class="btn-cancel">Hủy</a>
            </form>
        </div>
    </div>
</div>
</body>
</html>
