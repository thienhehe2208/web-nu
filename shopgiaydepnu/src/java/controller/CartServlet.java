/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import model.CartDAO;
import model.OrderDAO;
import java.io.IOException;
import java.util.*;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;

public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        switch (action) {
            case "remove":
                doRemove(request, response);
                break;
            default:
                doView(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "add":
                doAdd(request, response);
                break;
            case "update":
                doUpdate(request, response);
                break;
            case "order":
                doOrder(request, response);
                break;
            default:
                response.sendRedirect("cart");
        }
    }

    // Hiển thị giỏ hàng
    private void doView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null) {
            response.sendRedirect("UserServlet?action=login");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.getOrCreateCart(loggedUser.getId());
        List<CartItem> items = cartDAO.getItemsByCartId(cart.getId());

        Map<Integer, Product> productMap = new LinkedHashMap<>();
        for (CartItem item : items) {
            if (!productMap.containsKey(item.getProductId())) {
                productMap.put(item.getProductId(), cartDAO.getProductById(item.getProductId()));
            }
        }

        // Tính tổng tiền
        double total = 0;
        for (CartItem item : items) {
            Product p = productMap.get(item.getProductId());
            if (p != null) {
                double price = (p.getDiscountPrice() != null && p.getDiscountPrice() > 0)
                        ? p.getDiscountPrice() : p.getPrice();
                total += price * item.getQuantity();
            }
        }

        request.setAttribute("cart", cart);
        request.setAttribute("items", items);
        request.setAttribute("productMap", productMap);
        request.setAttribute("total", total);
        request.getRequestDispatcher("giohang.jsp").forward(request, response);
    }

    // Thêm sản phẩm vào giỏ — có kiểm tra stock
    private void doAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null) {
            response.sendRedirect("UserServlet?action=login");
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String size = request.getParameter("size");

            CartDAO cartDAO = new CartDAO();

            // Kiểm tra stock trước khi thêm
            int stock = cartDAO.checkStock(productId);
            if (stock <= 0) {
                // Hết hàng → quay lại trang chi tiết với thông báo
                response.sendRedirect("ProductServlet?action=detail&id=" + productId + "&error=outofstock");
                return;
            }
            if (quantity > stock) {
                response.sendRedirect("ProductServlet?action=detail&id=" + productId + "&error=exceed&max=" + stock);
                return;
            }

            Cart cart = cartDAO.getOrCreateCart(loggedUser.getId());
            cartDAO.addItem(cart.getId(), productId, quantity, size);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("cart");
    }

    // Cập nhật số lượng — có kiểm tra stock
    private void doUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null) {
            response.sendRedirect("UserServlet?action=login");
            return;
        }

        try {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int productId = Integer.parseInt(request.getParameter("productId"));

            CartDAO cartDAO = new CartDAO();
            int stock = cartDAO.checkStock(productId);

            if (quantity > stock) {
                // Vượt stock → tự động set bằng stock tối đa
                quantity = stock;
            }
            cartDAO.updateQuantity(cartItemId, quantity);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("cart");
    }

    // Xóa item khỏi giỏ
    private void doRemove(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null) {
            response.sendRedirect("UserServlet?action=login");
            return;
        }

        try {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            CartDAO cartDAO = new CartDAO();
            cartDAO.removeItem(cartItemId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("cart");
    }

    // Đặt hàng — kiểm tra stock toàn bộ trước khi tạo order
    private void doOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null) {
            response.sendRedirect("UserServlet?action=login");
            return;
        }

        String customerName = request.getParameter("customerName") != null ? request.getParameter("customerName").trim() : "";
        String customerPhone = request.getParameter("customerPhone") != null ? request.getParameter("customerPhone").trim() : "";
        String customerAddress = request.getParameter("customerAddress") != null ? request.getParameter("customerAddress").trim() : "";

        // Validate thông tin giao hàng
        boolean hasError = false;
        if (customerName.isEmpty()) {
            request.setAttribute("nameError", "Vui lòng nhập họ tên.");
            hasError = true;
        }
        if (customerPhone.isEmpty() || !customerPhone.matches("^[0-9]{9,11}$")) {
            request.setAttribute("phoneError", "Số điện thoại không hợp lệ.");
            hasError = true;
        }
        if (customerAddress.isEmpty()) {
            request.setAttribute("addressError", "Vui lòng nhập địa chỉ.");
            hasError = true;
        }

        if (hasError) {
            request.setAttribute("orderError", "Vui lòng kiểm tra lại thông tin.");
            doView(request, response);
            return;
        }

        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.getOrCreateCart(loggedUser.getId());
        List<CartItem> items = cartDAO.getItemsByCartId(cart.getId());

        if (items.isEmpty()) {
            request.setAttribute("orderError", "Giỏ hàng đang trống, không thể đặt hàng.");
            doView(request, response);
            return;
        }

        // Kiểm tra stock toàn bộ sản phẩm trong giỏ trước khi đặt
        for (CartItem item : items) {
            int stock = cartDAO.checkStock(item.getProductId());
            if (stock <= 0) {
                Product p = cartDAO.getProductById(item.getProductId());
                String pName = p != null ? p.getName() : "Sản phẩm #" + item.getProductId();
                request.setAttribute("orderError", "Sản phẩm \"" + pName + "\" đã hết hàng. Vui lòng xóa khỏi giỏ trước khi đặt hàng.");
                doView(request, response);
                return;
            }
            if (item.getQuantity() > stock) {
                Product p = cartDAO.getProductById(item.getProductId());
                String pName = p != null ? p.getName() : "Sản phẩm #" + item.getProductId();
                request.setAttribute("orderError", "Sản phẩm \"" + pName + "\" chỉ còn " + stock + " cái. Vui lòng cập nhật lại số lượng.");
                doView(request, response);
                return;
            }
        }

        // Tính tổng tiền & tạo OrderDetail
        double total = 0;
        List<OrderDetail> details = new ArrayList<>();
        for (CartItem item : items) {
            Product p = cartDAO.getProductById(item.getProductId());
            if (p != null) {
                double price = (p.getDiscountPrice() != null && p.getDiscountPrice() > 0)
                        ? p.getDiscountPrice() : p.getPrice();
                total += price * item.getQuantity();
                details.add(new OrderDetail(0, 0, item.getProductId(), price, item.getQuantity(), item.getSize()));
            }
        }

        // Tạo Order
        Order order = new Order(0, loggedUser.getId(), customerName, customerPhone, customerAddress, total, "Chờ xác nhận", null);
        OrderDAO orderDAO = new OrderDAO();
        int orderId = orderDAO.createOrder(order);

        if (orderId > 0) {
            for (OrderDetail d : details) {
                d.setOrderId(orderId);
            }
            // saveOrderDetails đã tự trừ stock bên trong
            orderDAO.saveOrderDetails(details);
            cartDAO.clearCart(cart.getId());
            request.setAttribute("successMsg", "🎉 Đặt hàng thành công! Mã đơn hàng: #" + orderId);
        } else {
            request.setAttribute("orderError", "Có lỗi xảy ra, vui lòng thử lại.");
        }

        doView(request, response);
    }
}
