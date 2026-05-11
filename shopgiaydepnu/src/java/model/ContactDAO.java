
package model;
 
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.ConnectDB;
 
public class ContactDAO {
 
    private Connection conn;
 
    public ContactDAO() {
        conn = ConnectDB.getConnection();
    }
 
    // Lưu liên hệ mới vào DB
    public boolean save(Contact contact) {
        String sql = "INSERT INTO contacts(name, email, phone, message, created_at) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, contact.getName());
            ps.setString(2, contact.getEmail());
            ps.setString(3, contact.getPhone());
            ps.setString(4, contact.getMessage());
            ps.setString(5, contact.getCreatedAt());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 
    // Lấy toàn bộ góp ý (admin dùng), mới nhất lên trên
    public List<Contact> getAll() {
        List<Contact> list = new ArrayList<>();
        String sql = "SELECT * FROM contacts ORDER BY id DESC";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contact c = new Contact(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("message"),
                        rs.getString("created_at")
                );
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 
    // Xóa góp ý theo id
    public boolean delete(int id) {
        String sql = "DELETE FROM contacts WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}