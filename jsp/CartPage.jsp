<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ include file="SQLcontants.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="../css/common.css">
</head>
<body>

<%@ include file="header.jsp" %>
<%@ include file="log.jsp" %>
<%
    writeLog("게임 상세 조회", request, session);
%>

<main>
  <h2>장바구니</h2>

  <%
    String userId = (String) session.getAttribute("currentUser");

    if (userId == null || userId.isEmpty()) {
        out.println("<p style='color:red;'>로그인이 필요합니다.</p>");
    } else {
        try {
            Class.forName(jdbc_driver);
            Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
            Statement stmt = conn.createStatement();

            // 유저 ID를 통해 유저 번호(ID) 조회
            ResultSet userRs = stmt.executeQuery("SELECT ID FROM User WHERE UserID = '" + userId + "'");
            if (!userRs.next()) {
                out.println("<p style='color:red;'>유효하지 않은 사용자입니다.</p>");
            } else {
                int userDbId = userRs.getInt("ID");

                // 유저 ID로 카트 ID 조회
                ResultSet cartRs = stmt.executeQuery("SELECT ID FROM Cart WHERE User_ID = " + userDbId);
                if (!cartRs.next()) {
                    out.println("<p>장바구니가 비어 있습니다.</p>");
                } else {
                    int cartId = cartRs.getInt("ID");

                    // 카트 아이템 조회
                    ResultSet rs = stmt.executeQuery(
                        "SELECT g.ID, g.Name, g.Price " +
                        "FROM CartItem c JOIN Game g ON c.Game_ID = g.ID " +
                        "WHERE c.Cart_ID = " + cartId
                    );

                    int total = 0;
  %>
      <form method="post" action="RemoveCartItems.jsp">
        <ul>
        <%
          while (rs.next()) {
              int gameId = rs.getInt("ID");
              String name = rs.getString("Name");
              int price = rs.getInt("Price");
              total += price;
        %>
          <li>
            <input type="checkbox" name="remove" value="<%= gameId %>">
            <%= name %> - <%= price %>원
          </li>
        <%
          }
        %>
        </ul>
        <p><strong>총 금액: <%= total %>원</strong></p>
        <div class="action-buttons">
          <button type="submit">선택 항목 삭제</button>
          <button formaction="PaymentPage.jsp" formmethod="post">결제하기</button>
          <a href="LibraryPage.jsp"><button type="button">마이페이지</button></a>
        </div>
      </form>
  <%
                    rs.close();
                }
                cartRs.close();
            }
            userRs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>DB 오류: " + e.getMessage() + "</p>");
        }
    }
  %>
</main>

</body>
</html>
