<%@ page language="java" import="java.sql.*, javax.sql.DataSource" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%@ include file="SQLcontants.jsp" %>
<%@ include file="log.jsp" %>
<%
    writeLog("회원가입 시도", request, session);
%>

<%
    String userId = request.getParameter("userID");
    String password = request.getParameter("PassWord");
    String name = request.getParameter("name");
    String email = request.getParameter("Email");

    boolean isDuplicate = false;

    try {
        Class.forName(jdbc_driver);
        Connection conn = DriverManager.getConnection(mySQL_database, mySQL_id, mySQL_password);
        Statement stmt = conn.createStatement();


        if(name == null)
        {
%>      
            <script>
                alert("이름을 입력해주세요.")
                history.back();
            </script>
<%
        }

        if(userId == null)
        {
%>      
            <script>
                alert("ID를 입력해주세요.")
                history.back();
            </script>
<%
        }
        // 아이디 중복 체크
        ResultSet idRs = stmt.executeQuery("SELECT ID FROM User WHERE LOWER(UserID) = LOWER('" + userId + "')");
        if (idRs.next()) {
            isDuplicate = true;
%>
            <script>
                alert("이미 사용 중인 아이디입니다.");
                history.back();
            </script>
<%
        }
        idRs.close();

        if(email == null)
        {
%>      
            <script>
                alert("이메일을 입력해주세요.")
                history.back();
            </script>
<%
        }
        if (!isDuplicate) {
            // 이메일 중복 체크
            ResultSet emailRs = stmt.executeQuery("SELECT ID FROM User WHERE Email = '" + email + "'");
            if (emailRs.next()) {
                isDuplicate = true;
%>
                <script>
                    alert("이미 등록된 이메일입니다.");
                    history.back();
                </script>
<%
            }
            emailRs.close();
        }

        if(password == null)
        {
%>      
            <script>
                alert("비밀번호를 입력해주세요.")
                history.back();
            </script>
<%
        }
        if (!isDuplicate) {
            // INSERT 처리
            int result = stmt.executeUpdate("INSERT INTO User (UserID, PassWord, Name, Email, IsAdmin) " +
                                            "VALUES ('" + userId + "', '" + password + "', '" + name + "', '" + email + "', false)");

            if (result > 0) {
%>
                <script>
                    alert("회원가입이 완료되었습니다!");
                    location.href = "LoginPage.jsp";
                </script>
<%
            } else {
%>
                <script>
                    alert("회원가입에 실패했습니다.");
                    history.back();
                </script>
<%
            }
        }

        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
%>
        <script>
            alert("오류 발생: <%= e.getMessage() %>");
            history.back();
        </script>
<%
    }
%>
