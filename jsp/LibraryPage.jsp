<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Game, dao.LibraryDAO" %>
<%
  String currentUser = (String) session.getAttribute("currentUser");
  if (currentUser == null) {
%>
  <script>
    alert("로그인이 필요합니다.");
    location.href = "LoginPage.jsp";
  </script>
<%
    return;
  }

  List<Game> games = LibraryDAO.getPurchasedGames(currentUser);
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
    <h2>내 라이브러리</h2>

    <%
      if (games.isEmpty()) {
    %>
      <p>보유한 게임이 없습니다.</p>
    <%
      } else {
    %>
      <div class="game-grid">
        <% for (Game game : games) { %>
          <div class="game-card">
            <img src="<%= game.getImage() %>" alt="<%= game.getName() %>">
            <p><%= game.getName() %></p>
          </div>
        <% } %>
      </div>
    <%
      }
    %>
  </main>

</body>
</html>
