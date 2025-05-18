<%@ page import="dao.UserDAO, model.User" %>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("userId");
    String password = request.getParameter("password");
    String name = request.getParameter("name");
    String email = request.getParameter("email");

    // 중복 확인
    if (UserDAO.isUserIdTaken(userId)) {
%>
        <script>
            alert("이미 사용 중인 아이디입니다.");
            history.back();
        </script>
<%
        return;
    }

    if (UserDAO.isEmailTaken(email)) {
%>
        <script>
            alert("이미 등록된 이메일입니다.");
            history.back();
        </script>
<%
        return;
    }

    // 가입 처리
    User newUser = new User(0, userId, password, name, email, false);
    boolean success = UserDAO.register(newUser);

    if (success) {
%>
        <script>
            alert("회원가입이 완료되었습니다!");
            location.href = "LoginPage.jsp";
        </script>
<%
    } else {
%>
        <script>
            alert("회원가입에 실패했습니다.");
            history.back();
        </script>
<%
    }
%>
