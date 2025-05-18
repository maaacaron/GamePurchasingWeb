<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Game, dao.LibraryDAO" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
%>
    <script>
        alert("로그인이 필요합니다.");
        location.href = "LoginPage.jsp";
    </script>
<%
        return;
    }

    List<Game> games = LibraryDAO.getLibraryGames(userId);
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
    <h2>내 게임 라이브러리</h2>
    <div class="game-grid">
      <%
        if (games.isEmpty()) {
      %>
        <p>아직 구매한 게임이 없습니다.</p>
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
  </main>

</body>
</html>
