package controller;
 
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.*;
 
import java.io.*;
import java.net.URI;
import java.net.http.*;
import java.util.List;
 

public class ChatbotServlet extends HttpServlet {
 
    // =========================================================
    // CẤU HÌNH — chỉ sửa 2 dòng này nếu cần
    // =========================================================
    private static final String API_KEY =
        "copy vào đây";
 
    private static final String GROQ_URL =
        "https://api.groq.com/openai/v1/chat/completions";
 
    // Model miễn phí tốc độ cao của Groq
    private static final String MODEL = "llama-3.1-8b-instant";
    // =========================================================
 
    // Từ khóa nhận diện loại câu hỏi để load DB có chọn lọc
    private static final String[] KW_CATEGORY = {
        "loại", "danh mục", "category", "kiểu giày", "bán gì", "có gì",
        "sản phẩm gì", "mặt hàng"
    };
    private static final String[] KW_PRODUCT = {
        "giày", "dép", "sandal", "cao gót", "búp bê", "sneaker", "tông",
        "sản phẩm", "sp", "mua", "giá", "bao nhiêu", "rẻ", "đắt",
        "size", "cỡ", "còn hàng", "hết hàng", "tồn", "stock",
        "mới", "hot", "bán chạy", "giảm giá", "khuyến mãi", "sale",
        "tư vấn", "gợi ý", "chọn"
    };
    private static final String[] KW_ORDER = {
        "đơn", "order", "mua rồi", "đã mua", "đặt hàng", "đặt rồi",
        "giao hàng", "ship", "vận chuyển", "tracking", "theo dõi",
        "trạng thái", "hủy đơn", "đổi trả", "hoàn tiền"
    };
 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
 
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
 
