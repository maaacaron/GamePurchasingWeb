package dao;

import model.User;
import util.DBUtil;

import java.sql.*;

public class UserDAO {

    // 로그인 확인
    public static User checkLogin(String userId, String password) {
        String sql = "SELECT * FROM User WHERE UserID = ? AND PassWord = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new User(
                    rs.getInt("ID"),
                    rs.getString("UserID"),
                    rs.getString("PassWord"),
                    rs.getString("Name"),
                    rs.getString("Email"),
                    rs.getBoolean("IsAdmin")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 회원가입 중복 확인
    public static boolean isUserIdTaken(String userId) {
        String sql = "SELECT * FROM User WHERE UserID = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true; // 오류 발생 시 사용중으로 처리
    }

    public static boolean isEmailTaken(String email) {
        String sql = "SELECT * FROM User WHERE Email = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }

    // 회원 등록
    public static boolean register(User user) {
        String sql = "INSERT INTO User (UserID, PassWord, Name, Email, IsAdmin) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUserId());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getName());
            stmt.setString(4, user.getEmail());
            stmt.setBoolean(5, user.isAdmin());
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
