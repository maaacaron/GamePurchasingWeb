<%@ include file="log.jsp" %>
<%
    writeLog("로그아웃", request, session);
%>

<%
  session.invalidate();
  response.sendRedirect("MainPage.jsp");
%>