        // ----------------------------------------------------------
        // 1. Đọc body JSON từ frontend: {"messages": [...]}
        // ----------------------------------------------------------
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
        }
        String requestBody = sb.toString();
 
        // ----------------------------------------------------------
        // 2. Lấy tin nhắn cuối của user để phân tích
        // ----------------------------------------------------------
        String lastUserMsg = getLastUserMessage(requestBody).toLowerCase();
 
        // ----------------------------------------------------------
        // 3. Lấy user session
        // ----------------------------------------------------------
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("user") : null;
 
        // ----------------------------------------------------------
        // 4. Phân tích → chỉ load DB cần thiết
        // ----------------------------------------------------------
        boolean needCategory = containsAny(lastUserMsg, KW_CATEGORY);
        boolean needProduct  = containsAny(lastUserMsg, KW_PRODUCT);
        boolean needOrder    = containsAny(lastUserMsg, KW_ORDER);
        if (needProduct) needCategory = true;
 
        // ----------------------------------------------------------
        // 5. Load DB có chọn lọc
        // ----------------------------------------------------------
        String categoryContext = needCategory ? buildCategoryContext()       : "";
        String productContext  = needProduct  ? buildProductContext()        : "";
        String orderContext    = needOrder    ? buildOrderContext(loggedUser) : "";
 
        // ----------------------------------------------------------
        // 6. Xây system prompt
        // ----------------------------------------------------------
        String systemPrompt = buildSystemPrompt(
            categoryContext, productContext, orderContext, loggedUser,
            needCategory, needProduct, needOrder
        );
 
        // ----------------------------------------------------------
        // 7. Xây Groq request body (format OpenAI)
        //    Groq dùng: {"model":"...","messages":[{"role":"system","content":"..."},...]}"
        // ----------------------------------------------------------
        String messagesJson = buildGroqMessages(systemPrompt, requestBody);
 
        String groqBody = "{"
            + "\"model\":\"" + MODEL + "\","
            + "\"messages\":" + messagesJson + ","
            + "\"max_tokens\":500,"
            + "\"temperature\":0.7"
            + "}";
 
        // ----------------------------------------------------------
        // 8. Gọi Groq API
        // ----------------------------------------------------------
        try {
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest apiRequest = HttpRequest.newBuilder()
                .uri(URI.create(GROQ_URL))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + API_KEY)
                .POST(HttpRequest.BodyPublishers.ofString(groqBody))
                .build();
 
            HttpResponse<String> apiResponse =
                client.send(apiRequest, HttpResponse.BodyHandlers.ofString());
 
            // Chuyển Groq response → format Claude để JSP không cần sửa
            String converted = convertGroqResponseToClaude(apiResponse.body());
            response.setStatus(apiResponse.statusCode());
            response.getWriter().write(converted);
 
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            response.setStatus(500);
            response.getWriter().write("{\"error\":\"Server bị gián đoạn\"}");
        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write(
                "{\"error\":\"Lỗi kết nối API: " + escapeJson(e.getMessage()) + "\"}"
            );
        }
    }
 
    // =============================================================
    // XÂY DỰNG MESSAGES CHO GROQ
    // Groq/OpenAI format:
    // [{"role":"system","content":"..."},
    //  {"role":"user","content":"..."},
    //  {"role":"assistant","content":"..."}]
    // =============================================================
 
    private String buildGroqMessages(String systemPrompt, String requestBody) {
        StringBuilder result = new StringBuilder("[");
 
        // Thêm system message đầu tiên
        result.append("{\"role\":\"system\",\"content\":").append(toJsonString(systemPrompt)).append("}");
 
        // Thêm lịch sử hội thoại từ frontend
        String messages = extractMessages(requestBody);
        if (!"[]".equals(messages)) {
            int i = 0;
            while (i < messages.length()) {
                int objStart = messages.indexOf("{", i);
                if (objStart == -1) break;
 
                int depth = 0, objEnd = -1;
                for (int j = objStart; j < messages.length(); j++) {
                    char c = messages.charAt(j);
                    if (c == '{') depth++;
                    else if (c == '}') { depth--; if (depth == 0) { objEnd = j; break; } }
                }
                if (objEnd == -1) break;
 
                String obj     = messages.substring(objStart, objEnd + 1);
                String role    = extractStringValue(obj, "role");
                String content = extractStringValue(obj, "content");
 
                // Groq dùng "assistant" (giống OpenAI), không đổi role
                result.append(",")
                      .append("{\"role\":").append(toJsonString(role)).append(",")
                      .append("\"content\":").append(toJsonString(content)).append("}");
 
                i = objEnd + 1;
            }
        }
 
        result.append("]");
        return result.toString();
    }
 
    // =============================================================
    // CHUYỂN GROQ RESPONSE → FORMAT CLAUDE (để JSP không cần sửa)
    //
    // Groq response:
    // {"choices":[{"message":{"role":"assistant","content":"..."}}]}
    //
    // Claude format:
    // {"content":[{"type":"text","text":"..."}]}
    // =============================================================
 
    private String convertGroqResponseToClaude(String groqBody) {
        try {
            // Kiểm tra có choices không
            if (!groqBody.contains("\"choices\"")) {
                String errMsg = extractErrorMessage(groqBody);
                String msg = errMsg.isEmpty()
                    ? "Xin lỗi, tôi không thể trả lời lúc này. Vui lòng thử lại."
                    : "Lỗi: " + errMsg;
                return "{\"content\":[{\"type\":\"text\",\"text\":" + toJsonString(msg) + "}]}";
            }
 
            // Lấy content từ choices[0].message.content
            int messageIdx = groqBody.indexOf("\"message\"");
            if (messageIdx == -1) {
                return "{\"content\":[{\"type\":\"text\",\"text\":"
                    + toJsonString("Không có nội dung phản hồi.") + "}]}";
            }
 
            int contentIdx = groqBody.indexOf("\"content\"", messageIdx);
            if (contentIdx == -1) {
                return "{\"content\":[{\"type\":\"text\",\"text\":"
                    + toJsonString("Không có nội dung phản hồi.") + "}]}";
            }
 
            int colonIdx = groqBody.indexOf(":", contentIdx);
            int strStart = groqBody.indexOf("\"", colonIdx + 1);
            if (strStart == -1) return "{\"error\":\"Parse lỗi\"}";
 
            int strEnd = findStringEnd(groqBody, strStart + 1);
            if (strEnd == -1) return "{\"error\":\"Parse lỗi\"}";
 
            // Giữ nguyên chuỗi JSON tránh escape 2 lần
            String textValue = groqBody.substring(strStart, strEnd + 1);
            return "{\"content\":[{\"type\":\"text\",\"text\":" + textValue + "}]}";
 
        } catch (Exception e) {
            return "{\"error\":\"Lỗi parse: " + escapeJson(e.getMessage()) + "\"}";
        }
    }
 
    // =============================================================
    // XÂY DỰNG SYSTEM PROMPT THÔNG MINH
    // =============================================================
 
    private String buildSystemPrompt(
            String categories, String products, String orders,
            User user, boolean hasCategory, boolean hasProduct, boolean hasOrder) {
 
        StringBuilder p = new StringBuilder();
        p.append("Bạn là trợ lý tư vấn TTQ SHOP - cửa hàng giày dép nữ.\n")
         .append("Trả lời bằng tiếng Việt, thân thiện, ngắn gọn (3-4 câu).\n")
         .append("Chỉ dựa vào dữ liệu được cung cấp, KHÔNG bịa thông tin.\n\n");
 
        if (hasCategory && !categories.isEmpty()) {
            p.append("=== DANH MỤC ===\n").append(categories).append("\n");
        }
 
        if (hasProduct && !products.isEmpty()) {
            p.append("=== SẢN PHẨM ===\n").append(products).append("\n");
            p.append("Quy tắc: Giá format '500.000đ'. Stock=0 thì báo hết hàng.\n\n");
        }
 
        if (hasOrder) {
            if (user != null) {
                p.append("=== KHÁCH HÀNG ===\nTên: ").append(user.getAccountName()).append("\n\n");
                if (!orders.isEmpty()) {
                    p.append("=== ĐƠN HÀNG ===\n").append(orders).append("\n");
                } else {
                    p.append("Khách chưa có đơn hàng nào.\n\n");
                }
            } else {
                p.append("Khách hỏi đơn hàng nhưng chưa đăng nhập. Yêu cầu đăng nhập trước.\n\n");
            }
        }
 
        if (!hasCategory && !hasProduct && !hasOrder) {
            p.append("Câu hỏi chung. Trả lời lịch sự. ")
             .append("Nếu hỏi sản phẩm/đơn hàng cụ thể hãy hướng dẫn khách hỏi rõ hơn.\n")
             .append("Hotline: 0357 349 545\n");
        }
 
        return p.toString();
    }
 
    // =============================================================
    // LOAD DỮ LIỆU TỪ DB — CHỈ KHI CẦN
    // =============================================================
 
    private String buildCategoryContext() {
        StringBuilder sb = new StringBuilder();
        try {
            for (Category c : new CategoryDAO().getAll()) {
                sb.append("- ").append(c.getName()).append("\n");
            }
        } catch (Exception e) {
            sb.append("(Lỗi tải danh mục)\n");
        }
        return sb.toString();
    }
 
    private String buildProductContext() {
        StringBuilder sb = new StringBuilder();
        try {
            ProductDAO  productDao  = new ProductDAO();
            CategoryDAO categoryDao = new CategoryDAO();
 
            java.util.Map<Integer, String> catMap = new java.util.HashMap<>();
            for (Category c : categoryDao.getAll()) catMap.put(c.getId(), c.getName());
 
            for (Product p : productDao.getAll()) {
                Product full = productDao.getById(p.getId());
 
                sb.append("- [").append(catMap.getOrDefault(p.getCategoryId(), "Khác")).append("] ");
                sb.append(p.getName()).append(" | ");
                sb.append("Giá: ").append(formatPrice((long) p.getPrice())).append("đ");
 
                if (p.getDiscountPrice() != null && p.getDiscountPrice() > 0) {
                    sb.append(" → còn ").append(formatPrice(p.getDiscountPrice().longValue())).append("đ");
                }
 
                sb.append(" | ").append(p.getStock() > 0 ? "Còn " + p.getStock() + " đôi" : "Hết hàng");
 
                if (full != null && full.getSizes() != null && !full.getSizes().isEmpty()) {
                    sb.append(" | Size: ").append(String.join(",", full.getSizes()));
                }
 
                if (p.isIsNew())        sb.append(" [Mới]");
                if (p.isIsBestseller()) sb.append(" [Hot]");
 
                sb.append("\n");
            }
        } catch (Exception e) {
            sb.append("(Lỗi tải sản phẩm)\n");
        }
        return sb.toString();
    }
 
    private String buildOrderContext(User user) {
        if (user == null) return "";
        StringBuilder sb = new StringBuilder();
        try {
            OrderDAO orderDao = new OrderDAO();
            List<Order> orders = orderDao.getOrdersByUserId(user.getId());
            if (orders.isEmpty()) return "";
 
            int limit = Math.min(orders.size(), 5);
            for (int i = 0; i < limit; i++) {
                Order o = orders.get(i);
                sb.append("Đơn #").append(o.getId()).append(": ");
 
                List<OrderDetail> details = orderDao.getOrderDetailsByOrderId(o.getId());
                StringBuilder items = new StringBuilder();
                for (OrderDetail d : details) {
                    Product p = orderDao.getProductById(d.getProductId());
                    if (p != null) {
                        if (items.length() > 0) items.append(", ");
                        items.append(p.getName())
                             .append("(size ").append(d.getSize()).append(")")
                             .append("x").append(d.getQuantity());
                    }
                }
                sb.append(items.length() > 0 ? items : "?").append(" | ");
                sb.append(formatPrice((long) o.getTotalMoney())).append("đ | ");
                sb.append(o.getStatus()).append(" | ");
                sb.append(o.getCreatedAt()).append("\n");
            }
        } catch (Exception e) {
            sb.append("(Lỗi tải đơn hàng)\n");
        }
        return sb.toString();
    }
 
    // =============================================================
    // HELPER METHODS
    // =============================================================
 
    private String getLastUserMessage(String body) {
        String messages = extractMessages(body);
        String last = "";
        int i = 0;
        while (i < messages.length()) {
            int objStart = messages.indexOf("{", i);
            if (objStart == -1) break;
            int depth = 0, objEnd = -1;
            for (int j = objStart; j < messages.length(); j++) {
                char c = messages.charAt(j);
                if (c == '{') depth++;
                else if (c == '}') { depth--; if (depth == 0) { objEnd = j; break; } }
            }
            if (objEnd == -1) break;
            String obj = messages.substring(objStart, objEnd + 1);
            if ("user".equals(extractStringValue(obj, "role"))) {
                last = extractStringValue(obj, "content");
            }
            i = objEnd + 1;
        }
        return last;
    }
 
    private boolean containsAny(String text, String[] keywords) {
        for (String kw : keywords) if (text.contains(kw)) return true;
        return false;
    }
 
    private String formatPrice(long price) {
        String s = String.valueOf(price);
        StringBuilder result = new StringBuilder();
        int mod = s.length() % 3;
        for (int i = 0; i < s.length(); i++) {
            if (i != 0 && (i - mod) % 3 == 0) result.append('.');
            result.append(s.charAt(i));
        }
        return result.toString();
    }
 
    private String extractMessages(String body) {
        int start = body.indexOf("\"messages\"");
        if (start == -1) return "[]";
        int colon    = body.indexOf(":", start);
        int arrStart = body.indexOf("[", colon);
        if (arrStart == -1) return "[]";
        int depth = 0, arrEnd = -1;
        for (int i = arrStart; i < body.length(); i++) {
            if (body.charAt(i) == '[') depth++;
            else if (body.charAt(i) == ']') { depth--; if (depth == 0) { arrEnd = i; break; } }
        }
        return arrEnd == -1 ? "[]" : body.substring(arrStart, arrEnd + 1);
    }
 
    private String extractStringValue(String obj, String key) {
        int keyIdx = obj.indexOf("\"" + key + "\"");
        if (keyIdx == -1) return "";
        int colon    = obj.indexOf(":", keyIdx);
        int strStart = obj.indexOf("\"", colon + 1);
        if (strStart == -1) return "";
        int strEnd = findStringEnd(obj, strStart + 1);
        if (strEnd == -1) return "";
        return obj.substring(strStart + 1, strEnd)
                  .replace("\\n", "\n").replace("\\\"", "\"").replace("\\\\", "\\");
    }
 
    private String extractErrorMessage(String body) {
        int msgIdx = body.indexOf("\"message\"");
        if (msgIdx == -1) return "";
        int colon    = body.indexOf(":", msgIdx);
        int strStart = body.indexOf("\"", colon + 1);
        if (strStart == -1) return "";
        int strEnd = findStringEnd(body, strStart + 1);
        if (strEnd == -1) return "";
        return body.substring(strStart + 1, strEnd);
    }
 
    private int findStringEnd(String s, int start) {
        for (int i = start; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '\\') { i++; continue; }
            if (c == '"') return i;
        }
        return -1;
    }
 
    private String toJsonString(String s) {
        if (s == null) return "\"\"";
        return "\"" + s.replace("\\", "\\\\").replace("\"", "\\\"")
                       .replace("\n", "\\n").replace("\r", "").replace("\t", "\\t") + "\"";
    }
 
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}