<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ include file="SQLcontants.jsp" %>
<%@ include file="log.jsp" %>
<%
    writeLog("장바구니에서 게임 제거", request, session);
%>


<%
  String userId = (String) session.getAttribute("currentUser");
  String[] removeIds = request.getParameterValues("remove");

  if (userId == null || removeIds == null || removeIds.length == 0) {
      response.sendRedirect("CartPage.jsp");
  } else {
      try {
          Class.forName(jdbc_driver);
          Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
          Statement stmt = conn.createStatement();

          // 유저 ID → 유저 DB 번호 → 카트 ID 확인
          ResultSet userRs = stmt.executeQuery("SELECT ID FROM User WHERE UserID = '" + userId + "'");
          if (userRs.next()) {
              int userDbId = userRs.getInt("ID");
              ResultSet cartRs = stmt.executeQuery("SELECT ID FROM Cart WHERE User_ID = " + userDbId);

              if (cartRs.next()) {
                  int cartId = cartRs.getInt("ID");

                  for (String gameId : removeIds) {
                      stmt.executeUpdate("DELETE FROM CartItem WHERE Cart_ID = " + cartId + " AND Game_ID = " + gameId);
                  }
              }
              cartRs.close();
          }
          userRs.close();
          stmt.close();
          conn.close();
      } catch (Exception e) {
          out.println("<p style='color:red;'>삭제 중 오류 발생: " + e.getMessage() + "</p>");
      }
      response.sendRedirect("CartPage.jsp");
  }
%>
