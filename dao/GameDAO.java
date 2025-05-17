package dao;

import model.Game;
import java.sql.*;
import java.util.*;

public class GameDAO {

    public static List<Game> getPopularGames() {
        return getGames("SELECT * FROM games ORDER BY popularity DESC LIMIT 6");
    }

    public static List<Game> getGamesByGenre(String genre) {
        return getGames("SELECT * FROM games WHERE genre = '" + genre + "'");
    }

    public static List<String> getAllGenres() {
        List<String> genres = new ArrayList<>();
        String sql = "SELECT DISTINCT genre FROM games ORDER BY genre";
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                genres.add(rs.getString("genre"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return genres;
    }
    

    public static List<Game> searchGames(String keyword) {
        List<Game> list = new ArrayList<>();
        String sql = "SELECT * FROM games WHERE name LIKE ?";
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
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



    public static Game getGameById(int id) {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM games WHERE id = ?")) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractGame(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    private static List<Game> getGames(String query) {
        List<Game> list = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                list.add(extractGame(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    private static Game extractGame(ResultSet rs) throws SQLException {
        return new Game(
            rs.getInt("id"),
            rs.getString("name"),
            rs.getString("image"),
            rs.getString("link"),
            rs.getString("description"),
            rs.getString("genre"),
            rs.getInt("price"),
            rs.getBoolean("discount")
        );
    }


    public static List<Game> filterGames(String genre, String discount, int minPrice, int maxPrice) {
        List<Game> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM games WHERE 1=1");

        if (genre != null && !genre.isEmpty()) {
            sql.append(" AND genre = '").append(genre).append("'");
        }

        if ("true".equals(discount)) {
            sql.append(" AND discount = true");
        }

        sql.append(" AND price BETWEEN ").append(minPrice).append(" AND ").append(maxPrice);

        return getGames(sql.toString());
    }


    public static List<String> getAllGenres() {
        List<String> genres = new ArrayList<>();
        String sql = "SELECT DISTINCT genre FROM games ORDER BY genre";
        try (Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                genres.add(rs.getString("genre"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return genres;
    }



    public static List<Post> getAllPosts() {
        List<Post> posts = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM posts ORDER BY created_at DESC")) {

            while (rs.next()) {
                Post post = new Post();
                post.setId(rs.getInt("id"));
                post.setTitle(rs.getString("title"));
                post.setAuthor(rs.getString("author"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                posts.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return posts;
    }
}