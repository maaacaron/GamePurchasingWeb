<%@ page contentType="text/html;charset=utf8" pageEncoding="utf8" %>
<% request.setCharacterEncoding("UTF-8");%>

<%
  String currentUser = (String) session.getAttribute("currentUser");
%>
<header class="site-header">
  <div class="logo">
    <a href="MainPage.jsp">GameMart</a>
  </div>

  <nav class="main-nav">
    <a href="CategoryPage.jsp">카테고리</a>
    <a href="GameListPage.jsp?discount=true">할인</a>
    <a href="CommunityPage.jsp">커뮤니티</a>
    <a href="SupportPage.jsp">지원</a>
  </nav>

  <div class="header-right">
    <form action="search.jsp" method="get" style="display:inline;">
      <input type="text" id="search-input" name="search" placeholder="검색..." />
    </form>
    <a href="CartPage.jsp" class="cart-btn">장바구니</a>

    <% if (currentUser == null) { %>
      <a href="LoginPage.jsp" class="login-btn" id="login-button">로그인</a>
    <% } else { %>
      <a href="LibraryPage.jsp" class="cart-btn" id="myPage-button">마이페이지</a>
      <a href="Logout.jsp" class="login-btn">로그아웃</a>
    <% } %>
  </div>
</header>
