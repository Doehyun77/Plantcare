<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/layout/header.jsp" %>

<div class="cal-wrap">
	<div class="cal-nav">
		<a href="/calendar?year=${prevYear}&month=${prevMonth}" class="cal-nav-btn">◀</a>
		<div class="cal-title">${year}년 ${month}월</div>
		<a href="/calendar?year=${nextYear}&month=${nextMonth}" class="cal-nav-btn">▶</a>
	</div>

	<table class="cal-table">
		<thead>
			<tr>
				<th class="cal-sun">일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th class="cal-sat">토</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="week" items="${weeks}">
				<tr>
					<c:forEach var="day" items="${week}">
						<td class="cal-cell ${day == 0 ? 'empty' : ''} ${day == today ? 'today' : ''}"
							<c:if test="${day > 0}">onclick="showDayDetail(${day})"</c:if>>
							<c:if test="${day > 0}">
								<span class="cal-day">${day}</span>
								<c:set var="cnt" value="${waterCounts[day]}"/>
								<c:if test="${cnt != null && cnt > 0}">
									<span class="cal-badge">💧 ${cnt}</span>
								</c:if>
							</c:if>
						</td>
					</c:forEach>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<div id="dayModal" class="modal-overlay">
	<div class="modal-card">
		<button type="button" class="modal-close" id="dayModalClose" aria-label="닫기">✕</button>
		<div class="modal-title-row">
			<svg class="watering-can-icon" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
				<path d="M3 9h10a2 2 0 0 1 2 2v3a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V9Z" fill="none" stroke="currentColor" stroke-width="1.6"/>
				<path d="M15 10h3.5L21 8" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
				<path d="M7 9V7a2 2 0 0 1 2-2h2" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
				<circle cx="21.2" cy="10.3" r=".9" fill="currentColor"/>
				<circle cx="19.6" cy="11.6" r=".7" fill="currentColor"/>
			</svg>
			<p class="modal-title" id="dayModalTitle"></p>
		</div>
		<div id="dayModalBody"></div>
	</div>
</div>

<script>
var waterDetail = {
	<c:forEach var="entry" items="${waterDetail}" varStatus="loop">
		${entry.key}: [
			<c:forEach var="name" items="${entry.value}" varStatus="nloop">
				"${name}"<c:if test="${!nloop.last}">,</c:if>
			</c:forEach>
		]<c:if test="${!loop.last}">,</c:if>
	</c:forEach>
};
var calYear = ${year};
var calMonth = ${month};

function showDayDetail(day) {
	var names = waterDetail[day] || [];
	document.getElementById('dayModalTitle').textContent = calYear + '년 ' + calMonth + '월 ' + day + '일';
	var body = document.getElementById('dayModalBody');
	if (names.length === 0) {
		body.innerHTML = '<p class="detail-warn">이 날은 물 준 기록이 없어요.</p>';
	} else {
		body.innerHTML = names.map(function(name) {
			return '<div class="modal-list-item">' + name + '</div>';
		}).join('');
	}
	document.getElementById('dayModal').classList.add('show');
}

var dayModal = document.getElementById('dayModal');
document.getElementById('dayModalClose').addEventListener('click', function() {
	dayModal.classList.remove('show');
});
dayModal.addEventListener('click', function(e) {
	if (e.target === dayModal) dayModal.classList.remove('show');
});
</script>

<%@ include file="/views/layout/footer.jsp" %>
