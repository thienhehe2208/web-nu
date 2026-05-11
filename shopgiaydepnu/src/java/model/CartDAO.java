/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.*;
import java.util.*;
import model.Cart;
import model.CartItem;
import model.Product;
import utils.ConnectDB;
 
public class CartDAO {
 
    private Connection conn;
 
    public CartDAO() {
        conn = ConnectDB.getConnection();
    }
 
    // Lấy Cart theo userId, nếu chưa có thì tạo mới
    public Cart getOrCreateCart(int userId) {
        String sql = "SELECT * FROM cart WHERE user_id = ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Cart(rs.getInt("id"), rs.getInt("user_id"),
                        rs.getString("created_at"), rs.getString("updated_at"));
            } else {
                String insertSql = "INSERT INTO cart(user_id, created_at, updated_at) VALUES (?, NOW(), NOW())";
                PreparedStatement psInsert = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
                psInsert.setInt(1, userId);
                psInsert.executeUpdate();
                ResultSet keys = psInsert.getGeneratedKeys();
                if (keys.next()) {
                    return new Cart(keys.getInt(1), userId, null, null);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
 
    // Thêm sản phẩm vào giỏ (nếu đã có cùng productId + size thì tăng quantity)
    public boolean addItem(int cartId, int productId, int quantity, String size) {
        String checkSql = "SELECT id, quantity FROM cart_items WHERE cart_id=? AND product_id=? AND size=?";
        try {
            PreparedStatement psCheck = conn.prepareStatement(checkSql);
            psCheck.setInt(1, cartId);
            psCheck.setInt(2, productId);
            psCheck.setString(3, size);
            ResultSet rs = psCheck.executeQuery();
            if (rs.next()) {
                int newQty = rs.getInt("quantity") + quantity;
                String updateSql = "UPDATE cart_items SET quantity=? WHERE id=?";
                PreparedStatement psUpdate = conn.prepareStatement(updateSql);
                psUpdate.setInt(1, newQty);
                psUpdate.setInt(2, rs.getInt("id"));
                psUpdate.executeUpdate();
            } else {
                String insertSql = "INSERT INTO cart_items(cart_id, product_id, quantity, size) VALUES (?,?,?,?)";
                PreparedStatement psInsert = conn.prepareStatement(insertSql);
                psInsert.setInt(1, cartId);
                psInsert.setInt(2, productId);
                psInsert.setInt(3, quantity);
                psInsert.setString(4, size);
                psInsert.executeUpdate();
            }
            conn.prepareStatement("UPDATE cart SET updated_at=NOW() WHERE id=" + cartId).executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 
    // Xóa một item khỏi giỏ
    public boolean removeItem(int cartItemId) {
        String sql = "DELETE FROM cart_items WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 
    // Cập nhật số lượng
    public boolean updateQuantity(int cartItemId, int quantity) {
        if (quantity <= 0) return removeItem(cartItemId);
        String sql = "UPDATE cart_items SET quantity=? WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 
    // Lấy danh sách CartItem theo cartId
    public List<CartItem> getItemsByCartId(int cartId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT * FROM cart_items WHERE cart_id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem(
                        rs.getInt("id"),
                        rs.getInt("cart_id"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity"),
                        rs.getString("size")
                );
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 
    // Lấy Product theo productId (kèm stock)
    public Product getProductById(int productId) {
        String sql = "SELECT * FROM products WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getDouble("price"));
                p.setDiscountPrice(rs.getObject("discount_price") != null ? rs.getDouble("discount_price") : null);
                p.setImage(rs.getString("image"));
                p.setStock(rs.getInt("stock"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
 
    // Xóa toàn bộ item trong giỏ sau khi đặt hàng thành công
    public void clearCart(int cartId) {
        String sql = "DELETE FROM cart_items WHERE cart_id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cartId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
 
    // Đếm tổng số lượng item trong giỏ (dùng cho badge)
    public int countItems(int cartId) {
        String sql = "SELECT SUM(quantity) FROM cart_items WHERE cart_id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
 
    // Lấy stock hiện tại của sản phẩm
    public int checkStock(int productId) {
        String sql = "SELECT stock FROM products WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("stock");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
 
    // Trừ stock sau khi đặt hàng thành công
    public boolean reduceStock(int productId, int quantity) {
        // Điều kiện stock >= quantity để tránh trừ âm
        String sql = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
 