package utils;
 
import java.sql.Connection;
import java.sql.DriverManager;
 
public class ConnectDB {
    private static final String URL  = "jdbc:mysql://localhost:3306/test3?autoReconnect=true&useSSL=false";
    private static final String USER = "root";
    private static final String PASS = "";
 
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
 