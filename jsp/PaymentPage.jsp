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
  
  CartDAO.purchaseCart(currentUser);
%>
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
      <h2>결제 완료</h2>
      <p>감사합니다. 결제가 완료되었습니다.</p>
      <button onclick="location.href='MainPage.jsp'">메인으로 돌아가기</button>
    </div>
  </main>

</body>
</html>
