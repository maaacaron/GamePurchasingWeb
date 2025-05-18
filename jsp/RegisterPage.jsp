<%@ page contentType="text/html;charset=utf8" language="java" %>
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
      <h2>회원가입</h2>
      <form method="post" action="RegisterCheck.jsp">
        <div class="login-ID">
          <input type="name" name="name" placeholder="이름 입력" required />
        </div>
        <div class="login-ID">
          <input type="text" name="userID" placeholder="ID 입력" required />
        </div>
        <div class="login-PW">
          <input type="password" name="PassWord" placeholder="비밀번호 입력" required />
        </div>
        <div class="login-EM">
          <input type="Email" name="Email" placeholder="이메일 입력" required />
        </div>
        <button type="submit">가입하기</button>
      </form>
      <div class="login-links">
        <a href="LoginPage.jsp">로그인으로 이동</a>
      </div>
    </div>
  </main>

</body>
</html>
