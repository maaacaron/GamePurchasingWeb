<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ include file="SQLcontants.jsp" %>

<%
    String id = request.getParameter("id");

    if (id == null || id.trim().isEmpty()) {
%>
    <script>
      alert("게임 ID가 유효하지 않습니다.");
      location.href = "MainPage.jsp";
    </script>
<%
      return;
    }

    String name = "", genre = "", image = "";
    int price = 0;
    boolean discount = false;
    boolean gameFound = false;

    try {
        Class.forName(jdbc_driver);
        Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
        Statement stmt = conn.createStatement();

        String query = "SELECT g.ID, g.Name, g.Price, g.Image, g.Discount, gr.Name AS GenreName " +
                       "FROM Game g " +
                       "LEFT JOIN GameGenre gg ON g.ID = gg.GameID " +
                       "LEFT JOIN Genre gr ON gg.GenreID = gr.ID " +
                       "WHERE g.ID = " + id;

        ResultSet rs = stmt.executeQuery(query);

        if (rs.next()) {
            name = rs.getString("Name");
            price = rs.getInt("Price");
            image = rs.getString("Image");
            discount = rs.getBoolean("Discount");
            genre = rs.getString("GenreName") != null ? rs.getString("GenreName") : "-";
            gameFound = true;
        }

        rs.close();
        stmt.close();
        conn.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    if (!gameFound) {
%>
    <script>
      alert("게임 정보를 찾을 수 없습니다.");
      location.href = "MainPage.jsp";
    </script>
<%
      return;
    }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="../css/common.css">
</head>
<body>

<%@ include file="header.jsp" %>

<main style="padding: 30px;">
  <h1><%= name %></h1>
  <p>장르: <strong><%= genre %></strong></p>
  <p>가격: <%= price %>원</p>
  <p><%= discount ? "할인 중!" : "" %></p>

  <img src="<%= image %>" alt="<%= name %>" style="width: 300px; margin-top: 20px;">

  <form method="post" action="AddToCart.jsp">
    <input type="hidden" name="gameId" value="<%= id %>">
    <button type="submit" class="buy-button" style="margin-top: 20px;">장바구니에 담기</button>
  </form>
</main>

</body>
</html>
