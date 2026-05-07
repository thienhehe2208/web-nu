<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Liên Hệ - TTQ SHOP</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="css/Style.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600&display=swap" rel="stylesheet">
        <style>
            .contact-wrapper {
                max-width: 700px;
                margin: 60px auto;
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 8px 32px rgba(0,0,0,0.10);
                padding: 48px 48px 40px 48px;
                font-family: 'Poppins', sans-serif;
            }
            .contact-wrapper h2 {
                text-align: center;
                font-size: 1.8rem;
                font-weight: 600;
                color: #222;
                margin-bottom: 8px;
                letter-spacing: 0.5px;
            }
            .contact-wrapper p.subtitle {
                text-align: center;
                color: #888;
                margin-bottom: 32px;
                font-size: 0.97rem;
            }
            .contact-wrapper .form-group {
                margin-bottom: 20px;
            }
            .contact-wrapper label {
                display: block;
                font-weight: 500;
                margin-bottom: 6px;
                color: #444;
                font-size: 0.95rem;
            }
            .contact-wrapper input,
            .contact-wrapper textarea {
                width: 100%;
                padding: 12px 14px;
                border: 1.5px solid #e0e0e0;
                border-radius: 8px;
                font-size: 0.97rem;
                font-family: 'Poppins', sans-serif;
                transition: border 0.2s;
                box-sizing: border-box;
                background: #fafafa;
                color: #222;
            }
            .contact-wrapper input:focus,
            .contact-wrapper textarea:focus {
                border-color: #e74c3c;
                outline: none;
                background: #fff;
            }
            .contact-wrapper textarea {
                min-height: 130px;
                resize: vertical;
            }
            .contact-wrapper .error-msg {
                color: #e74c3c;
                font-size: 0.85rem;
                margin-top: 4px;
            }
            .contact-wrapper .btn-submit {
                width: 100%;
                padding: 14px;
                background: #e74c3c;
                color: #fff;
                border: none;
                border-radius: 8px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                letter-spacing: 0.5px;
                transition: background 0.2s, transform 0.1s;
                margin-top: 8px;
            }
            .contact-wrapper .btn-submit:hover {
                background: #c0392b;
                transform: translateY(-1px);
            }
            .contact-wrapper .btn-back {
                display: block;
                text-align: center;
                margin-top: 18px;
                color: #e74c3c;
                text-decoration: none;
                font-size: 0.93rem;
                font-weight: 500;
            }
            .contact-wrapper .btn-back:hover {
                text-decoration: underline;
            }
            .contact-info {
                margin-top: 36px;
                border-top: 1px solid #f0f0f0;
                padding-top: 24px;
                display: flex;
                justify-content: center;
                gap: 32px;
                flex-wrap: wrap;
                color: #666;
                font-size: 0.9rem;
            }
            .contact-info span {
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .success-box {
                background: #eafaf1;
                border: 1.5px solid #2ecc71;
                color: #1a7a40;
                border-radius: 8px;
                padding: 14px 18px;
                margin-bottom: 20px;
                font-size: 0.97rem;
                text-align: center;
            }
            .error-box {
                background: #fdecea;
                border: 1.5px solid #e74c3c;
                color: #c0392b;
                border-radius: 8px;
                padding: 14px 18px;
                margin-bottom: 20px;
                font-size: 0.97rem;
                text-align: center;
            }
        </style>
    </head>
    <body>

        <jsp:include page="Header.jsp"/>
        <jsp:include page="menu.jsp"/>

        <div class="contact-wrapper">
            <h2>💬 Góp Ý & Liên Hệ</h2>
            <p class="subtitle">Hãy để lại thông tin, TTQ SHOP sẽ phản hồi bạn sớm nhất!</p>

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

                <button type="submit" class="btn-submit">📨 Gửi Góp Ý</button>
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
