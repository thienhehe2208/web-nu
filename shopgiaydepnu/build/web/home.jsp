<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, model.Product, model.Category"%>
<%
    List<Product> allProducts = (List<Product>) request.getAttribute("allProducts");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String pageTitle = (String) request.getAttribute("pageTitle");
    String keyword = (String) request.getAttribute("keyword");
    Integer selectedCategory = (Integer) request.getAttribute("selectedCategoryId");
    String action = request.getParameter("action"); // lấy action từ URL

    if (pageTitle == null) {
        pageTitle = "🛍️ tất Cả Sản Phẩm";
    }

    java.text.NumberFormat fmt = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
%>
<!DOCTYPE html>
<html>
    <head>
        <title>TTQ SHOP</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="css/Style.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
        <!-- Font mới (menu/submenu đẹp hơn) -->
        <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600&display=swap" rel="stylesheet">
    </head>
    <body>

        <jsp:include page="Header.jsp"/>

        <!-- BANNER -->
        <div class="banner">
            <button onclick="prevSlide()" class="btn-left">❮</button>
            <img id="bannerImg" src="img/banners1.png">
            <button onclick="nextSlide()" class="btn-right">❯</button>
        </div>

        
        <div style="
             display: flex;
             justify-content: flex-end;
             padding: 12px 32px 4px 32px;
             ">
            
        </div>
        
        <jsp:include page="menu.jsp"/>

        <!-- DANH SÁCH SẢN PHẨM -->
        <h2 class="section-title"><%= pageTitle%></h2>
        <div class="products">
            <%
                if (allProducts == null || allProducts.isEmpty()) {
            %>
            <p class="no-result">Không có sản phẩm nào!</p>
            <%
            } else {
                for (Product p : allProducts) {
                    String pName = p.getName().replace("'", "\\'");
            %>
            <div class="product">
                <img src="<%= p.getImage()%>" width="100%">
                <% if (p.isIsNew()) { %><span class="badge-new">MỚI</span><% } %>
                <% if (p.isIsBestseller()) { %><span class="badge-hot">🔥 HOT</span><% }%>
                <h3><%= p.getName()%></h3>
                <% if (p.getDiscountPrice() != null && p.getDiscountPrice() > 0) {%>
                <p class="price-original"><del><%= fmt.format((long) p.getPrice())%>đ</del></p>
                <p class="price-sale"><%= fmt.format(p.getDiscountPrice().longValue())%>đ</p>
                <% } else {%>
                <p class="price"><%= fmt.format((long) p.getPrice())%>đ</p>
                <% }%>
                <div class="product-actions">

    <a href="ProductServlet?action=detail&id=<%= p.getId()%>" class="info-btn">
        <img src="img/thongtinsp.png">
        Thông Tin
    </a>

    <button class="add-cart-btn"
            onclick="openModal(<%= p.getId()%>, '<%= pName%>')">
        <img src="img/them.png">
        Thêm vào giỏ
    </button>

</div>
            </div>
            <%
                    }
                }
            %>
        </div>

        <!-- CHATBOT -->
        <div class="chatbot">

    <div class="chat-icon" onclick="toggleChat()">
        <img src="img/chatbot.png">
    </div>

    <div class="chat-box" id="chatBox">

        <div class="chat-header">
            <img src="img/logo.png">

            <div>
                <h4>TTQ SHOP</h4>
                <span>Hỗ trợ khách hàng 24/7</span>
            </div>
        </div>

        <div class="chat-content">

            <div class="message bot-message">
                Xin chào 👋 TTQ SHOP có thể giúp gì cho bạn?
            </div>
            
        </div>

        <div class="chat-footer">
            <input type="text"
                   class="chat-input"
                   placeholder="Nhập tin nhắn...">

            <button class="send-btn">
                ➤
            </button>
        </div>

    </div>

</div>
        <!-- FLOATING CONTACT BUTTON -->
            <div class="floating-contact">
                 <a href="ContactServlet">
                 <img src="img/contact.png" >
                 </a>
            </div>

        <!-- MODAL THÊM GIỎ HÀNG -->
        <div id="cartModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h2 id="productName">Chọn sản phẩm</h2>
                <form action="cart" method="post">
                    <input type="hidden" name="productId" id="productId">
                    <label>Size:</label><br><br>
                    <select name="size" required>
                        <option value="">-- Chọn size --</option>
                        <option value="34">34</option>
                        <option value="35">35</option>
                        <option value="36">36</option>
                        <option value="37">37</option>
                        <option value="38">38</option>
                        <option value="39">39</option>
                        <option value="40">40</option>
                        <option value="41">41</option>
                        <option value="42">42</option>
                    </select>
                    <br><br>
                    <label>Số lượng:</label>
                    <input type="number" name="quantity" value="1" min="1" required>
                    <br><br>
                    <button type="submit">Thêm vào giỏ</button>
                    <button type="button" onclick="closeModal()">Hủy</button>
                </form>
            </div>
        </div>

        <!-- CONTACT MODAL -->
        <div id="contactModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeContact()">&times;</span>
                <h2>MỌI THẮC MẮC QUÝ KHÁCH VUI LÒNG LIÊN HỆ</h2>
                <p>📧 Email: ttqshop@gmail.com</p>
                <p>📞 SĐT: 0357 349 545</p>
                <p>📍 Địa chỉ: TTQ SHOP - Số 999 đường Manchester United, Hà Nội, Việt Nam</p>
                <p>❤️ TTQ SHOP XIN CHÂN THÀNH CẢM ƠN!</p>
                <button onclick="closeContact()">Đóng</button>
            </div>
        </div>

        <!-- SCRIPT -->
        <script>
            let images = ["img/banners1.png", "img/banners2.png", "img/banners3.png", "img/banners4.png"];
            let index = 0;
            function showSlide() {
                let img = document.getElementById("bannerImg");
                img.classList.remove("fade");
                void img.offsetWidth;
                img.classList.add("fade");
                img.src = images[index];
            }
            function nextSlide() {
                index = (index + 1) % images.length;
                showSlide();
            }
            function prevSlide() {
                index = (index - 1 + images.length) % images.length;
                showSlide();
            }
            setInterval(nextSlide, 3000);

            function toggleChat() {
                let box = document.getElementById("chatBox");
                box.style.display = box.style.display === "block" ? "none" : "block";
            }
            function openModal(id, name) {
                document.getElementById("cartModal").style.display = "block";
                document.getElementById("productId").value = id;
                document.getElementById("productName").innerText = name;
            }
            function closeModal() {
                document.getElementById("cartModal").style.display = "none";
            }
            function openContact() {
                document.getElementById("contactModal").style.display = "block";
            }
            function closeContact() {
                document.getElementById("contactModal").style.display = "none";
            }
        </script>

        <jsp:include page="Footer.jsp"/>

    </body>
</html>
