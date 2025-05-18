package dao;

import model.Game;
import model.CartItem;
import util.DBUtil;

import java.sql.*;
import java.util.*;

public class CartDAO {

    // 장바구니 ID 조회 (없으면 생성)
    public static int getOrCreateCartId(int userId) {
        int cartId = -1;
        
        try (Connection conn = DBUtil.getConnection()) {
            // 먼저 존재 여부 확인
            PreparedStatement checkStmt = conn.prepareStatement("SELECT ID FROM Cart WHERE User_ID = ?");
            checkStmt.setInt(1, userId);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("ID");
            }

            // 없으면 생성
            PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO Cart(User_ID) VALUES (?)", Statement.RETURN_GENERATED_KEYS);
            insertStmt.setInt(1, userId);
            insertStmt.executeUpdate();
            ResultSet genKeys = insertStmt.getGeneratedKeys();
            if (genKeys.next()) {
                cartId = genKeys.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cartId;
    }

    // 게임을 장바구니에 추가
    public static void addToCart(int userId, int gameId) {
        int cartId = getOrCreateCartId(userId);
        String sql = "INSERT IGNORE INTO CartItem (Cart_ID, Game_ID) VALUES (?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            stmt.setInt(2, gameId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 장바구니 항목 조회
    public static List<CartItem> getCartItems(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = """
            SELECT g.*, ge.Name AS GenreName
            FROM CartItem ci
            JOIN Cart c ON ci.Cart_ID = c.ID
            JOIN Game g ON ci.Game_ID = g.ID
            LEFT JOIN GameGenre gg ON g.ID = gg.GameID
            LEFT JOIN Genre ge ON gg.GenreID = ge.ID
            WHERE c.User_ID = ?
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
                list.add(new CartItem(game, 1)); // 수량 = 1 고정
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 선택 항목 삭제
    public static void removeFromCart(int userId, List<Integer> gameIds) {
        if (gameIds.isEmpty()) return;

        int cartId = getOrCreateCartId(userId);
        String sql = "DELETE FROM CartItem WHERE Cart_ID = ? AND Game_ID = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int gameId : gameIds) {
                stmt.setInt(1, cartId);
                stmt.setInt(2, gameId);
                stmt.addBatch();
            }
            stmt.executeBatch();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
