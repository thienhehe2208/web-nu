package model;
 
import java.security.MessageDigest;
import java.math.BigInteger;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.ConnectDB;
 
public class UserDAO {
 
    private Connection conn;
 
    public UserDAO() {
        conn = ConnectDB.getConnection();
    }
 
    public String md5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            BigInteger no = new BigInteger(1, messageDigest);
            String hashtext = no.toString(16);
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
 
    // Map ResultSet -> User (kèm role)
    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setAccountName(rs.getString("account_name"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setAddress(rs.getString("address"));
        u.setRole(rs.getString("role"));
        u.setCreatedAt(rs.getString("created_at"));
        return u;
    }
 
    // LOGIN — load thêm role
    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username=? AND password=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, md5(password));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
 
    // REGISTER
    public boolean register(User u) {
        String sql = "INSERT INTO users(account_name, username, email, phone, address, password, role) VALUES (?, ?, ?, ?, ?, ?, 'user')";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, u.getAccountName());
            ps.setString(2, u.getUsername());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPhone());
            ps.setString(5, u.getAddress());
            ps.setString(6, md5(u.getPassword()));
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 
    // CHECK USERNAME tồn tại
    public boolean checkUsername(String username) {
        String sql = "SELECT id FROM users WHERE username=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 
    // Lấy toàn bộ user (admin dùng)
    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id DESC";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
 
    // Lấy user theo id
    public User getById(int id) {
        String sql = "SELECT * FROM users WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
 
    // Xóa user
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id=? AND role != 'admin'";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
 
    // Đổi role user
    public boolean updateRole(int id, String role) {
        String sql = "UPDATE users SET role=? WHERE id=?";
        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, role);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
   
}
