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
						<td class="cal-cell ${day == 0 ? 'empty' : ''} ${day == today ? 'today' : ''}">
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

<%@ include file="/views/layout/footer.jsp" %>
