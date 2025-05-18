<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Game, dao.GameDAO" %>
<%
    request.setCharacterEncoding("UTF-8");

    String genre = request.getParameter("genre");
    String discount = request.getParameter("discount");
    String minStr = request.getParameter("minPrice");
    String maxStr = request.getParameter("maxPrice");

    int minPrice = (minStr != null && !minStr.isEmpty()) ? Integer.parseInt(minStr) : 0;
    int maxPrice = (maxStr != null && !maxStr.isEmpty()) ? Integer.parseInt(maxStr) : 999999;

    List<Game> games = GameDAO.filterGames(genre, discount, minPrice, maxPrice);
    List<String> genreList = GameDAO.getAllGenres();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="common.css">
</head>
<body>

  <%@ include file="header.jsp" %>

  <main style="display: flex; padding: 20px;">
    <!-- 왼쪽 필터 영역-->
    <aside class="sidebar">
      <h3>필터</h3>
      <form method="get" action="GameListPage.jsp">
        <div class="filter-group">
          <label><input type="checkbox" name="discount" value="true" <%= "true".equals(discount) ? "checked" : "" %>> 할인 중</label>
        </div>

        <div class="filter-group">
          <label>장르:</label>
          <select name="genre">
            <option value="">전체</option>
            <%
              for (String g : genreList) {
            %>
              <option value="<%= g %>" <%= g.equals(genre) ? "selected" : "" %>><%= g %></option>
            <%
              }
            %>
          </select>
        </div>

        <div class="filter-group">
          <label>가격 범위:</label>
          <input type="number" name="minPrice" value="<%= minPrice %>" style="width: 80px;"> 원 ~
          <input type="number" name="maxPrice" value="<%= maxPrice %>" style="width: 80px;"> 원
        </div>

        <button type="submit">적용</button>
      </form>
    </aside>

    <!--게임 목록-->
    <section class="game-content">
      <h2><%= (genre != null && !genre.isEmpty()) ? "장르: " + genre : "전체 게임 목록" %></h2>
      <div class="game-grid">
        <%
          if (games.isEmpty()) {
        %>
          <p>해당 조건의 게임이 없습니다.</p>
        <%
          } else {
            for (Game game : games) {
        %>
          <a href="Game_Detail.jsp?id=<%= game.getId() %>" class="game-card">
            <img src="<%= game.getImage() %>" alt="<%= game.getName() %>">
            <p><%= game.getName() %> (<%= game.getGenre() %>)</p>
          </a>
        <%
            }
          }
        %>
      </div>
    </section>
  </main>

</body>
</html>
