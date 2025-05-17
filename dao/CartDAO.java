package dao;

import java.sql.*;
import java.util.*;
import model.*;
import util.DBUtil;

public class CartDAO {

    // 장바구니 조회
    public static List<CartItem> getCartByUser(String username) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.game_id, g.name, g.price, g.image FROM cart c JOIN games g ON c.game_id = g.id WHERE c.user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Game game = new Game();
                game.setId(rs.getString("game_id"));
                game.setName(rs.getString("name"));
                game.setPrice(rs.getInt("price"));
                game.setImage(rs.getString("image"));

                CartItem item = new CartItem();
                item.setGame(game);
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 장바구니 항목 삭제
    public static void removeItem(String username, String gameId) {
        String sql = "DELETE FROM cart WHERE user_id = ? AND game_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, gameId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 결제 처리: 장바구니 → 구매 라이브러리
    public static void purchaseCart(String username) {
        String selectSql = "SELECT game_id FROM cart WHERE user_id = ?";
        String insertSql = "INSERT IGNORE INTO library(user_id, game_id) VALUES (?, ?)";
        String deleteSql = "DELETE FROM cart WHERE user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement selectStmt = conn.prepareStatement(selectSql);
             PreparedStatement insertStmt = conn.prepareStatement(insertSql);
             PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {

            conn.setAutoCommit(false); // 트랜잭션 시작
            selectStmt.setString(1, username);
            ResultSet rs = selectStmt.executeQuery();

            while (rs.next()) {
                String gameId = rs.getString("game_id");
                insertStmt.setString(1, username);
                insertStmt.setString(2, gameId);
                insertStmt.addBatch();
            }
            insertStmt.executeBatch();

            deleteStmt.setString(1, username);
            deleteStmt.executeUpdate();

            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void addToCart(String username, String gameId) {
        String sql = "INSERT IGNORE INTO cart(user_id, game_id) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, gameId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
