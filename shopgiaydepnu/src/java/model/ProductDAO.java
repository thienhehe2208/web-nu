
package model;
 
import java.sql.*;
import java.util.*;
import utils.ConnectDB;
 
public class ProductDAO {
 
    // ================== MAP ==================
    private Product mapProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setSku(rs.getString("sku"));
        p.setName(rs.getString("name"));
        p.setPrice(rs.getDouble("price"));
        Object discountObj = rs.getObject("discount_price");
        p.setDiscountPrice(discountObj != null ? ((java.math.BigDecimal) discountObj).doubleValue() : null);
        p.setImage(rs.getString("image"));
        p.setDescription(rs.getString("description"));
        p.setIsNew(rs.getBoolean("is_new"));
        p.setIsBestseller(rs.getBoolean("is_bestseller"));
        return p;
    }
 
    // ================== BASIC ==================
    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 
    public Product getById(int id) {
        String sql = "SELECT * FROM products WHERE id=?";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapProduct(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
 
    // ================== SEARCH ==================
    public List<Product> search(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE name LIKE ?";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 
    // ================== FILTER ==================
    public List<Product> getNewProducts() {
        return getByCondition("is_new = 1");
    }
 
    public List<Product> getBestsellerProducts() {
        return getByCondition("is_bestseller = 1");
    }
 
    public List<Product> getDiscountProducts() {
        return getByCondition("discount_price IS NOT NULL");
    }
 
    public List<Product> getByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category_id=?";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 
    // ================== HELPER ==================
    private List<Product> getByCondition(String condition) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE " + condition;
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 
    public Product getBySku(String sku) {
        String sql = "SELECT * FROM products WHERE sku=?";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, sku);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapProduct(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
 