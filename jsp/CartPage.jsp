<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.CartItem, dao.CartDAO" %>
<%
    Integer userId = (Integer) session.getAttribute("userId"); // 세션에 저장된 사용자 ID
    if (userId == null) {
%>
    <script>
        alert("로그인이 필요합니다.");
        location.href = "LoginPage.jsp";
    </script>
<%
        return;
    }

    List<CartItem> cartItems = CartDAO.getCartItems(userId);
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="common.css">
  <style>
    .action-buttons button {
      margin-right: 12px;
      background-color: #ff6b00;
      color: white;
      border: none;
      padding: 10px 16px;
      border-radius: 6px;
      cursor: pointer;
    }
    .action-buttons button:hover {
      background-color: #e85e00;
    }
  </style>
</head>
<body>

  <%@ include file="header.jsp" %>

  <main>
    <h2>장바구니</h2>
    <%
      if (cartItems.isEmpty()) {
    %>
        <p>장바구니가 비어 있습니다.</p>
    <%
      } else {
    %>
    <form method="post" action="RemoveCartItems.jsp">
      <ul>
        <%
          int total = 0;
          for (CartItem item : cartItems) {
            total += item.getGame().getPrice();
        %>
          <li>
            <input type="checkbox" name="remove" value="<%= item.getGame().getId() %>">
            <%= item.getGame().getName() %> - <%= item.getGame().getPrice() %>원
          </li>
        <%
          }
        %>
      </ul>
      <p><strong>총 금액: <%= total %>원</strong></p>
      <div class="action-buttons">
        <button type="submit">선택 삭제</button>
        <button formaction="PaymentPage.jsp" formmethod="post">결제하기</button>
      </div>
    </form>
    <%
      }
    %>
  </main>

</body>
</html>
