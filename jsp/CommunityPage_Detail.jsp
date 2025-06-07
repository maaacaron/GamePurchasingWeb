<%@ page contentType="text/html; charset=UTF-8" session="true" %>
<%@ include file="header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<script src="${pageContext.request.contextPath}/js/header-login-status.js"></script>
<script src="${pageContext.request.contextPath}/js/game-data.js"></script>

<main>
  <h2 id="detail-title"></h2>
  <p id="detail-meta"></p>
  <p><strong>게임:</strong> <span id="detail-game"></span></p>
  <div id="detail-content" class="post-content"></div>
</main>

<script>
  document.addEventListener('DOMContentLoaded', () => {
    const params = new URLSearchParams(location.search);
    const postId = params.get('postId');
    const posts = JSON.parse(localStorage.getItem('posts') || '[]');
    const post = posts.find(p => p.id === postId);
    if (!post) {
      document.getElementById('detail-title').textContent = '게시글을 찾을 수 없습니다.';
      return;
    }
    document.getElementById('detail-title').textContent = post.title;
    document.getElementById('detail-meta').textContent = `작성자: ${post.author} | ${new Date(post.timestamp).toLocaleString()}`;
    const game = games.find(g => g.id === post.gameId);
    document.getElementById('detail-game').textContent = game ? game.name : '알 수 없음';
    document.getElementById('detail-content').textContent = post.content;
  });
</script>
