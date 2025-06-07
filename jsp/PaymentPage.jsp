<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ include file="SQLcontants.jsp" %>
<%@ include file="log.jsp" %>
<%
    writeLog("결제 시도", request, session);
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>결제 완료</title>
  <link rel="stylesheet" href="../css/common.css">
</head>
<body>
<%@ include file="header.jsp" %>

<main style="padding: 20px;">
<%
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId != null) {
        try {
            Class.forName(jdbc_driver);
            Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
            Statement stmt = conn.createStatement();

            // 유저의 장바구니 ID 조회
            ResultSet cartRs = stmt.executeQuery("SELECT ID FROM Cart WHERE User_ID = " + userId);
            int cartId = -1;

            if (cartRs.next()) {
                cartId = cartRs.getInt("ID");
            }
            cartRs.close();

            if (cartId != -1) {
                // 장바구니 안의 Game_ID 목록을 수집
                List<Integer> gameIds = new ArrayList<>();
                ResultSet itemsRs = stmt.executeQuery("SELECT Game_ID FROM CartItem WHERE Cart_ID = " + cartId);
                while (itemsRs.next()) {
                    gameIds.add(itemsRs.getInt("Game_ID"));
                }
                itemsRs.close();

                // 현재 시간
                LocalDateTime now = LocalDateTime.now();

                // Purchase 테이블에 삽입
                for (Integer gameId : gameIds) {
                    stmt.executeUpdate("INSERT INTO Purchase (User_ID, Game_ID, PurchaseDate) VALUES (" +
                        userId + ", " + gameId + ", '" + now + "')");
                }

                // 장바구니 비우기
                stmt.executeUpdate("DELETE FROM CartItem WHERE Cart_ID = " + cartId);
            }

            stmt.close();
            conn.close();

            writeLog("결제 완료", request, session);
%>
            <h2>결제가 완료되었습니다!</h2>
            <p>구매해 주셔서 감사합니다.</p>
            <a href="LibraryPage.jsp" class="button">내 라이브러리로 이동</a>
<%
        } catch (Exception e) {
            out.println("<p style='color:red;'>결제 오류: " + e.getMessage() + "</p>");
        }
    } else {
%>
        <script>
            alert("로그인이 필요합니다.");
            location.href = "LoginPage.jsp";
        </script>
<%
    }
%>
</main>
</body>
</html>
