<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ include file="/views/layout/header.jsp" %>

<div class="reg-wrap">

	<div class="detail-top-bar">
		<a href="/" class="detail-back">홈으로</a>
		<div class="detail-actions">
			<button type="button" class="btn-ghost" id="editOpenBtn">수정</button>
			<button type="button" class="btn-danger" id="deleteOpenBtn">삭제</button>
		</div>
	</div>

	<div class="reg-panel">
		<div class="detail-head">
			<div class="detail-avatar">
				<c:choose>
					<c:when test="${not empty plant.photoPath}">
						<img src="${plant.photoPath}" alt="">
					</c:when>
					<c:when test="${not empty info.imageUrl}">
						<img src="${fn:split(info.imageUrl, '|')[0]}" alt="">
					</c:when>
					<c:otherwise>🌱</c:otherwise>
				</c:choose>
			</div>
			<div>
				<div class="detail-name">${plant.nickname}</div>
				<c:if test="${not empty info.plantName && info.plantName != plant.nickname}">
					<div class="detail-species">${info.plantName}<c:if test="${not empty info.plantSciName}"> · ${info.plantSciName}</c:if></div>
				</c:if>
			</div>
			<span class="detail-status ${needsWater ? 'due' : 'ok'}">
				<c:choose>
					<c:when test="${needsWater}">💧 물 필요</c:when>
					<c:otherwise>괜찮음</c:otherwise>
				</c:choose>
			</span>
		</div>

		<div class="detail-stats">
			<div class="detail-stat">
				<span class="detail-stat-label">물주기 간격</span>
				<span class="detail-stat-value">${actualInterval}일마다</span>
			</div>
			<div class="detail-stat">
				<span class="detail-stat-label">마지막 물 준 날짜</span>
				<span class="detail-stat-value">${plant.lastWaterDate != null ? plant.lastWaterDate : '기록 없음'}</span>
			</div>
			<div class="detail-stat">
				<span class="detail-stat-label">함께한 지</span>
				<span class="detail-stat-value">${daysTogether}일째</span>
			</div>
			<div class="growth-medal-slot">
				<c:if test="${growthTier == 'seed'}">
					<span class="medal seed"><svg viewBox="0 0 24 24"><ellipse class="seed-shape" cx="12" cy="12" rx="5" ry="6.8" transform="rotate(-12 12 12)"/><path class="seam" d="M12 6c-1.3 2.2-1.3 9.6 0.5 11.8" transform="rotate(-12 12 12)"/><ellipse class="shine" cx="10" cy="8.2" rx="1.3" ry="2.1" transform="rotate(-12 12 12)"/></svg></span>
				</c:if>
				<c:if test="${growthTier == 'sprout'}">
					<span class="medal sprout"><svg viewBox="0 0 24 24"><line class="stem" x1="12" y1="17.3" x2="12" y2="10.5"/><ellipse class="leaf" cx="8.3" cy="9.3" rx="3.4" ry="2" transform="rotate(-30 8.3 9.3)"/><ellipse class="leaf" cx="15.7" cy="9.3" rx="3.4" ry="2" transform="rotate(30 15.7 9.3)"/><ellipse class="shine" cx="7.2" cy="8.3" rx="1" ry="1.6" transform="rotate(-30 8.3 9.3)"/></svg></span>
				</c:if>
				<c:if test="${growthTier == 'flower'}">
					<span class="medal flower"><svg viewBox="0 0 24 24"><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(0 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(45 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(90 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(135 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(180 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(225 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(270 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(315 12 12)"/><circle class="center" cx="12" cy="12" r="2.1"/><ellipse class="shine" cx="10.7" cy="10.6" rx="0.9" ry="1.2" transform="rotate(-30 10.7 10.6)"/></svg></span>
				</c:if>
			</div>
			<c:if test="${not empty info.manageLevel}">
				<div class="detail-stat">
					<span class="detail-stat-label">관리 난이도</span>
					<span class="detail-stat-value">${info.manageLevel}</span>
				</div>
			</c:if>
		</div>

	</div>

	<c:if test="${not empty info}">
	<div class="reg-panel">
		<h3>📖 도감 정보</h3>

		<div class="detail-facts">
			<c:if test="${not empty info.distbNm}">
				<div class="detail-fact"><span class="detail-fact-label">유통명</span><span class="detail-fact-value">${info.distbNm}</span></div>
			</c:if>
			<c:if test="${not empty info.orgplceInfo}">
				<div class="detail-fact"><span class="detail-fact-label">원산지</span><span class="detail-fact-value">${info.orgplceInfo}</span></div>
			</c:if>
			<c:if test="${not empty info.fncltyInfo}">
				<div class="detail-fact"><span class="detail-fact-label">기능성</span><span class="detail-fact-value">${info.fncltyInfo}</span></div>
			</c:if>
			<c:if test="${not empty info.speclmanageInfo}">
				<div class="detail-fact"><span class="detail-fact-label">특별 관리</span><span class="detail-fact-value">${info.speclmanageInfo}</span></div>
			</c:if>
			<c:if test="${not empty info.toxctyInfo}">
				<div class="detail-fact"><span class="detail-fact-label">독성 정보</span><span class="detail-fact-value">${info.toxctyInfo}</span></div>
			</c:if>
		</div>

		<h4 class="detail-subhead">💧 계절별 물주기</h4>
		<div class="detail-facts">
			<div class="detail-fact ${season == 'spring' ? 'current' : ''}">
				<span class="detail-fact-label">봄</span>
				<span class="detail-fact-value">${info.waterSpringDesc}
					<c:if test="${springDays != null}">${springDays}일에 한 번</c:if>
				</span>
			</div>
			<div class="detail-fact ${season == 'summer' ? 'current' : ''}">
				<span class="detail-fact-label">여름</span>
				<span class="detail-fact-value">${info.waterSummerDesc}
					<c:if test="${summerDays != null}">${summerDays}일에 한 번</c:if>
				</span>
			</div>
			<div class="detail-fact ${season == 'autumn' ? 'current' : ''}">
				<span class="detail-fact-label">가을</span>
				<span class="detail-fact-value">${info.waterAutumnDesc}
					<c:if test="${autumnDays != null}">${autumnDays}일에 한 번</c:if>
				</span>
			</div>
			<div class="detail-fact ${season == 'winter' ? 'current' : ''}">
				<span class="detail-fact-label">겨울</span>
				<span class="detail-fact-value">${info.waterWinterDesc}
					<c:if test="${winterDays != null}">${winterDays}일에 한 번</c:if>
				</span>
			</div>
		</div>
	</div>
	</c:if>

	<div class="reg-panel">
		<h3>성장 일지 <span class="diary-count">${fn:length(diaries)}</span></h3>

		<form action="/plants/diary" method="post" enctype="multipart/form-data" class="diary-input-row">
			<input type="hidden" name="plantNo" value="${plant.plantNo}">
			<label class="diary-photo-btn" for="diaryPhoto">📷</label>
			<input type="file" name="photo" id="diaryPhoto" accept="image/*" style="display:none;">
			<textarea name="content" class="diary-textarea" placeholder="오늘 이 아이는 어땠나요?" rows="1" required></textarea>
			<button type="submit" class="btn-primary">기록하기</button>
		</form>

		<c:choose>
			<c:when test="${empty diaries}">
				<div class="diary-empty">
					<div class="icon">📔</div>
					첫 기록을 남겨보세요.
				</div>
			</c:when>
			<c:otherwise>
				<div class="diary-list">
					<c:forEach var="diary" items="${diaries}">
						<div class="diary-entry">
							<div class="diary-thumb">
								<c:choose>
									<c:when test="${not empty diary.photoPath}"><img src="${diary.photoPath}" alt=""></c:when>
									<c:otherwise>🌿</c:otherwise>
								</c:choose>
							</div>
							<div class="diary-body">
								<div class="diary-date">${fn:substring(diary.regDate, 0, 10)}</div>
								<div class="diary-text">${diary.content}</div>
							</div>
							<form action="/plants/diary/delete" method="post" class="diary-delete-form">
								<input type="hidden" name="diaryNo" value="${diary.diaryNo}">
								<input type="hidden" name="plantNo" value="${plant.plantNo}">
								<button type="submit" class="diary-delete">삭제</button>
							</form>
						</div>
					</c:forEach>
				</div>
			</c:otherwise>
		</c:choose>
	</div>

</div>

<div id="editModal" class="modal-overlay">
	<div class="modal-card">
		<button type="button" class="modal-close" id="editModalClose" aria-label="닫기">✕</button>
		<div class="modal-title-row">
			<p class="modal-title">정보 수정</p>
		</div>
		<form action="/plants/update" method="post">
			<input type="hidden" name="plantNo" value="${plant.plantNo}">

			<div class="form-field">
				<label for="nickname">별명</label>
				<input type="text" name="nickname" id="nickname" value="${plant.nickname}" required>
			</div>
			<div class="form-field">
				<label for="userWaterInterval">물주기 간격 (일)</label>
				<input type="number" name="userWaterInterval" id="userWaterInterval" value="${plant.userWaterInterval}">
				<c:if test="${empty plant.userWaterInterval}">
					<span class="form-hint">비워두면 계절 기본값(${actualInterval}일)이 적용돼요</span>
				</c:if>
			</div>

			<button type="submit" class="btn-primary">수정하기</button>
		</form>
	</div>
</div>

<form id="deleteForm" action="/plants/delete" method="post" style="display:none;">
	<input type="hidden" name="plantNo" value="${plant.plantNo}">
</form>

<div id="deleteModal" class="modal-overlay">
	<div class="modal-card">
		<p class="modal-title">삭제하시겠습니까?</p>
		<p class="modal-desc">"${plant.nickname}"을(를) 삭제하면 되돌릴 수 없어요.</p>
		<div class="modal-actions">
			<button type="button" class="btn-danger" id="modalConfirm">삭제</button>
			<button type="button" class="btn-ghost" id="modalCancel">취소</button>
		</div>
	</div>
</div>

<div id="diaryDeleteModal" class="modal-overlay">
	<div class="modal-card">
		<p class="modal-title">삭제할까요?</p>
		<p class="modal-desc">이 기록을 삭제하면 되돌릴 수 없어요.</p>
		<div class="modal-actions">
			<button type="button" class="btn-danger" id="diaryModalConfirm">삭제</button>
			<button type="button" class="btn-ghost" id="diaryModalCancel">취소</button>
		</div>
	</div>
</div>

<script>
var editModal = document.getElementById('editModal');
document.getElementById('editOpenBtn').addEventListener('click', function() {
	editModal.classList.add('show');
});
document.getElementById('editModalClose').addEventListener('click', function() {
	editModal.classList.remove('show');
});
editModal.addEventListener('click', function(e) {
	if (e.target === editModal) editModal.classList.remove('show');
});

var deleteForm = document.getElementById('deleteForm');
var deleteModal = document.getElementById('deleteModal');
document.getElementById('deleteOpenBtn').addEventListener('click', function() {
	deleteModal.classList.add('show');
});
document.getElementById('modalCancel').addEventListener('click', function() {
	deleteModal.classList.remove('show');
});
document.getElementById('modalConfirm').addEventListener('click', function() {
	deleteForm.submit();
});
deleteModal.addEventListener('click', function(e) {
	if (e.target === deleteModal) deleteModal.classList.remove('show');
});

var diaryDeleteModal = document.getElementById('diaryDeleteModal');
var diaryFormToDelete = null;
document.querySelectorAll('.diary-delete-form').forEach(function(form) {
	form.addEventListener('submit', function(e) {
		e.preventDefault();
		diaryFormToDelete = form;
		diaryDeleteModal.classList.add('show');
	});
});
document.getElementById('diaryModalCancel').addEventListener('click', function() {
	diaryDeleteModal.classList.remove('show');
});
document.getElementById('diaryModalConfirm').addEventListener('click', function() {
	if (diaryFormToDelete) diaryFormToDelete.submit();
});
diaryDeleteModal.addEventListener('click', function(e) {
	if (e.target === diaryDeleteModal) diaryDeleteModal.classList.remove('show');
});
</script>

<%@ include file="/views/layout/footer.jsp" %>
