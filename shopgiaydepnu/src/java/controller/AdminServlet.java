package controller;
import model.ContactDAO;
import model.OrderDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;

public class AdminServlet extends HttpServlet {

    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User loggedUser = (User) request.getSession().getAttribute("loggedUser");
        if (loggedUser == null || !loggedUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/ProductServlet");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdmin(request, response)) {
            return;
        }

        String path = request.getPathInfo();
        if (path == null) {
            path = "/index";
        }

        switch (path) {
            case "/":
            case "/index":
                showDashboard(request, response);
                break;
            case "/products":
                showProducts(request, response);
                break;
            case "/product-add":
                showProductForm(request, response, null);
                break;
            case "/product-edit":
                showProductEdit(request, response);
                break;
            case "/product-delete":
                deleteProduct(request, response);
                break;
            case "/orders":
                showOrders(request, response);
                break;
            case "/order-detail":
                showOrderDetail(request, response);
                break;
            case "/order-status":
                updateOrderStatus(request, response);
                break;
            case "/users":
                showUsers(request, response);
                break;
            case "/user-delete":
                deleteUser(request, response);
                break;
            case "/user-role":
                updateUserRole(request, response);
                break;
            case "/contacts":
                showContacts(request, response);
                break;
            case "/contact-delete":
                deleteContact(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/index");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!checkAdmin(request, response)) {
            return;
        }
        request.setCharacterEncoding("UTF-8");

        String path = request.getPathInfo();
        if (path == null) {
            path = "/";
        }

        switch (path) {
            case "/product-add":
                saveProduct(request, response, false);
                break;
            case "/product-edit":
                saveProduct(request, response, true);
                break;
            case "/order-status":
                updateOrderStatus(request, response);
                break;
            case "/user-role":
                updateUserRole(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/index");
        }
    }

    // ===== DASHBOARD =====
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ProductDAO productDAO = new ProductDAO();
            UserDAO userDAO = new UserDAO();
            OrderDAO orderDAO = new OrderDAO();
            request.setAttribute("totalProducts", productDAO.getAll().size());
            request.setAttribute("totalUsers", userDAO.getAll().size());
            request.setAttribute("totalOrders", orderDAO.getAllOrders().size());
            request.getRequestDispatcher("/WEB-INF/admin/index.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("LOI: " + e.getMessage());
        }
    }

    // ===== SẢN PHẨM =====
    private void showProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        request.setAttribute("products", productDAO.getAll());
        request.getRequestDispatcher("/WEB-INF/admin/products.jsp").forward(request, response);
    }

    private void showProductForm(HttpServletRequest request, HttpServletResponse response, Product product)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        request.setAttribute("categories", categoryDAO.getAll());
        request.setAttribute("product", product);
        request.getRequestDispatcher("/WEB-INF/admin/product-form.jsp").forward(request, response);
    }

    private void showProductEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ProductDAO productDAO = new ProductDAO();
            Product p = productDAO.getById(id);
            if (p == null) {
                response.sendRedirect(request.getContextPath() + "/admin/products");
                return;
            }
            showProductForm(request, response, p);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    private void saveProduct(HttpServletRequest request, HttpServletResponse response, boolean isEdit)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name").trim();
            String sku = request.getParameter("sku").trim();
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            double price = Double.parseDouble(request.getParameter("price"));
            String discountStr = request.getParameter("discountPrice");
            Double discount = (discountStr != null && !discountStr.trim().isEmpty()) ? Double.parseDouble(discountStr) : null;
            String image = request.getParameter("image").trim();
            String description = request.getParameter("description");
            boolean isNew = request.getParameter("isNew") != null;
            boolean isBest = request.getParameter("isBestseller") != null;
            int stock = Integer.parseInt(request.getParameter("stock"));
            String[] sizes = request.getParameterValues("sizes");

            Product p = new Product();
            p.setName(name);
            p.setSku(sku);
            p.setCategoryId(categoryId);
            p.setPrice(price);
            p.setDiscountPrice(discount);
            p.setImage(image);
            p.setDescription(description != null ? description : "");
            p.setIsNew(isNew);
            p.setIsBestseller(isBest);
            p.setStock(stock);

            ProductDAO productDAO = new ProductDAO();
            if (isEdit) {
                int id = Integer.parseInt(request.getParameter("id"));
                p.setId(id);
                productDAO.update(p, sizes);
            } else {
                productDAO.insert(p, sizes);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            new ProductDAO().delete(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    // ===== ĐƠN HÀNG =====
    private void showOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDAO orderDAO = new OrderDAO();
        request.setAttribute("orders", orderDAO.getAllOrders());
        request.getRequestDispatcher("/WEB-INF/admin/orders.jsp").forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(id);
            List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(id);
            java.util.Map<Integer, Product> productMap = new java.util.LinkedHashMap<>();
            for (OrderDetail d : details) {
                if (!productMap.containsKey(d.getProductId())) {
                    productMap.put(d.getProductId(), orderDAO.getProductById(d.getProductId()));
                }
            }
            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.setAttribute("productMap", productMap);
            request.getRequestDispatcher("/WEB-INF/admin/orders.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            new OrderDAO().updateStatus(id, status);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    // ===== NGƯỜI DÙNG =====
    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        request.setAttribute("users", userDAO.getAll());
        request.getRequestDispatcher("/WEB-INF/admin/users.jsp").forward(request, response);
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            new UserDAO().deleteUser(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void updateUserRole(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String role = request.getParameter("role");
            new UserDAO().updateRole(id, role);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }

    private void showContacts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ContactDAO contactDAO = new ContactDAO();
        request.setAttribute("contacts", contactDAO.getAll());
        request.getRequestDispatcher("/WEB-INF/admin/contacts.jsp").forward(request, response);
    }

    private void deleteContact(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            new ContactDAO().delete(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/admin/contacts");
    }
}
