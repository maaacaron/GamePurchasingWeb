<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <!-- 공통 스타일 -->
  <link rel="stylesheet" href="common.css">
</head>
<body>
  <!-- header.html을 header.jsp로 이름 바꾼 뒤, JSP include 처리 -->
  <jsp:include page="header.jsp" flush="true" />

  <main>
    <!-- MainPage.html과 동일한 배너 -->
    <div class="main-banner">
      인기 게임?
    </div>

    <!-- 게임 카드 그리드 -->
    <div class="game-grid" id="gameGrid"></div>
  </main>

  <!-- 게임 데이터 스크립트 -->
  <script src="game-data.js"></script>
  <script>
    const grid = document.getElementById('gameGrid');
    games.forEach(game => {
      const card = document.createElement('a');
      card.href = game.link;
      card.className = 'game-card';
      card.innerHTML = `
        <img src="${game.image}" alt="${game.name}">
        <p>${game.name}</p>
      `;
      grid.appendChild(card);
    });
  </script>
</body>
</html>
