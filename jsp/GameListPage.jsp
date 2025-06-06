<%@ page language="java" import="java.sql.*, java.util.*" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ include file="SQLcontants.jsp" %>
<%@ include file="header.jsp" %>
<%@ include file="log.jsp" %>
<%
    writeLog("페이지 접근", request, session);
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>게임 목록</title>
  <link rel="stylesheet" href="../css/common.css">
</head>
<body>
<main>
  <div class="filter-bar">
    <form method="get" action="GameListPage.jsp">
      <select name="category" id="categoryFilter">
        <option value="">장르 선택</option>
        <%
          try {
              Class.forName(jdbc_driver);
              Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
              Statement stmt = conn.createStatement();
              ResultSet rs = stmt.executeQuery("SELECT Name FROM Genre ORDER BY Name");

              while (rs.next()) {
                  String genre = rs.getString("Name");
                  String selected = genre.equals(request.getParameter("category")) ? "selected" : "";
        %>
          <option value="<%= genre %>" <%= selected %>><%= genre %></option>
        <%
              }

              rs.close();
              stmt.close();
              conn.close();
          } catch (Exception e) {
              out.println("<option disabled>장르 불러오기 실패</option>");
          }
        %>
      </select>
      <input type="submit" value="검색">
    </form>
  </div>

  <div class="game-grid">
    <%
      String category = request.getParameter("category");
      String query = "SELECT * FROM Game";
      if (category != null && !category.isEmpty()) {
          query += " WHERE Genre = '" + category + "'";
      }
      query += " ORDER BY ID DESC";

      try {
          Class.forName(jdbc_driver);
          Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
          Statement stmt = conn.createStatement();
          ResultSet rs = stmt.executeQuery(query);

          while (rs.next()) {
              int id = rs.getInt("ID");
              String name = rs.getString("Name");
              String image = rs.getString("Image");
              int price = rs.getInt("Price");
    %>
      <a href="Game_Detail.jsp?id=<%= id %>" class="game-card">
        <img src="<%= image %>" alt="<%= name %>">
        <p class="game-title"><%= name %></p>
        <p class="game-description"><%= price == 0 ? "무료" : price + "원" %></p>
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
