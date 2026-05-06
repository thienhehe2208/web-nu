package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnectDB {

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/test3",
                    "root",
                    ""
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
