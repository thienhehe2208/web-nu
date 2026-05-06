

package controller;
 
import model.Product;
import model.ProductDAO;
import model.Category;
import model.CategoryDAO;
 
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
 
import java.io.IOException;
import java.util.List;
 
public class ProductServlet extends HttpServlet {
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
 
        String action = request.getParameter("action");
 
        // Luôn load categories cho menu
        List<Category> categories = categoryDAO.getAll();
        request.setAttribute("categories", categories);
 
        if (action == null) {
            // ==================== HOME: chỉ hiện tất cả sản phẩm ====================
            List<Product> allProducts = productDAO.getAll();
            request.setAttribute("allProducts", allProducts);
            request.setAttribute("pageTitle", "Tất Cả Sản Phẩm");
 
        } else {
            switch (action) {
 
                // ==================== HÀNG MỚI ====================
                case "new":
                    List<Product> newProducts = productDAO.getNewProducts();
                    request.setAttribute("allProducts", newProducts);
                    request.setAttribute("pageTitle", "🆕 Hàng Mới");
                    break;
 
                // ==================== BÁN CHẠY ====================
                case "bestseller":
                    List<Product> bestsellerProducts = productDAO.getBestsellerProducts();
                    request.setAttribute("allProducts", bestsellerProducts);
                    request.setAttribute("pageTitle", "🔥 Bán Chạy Nhất");
                    break;
 
                // ==================== GIẢM GIÁ ====================
                case "discount":
                    List<Product> discountProducts = productDAO.getDiscountProducts();
                    request.setAttribute("allProducts", discountProducts);
                    request.setAttribute("pageTitle", "💸 Đang Giảm Giá");
                    break;
 
                // ==================== LỌC THEO CATEGORY ====================
                case "filter":
                    String catIdStr = request.getParameter("categoryId");
                    if (catIdStr == null || catIdStr.trim().isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/ProductServlet");
                        return;
                    }
                    try {
                        int categoryId = Integer.parseInt(catIdStr);
                        List<Product> filteredProducts = productDAO.getByCategory(categoryId);
                        request.setAttribute("allProducts", filteredProducts);
                        request.setAttribute("selectedCategoryId", categoryId);
                        // Lấy tên category để hiện tiêu đề
                        for (Category c : categories) {
                            if (c.getId() == categoryId) {
                                request.setAttribute("pageTitle", "📂 " + c.getName());
                                break;
                            }
                        }
                    } catch (NumberFormatException e) {
                        response.sendRedirect(request.getContextPath() + "/ProductServlet");
                        return;
                    }
                    break;
 
                // ==================== TÌM KIẾM ====================
                case "search":
                    String keyword = request.getParameter("keyword");
                    if (keyword == null || keyword.trim().isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/ProductServlet");
                        return;
                    }
                    List<Product> searchResults = productDAO.search(keyword.trim());
                    request.setAttribute("allProducts", searchResults);
                    request.setAttribute("keyword", keyword.trim());
                    request.setAttribute("pageTitle", "🔍 Kết quả: \"" + keyword.trim() + "\" (" + searchResults.size() + " sản phẩm)");
                    break;
 
                // ==================== CHI TIẾT SẢN PHẨM ====================
                case "detail":
                    String idStr = request.getParameter("id");
                    if (idStr == null || idStr.trim().isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/ProductServlet");
                        return;
                    }
                    try {
                        int productId = Integer.parseInt(idStr);
                        Product product = productDAO.getById(productId);
                        if (product == null) {
                            response.sendRedirect(request.getContextPath() + "/ProductServlet");
                            return;
                        }
                        request.setAttribute("product", product);
                        request.getRequestDispatcher("/product-detail.jsp").forward(request, response);
                        return;
                    } catch (NumberFormatException e) {
                        response.sendRedirect(request.getContextPath() + "/ProductServlet");
                        return;
                    }
 
                default:
                    response.sendRedirect(request.getContextPath() + "/ProductServlet");
                    return;
            }
        }
 
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}