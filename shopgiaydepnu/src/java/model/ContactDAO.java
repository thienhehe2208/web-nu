/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.*;
import model.Contact;
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
}