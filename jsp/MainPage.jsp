<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ include file="SQLcontants.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="css/common.css">
</head>
<body>

<%@ include file="header.jsp" %>

<main>
  <div class="main-banner">인기 게임</div>
  <div class="game-grid" id="gameGrid">
    <%
      try {
          Class.forName(jdbc_driver);
          Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
          Statement stmt = conn.createStatement();
          ResultSet rs = stmt.executeQuery("SELECT ID, Name, Image FROM Game ORDER BY ID DESC LIMIT 8");

          while (rs.next()) {
              int id = rs.getInt("ID");
              String name = rs.getString("Name");
              String image = rs.getString("Image");
    %>
      <a href="Game_Detail.jsp?id=<%= id %>" class="game-card">
        <img src="<%= image %>" alt="<%= name %>">
        <p><%= name %></p>
      </a>
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
