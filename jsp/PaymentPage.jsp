<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ include file="SQLcontants.jsp" %>
<%@ include file="log.jsp" %>
<%
    writeLog("결제 완료", request, session);
%>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    String[] gameIds = request.getParameterValues("remove");
    if (userId != null && gameIds != null) {
        try {
            Class.forName(jdbc_driver);
            Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);

            ResultSet cartRs = null;
            int cartId = -1;
            PreparedStatement cartStmt = conn.prepareStatement("SELECT ID FROM Cart WHERE User_ID = ?");
            cartStmt.setInt(1, userId);
            cartRs = cartStmt.executeQuery();
            if (cartRs.next()) {
                cartId = cartRs.getInt("ID");
            }
            cartRs.close();
            cartStmt.close();

            LocalDate now = java.time.LocalDate.now();

            for (String gid : gameIds) {
                int gameId = Integer.parseInt(gid);

                // 라이브러리 중복 여부 확인
                PreparedStatement psCheck = conn.prepareStatement(
                    "SELECT COUNT(*) FROM Library WHERE User_ID = ? AND Game_ID = ?"
                );
                psCheck.setInt(1, userId);
                psCheck.setInt(2, gameId);
                ResultSet checkRs = psCheck.executeQuery();
                checkRs.next();
                int count = checkRs.getInt(1);

                if (count == 0) {
                    // 존재하지 않을 때만 구매 처리
                    PreparedStatement psInsert = conn.prepareStatement(
                        "INSERT INTO Library (User_ID, Game_ID, PurchaseDate) VALUES (?, ?, ?)"
                    );
                    psInsert.setInt(1, userId);
                    psInsert.setInt(2, gameId);
                    psInsert.setString(3, now.toString());
                    psInsert.executeUpdate();
                    psInsert.close();

                    // 결제 후 장바구니 비우기
                    PreparedStatement psDelete = conn.prepareStatement(
                        "DELETE FROM CartItem WHERE Cart_ID = ? AND Game_ID = ?"
                    );
                    psDelete.setInt(1, cartId);
                    psDelete.setInt(2, gameId);
                    psDelete.executeUpdate();
                    psDelete.close();
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
                psCheck.close();
            }
            conn.close();

        } catch (Exception e) {
            out.println("<p style='color:red;'>결제 오류: " + e.getMessage() + "</p>");
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
