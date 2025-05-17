package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBUtil {
    private static final String URL = "jdbc:mysql://52.65.232.17:3306/SteamDB?serverTimezone=UTC";
    private static final String USER = "HamYiHyeon";
    private static final String PASSWORD = "116512eh";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // JDBC 드라이버 로딩
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
