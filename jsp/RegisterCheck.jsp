<%@ page import="dao.UserDAO" %>
<%
  request.setCharacterEncoding("UTF-8");
  String username = request.getParameter("username");
  String password = request.getParameter("password");

  boolean exists = UserDAO.exists(username);
  if (exists) {
%>
    <script>
      alert("이미 존재하는 아이디입니다.");
      history.back();
    </script>
<%
  } else {
    boolean success = UserDAO.insertUser(username, password);
    if (success) {
      session.setAttribute("currentUser", username);
      response.sendRedirect("LoginPage.jsp");
    } else {
%>
      <script>
        alert("회원가입 실패");
        history.back();
      </script>
<%
    }
  }
%>
