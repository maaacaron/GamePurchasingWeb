package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import util.DBUtil;

public class UserDAO {

    // 1. 로그인 확인
    public static boolean checkLogin(String username, String password) {
        String query = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            return rs.next();  // 사용자가 존재하면 로그인 성공
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. 아이디 중복 확인
    public static boolean exists(String username) {
        String query = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            return rs.next();  // 이미 존재하는 ID면 true
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. 회원 가입
    public static boolean insertUser(String username, String password) {
        String query = "INSERT INTO users (username, password) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            return stmt.executeUpdate() > 0;  // 성공 시 true
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
