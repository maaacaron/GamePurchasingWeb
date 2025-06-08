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
  <title>글 쓰기</title>
</head>
<body>
<%@ include file="header.jsp" %>
  <main>
    <h2>새 게시글 작성</h2>
    <form method="post" action="CommunityPage_Write.jsp">
      <div class="form-group">
        <label class="form-label" for="post-title">제목:</label><br>
        <input type="text" name="title" class="title-input">
      </div>
      <div class="community-filter-group">
          <label>게임 선택:
            <select name="gameId" required>
              <option value="">-- 선택 --</option>
              <%
                String userId = (String) session.getAttribute("currentUser");
                if (userId == null) {
                    response.sendRedirect("LoginPage.jsp");
                    return;
                }
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    String title   = request.getParameter("title");
                    String content = request.getParameter("content");
                    String gameId  = request.getParameter("gameId");
                    Connection conn = null;
                    PreparedStatement ps = null;
                    try {
                        Class.forName(jdbc_driver);
                        conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);

                        PreparedStatement userStmt = conn.prepareStatement("SELECT ID FROM User WHERE UserID = ?");
                        userStmt.setString(1, userId);
                        ResultSet userRs = userStmt.executeQuery();
                        if (userRs.next()) {
                            int userDbId = userRs.getInt("ID");

                            String sql = "INSERT INTO posts (title, user_id, content, game_id) "
                                       + "VALUES (?, ?, ?, ?)";
                            ps = conn.prepareStatement(sql);
                            ps.setString(1, title);
                            ps.setInt(2, userDbId);
                            ps.setString(3, content);
                            ps.setInt(4, Integer.parseInt(gameId));
                            ps.executeUpdate();
                            response.sendRedirect("CommunityPage.jsp");
                        }
                        return;
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        try { if (ps   != null) ps.close();   } catch (Exception e) {}
                        try { if (conn != null) conn.close(); } catch (Exception e) {}
                    }
                }
                Connection conn2 = null;
                PreparedStatement ps2 = null;
                ResultSet rs2 = null;
                try {
                    Class.forName(jdbc_driver);
                    conn2 = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
                    String sql2 = "SELECT ID, Name FROM Game";
                    ps2 = conn2.prepareStatement(sql2);
                    rs2 = ps2.executeQuery();
                    while (rs2.next()) {
              %>
                      <option value="<%= rs2.getString("ID") %>">
                        <%= rs2.getString("Name") %>
                      </option>
              <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if (rs2   != null) rs2.close();   } catch (Exception e) {}
                    try { if (ps2   != null) ps2.close();   } catch (Exception e) {}
                    try { if (conn2 != null) conn2.close(); } catch (Exception e) {}
                }
              %>
            </select>
          </label>
        </div>
      <div class="form-group">
        <label class="form-label" for="post-content">내용:</label><br>
        <textarea name="content" class="content-textarea"></textarea>
      </div>
      <button type="submit"> 등록하기</button>
      <button type="button" onclick="history.back()">취소</button>
    </form>
  </main>
</body>
</html>
