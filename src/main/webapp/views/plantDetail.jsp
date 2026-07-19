<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ include file="/views/layout/header.jsp" %>

<div class="reg-wrap">

	<a href="/" class="detail-back">← 홈으로</a>

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
		<h3>✏️ 정보 수정</h3>
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

	<div class="reg-panel">
		<h3>🗑️ 식물 삭제</h3>
		<p class="detail-warn">삭제하면 되돌릴 수 없어요.</p>
		<form id="deleteForm" action="/plants/delete" method="post">
			<input type="hidden" name="plantNo" value="${plant.plantNo}">
			<button type="submit" class="btn-danger">삭제하기</button>
		</form>
	</div>

</div>

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

<script>
var deleteForm = document.getElementById('deleteForm');
var deleteModal = document.getElementById('deleteModal');
deleteForm.addEventListener('submit', function(e) {
	e.preventDefault();
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
</script>

<%@ include file="/views/layout/footer.jsp" %>
