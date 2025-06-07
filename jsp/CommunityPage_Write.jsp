<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ include file="header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<script src="${pageContext.request.contextPath}/js/header-login-status.js"></script>
<script src="${pageContext.request.contextPath}/js/game-data.js"></script>

<%
  String user = (String) session.getAttribute("currentUser");
  if (user == null) {
    response.sendRedirect("LoginPage.jsp");
    return;
  }
%>

<main>
  <h2>커뮤니티 글 작성</h2>
  <form onsubmit="event.preventDefault(); submitPost();">
    <div class="filter-group">
      <label>게임:
        <select id="post-game"></select>
      </label>
    </div>
    <div class="form-group">
      <label>제목:</label><br>
      <input type="text" id="post-title" style="width:100%;">
    </div>
    <div class="form-group">
      <label>내용:</label><br>
      <textarea id="post-content" rows="8" style="width:100%;"></textarea>
    </div>
    <button type="button" onclick="submitPost()">등록</button>
  </form>
</main>

<script>
  document.addEventListener('DOMContentLoaded', () => {
    const sel = document.getElementById('post-game');
    sel.innerHTML = '<option value="">-- 게임 선택 --</option>';
    games.forEach(g => {
      const opt = document.createElement('option');
      opt.value = g.id;
      opt.textContent = g.name;
      sel.appendChild(opt);
    });
  });

  function submitPost() {
    const author = localStorage.getItem('currentUser');
    if (!author) {
      alert('로그인이 필요합니다.');
      location.href = 'LoginPage.jsp';
      return;
    }
    const gameId = document.getElementById('post-game').value;
    const title = document.getElementById('post-title').value.trim();
    const content = document.getElementById('post-content').value.trim();
    if (!gameId || !title || !content) {
      alert('모든 항목을 입력해주세요.');
      return;
    }
    const posts = JSON.parse(localStorage.getItem('posts') || '[]');
    const id = Date.now().toString();
    posts.push({ id, gameId, author, title, content, timestamp: Date.now() });
    localStorage.setItem('posts', JSON.stringify(posts));
    alert('게시글이 등록되었습니다.');
    location.href = 'CommunityPage.jsp';
  }
</script>
