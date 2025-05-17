<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Game, dao.GameDAO" %>
<%
  request.setCharacterEncoding("UTF-8");
  String keyword = request.getParameter("search");

  List<Game> results = new ArrayList<>();
  if (keyword != null && !keyword.trim().isEmpty()) {
    results = GameDAO.searchGames(keyword);
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="common.css">
</head>
<body>

  <%@ include file="header.jsp" %>

  <main style="padding: 30px;">
    <h2>검색 결과</h2>

    <%
      if (keyword == null || keyword.trim().isEmpty()) {
    %>
      <p>검색어가 없습니다.</p>
    <%
      } else if (results.isEmpty()) {
    %>
      <p>"<%= keyword %>"에 대한 결과가 없습니다.</p>
    <%
      } else {
    %>
      <p>"<%= keyword %>"에 대한 검색 결과입니다.</p>
      <div class="game-grid">
        <% for (Game game : results) { %>
          <a href="Game_Detail.jsp?id=<%= game.getId() %>" class="game-card">
            <img src="<%= game.getImage() %>" alt="<%= game.getName() %>">
            <p><%= game.getName() %></p>
          </a>
        <% } %>
      </div>
    <%
      }
    %>
  </main>

</body>
</html>
