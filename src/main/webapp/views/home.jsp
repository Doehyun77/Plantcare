<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ include file="/views/layout/header.jsp" %>

<c:set var="dueCount" value="0" />
<c:forEach var="p" items="${plants}">
	<c:if test="${p.needsWater}"><c:set var="dueCount" value="${dueCount + 1}" /></c:if>
</c:forEach>

<c:if test="${empty plants}">
	<div class="home-empty">
		<p>등록된 식물이 없습니다.</p>
		<a href="/plants/register">첫 식물 등록하기</a>
	</div>
</c:if>

<c:if test="${not empty plants}">

	<div class="home-hero">
		<div class="home-hero-text">
			<p class="who"><span class="who-name">${sessionScope.nickname}</span> 님의 정원</p>
			<div class="stat">
				<span class="num">${dueCount}</span>
				<span class="label">
					<c:choose>
						<c:when test="${dueCount > 0}">개, 오늘 물 줄 시간이에요</c:when>
						<c:otherwise>오늘은 모두 괜찮아요</c:otherwise>
					</c:choose>
				</span>
			</div>
			<p class="sub">
				<c:choose>
					<c:when test="${dueCount > 0}">딱 맞춰 오셨네요 ! 🌿</c:when>
					<c:otherwise>내일 다시 와 주셔야 해요 ! 🌿</c:otherwise>
				</c:choose>
			</p>
			<a href="/plants/register" class="cta">+ 새 식물 등록하기</a>
		</div>
		<div class="home-hero-badge">🌿</div>
	</div>

	<div class="home-tabs">
		<button id="tab-btn-todo" class="active" onclick="showTab('todo')">할 일</button>
		<button id="tab-btn-all" onclick="showTab('all')">내 식물</button>
	</div>

	<div class="home-avatars">
		<c:forEach var="plant" items="${plants}">
			<div class="home-avatar-item ${plant.needsWater ? 'due' : ''}">
				<div class="home-avatar-circle"><c:choose><c:when test="${not empty plant.photoPath}"><img src="${plant.photoPath}" alt="" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"></c:when><c:when test="${not empty plant.imageUrl}"><img src="${plant.imageUrl}" alt="" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"></c:when><c:otherwise>${fn:substring(plant.nickname, 0, 1)}</c:otherwise></c:choose></div>
				<div class="home-avatar-label">${plant.nickname}</div>
			</div>
		</c:forEach>
	</div>

	<div id="tabpane-todo" class="home-tabpane active">
		<div class="home-board">
			<div>
				<div class="home-section-label">💧 오늘 할 일</div>
				<c:set var="anyDue" value="false" />
				<c:forEach var="plant" items="${plants}">
					<c:if test="${plant.needsWater}">
						<c:set var="anyDue" value="true" />
						<div class="home-row due">
							<div class="row-avatar"><c:choose><c:when test="${not empty plant.photoPath}"><img src="${plant.photoPath}" alt="" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"></c:when><c:when test="${not empty plant.imageUrl}"><img src="${plant.imageUrl}" alt="" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"></c:when><c:otherwise>${fn:substring(plant.nickname, 0, 1)}</c:otherwise></c:choose></div>
							<div class="row-body">
								<div class="row-name">${plant.nickname}</div>
								<div class="row-sub">마지막 물: ${plant.lastWaterDate != null ? plant.lastWaterDate : '기록 없음'}</div>
							</div>
							<button class="row-check" onclick="waterPlant(${plant.plantNo})">체크</button>
						</div>
					</c:if>
				</c:forEach>
				<c:if test="${!anyDue}"><p class="row-sub" style="color:var(--sub);">오늘 물 줄 아이가 없어요.</p></c:if>
			</div>

			<div>
				<div class="home-section-label">오늘은 괜찮아요</div>
				<c:set var="anyOk" value="false" />
				<c:forEach var="plant" items="${plants}">
					<c:if test="${!plant.needsWater}">
						<c:set var="anyOk" value="true" />
						<div class="home-row ok">
							<div class="row-avatar"><c:choose><c:when test="${not empty plant.photoPath}"><img src="${plant.photoPath}" alt="" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"></c:when><c:when test="${not empty plant.imageUrl}"><img src="${plant.imageUrl}" alt="" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"></c:when><c:otherwise>${fn:substring(plant.nickname, 0, 1)}</c:otherwise></c:choose></div>
							<div class="row-body">
								<div class="row-name">${plant.nickname}</div>
								<div class="row-sub">마지막 물: ${plant.lastWaterDate != null ? plant.lastWaterDate : '기록 없음'}</div>
							</div>
						</div>
					</c:if>
				</c:forEach>
				<c:if test="${!anyOk}"><p class="row-sub" style="color:var(--sub);">모든 식물이 물이 필요해요.</p></c:if>
				<a href="/plants/register" class="home-add-tile">+ 새 식물 등록하기</a>
			</div>
		</div>
	</div>

	<div id="tabpane-all" class="home-tabpane home-all-list">
		<div class="home-section-label">내 식물 전체 · ${fn:length(plants)}</div>
		<c:forEach var="plant" items="${plants}">
			<div class="home-row">
				<div class="row-avatar"><c:choose><c:when test="${not empty plant.photoPath}"><img src="${plant.photoPath}" alt="" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"></c:when><c:when test="${not empty plant.imageUrl}"><img src="${plant.imageUrl}" alt="" style="width:100%;height:100%;object-fit:cover;border-radius:50%;"></c:when><c:otherwise>${fn:substring(plant.nickname, 0, 1)}</c:otherwise></c:choose></div>
				<div class="row-body">
					<div class="row-name">${plant.nickname}
						<span class="together-chip">D+${plant.daysTogether}</span>
						<c:if test="${plant.growthTier == 'seed'}">
							<span class="medal seed"><svg viewBox="0 0 24 24"><ellipse class="seed-shape" cx="12" cy="12" rx="5" ry="6.8" transform="rotate(-12 12 12)"/><path class="seam" d="M12 6c-1.3 2.2-1.3 9.6 0.5 11.8" transform="rotate(-12 12 12)"/><ellipse class="shine" cx="10" cy="8.2" rx="1.3" ry="2.1" transform="rotate(-12 12 12)"/></svg></span>
						</c:if>
						<c:if test="${plant.growthTier == 'sprout'}">
							<span class="medal sprout"><svg viewBox="0 0 24 24"><line class="stem" x1="12" y1="17.3" x2="12" y2="10.5"/><ellipse class="leaf" cx="8.3" cy="9.3" rx="3.4" ry="2" transform="rotate(-30 8.3 9.3)"/><ellipse class="leaf" cx="15.7" cy="9.3" rx="3.4" ry="2" transform="rotate(30 15.7 9.3)"/><ellipse class="shine" cx="7.2" cy="8.3" rx="1" ry="1.6" transform="rotate(-30 8.3 9.3)"/></svg></span>
						</c:if>
						<c:if test="${plant.growthTier == 'flower'}">
							<span class="medal flower"><svg viewBox="0 0 24 24"><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(0 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(45 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(90 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(135 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(180 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(225 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(270 12 12)"/><ellipse class="petal" cx="12" cy="7.2" rx="2.1" ry="3.2" transform="rotate(315 12 12)"/><circle class="center" cx="12" cy="12" r="2.1"/><ellipse class="shine" cx="10.7" cy="10.6" rx="0.9" ry="1.2" transform="rotate(-30 10.7 10.6)"/></svg></span>
						</c:if>
					</div>
					<div class="row-sub">마지막 물: ${plant.lastWaterDate != null ? plant.lastWaterDate : '기록 없음'}</div>
				</div>
				<c:if test="${plant.needsWater}">
					<button class="row-check" onclick="waterPlant(${plant.plantNo})">체크</button>
				</c:if>
				<a class="row-detail" href="/plants/detail?plantNo=${plant.plantNo}">상세</a>
			</div>
		</c:forEach>
	</div>

</c:if>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
function waterPlant(plantNo) {
	$.post('/water/check', { plantNo: plantNo }, function() {
		location.reload();
	});
}

function showTab(name) {
	document.getElementById('tabpane-todo').classList.toggle('active', name === 'todo');
	document.getElementById('tabpane-all').classList.toggle('active', name === 'all');
	document.getElementById('tab-btn-todo').classList.toggle('active', name === 'todo');
	document.getElementById('tab-btn-all').classList.toggle('active', name === 'all');
}
</script>
<%@ include file="/views/layout/footer.jsp" %>
