<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html;charset=utf8" pageEncoding="utf8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ include file="SQLcontants.jsp" %>
<%@ include file="log.jsp" %>
<%
    writeLog("페이지 접근", request, session);
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link rel="stylesheet" href="../css/common.css">
  <title>게시글 상세</title>
</head>
<body>
<%@ include file="header.jsp" %>
  <main>

<%
    String postId = request.getParameter("postId");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        Class.forName(jdbc_driver);
        conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
        String sql = "SELECT p.title, p.user_id, p.content "
                   + "FROM posts p WHERE p.id = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, postId);
        rs = ps.executeQuery();
        if (!rs.next()) {
%>
<!DOCTYPE html>
<html><body>
  <h2>게시글을 찾을 수 없습니다.</h2>
</body></html>
<%
        } else {
            String title = rs.getString("title");
            String user_id = rs.getString("user_id");
            String content = rs.getString("content");
%>

    <h2><%= title %></h2>
    <p>작성자: <%= user_id %> | <%= ts %></p>
    <div class="post-content">
      <%= content.replaceAll("\n", "<br/>") %>
    </div>
    <p><button onclick="history.back()">목록으로 돌아가기</button></p>
  </main>
</body>
</html>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>