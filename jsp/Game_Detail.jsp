<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="model.Game, dao.GameDAO" %>
<%
    String id = request.getParameter("id");
    Game game = null;

    try {
        game = GameDAO.getGameById(Integer.parseInt(id));
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (game == null) {
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
  <link rel="stylesheet" href="common.css">
</head>
<body>

  <%@ include file="header.jsp" %>

  <main style="padding: 30px;">
    <h1><%= game.getName() %></h1>
    <p>장르: <strong><%= game.getGenre() %></strong></p>
    <p>가격: <%= game.getPrice() %>원</p>
    <p><%= game.isDiscount() ? "할인 중!" : "" %></p>

    <img src="<%= game.getImage() %>" alt="<%= game.getName() %>" style="width: 300px; margin-top: 20px;">

    <form method="post" action="AddToCart.jsp">
      <input type="hidden" name="gameId" value="<%= game.getId() %>">
      <button type="submit" class="buy-button" style="margin-top: 20px;">장바구니에 담기</button>
    </form>
  </main>

</body>
</html>
