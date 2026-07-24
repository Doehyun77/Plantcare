<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
</main>
<footer>
	<p>&copy; 2026 Plan-Ti</p>
</footer>

<!-- 성장 배지(씨앗/모종/꽃) 그라데이션 정의 - 화면 어디서든 url(#gradXxx)로 참조 -->
<svg width="0" height="0" style="position:absolute">
	<defs>
		<linearGradient id="gradBronze" x1="15%" y1="8%" x2="88%" y2="96%">
			<stop offset="0%" stop-color="#f7d4a8"/>
			<stop offset="32%" stop-color="#dd934e"/>
			<stop offset="68%" stop-color="#a8611f"/>
			<stop offset="100%" stop-color="#7a4318"/>
		</linearGradient>
		<linearGradient id="gradSilver" x1="15%" y1="8%" x2="88%" y2="96%">
			<stop offset="0%" stop-color="#ffffff"/>
			<stop offset="32%" stop-color="#e2e7ea"/>
			<stop offset="68%" stop-color="#a3adb5"/>
			<stop offset="100%" stop-color="#6d757d"/>
		</linearGradient>
		<linearGradient id="gradGold" x1="15%" y1="8%" x2="88%" y2="96%">
			<stop offset="0%" stop-color="#fff8dd"/>
			<stop offset="32%" stop-color="#f3cd52"/>
			<stop offset="68%" stop-color="#c99a1f"/>
			<stop offset="100%" stop-color="#8a6a10"/>
		</linearGradient>
	</defs>
</svg>

<div id="logoutModal" class="modal-overlay">
	<div class="modal-card">
		<p class="modal-title">정원에서 나가시겠어요?</p>
		<div class="modal-actions">
			<button type="button" class="btn-primary" id="logoutConfirm">로그아웃</button>
			<button type="button" class="btn-ghost" id="logoutCancel">취소</button>
		</div>
	</div>
</div>

<script>
var logoutLink = document.getElementById('logoutLink');
if (logoutLink) {
	var logoutModal = document.getElementById('logoutModal');
	logoutLink.addEventListener('click', function(e) {
		e.preventDefault();
		logoutModal.classList.add('show');
	});
	document.getElementById('logoutCancel').addEventListener('click', function() {
		logoutModal.classList.remove('show');
	});
	document.getElementById('logoutConfirm').addEventListener('click', function() {
		window.location.href = '/logout';
	});
	logoutModal.addEventListener('click', function(e) {
		if (e.target === logoutModal) logoutModal.classList.remove('show');
	});
}
</script>
</body>
</html>
