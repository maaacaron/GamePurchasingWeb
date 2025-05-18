<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ include file="SQLcontants.jsp" %>

<%
    String userId = request.getParameter("userId");
    String password = request.getParameter("password");

    boolean loginSuccess = false;
    int userDbId = 0;
    String userName = "";
    boolean isAdmin = false;

    try {
        Class.forName(jdbc_driver);
        Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
        Statement stmt = conn.createStatement();

        String query = "SELECT * FROM User WHERE UserID = '" + userId + "' AND PassWord = '" + password + "'";
        ResultSet rs = stmt.executeQuery(query);

        if (rs.next()) {
            loginSuccess = true;
            userDbId = rs.getInt("ID");
            userName = rs.getString("Name");
            isAdmin = rs.getBoolean("IsAdmin");
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (loginSuccess) {
        session.setAttribute("currentUser", userId);
        session.setAttribute("userId", userDbId);
        session.setAttribute("userName", userName);
        session.setAttribute("isAdmin", isAdmin);
%>
        <script>
            alert("로그인 성공!");
            location.href = "MainPage.jsp";
        </script>
<%
    } else {
%>
        <script>
            alert("아이디 또는 비밀번호가 잘못되었습니다.");
            history.back();
        </script>
<%
    }
%>
