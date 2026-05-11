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
        p.setStock(rs.getInt("stock"));
        return p;
    }

    // ================== BASIC ==================
    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try (Connection conn = ConnectDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        try (Connection conn = ConnectDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = mapProduct(rs);
                p.setSizes(getSizesByProductId(id)); // thêm dòng này
                return p;
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
        try (Connection conn = ConnectDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try (Connection conn = ConnectDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try (Connection conn = ConnectDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        try (Connection conn = ConnectDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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

    private List<String> getSizesByProductId(int productId) {
        List<String> sizes = new ArrayList<>();
        String sql = "SELECT size FROM product_sizes WHERE product_id = ? ORDER BY size";
        try (Connection conn = ConnectDB.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                sizes.add(rs.getString("size"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sizes;
    }
     // ================== THÊM CÁC METHOD NÀY VÀO ProductDAO.java ==================
// Dán vào trước dấu } cuối cùng của class ProductDAO
 
    // INSERT sản phẩm mới
    public boolean insert(Product p, String[] sizes) {
        String sql = "INSERT INTO products(category_id, sku, name, price, discount_price, image, description, is_new, is_bestseller, stock) "
                   + "VALUES (?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getSku());
            ps.setString(3, p.getName());
            ps.setDouble(4, p.getPrice());
            if (p.getDiscountPrice() != null) ps.setDouble(5, p.getDiscountPrice());
            else ps.setNull(5, java.sql.Types.DECIMAL);
            ps.setString(6, p.getImage());
            ps.setString(7, p.getDescription());
            ps.setBoolean(8, p.isIsNew());
            ps.setBoolean(9, p.isIsBestseller());
            ps.setInt(10, p.getStock());
            ps.executeUpdate();
 
            // Lấy id vừa insert để lưu sizes
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next() && sizes != null) {
                int productId = keys.getInt(1);
                saveSizes(conn, productId, sizes);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 
    // UPDATE sản phẩm
    public boolean update(Product p, String[] sizes) {
        String sql = "UPDATE products SET category_id=?, sku=?, name=?, price=?, discount_price=?, image=?, description=?, is_new=?, is_bestseller=?, stock=? WHERE id=?";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setString(2, p.getSku());
            ps.setString(3, p.getName());
            ps.setDouble(4, p.getPrice());
            if (p.getDiscountPrice() != null) ps.setDouble(5, p.getDiscountPrice());
            else ps.setNull(5, java.sql.Types.DECIMAL);
            ps.setString(6, p.getImage());
            ps.setString(7, p.getDescription());
            ps.setBoolean(8, p.isIsNew());
            ps.setBoolean(9, p.isIsBestseller());
            ps.setInt(10, p.getStock());
            ps.setInt(11, p.getId());
            ps.executeUpdate();
 
            // Xóa sizes cũ rồi lưu lại sizes mới
            if (sizes != null) {
                deleteSizes(conn, p.getId());
                saveSizes(conn, p.getId(), sizes);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 
    // DELETE sản phẩm
    public boolean delete(int id) {
        String sql = "DELETE FROM products WHERE id=?";
        try (Connection conn = ConnectDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 
    // Lưu sizes cho sản phẩm
    private void saveSizes(Connection conn, int productId, String[] sizes) throws SQLException {
        String sql = "INSERT INTO product_sizes(product_id, size) VALUES (?,?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        for (String size : sizes) {
            if (size != null && !size.trim().isEmpty()) {
                ps.setInt(1, productId);
                ps.setString(2, size.trim());
                ps.addBatch();
            }
        }
        ps.executeBatch();
    }
 
    // Xóa sizes cũ của sản phẩm
    private void deleteSizes(Connection conn, int productId) throws SQLException {
        String sql = "DELETE FROM product_sizes WHERE product_id=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, productId);
        ps.executeUpdate();
    }
}
