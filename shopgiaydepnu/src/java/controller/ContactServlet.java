package controller;

import model.ContactDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Contact;
 
public class ContactServlet extends HttpServlet {

    // GET: hiển thị form liên hệ
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("Contact.jsp").forward(request, response);
    }

    // POST: xử lý submit form
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name    = request.getParameter("name")    != null ? request.getParameter("name").trim()    : "";
        String email   = request.getParameter("email")   != null ? request.getParameter("email").trim()   : "";
        String phone   = request.getParameter("phone")   != null ? request.getParameter("phone").trim()   : "";
        String message = request.getParameter("message") != null ? request.getParameter("message").trim() : "";

        boolean hasError = false;

        // --- Validate ---
        if (name.isEmpty()) {
            request.setAttribute("nameError", "Vui lòng nhập họ tên.");
            hasError = true;
        } else if (name.length() > 100) {
            request.setAttribute("nameError", "Họ tên không được vượt quá 100 ký tự.");
            hasError = true;
        }

        if (email.isEmpty()) {
            request.setAttribute("emailError", "Vui lòng nhập email.");
            hasError = true;
        } else if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            request.setAttribute("emailError", "Email không đúng định dạng.");
            hasError = true;
        } else if (email.length() > 150) {
            request.setAttribute("emailError", "Email không được vượt quá 150 ký tự.");
            hasError = true;
        }

        if (!phone.isEmpty()) {
            if (!phone.matches("^[0-9]{9,11}$")) {
                request.setAttribute("phoneError", "Số điện thoại không hợp lệ (9-11 chữ số).");
                hasError = true;
            }
        }

        if (message.isEmpty()) {
            request.setAttribute("messageError", "Vui lòng nhập nội dung góp ý.");
            hasError = true;
        } else if (message.length() > 1000) {
            request.setAttribute("messageError", "Nội dung không được vượt quá 1000 ký tự.");
            hasError = true;
        }

        // Nếu có lỗi → trả lại form kèm dữ liệu đã nhập
        if (hasError) {
            request.setAttribute("oldName",    name);
            request.setAttribute("oldEmail",   email);
            request.setAttribute("oldPhone",   phone);
            request.setAttribute("oldMessage", message);
            request.setAttribute("errorMsg", "Vui lòng kiểm tra lại thông tin.");
            request.getRequestDispatcher("Contact.jsp").forward(request, response);
            return;
        }

        // --- Lưu DB ---
        String createdAt = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        Contact contact = new Contact(0, name, email, phone, message, createdAt);

        try {
            ContactDAO dao = new ContactDAO();
            dao.save(contact);

            request.setAttribute("successMsg", "Cảm ơn bạn đã góp ý! TTQ SHOP sẽ phản hồi sớm nhất.");
            request.getRequestDispatcher("Contact.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("oldName",    name);
            request.setAttribute("oldEmail",   email);
            request.setAttribute("oldPhone",   phone);
            request.setAttribute("oldMessage", message);
            request.setAttribute("errorMsg", "Có lỗi xảy ra, vui lòng thử lại sau.");

            request.getRequestDispatcher("Contact.jsp").forward(request, response);
        }
    }
}
