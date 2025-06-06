<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ include file="SQLcontants.jsp" %>
<%@ include file="log.jsp" %>
<%
    writeLog("장바구니에 게임 추가", request, session);
%>


<%
  String userId = (String) session.getAttribute("currentUser");
  String gameIdParam = request.getParameter("gameId");

  if (userId == null || userId.isEmpty()) {
%>
    <script>
        alert("로그인이 필요합니다.");
        location.href = "LoginPage.jsp";
    </script>
<%
  } else if (gameIdParam == null || gameIdParam.isEmpty()) {
%>
    <script>
        alert("게임 ID가 유효하지 않습니다.");
        history.back();
    </script>
<%
  } else {
      try {
          Class.forName(jdbc_driver);
          Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
          Statement stmt = conn.createStatement();

          int gameId = Integer.parseInt(gameIdParam);

          // 유저 ID로 유저 DB 번호 가져오기
          ResultSet userRs = stmt.executeQuery("SELECT ID FROM User WHERE UserID = '" + userId + "'");
          if (!userRs.next()) {
%>
    <script>
        alert("유효하지 않은 사용자입니다.");
        location.href = "LoginPage.jsp";
    </script>
<%
          } else {
              int userDbId = userRs.getInt("ID");

              // Cart 존재 확인
              ResultSet cartRs = stmt.executeQuery("SELECT ID FROM Cart WHERE User_ID = " + userDbId);
              int cartId = -1;

              if (cartRs.next()) {
                  cartId = cartRs.getInt("ID");
              } else {
                  // Cart 없으면 새로 생성
                  stmt.executeUpdate("INSERT INTO Cart (User_ID) VALUES (" + userDbId + ")", Statement.RETURN_GENERATED_KEYS);
                  ResultSet genKey = stmt.getGeneratedKeys();
                  if (genKey.next()) {
                      cartId = genKey.getInt(1);
                  }
                  genKey.close();
              }

              cartRs.close();

              // 이미 같은 게임이 담겨 있는지 확인
              ResultSet checkRs = stmt.executeQuery(
                  "SELECT ID FROM CartItem WHERE Cart_ID = " + cartId + " AND Game_ID = " + gameId
              );
              if (!checkRs.next()) {
                  stmt.executeUpdate("INSERT INTO CartItem (Cart_ID, Game_ID) VALUES (" + cartId + ", " + gameId + ")");
              }
              checkRs.close();

              response.sendRedirect("CartPage.jsp");
          }

          userRs.close();
          stmt.close();
          conn.close();
      } catch (Exception e) {
%>
    <script>
        alert("DB 오류 발생: <%= e.getMessage().replace("\"", "'") %>");
        history.back();
    </script>
<%
      }
  }
%>
