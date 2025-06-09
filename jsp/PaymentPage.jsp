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

            ResultSet cartRs = stmt.executeQuery("SELECT ID FROM Cart WHERE User_ID = " + userId);
            int cartId = -1;
            if (cartRs.next()) {
                cartId = cartRs.getInt("ID");
            }
            cartRs.close();

            ResultSet itemsRs = stmt.executeQuery("SELECT Game_ID FROM CartItem WHERE Cart_ID = " + cartId);
            LocalDate now = java.time.LocalDate.now();

            while (itemsRs.next()) {
                int gameId = itemsRs.getInt("Game_ID");

                // 🔍 라이브러리 중복 여부 확인
                ResultSet checkRs = stmt.executeQuery(
                    "SELECT COUNT(*) FROM Library WHERE User_ID = " + userId + " AND Game_ID = " + gameId
                );
                checkRs.next();
                int count = checkRs.getInt(1);

                if (count == 0) {
                  // ✔️ 존재하지 않을 때만 구매 처리
                  stmt.executeUpdate("INSERT INTO Library (User_ID, Game_ID, PurchaseDate) VALUES (" + userId + ", " + gameId + ", '" + now + "')");

                  // 결제 후 장바구니 비우기
                  stmt.executeUpdate("DELETE FROM CartItem WHERE Cart_ID = " + cartId + " AND Game_ID = " + gameId);
                }
                else
                {
                %>
                  <script>
                    alert("이미 보유중인 게임을 제외한 모든 게임이 구매 완료되었습니다.");
                  </script>
                <%
                }
                checkRs.close();
            }

            itemsRs.close();

            stmt.close();
            conn.close();

            // 결제 완료 메시지
%>
            <script>
                alert("결제가 완료되었습니다!");
                location.href = "LibraryPage.jsp";
            </script>
<%
        } catch (Exception e) {
            //out.println("<p style='color:red;'>결제 오류: " + e.getMessage() + "</p>");
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
