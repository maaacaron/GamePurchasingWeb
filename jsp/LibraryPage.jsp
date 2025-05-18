<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="SQLcontants.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>내 라이브러리</title>
  <link rel="stylesheet" href="css/common.css">
</head>
<body>

<%@ include file="header.jsp" %>

<main>
  <h2>내 라이브러리</h2>

  <%
    String userId = (String) session.getAttribute("currentUser");

    if (userId == null || userId.isEmpty()) {
        out.println("<p style='color:red;'>로그인이 필요합니다.</p>");
    } else {
        try {
            Class.forName(jdbc_driver);
            Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
            Statement stmt = conn.createStatement();

            // 유저 ID → 유저 번호(ID) 조회
            ResultSet userRs = stmt.executeQuery("SELECT ID FROM User WHERE UserID = '" + userId + "'");
            if (userRs.next()) {
                int userDbId = userRs.getInt("ID");

                // 구매 기록 (라이브러리) 조회
                ResultSet rs = stmt.executeQuery(
                    "SELECT g.ID, g.Name, g.Image, g.Price " +
                    "FROM Library l JOIN Game g ON l.Game_ID = g.ID " +
                    "WHERE l.User_ID = " + userDbId
                );

                boolean hasGame = false;
                out.println("<div class='game-grid'>");

                while (rs.next()) {
                    hasGame = true;
                    int id = rs.getInt("ID");
                    String name = rs.getString("Name");
                    String image = rs.getString("Image");
                    int price = rs.getInt("Price");
  %>
    <a href="Game_Detail.jsp?id=<%= id %>" class="game-card">
      <img src="<%= image %>" alt="<%= name %>">
      <p><%= name %></p>
      <p><%= price %>원</p>
    </a>
  <%
                }

                out.println("</div>");

                if (!hasGame) {
                    out.println("<p>보유한 게임이 없습니다.</p>");
                }

                rs.close();
            } else {
                out.println("<p>사용자 정보를 찾을 수 없습니다.</p>");
            }

            userRs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>DB 오류: " + e.getMessage() + "</p>");
        }
    }
  %>
</main>

</body>
</html>
