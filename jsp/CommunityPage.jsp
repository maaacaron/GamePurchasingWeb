<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ include file="header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<script src="${pageContext.request.contextPath}/js/header-login-status.js"></script>
<script src="${pageContext.request.contextPath}/js/game-data.js"></script>

<main>
  <h2>커뮤니티</h2>
  <div class="filter-group">
    <label>게임 선택:
      <select id="gameFilter"></select>
    </label>
    <button type="button" onclick="location.href='CommunityPage_Write.jsp'">글 쓰기</button>
  </div>
  <ul id="postList"></ul>
</main>

<script>
  // 게임 필터 로드
  function loadGameFilter() {
    const sel = document.getElementById('gameFilter');
    sel.innerHTML = '<option value="">전체 게임</option>';
    games.forEach(g => {
      const opt = document.createElement('option');
      opt.value = g.id;
      opt.textContent = g.name;
      sel.appendChild(opt);
    });
    sel.onchange = loadPosts;
  }

  // 게시글 로드
  function loadPosts() {
    const all = JSON.parse(localStorage.getItem('posts') || '[]');
    const filter = document.getElementById('gameFilter').value;
    const list = document.getElementById('postList');
    list.innerHTML = '';
    const posts = filter ? all.filter(p => p.gameId === filter) : all;
    if (!posts.length) {
      list.innerHTML = '<li>등록된 게시글이 없습니다.</li>';
      return;
    }
    posts.forEach(p => {
      const li = document.createElement('li');
      li.innerHTML = `
        <a href="CommunityPage_Detail.jsp?postId=${p.id}">
          [${new Date(p.timestamp).toLocaleString()}] ${p.title} (${p.author})
        </a>`;
      list.appendChild(li);
    });
  }

  document.addEventListener('DOMContentLoaded', () => {
    loadGameFilter();
    loadPosts();
  });
</script>
