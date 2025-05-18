<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ include file="SQLconstants.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="css/common.css">
</head>
<body>

<%@ include file="header.jsp" %>

<main style="padding: 20px;">
  <%
    String search = request.getParameter("search");

    if (search == null || search.trim().isEmpty()) {
        out.println("<p>검색어가 없습니다.</p>");
    } else {
  %>
    <h2>"<%= search %>"에 대한 검색 결과</h2>
    <div class="game-grid">
    <%
      try {
          Class.forName(jdbc_driver);
          Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
          Statement stmt = conn.createStatement();
          ResultSet rs = stmt.executeQuery("SELECT * FROM Game WHERE Name LIKE '%" + search + "%'");

          boolean hasResult = false;
          while (rs.next()) {
              hasResult = true;
              int id = rs.getInt("ID");
              String name = rs.getString("Name");
              String image = rs.getString("Image");
              int price = rs.getInt("Price");
    %>
      <a href="Game_Detail.jsp?id=<%= id %>" class="game-card">
        <img src="<%= image %>" alt="<%= name %>">
        <p><%= name %></p>
        <p><%= price %>원</p>
      </a>
    <%
          }

          if (!hasResult) {
              out.println("<p>검색 결과가 없습니다.</p>");
          }

          rs.close();
          stmt.close();
          conn.close();
      } catch (Exception e) {
          out.println("<p style='color:red;'>DB 오류: " + e.getMessage() + "</p>");
      }
    %>
    </div>
  <%
    }
  %>
</main>

</body>
</html>
