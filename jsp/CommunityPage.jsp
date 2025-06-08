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
  <title>커뮤니티</title>
</head>
<body>
<%@ include file="header.jsp" %>
  <main>
    <h2>커뮤니티</h2>
    <div class="filter-group">
      <label>게임 선택:
        <select name="gameFilter" onchange="location.href='CommunityPage.jsp?GameId=' + this.value">
          <option value="">-- 전체 --</option>
<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String filterGameId = request.getParameter("GameId");
    try {
        Class.forName(jdbc_driver);
        conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);

        // 게임 목록 조회 (필터 select 옵션)
        String sqlGames = "SELECT ID, Name FROM Game";
        PreparedStatement psGames = conn.prepareStatement(sqlGames);
        ResultSet rsGames = psGames.executeQuery();
        while (rsGames.next()) {
          String gid = rsGames.getString("ID");
          String gname = rsGames.getString("Name");
          String sel = (filterGameId != null && filterGameId.equals(gid)) ? "selected" : "";
          %>
            <option value="<%=gid%>" <%=sel%>><%=gname%></option>
          <% } 
             rsGames.close();
             psGames.close();
          %>
        </select>
      </label>
      <button type="button" onclick="location.href='CommunityPage_Write.jsp'">글 쓰기</button>
    </div>
    <ul id="postList">
      <%
        String sqlPosts = "SELECT p.id, p.title, p.user_id, p.game_id "
                        + "FROM posts p ";
        ps = conn.prepareStatement(sqlPosts);
        rs = ps.executeQuery();
        boolean hasAny = false;
        while (rs.next()) {
          String pid   = rs.getString("id");
          String title = rs.getString("title");
          String user_id  = rs.getString("user_id");
          String gid   = rs.getString("game_id");

          String userName = user_id; // 기본값(혹시 name 못 구할 때는 id 출력)
          PreparedStatement psUser = null;
          ResultSet rsUser = null;
          try {
            String sqlUser = "SELECT Name FROM User WHERE UserID = ?";
            psUser = conn.prepareStatement(sqlUser);
            psUser.setString(1, user_id);
            rsUser = psUser.executeQuery();
            if (rsUser.next()) {
                userName = rsUser.getString("Name");
            }
          } catch(Exception e) {
              // 필요시 로그
          } finally {
              if (rsUser != null) try { rsUser.close(); } catch(Exception e) {}
              if (psUser != null) try { psUser.close(); } catch(Exception e) {}
          }

          if (filterGameId == null || filterGameId.isEmpty() || filterGameId.equals(gid)) {
            hasAny = true;
      %>
        <li>
          <a href="CommunityPage_Detail.jsp?postId=<%=pid%>">
            <%=title%> (<%=userName%>)
          </a>
        </li>
      <%  }
        }
        if (!hasAny) { %>
        <li>등록된 게시글이 없습니다.</li>
      <% } %>
    </ul>
  </main>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>