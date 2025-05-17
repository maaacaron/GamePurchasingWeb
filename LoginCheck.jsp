<%@ page import="dao.GameDAO" %>
<%
  request.setCharacterEncoding("UTF-8");
  String username = request.getParameter("username");
  String password = request.getParameter("password");

  boolean isValid = GameDAO.checkLogin(username, password);

  if (isValid) {
    session.setAttribute("currentUser", username);
    response.sendRedirect("MainPage.jsp");
  } else {
%>
    <script>
      alert("아이디 또는 비밀번호가 틀렸습니다.");
      history.back();
    </script>
<%
  }
%>
