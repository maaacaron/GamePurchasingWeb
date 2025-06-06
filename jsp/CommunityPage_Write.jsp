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

<main>

    <form method="post">
        <!-- 여기서 title이랑 content 값 저장해서 버튼으로 request 보내주면 됨-->
    </form>

<%
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    if (title != null && content != null) {
        try {
            Class.forName(jdbc_driver);
            Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
            Statement stmt = conn.createStatement();

            String sql = "INSERT INTO post (title, content) VALUES ('" + 
                         title.replace("'", "''") + "', '" + 
                         content.replace("'", "''") + "', NOW())";

            stmt.executeUpdate(sql);

            stmt.close();
            conn.close();

            out.println("<script>alert('게시글이 저장되었습니다.'); location.href='CommunityPage.jsp';</script>");
        } catch (Exception e) {
            out.println("<p style='color:red;'>DB 오류: " + e.getMessage() + "</p>");
        }
    }
%>
</main>
</body>
</html>
