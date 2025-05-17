<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.Game, dao.GameDAO" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="common.css">
    </head>
    <body>

    <!-- 원래 있었던 위쪽 script부분 header에 넣고 include로 통합-->
    <%@ include file="header.jsp" %>

    <main>
        <div class="main-banner">인기 게임</div>
        <div class="game-grid">
            <%
                List<Game> games = GameDAO.getPopularGames();
                for (Game game : games) {
            %>
                <a href="Game_Detail.jsp?id=<%= game.getId() %>" class="game-card">
                  <img src="<%= game.getImage() %>" alt="<%= game.getName() %>">
                  <p><%= game.getName() %></p>
                </a>
            <%
                }
            %>
        </div>
    </main>

    </body>
</html>