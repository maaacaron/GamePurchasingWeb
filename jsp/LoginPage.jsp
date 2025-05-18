<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="common.css">
</head>
<body>

  <%@ include file="header.jsp" %>

  <main class="login-wrapper">
    <div class="login-box">
      <form method="post" action="LoginCheck.jsp">
        <div class="login-ID">
          <input type="text" name="userId" placeholder="ID 입력" required />
        </div>
        <div class="login-PW">
          <input type="password" name="password" placeholder="비밀번호 입력" required />
        </div>
        <button type="submit">로그인</button>
      </form>
      <div class="login-links">
        <div class="register">
          <a href="RegisterPage.jsp">회원 가입</a>
        </div>
        <div class="forget-PW">
          <a href="#">비밀번호 찾기</a>
        </div>
      </div>
    </div>
  </main>

</body>
</html>
