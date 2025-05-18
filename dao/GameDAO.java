package dao;

import model.Game;
import model.Post;
import util.DBUtil;

import java.sql.*;
import java.util.*;

public class GameDAO {

    // 인기 게임 6개
    public static List<Game> getPopularGames() {
        String sql = """
            SELECT g.*, ge.Name AS GenreName
            FROM Game g
            LEFT JOIN GameGenre gg ON g.ID = gg.GameID
            LEFT JOIN Genre ge ON gg.GenreID = ge.ID
            ORDER BY g.ID DESC
            LIMIT 6
        """;
        return getGames(sql);
    }

    // 장르별 게임
    public static List<Game> getGamesByGenre(String genreName) {
        String sql = """
            SELECT g.*, ge.Name AS GenreName
            FROM Game g
            JOIN GameGenre gg ON g.ID = gg.GameID
            JOIN Genre ge ON gg.GenreID = ge.ID
            WHERE ge.Name = ?
        """;
        List<Game> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, genreName);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(extractGame(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 모든 장르 조회
    public static List<String> getAllGenres() {
        List<String> genres = new ArrayList<>();
        String sql = "SELECT Name FROM Genre ORDER BY Name";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                genres.add(rs.getString("Name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return genres;
    }

    // 키워드 검색
    public static List<Game> searchGames(String keyword) {
        String sql = """
            SELECT g.*, ge.Name AS GenreName
            FROM Game g
            LEFT JOIN GameGenre gg ON g.ID = gg.GameID
            LEFT JOIN Genre ge ON gg.GenreID = ge.ID
            WHERE g.Name LIKE ?
        """;
        List<Game> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(extractGame(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ID로 게임 조회
    public static Game getGameById(int id) {
        String sql = """
            SELECT g.*, ge.Name AS GenreName
            FROM Game g
            LEFT JOIN GameGenre gg ON g.ID = gg.GameID
            LEFT JOIN Genre ge ON gg.GenreID = ge.ID
            WHERE g.ID = ?
        """;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractGame(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 가격/할인/장르 필터
    public static List<Game> filterGames(String genre, String discount, int minPrice, int maxPrice) {
        StringBuilder sql = new StringBuilder("""
            SELECT g.*, ge.Name AS GenreName
            FROM Game g
            LEFT JOIN GameGenre gg ON g.ID = gg.GameID
            LEFT JOIN Genre ge ON gg.GenreID = ge.ID
            WHERE 1=1
        """);

        List<Object> params = new ArrayList<>();

        if (genre != null && !genre.isEmpty()) {
            sql.append(" AND ge.Name = ?");
            params.add(genre);
        }

        if ("true".equals(discount)) {
            sql.append(" AND g.Discount = 1");
        }

        sql.append(" AND g.Price BETWEEN ? AND ?");
        params.add(minPrice);
        params.add(maxPrice);

        List<Game> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof String s) stmt.setString(i + 1, s);
                else if (p instanceof Integer v) stmt.setInt(i + 1, v);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                list.add(extractGame(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ResultSet → Game 변환
    private static Game extractGame(ResultSet rs) throws SQLException {
        return new Game(
            rs.getInt("ID"),
            rs.getString("Name"),
            rs.getString("Image"),
            rs.getString("GenreName"),
            rs.getInt("Price"),
            rs.getBoolean("Discount")
        );
    }

    // 기본 SELECT용 도우미 메서드
    private static List<Game> getGames(String sql) {
        List<Game> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(extractGame(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 커뮤니티 글 전체 조회
    public static List<Post> getAllPosts() {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT * FROM Post ORDER BY ID DESC";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Post post = new Post();
                post.setId(rs.getInt("ID"));
                post.setTitle(rs.getString("Title"));
                post.setAuthor(rs.getString("User_ID"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                posts.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return posts;
    }
}
