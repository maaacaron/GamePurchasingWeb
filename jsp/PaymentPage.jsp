<%@ page contentType="text/html;charset=utf8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="../css/common.css">
</head>
<body>

<%@ include file="header.jsp" %>

<main class="login-wrapper">
  <div class="login-box">
    <h2>결제 완료</h2>
    <p>감사합니다. 결제가 완료되었습니다.</p>
    <button onclick="goHome()">메인으로 돌아가기</button>
  </div>
</main>

<script>
  function goHome() {
    window.location.href = 'MainPage.jsp';
  }
</script>

</body>
</html>
