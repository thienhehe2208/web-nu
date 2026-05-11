/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import model.OrderDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderDetail;
import model.User;
 

public class OrderServlet extends HttpServlet {
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
 
        // Kiểm tra đăng nhập
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null) {
            response.sendRedirect("UserServlet?action=login");
            return;
        }
 
        String action = request.getParameter("action");
        if (action == null) action = "list";
 
        OrderDAO orderDAO = new OrderDAO();
 
        switch (action) {
 
            // Danh sách đơn hàng
            case "list": {
                List<Order> orders = orderDAO.getOrdersByUserId(loggedUser.getId());
                request.setAttribute("orders", orders);
                request.getRequestDispatcher("/donhang.jsp").forward(request, response);
                break;
            }
 
            // Chi tiết 1 đơn hàng
            case "detail": {
                String idStr = request.getParameter("id");
                if (idStr == null || idStr.trim().isEmpty()) {
                    response.sendRedirect("OrderServlet");
                    return;
                }
                try {
                    int orderId = Integer.parseInt(idStr);
                    Order order = orderDAO.getOrderById(orderId);
 
                    // Kiểm tra đơn hàng có thuộc về user này không
                    if (order == null || !order.getUserId().equals(loggedUser.getId())) {
                        response.sendRedirect("OrderServlet");
                        return;
                    }
 
                    List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(orderId);
 
                    // Map productId -> Product để hiển thị tên, ảnh
                    java.util.Map<Integer, model.Product> productMap = new java.util.LinkedHashMap<>();
                    for (OrderDetail d : details) {
                        if (!productMap.containsKey(d.getProductId())) {
                            productMap.put(d.getProductId(), orderDAO.getProductById(d.getProductId()));
                        }
                    }
 
                    request.setAttribute("order", order);
                    request.setAttribute("details", details);
                    request.setAttribute("productMap", productMap);
                    request.getRequestDispatcher("/donhang.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect("OrderServlet");
                }
                break;
            }
 
            default:
                response.sendRedirect("OrderServlet");
        }
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}