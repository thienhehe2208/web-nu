package controller;

import model.User;
import model.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "login":
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                break;
            case "register":
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                break;
            case "logout":
                HttpSession session = request.getSession(false);
                if (session != null) session.invalidate();
                response.sendRedirect(request.getContextPath() + "/ProductServlet");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/ProductServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        UserDAO userDAO = new UserDAO();

        switch (action) {

            // ==================== ĐĂNG NHẬP ====================
            case "login": {
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                if (username == null || username.trim().isEmpty() ||
                    password == null || password.trim().isEmpty()) {
                    request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }

                User user = userDAO.login(username.trim(), password.trim());
                if (user != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("loggedUser", user);
                    response.sendRedirect(request.getContextPath() + "/ProductServlet");
                } else {
                    request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
                break;
            }

            // ==================== ĐĂNG KÝ ====================
            case "register": {
                String accountName = request.getParameter("accountName");
                String username    = request.getParameter("username");
                String email       = request.getParameter("email");
                String phone       = request.getParameter("phone");
                String address     = request.getParameter("address");
                String password    = request.getParameter("password");
                String confirmPass = request.getParameter("confirmPassword");

                // Validate cơ bản
                if (accountName == null || accountName.trim().isEmpty() ||
                    username == null    || username.trim().isEmpty()    ||
                    email == null       || email.trim().isEmpty()       ||
                    password == null    || password.trim().isEmpty()) {
                    request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc!");
                    request.getRequestDispatcher("/register.jsp").forward(request, response);
                    return;
                }

                // Kiểm tra mật khẩu khớp
                if (!password.equals(confirmPass)) {
                    request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
                    request.getRequestDispatcher("/register.jsp").forward(request, response);
                    return;
                }

                // Kiểm tra username đã tồn tại
                if (userDAO.checkUsername(username.trim())) {
                    request.setAttribute("error", "Tên đăng nhập đã tồn tại, vui lòng chọn tên khác!");
                    request.getRequestDispatcher("/register.jsp").forward(request, response);
                    return;
                }

                User newUser = new User();
                newUser.setAccountName(accountName.trim());
                newUser.setUsername(username.trim());
                newUser.setEmail(email.trim());
                newUser.setPhone(phone != null ? phone.trim() : "");
                newUser.setAddress(address != null ? address.trim() : "");
                newUser.setPassword(password);

                boolean success = userDAO.register(newUser);
                if (success) {
                    request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Đăng ký thất bại, vui lòng thử lại!");
                    request.getRequestDispatcher("/register.jsp").forward(request, response);
                }
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/ProductServlet");
        }
    }
}