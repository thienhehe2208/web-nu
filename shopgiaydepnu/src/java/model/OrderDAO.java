package model;
 
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.OrderDetail;
import model.Product;
import utils.ConnectDB;
 
public class OrderDAO {
 
    private Connection conn;
 
    public OrderDAO() {
        conn = ConnectDB.getConnection();
    }
 
    // Tạo đơn hàng mới, trả về orderId vừa tạo
    public int createOrder(Order order) {
        String sql = "INSERT INTO orders(user_id, customer_name, customer_phone, customer_address, total_money, status, created_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try {
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            if (order.getUserId() != null) ps.setInt(1, order.getUserId());
            else ps.setNull(1, Types.INTEGER);
            ps.setString(2, order.getCustomerName());
            ps.setString(3, order.getCustomerPhone());
            ps.setString(4, order.getCustomerAddress());
            ps.setDouble(5, order.getTotalMoney());
            ps.setString(6, "Chờ xác nhận");
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
 
    // Lưu danh sách OrderDetail VÀ trừ stock từng sản phẩm
    public boolean saveOrderDetails(List<OrderDetail> details) {
        String sqlDetail = "INSERT INTO order_details(order_id, product_id, price, quantity, size) VALUES (?,?,?,?,?)";
        String sqlStock  = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";
        try {
            PreparedStatement psDetail = conn.prepareStatement(sqlDetail);
            for (OrderDetail d : details) {
                psDetail.setInt(1, d.getOrderId());
                psDetail.setInt(2, d.getProductId());
                psDetail.setDouble(3, d.getPrice());
                psDetail.setInt(4, d.getQuantity());
                psDetail.setString(5, d.getSize());
                psDetail.addBatch();
            }
            psDetail.executeBatch();
 
            PreparedStatement psStock = conn.prepareStatement(sqlStock);
            for (OrderDetail d : details) {
                psStock.setInt(1, d.getQuantity());
                psStock.setInt(2, d.getProductId());
                psStock.setInt(3, d.getQuantity());
                psStock.addBatch();
            }
            psStock.executeBatch();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 
    // Lấy danh sách đơn hàng theo userId, mới nhất lên trên
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY id DESC";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("customer_name"),
                        rs.getString("customer_phone"),
                        rs.getString("customer_address"),
                        rs.getDouble("total_money"),
                        rs.getString("status"),
                        rs.getString("created_at")
                );
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 
    // Lấy đơn hàng theo orderId
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Order(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("customer_name"),
                        rs.getString("customer_phone"),
                        rs.getString("customer_address"),
                        rs.getDouble("total_money"),
                        rs.getString("status"),
                        rs.getString("created_at")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
 
    // Lấy chi tiết đơn hàng theo orderId
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM order_details WHERE order_id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetail d = new OrderDetail(
                        rs.getInt("id"),
                        rs.getInt("order_id"),
                        rs.getInt("product_id"),
                        rs.getDouble("price"),
                        rs.getInt("quantity"),
                        rs.getString("size")
                );
                list.add(d);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 
    // Lấy Product theo productId (dùng để hiển thị trong chi tiết đơn)
    public Product getProductById(int productId) {
        String sql = "SELECT id, name, image FROM products WHERE id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setImage(rs.getString("image"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    // ================== THÊM CÁC METHOD NÀY VÀO OrderDAO.java ==================
// Dán vào trước dấu } cuối cùng của class OrderDAO
 
    // Lấy toàn bộ đơn hàng (admin dùng), mới nhất lên trên
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY id DESC";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Order(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("customer_name"),
                        rs.getString("customer_phone"),
                        rs.getString("customer_address"),
                        rs.getDouble("total_money"),
                        rs.getString("status"),
                        rs.getString("created_at")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 
    // Cập nhật trạng thái đơn hàng
    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status=? WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}