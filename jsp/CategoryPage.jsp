<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ include file="SQLcontants.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>카테고리</title>
  <link rel="stylesheet" href="../css/common.css">
</head>
<body>

<%@ include file="header.jsp" %>
<%@ include file="log.jsp" %>
<%
    writeLog("페이지 접근", request, session);
%>

<main>
  <br>
  <div class="genre-grid" id="genreGrid">
  </div>
</main>
    <%
      try {
          Class.forName(jdbc_driver);
          Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
          Statement stmt = conn.createStatement();
          ResultSet rs = stmt.executeQuery("SELECT Name FROM Genre ORDER BY Name");

    %>
      <script>

        const genreGrid = document.getElementById('genreGrid');

        function loadGenres() {
    <%
          while (rs.next()) {
            String genre = rs.getString("Name");
    %>      
            var genreButton = document.createElement('button');
            genreButton.className = 'genre-button';
            genreButton.innerText = "<%= genre %>";
            genreGrid.appendChild(genreButton);

            // 클릭 이벤트로 이동 처리
            genreButton.onclick = () => {
                window.location.href = 'GameListPage.jsp?genre=' + encodeURIComponent("<%= genre %>");
            };
    <%
          }
    %>
        }
        loadGenres();  // 페이지 로드 시 장르 버튼들 생성
    <%

        rs.close();
        stmt.close();
        conn.close();
      } catch (Exception e) {
          out.println("<p style='color:red;'>DB 오류: " + e.getMessage() + "</p>");
      }
    %>
      </script>

</body>
</html>
