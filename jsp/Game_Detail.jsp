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
    alert("게임을 찾을 수 없습니다.");
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

  <main>
    <h1 id="game-title"><%= game.getName() %></h1>

    <div class="game-detail">
      <img id="game-image" src="<%= game.getImage() %>" alt="<%= game.getName() %>">

      <div class="game-info">
        <p id="game-description"><%= game.getDescription() %></p>
        <div id="rating-stars">
          <!-- 평점 임시 -->
          <p>평점: ⭐⭐⭐⭐☆ (4.2)</p>
        </div>
        <p id="game-price"><strong>가격:</strong> <%= game.getPrice() %>원</p>

        <form method="post" action="AddToCart.jsp">
          <input type="hidden" name="gameId" value="<%= game.getId() %>">
          <button type="submit" id="buy-button" class="buy-button">
            <%= game.getPrice() %>원 장바구니에 담기
          </button>
        </form>
      </div>
    </div>
  </main>

</body>
</html>
