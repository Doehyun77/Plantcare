<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
</main>
<footer>
	<p>&copy; 2026 Plan-Ti</p>
</footer>

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
