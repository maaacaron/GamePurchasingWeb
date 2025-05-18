package dao;

import model.Game;
import util.DBUtil;

import java.sql.*;
import java.util.*;

public class LibraryDAO {

    // 게임을 라이브러리에 추가 (중복 방지)
    public static void addGameToLibrary(int userId, int gameId) {
        String sql = "INSERT IGNORE INTO Library (User_ID, Game_ID) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, gameId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 해당 유저의 구매 게임 목록 조회
    public static List<Game> getLibraryGames(int userId) {
        List<Game> list = new ArrayList<>();
        String sql = """
            SELECT g.*, ge.Name AS GenreName
            FROM Library l
            JOIN Game g ON l.Game_ID = g.ID
            LEFT JOIN GameGenre gg ON g.ID = gg.GameID
            LEFT JOIN Genre ge ON gg.GenreID = ge.ID
            WHERE l.User_ID = ?
        """;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Game game = new Game(
                    rs.getInt("ID"),
                    rs.getString("Name"),
                    rs.getString("Image"),
                    rs.getString("GenreName"),
                    rs.getInt("Price"),
                    rs.getBoolean("Discount")
                );
                list.add(game);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // (선택) 이미 보유한지 확인
    public static boolean hasGame(int userId, int gameId) {
        String sql = "SELECT * FROM Library WHERE User_ID = ? AND Game_ID = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, gameId);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
