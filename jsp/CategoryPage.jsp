<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, dao.GameDAO" %>
<%
  List<String> genres = GameDAO.getAllGenres();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="common.css">
</head>
<body>

  <%@ include file="header.jsp" %>

  <main>
    <h2 style="padding: 30px;">장르별 게임 보기</h2>
    <div class="genre-grid">
      <%
        for (String genre : genres) {
      %>
        <form action="GameListPage.jsp" method="get" style="margin: 0;">
          <input type="hidden" name="genre" value="<%= genre %>">
          <button type="submit" class="genre-button"><%= genre %></button>
        </form>
      <%
        }
      %>
    </div>
  </main>

</body>
</html>
