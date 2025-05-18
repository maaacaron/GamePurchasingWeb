<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="SQLconstants.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>카테고리</title>
  <link rel="stylesheet" href="css/common.css">
</head>
<body>

<%@ include file="header.jsp" %>

<main>
  <h2 style="padding: 30px;">장르별 게임 보기</h2>
  <div class="genre-buttons">
    <%
      try {
          Class.forName(jdbc_driver);
          Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
          Statement stmt = conn.createStatement();
          ResultSet rs = stmt.executeQuery("SELECT Name FROM Genre ORDER BY Name");

          while (rs.next()) {
              String genre = rs.getString("Name");
    %>
        <a href="GameListPage.jsp?genre=<%= genre %>"><%= genre %></a>
    <%
          }

          rs.close();
          stmt.close();
          conn.close();
      } catch (Exception e) {
          out.println("<p style='color:red;'>DB 오류: " + e.getMessage() + "</p>");
      }
    %>
  </div>
</main>

</body>
</html>
