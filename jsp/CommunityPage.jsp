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
<%@ include file="log.jsp" %>
<%
    writeLog("페이지 접근", request, session);
%>

<main>
<%
    String title = "";
    int id = 0;

    try {
        Class.forName(jdbc_driver);
        Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
        Statement stmt = conn.createStatement();

        String sql = "SELECT title FROM Post";
        ResultSet rs = stmt.executeQuery(sql);

        while (rs.next()) {
            title = rs.getString("title");    //글 제목 저장
            id = rs.getInt("id");             //글 id 저장
          %>
            <!-- 여기에서 title 값을 출력하고 href로 CommunityPage_Detail.jsp로 id 값 request로 받을 수 있게 보내면 됨 (while문 내부임)
                                                                              id 값은 int로 못보낸다고 해서 string으로 보내주면 됨-->
          <%
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>DB 오류: " + e.getMessage() + "</p>");
    }
%>

</body>
</html>