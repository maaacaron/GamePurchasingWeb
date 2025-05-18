<%@ page contentType="text/html;charset=utf8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="css/common.css">
  <style>
    .login-wrapper {
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 300px;
    }
    .login-box {
      background-color: #f5f5f5;
      padding: 40px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      text-align: center;
    }
    .login-box button {
      margin-top: 20px;
      padding: 10px 20px;
      border: none;
      background-color: #ff6b00;
      color: white;
      font-weight: bold;
      border-radius: 6px;
      cursor: pointer;
    }
    .login-box button:hover {
      background-color: #e85e00;
    }
  </style>
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
