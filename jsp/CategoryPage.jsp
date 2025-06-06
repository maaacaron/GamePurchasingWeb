<%@ page language="java" import="java.sql.*" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="SQLcontants.jsp" %>
<%@ include file="header.jsp" %>
<main>
  <section class="filter">
    <h2>필터</h2>
    <form method="get" action="GameListPage.jsp">
      <label>장르 선택</label>
      <select name="genre">
        <option value="">전체</option>
        <%
          try {
              Class.forName(jdbc_driver);
              Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
              Statement stmt = conn.createStatement();
              ResultSet rs = stmt.executeQuery("SELECT Name FROM Genre");

              while (rs.next()) {
                  String genre = rs.getString("Name");
        %>
                  <option value="<%= genre %>"><%= genre %></option>
        <%
              }

              rs.close();
              stmt.close();
              conn.close();
          } catch (Exception e) {
              out.println("<p style='color:red;'>장르 로딩 오류: " + e.getMessage() + "</p>");
          }
        %>
      </select>

      <label>가격 범위</label>
      <input type="range" name="minPrice" id="minPrice" min="0" max="100000" step="1000" oninput="minOutput.value = minPrice.value">
      <output id="minOutput">0</output>원

      <input type="range" name="maxPrice" id="maxPrice" min="0" max="100000" step="1000" value="100000" oninput="maxOutput.value = maxPrice.value">
      <output id="maxOutput">100000</output>원

      <button type="submit">적용</button>
    </form>
  </section>

  <section class="genre-view">
    <h2>장르별 게임 보기</h2>
    <div class="genre-grid">
      <%
        try {
            Class.forName(jdbc_driver);
            Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT Name FROM Genre");

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
            out.println("<p style='color:red;'>장르 로딩 오류: " + e.getMessage() + "</p>");
        }
      %>
    </div>
  </section>
</main>
