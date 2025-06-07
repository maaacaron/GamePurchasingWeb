<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ include file="SQLcontants.jsp" %>
<%@ include file="log.jsp" %>
<%
    writeLog("결제 완료", request, session);
%>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId != null) {
        try {
            Class.forName(jdbc_driver);
            Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
            Statement stmt = conn.createStatement();

            // 해당 유저의 Cart ID 조회
            ResultSet cartRs = stmt.executeQuery("SELECT ID FROM Cart WHERE User_ID = " + userId);
            int cartId = -1;
            if (cartRs.next()) {
                cartId = cartRs.getInt("ID");
            }
            cartRs.close();

            // 장바구니에 담긴 게임들 조회
            ResultSet itemsRs = stmt.executeQuery("SELECT Game_ID FROM CartItem WHERE Cart_ID = " + cartId);
            java.sql.Date now = new java.sql.Date(System.currentTimeMillis());

            while (itemsRs.next()) {
                int gameId = itemsRs.getInt("Game_ID");

                // Purchase 테이블에 저장
                stmt.executeUpdate("INSERT INTO Purchase (User_ID, Game_ID, PurchaseDate) VALUES (" + userId + ", " + gameId + ", '" + now + "')");
            }

            itemsRs.close();

            // 장바구니 비우기
            stmt.executeUpdate("DELETE FROM CartItem WHERE Cart_ID = " + cartId);

            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>결제 처리 오류: " + e.getMessage() + "</p>");
        }
    }
%>

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
