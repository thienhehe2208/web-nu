<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Liên Hệ - TTQ SHOP</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="css/Style.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600&display=swap" rel="stylesheet">
        
    </head>
    <body>

        <jsp:include page="Header.jsp"/>
        <jsp:include page="menu.jsp"/>

        <div class="contact-wrapper">
            <h2>HÃY ĐỂ LẠI GÓP Ý CHO CHÚNG TÔI</h2>
            <p class="subtitle">TTQ SHOP sẽ phản hồi bạn sớm nhất!</p>

            <%-- Hiển thị thông báo thành công / thất bại --%>
            <%
                String successMsg = (String) request.getAttribute("successMsg");
                String errorMsg   = (String) request.getAttribute("errorMsg");
                if (successMsg != null) {
            %>
            <div class="success-box">✅ <%= successMsg %></div>
            <% } %>
            <% if (errorMsg != null) { %>
            <div class="error-box">❌ <%= errorMsg %></div>
            <% } %>

            <%-- Giữ lại dữ liệu đã nhập nếu có lỗi --%>
            <%
                String oldName    = request.getAttribute("oldName")    != null ? (String) request.getAttribute("oldName")    : "";
                String oldEmail   = request.getAttribute("oldEmail")   != null ? (String) request.getAttribute("oldEmail")   : "";
                String oldPhone   = request.getAttribute("oldPhone")   != null ? (String) request.getAttribute("oldPhone")   : "";
                String oldMessage = request.getAttribute("oldMessage") != null ? (String) request.getAttribute("oldMessage") : "";
            %>

            <form action="ContactServlet" method="post" novalidate>
                <div class="form-group">
                    <label>Họ và tên <span style="color:#e74c3c">*</span></label>
                    <input type="text" name="name" maxlength="100"
                           value="<%= oldName %>"
                           placeholder="Nhập họ tên của bạn" required>
                    <% if (request.getAttribute("nameError") != null) { %>
                    <div class="error-msg"><%= request.getAttribute("nameError") %></div>
                    <% } %>
                </div>

                <div class="form-group">
                    <label>Email <span style="color:#e74c3c">*</span></label>
                    <input type="email" name="email" maxlength="150"
                           value="<%= oldEmail %>"
                           placeholder="example@email.com" required>
                    <% if (request.getAttribute("emailError") != null) { %>
                    <div class="error-msg"><%= request.getAttribute("emailError") %></div>
                    <% } %>
                </div>

                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" maxlength="15"
                           value="<%= oldPhone %>"
                           placeholder="0xxx xxx xxx (không bắt buộc)">
                    <% if (request.getAttribute("phoneError") != null) { %>
                    <div class="error-msg"><%= request.getAttribute("phoneError") %></div>
                    <% } %>
                </div>

                <div class="form-group">
                    <label>Nội dung góp ý <span style="color:#e74c3c">*</span></label>
                    <textarea name="message" maxlength="1000"
                              placeholder="Nhập nội dung bạn muốn góp ý hoặc hỏi..." required><%= oldMessage %></textarea>
                    <% if (request.getAttribute("messageError") != null) { %>
                    <div class="error-msg"><%= request.getAttribute("messageError") %></div>
                    <% } %>
                </div>

                <button type="submit" class="btn-submit">GỬI</button>
            </form>

            <a href="ProductServlet" class="btn-back">← Quay về trang chủ</a>

            <div class="contact-info">
                <span>📧 ttqshop@gmail.com</span>
                <span>📞 0357 349 545</span>
                <span>📍 Số 999 đường Manchester United, Hà Nội</span>
            </div>
        </div>

        <jsp:include page="Footer.jsp"/>

    </body>
</html>
