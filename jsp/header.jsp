<%@ page contentType="text/html; charset=utf8" pageEncoding="utf8" %>
<% request.setCharacterEncoding("UTF-8");%>

<%
  String currentUser = (String) session.getAttribute("currentUser");
%>

<header class="site-header">
  <div class="logo">
    <a href="MainPage.jsp">GameMart</a>
  </div>

  <nav class="main-nav">
    <a href="CategoryPage.jsp">Category</a>
    <a href="DiscountPage.jsp">Discount</a>
    <a href="CommunityPage.jsp">Community</a>
    <a href="SupportPage.jsp">Support</a>
  </nav>

  <div class="header-right">
    <form action="search.jsp" method="get" style="display:inline;">
      <input type="text" id="search-input" name="search" placeholder="검색..." />
    </form>
    <a href="CartPage.jsp" class="cart-btn">Cart</a>

    <% if (currentUser == null) { %>
      <a href="LoginPage.jsp" class="login-btn" id="login-button">Login</a>
    <% } else { %>
      <span><%= currentUser %></span>
      <a href="Logout.jsp" class="logout-btn">Logout</a>
    <% } %>
  </div>
</header>
