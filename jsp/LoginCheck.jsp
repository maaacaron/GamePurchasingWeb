<%@ page import="dao.UserDAO, model.User" %>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("userId");
    String password = request.getParameter("password");

    User user = UserDAO.checkLogin(userId, password);

    if (user != null) {
        // 세션에 유저 정보 저장
        session.setAttribute("userId", user.getId());
        session.setAttribute("userName", user.getName());
        session.setAttribute("isAdmin", user.isAdmin());
%>
        <script>
            alert("로그인 성공!");
            location.href = "MainPage.jsp";
        </script>
<%
    } else {
%>
        <script>
            alert("아이디 또는 비밀번호가 잘못되었습니다.");
            history.back();
        </script>
<%
    }
%>
