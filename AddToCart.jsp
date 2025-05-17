<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dao.CartDAO" %>
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

  String gameId = request.getParameter("gameId");

  if (gameId != null && !gameId.isEmpty()) {
    CartDAO.addToCart(currentUser, gameId);
  }

  response.sendRedirect("CartPage.jsp");
%>
