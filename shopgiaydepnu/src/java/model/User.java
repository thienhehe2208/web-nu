package model;
 
public class User {
    private int id;
    private String accountName;
    private String username;
    private String email;
    private String phone;
    private String address;
    private String password;
    private String createdAt;
    private String role; // "admin" hoặc "user"
 
    public User() {
    }
 
    public User(int id, String accountName, String username, String email,
            String phone, String address, String password, String createdAt, String role) {
        this.id = id;
        this.accountName = accountName;
        this.username = username;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.password = password;
        this.createdAt = createdAt;
        this.role = role;
    }
 
    public int getId() { return id; }
    public String getAccountName() { return accountName; }
    public String getUsername() { return username; }
    public String getEmail() { return email; }
    public String getPhone() { return phone; }
    public String getAddress() { return address; }
    public String getPassword() { return password; }
    public String getCreatedAt() { return createdAt; }
    public String getRole() { return role; }
 
    public void setId(int id) { this.id = id; }
    public void setAccountName(String accountName) { this.accountName = accountName; }
    public void setUsername(String username) { this.username = username; }
    public void setEmail(String email) { this.email = email; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setAddress(String address) { this.address = address; }
    public void setPassword(String password) { this.password = password; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    public void setRole(String role) { this.role = role; }
 
    public boolean isAdmin() {
        return "admin".equals(this.role);
    }
}