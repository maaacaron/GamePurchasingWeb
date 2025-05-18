<%@ page import="dao.CartDAO" %>
<%
  Integer userId = (Integer) session.getAttribute("userId");
  String gameIdStr = request.getParameter("gameId");

  if (userId == null) {
%>
  <script>
    alert("로그인이 필요합니다.");
    location.href = "LoginPage.jsp";
  </script>
<%
    return;
  }

  if (gameIdStr != null && !gameIdStr.isEmpty()) {
    int gameId = Integer.parseInt(gameIdStr);
    CartDAO.addToCart(userId, gameId);
  }

  response.sendRedirect("CartPage.jsp");
%>
