<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/layout/header.jsp" %>
<h2>📅 물주기 캘린더</h2>

<div style="text-align:center;margin-bottom:1rem;">
	<a href="/calendar?year=${prevYear}&month=${prevMonth}" style="font-size:1.5rem;">◀</a>
	<strong style="font-size:1.5rem;margin:0 2rem;">${year}년 ${month}월</strong>
	<a href="/calendar?year=${nextYear}&month=${nextMonth}" style="font-size:1.5rem;">▶</a>
</div>

<table style="width:100%;border-collapse:collapse;text-align:center;">
	<thead>
		<tr style="background:#2d6a4f;color:#fff;">
			<th style="padding:8px;">일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th>토</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="week" items="${weeks}">
			<tr>
				<c:forEach var="day" items="${week}">
					<td style="padding:12px;border:1px solid #ddd;vertical-align:top;height:80px;
						${day == today ? 'background:#fff3cd;' : ''}
						${day == 0 ? 'background:#f8f9fa;' : ''}">
						<c:if test="${day > 0}">
							<strong>${day}</strong>
							<c:set var="cnt" value="${waterCounts[day]}"/>
							<c:if test="${cnt != null && cnt > 0}">
								<div style="font-size:0.8rem;color:#2d6a4f;">
									💧 <c:out value="${cnt}"/>회
								</div>
							</c:if>
						</c:if>
					</td>
				</c:forEach>
			</tr>
		</c:forEach>
	</tbody>
</table>

<style>
td:hover { background: #f0fff0; cursor: default; }
</style>

<%@ include file="/views/layout/footer.jsp" %>
