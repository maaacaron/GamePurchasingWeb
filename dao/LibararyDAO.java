package dao;

import java.sql.*;
import java.util.*;
import model.Game;
import util.DBUtil;

public class LibraryDAO {

    public static List<Game> getPurchasedGames(String userId) {
        List<Game> list = new ArrayList<>();
        String sql = "SELECT g.id, g.name, g.price, g.image FROM library l JOIN games g ON l.game_id = g.id WHERE l.user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Game game = new Game();
                game.setId(rs.getString("id"));
                game.setName(rs.getString("name"));
                game.setPrice(rs.getInt("price"));
                game.setImage(rs.getString("image"));
                list.add(game);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
