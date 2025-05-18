<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="SQLconstants.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="css/common.css">
</head>
<body>

<%@ include file="header.jsp" %>

<%
  String genre = request.getParameter("genre");
  String discount = request.getParameter("discount");
  String priceRange = request.getParameter("priceRange");

  if (genre == null) genre = "";
  if (discount == null) discount = "";
  if (priceRange == null) priceRange = "all";

  int minPrice = 0;
  int maxPrice = Integer.MAX_VALUE;

  if ("0-10000".equals(priceRange)) {
    maxPrice = 10000;
  } else if ("10000-30000".equals(priceRange)) {
    minPrice = 10000;
    maxPrice = 30000;
  } else if ("30000+".equals(priceRange)) {
    minPrice = 30000;
  }
%>

<main style="display: flex; padding: 20px;">
  <!-- 좌측 필터 영역 -->
  <aside class="sidebar">
    <h3>필터</h3>
    <form method="get" action="GameListPage.jsp">
      <input type="hidden" name="genre" value="<%= genre %>">

      <div class="filter-group">
        <label><input type="checkbox" name="discount" value="true" <%= "true".equals(discount) ? "checked" : "" %>> 할인 중인 게임만</label>
      </div>

      <div class="filter-group">
        <label>가격 범위:</label>
        <select name="priceRange">
          <option value="all" <%= "all".equals(priceRange) ? "selected" : "" %>>전체</option>
          <option value="0-10000" <%= "0-10000".equals(priceRange) ? "selected" : "" %>>~10,000원</option>
          <option value="10000-30000" <%= "10000-30000".equals(priceRange) ? "selected" : "" %>>10,000~30,000원</option>
          <option value="30000+" <%= "30000+".equals(priceRange) ? "selected" : "" %>>30,000원 이상</option>
        </select>
      </div>

      <button type="submit">적용</button>
    </form>
  </aside>

  <!-- 우측 게임 목록 -->
  <section class="game-content">
    <h2><%= genre.isEmpty() ? "전체 게임 목록" : "장르: " + genre %></h2>
    <div class="game-grid">
      <%
        try {
            Class.forName(jdbc_driver);
            Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
            Statement stmt = conn.createStatement();

            StringBuilder query = new StringBuilder("SELECT * FROM Game WHERE 1=1");

            if (!genre.isEmpty()) {
                query.append(" AND ID IN (SELECT GameID FROM GameGenre g JOIN Genre gr ON g.GenreID = gr.ID WHERE gr.Name = '").append(genre).append("')");
            }

            if ("true".equals(discount)) {
                query.append(" AND Discount = true");
            }

            query.append(" AND Price BETWEEN ").append(minPrice).append(" AND ").append(maxPrice);

            ResultSet rs = stmt.executeQuery(query.toString());

            boolean hasResult = false;
            while (rs.next()) {
                hasResult = true;
                int id = rs.getInt("ID");
                String name = rs.getString("Name");
                String image = rs.getString("Image");
                int price = rs.getInt("Price");
      %>
        <a href="Game_Detail.jsp?id=<%= id %>" class="game-card">
          <img src="<%= image %>" alt="<%= name %>">
          <h3 class="game-title"><%= name %></h3>
          <p class="game-description"><%= price %>원</p>
        </a>
      <%
            }

            if (!hasResult) {
                out.println("<p>해당 조건의 게임이 없습니다.</p>");
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>DB 오류: " + e.getMessage() + "</p>");
        }
      %>
    </div>
  </section>
</main>

</body>
</html>
