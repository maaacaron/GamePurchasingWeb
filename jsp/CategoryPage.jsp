<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.sql.*" %>
<%@ include file="SQLcontants.jsp" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="css/common.css">
  <style>
    .genre-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 12px;
      padding: 30px;
    }
    .genre-button {
      background-color: #333;
      color: white;
      border: none;
      padding: 12px;
      font-weight: bold;
      cursor: pointer;
      border-radius: 8px;
    }
    .genre-button:hover {
      background-color: orange;
    }
  </style>
</head>
<body>

<main>
  <h2 style="padding: 30px;">장르별 게임 보기</h2>

  <div class="genre-grid">
    <%
      try {
          Class.forName(jdbc_driver);
          Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
          Statement stmt = conn.createStatement();
          ResultSet rs = stmt.executeQuery("SELECT Name FROM Genre ORDER BY Name");

          while (rs.next()) {
              String genre = rs.getString("Name");
    %>
              <button class="genre-button" onclick="location.href='GameListPage.jsp?genre=<%= genre %>'"><%= genre %></button>
    <%
          }

          rs.close();
          stmt.close();
          conn.close();
      } catch (Exception e) {
          out.println("<p style='color:red;'>장르 불러오기 오류: " + e.getMessage() + "</p>");
      }
    %>
  </div>
</main>

</body>
</html>
