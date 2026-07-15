<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/layout/header.jsp" %>
<h2>🌿 나의 식물들</h2>

<c:if test="${empty plants}">
	<p>등록된 식물이 없습니다. <a href="/plants/register">첫 식물 등록하기</a></p>
</c:if>

<c:forEach var="plant" items="${plants}">
	<div style="border:1px solid #ddd;padding:12px;margin:8px 0;border-radius:8px;
		${plant.needsWater ? 'background:#fff3cd;border-color:#ffc107;' : ''}">
		<p>
			<strong>${plant.nickname}</strong>
			<c:if test="${plant.needsWater}"><span style="color:#d63384;"> 💧 물 줄 시간!</span></c:if>
		</p>
		<p>마지막 물: ${plant.lastWaterDate != null ? plant.lastWaterDate : '기록 없음'}</p>
		<button onclick="waterPlant(${plant.plantNo})">💧 간편체크</button>
		<a href="/plants/detail?plantNo=${plant.plantNo}">상세</a>
	</div>
</c:forEach>

<a href="/plants/register">+ 새 식물 등록</a>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
function waterPlant(plantNo) {
	$.post('/water/check', { plantNo: plantNo }, function() {
		location.reload();
	});
}
</script>
<%@ include file="/views/layout/footer.jsp" %>
