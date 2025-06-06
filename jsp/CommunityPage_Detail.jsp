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
<%
    String idPar = request.getParameter("id");
    String title = null;
    String content = null;

    try {
        int id = Integer.parseInt(idParam);
        Class.forName(jdbc_driver);
        Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
        Statement stmt = conn.createStatement();

        ResultSet rs = stmt.executeQuery("SELECT title, content FROM Post WHERE id = " + id);

        if (rs.next()) {
            title = rs.getString("title");    //글 제목 title 변수에 저장
            content = rs.getString("Content");  //글 본문 content 변수에 저장
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>DB 오류: " + e.getMessage() + "</p>");
    }
%>

<!-- 여기서 제목이랑 본문 같은것들 출력하면 됨-->

</body>
</html>