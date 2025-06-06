<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ include file="SQLcontants.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="../css/common.css">
</head>
<body>

<%@ include file="header.jsp" %>
<%@ include file="log.jsp" %>
<%
  writeLog("페이지 접근", request, session);
%>

<%
  String[] genres = request.getParameterValues("genre");
  if (genres == null) genres = new String[0];

  String discount = request.getParameter("discount");
  if (discount == null) discount = "";

  String genreMode = request.getParameter("genreMode");
  if (genreMode == null) genreMode = "or";  // 기본값은 OR

  String minPriceS = request.getParameter("minPrice");
  String maxPriceS = request.getParameter("maxPrice");

  int minPrice = (minPriceS != null && !minPriceS.isEmpty()) ? Integer.parseInt(minPriceS) : 0;
  int maxPrice = (maxPriceS != null && !maxPriceS.isEmpty()) ? Integer.parseInt(maxPriceS) : 200000;


%>

<main style="display: flex; padding: 20px;">
  <!-- 좌측 필터 영역 -->
  <aside class="sidebar">
    <h3>필터</h3>
    <form method="get" action="GameListPage.jsp">
      <div class="filter-group">
        <label><input type="checkbox" name="discount" value="true" <%= "true".equals(discount) ? "checked" : "" %>> 할인 중인 게임만</label>
      </div>

      <div class="filter-group">
        <label>장르 조건:</label><br>
        <label><input type="radio" name="genreMode" value="or" <%= "or".equals(genreMode) ? "checked" : "" %>> OR 조건</label><br>
        <label><input type="radio" name="genreMode" value="and" <%= "and".equals(genreMode) ? "checked" : "" %>> AND 조건</label>
      </div>


      <div class="filter-group">
        <label>장르 선택:</label>
      <%
        try {
          Class.forName(jdbc_driver);
          Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
          Statement stmt = conn.createStatement();

          StringBuilder query = new StringBuilder("SELECT Name FROM Genre ORDER BY Name");

          ResultSet rs = stmt.executeQuery(query.toString());

          while (rs.next()) {
            String genreName = rs.getString("Name");
            if(java.util.Arrays.asList(genres).contains(genreName))
            {
        %>
            <label><input type="checkbox" name="genre" value="<%= genreName %>" checked> <%= genreName %></label>
        <%
            } else { 
        %>
            <label><input type="checkbox" name="genre" value="<%= genreName %>"> <%= genreName %></label>
        <%
            }
          }

          rs.close();
          stmt.close();
          conn.close();
        } catch (Exception e) {
            out.println("<option disabled>장르 불러오기 실패</option>");
        }
        %>
      </div>


      <div class="filter-group">
        <label>가격 범위:</label>
        <input type="range" id="minPrice" name="minPrice" min="0" max="200000" step="1000" value="<%= minPrice %>">
        <p id="minPriceLabel">최소: <%= minPrice %>원</p>

        <input type="range" id="maxPrice" name="maxPrice" min="0" max="200000" step="1000" value="<%= maxPrice %>">
        <p id="maxPriceLabel">최대: <%= maxPrice %>원</p>
      </div>

      <button type="submit">적용</button>
    </form>
    <script>
      const minSlider = document.getElementById('minPrice');
      const maxSlider = document.getElementById('maxPrice');
      const minLabel = document.getElementById('minPriceLabel');
      const maxLabel = document.getElementById('maxPriceLabel');

      minSlider.addEventListener('input', () => {
        minLabel.textContent = '최소: ' + minSlider.value + '원';
      });

      maxSlider.addEventListener('input', () => {
        maxLabel.textContent = '최대: ' + maxSlider.value + '원';
      });
    </script>
  </aside>

  <!-- 우측 게임 목록 -->
  <section class="game-content">
    <h2><%= genres.length == 0 ? "전체 게임 목록" : "장르: " + String.join(", ", genres) %></h2>
    <div class="game-grid">
      <%
        try {
          Class.forName(jdbc_driver);
          Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
          Statement stmt = conn.createStatement();

          StringBuilder query = new StringBuilder("SELECT * FROM Game WHERE 1=1");

          if (genres.length > 0) {
            if ("or".equals(genreMode)) {
              query.append(" AND ID IN (SELECT GameID FROM GameGenre g JOIN Genre gr ON g.GenreID = gr.ID WHERE gr.Name IN (");
              for (int i = 0; i < genres.length; i++) {
                query.append("'").append(genres[i]).append("'");
                if (i < genres.length - 1) query.append(", ");
              }
              query.append("))");
            } else if ("and".equals(genreMode)) {
              for (String g : genres) {
                query.append(" AND ID IN (SELECT GameID FROM GameGenre g JOIN Genre gr ON g.GenreID = gr.ID WHERE gr.Name = '")
                     .append(g).append("')");
              }
            }
          }

          if ("true".equals(discount)) {
            query.append(" AND Discount = 1");
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
          <p class="game-description"><%= (price == 0 ? "무료" : price + "원") %></p>
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
