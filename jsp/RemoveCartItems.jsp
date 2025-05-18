<%@ page import="java.util.*, dao.CartDAO" %>
<%
  Integer userId = (Integer) session.getAttribute("userId");
  String[] selected = request.getParameterValues("remove");

  if (userId == null) {
%>
  <script>
    alert("로그인이 필요합니다.");
    location.href = "LoginPage.jsp";
  </script>
<%
    return;
  }

  if (selected != null && selected.length > 0) {
    List<Integer> gameIds = new ArrayList<>();
    for (String idStr : selected) {
      gameIds.add(Integer.parseInt(idStr));
    }
    CartDAO.removeFromCart(userId, gameIds);
  }

  response.sendRedirect("CartPage.jsp");
%>
