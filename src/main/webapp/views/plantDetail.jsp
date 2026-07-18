<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/layout/header.jsp" %>
<h2>🌱 식물 상세</h2>

<form action="/plants/update" method="post">
	<input type="hidden" name="plantNo" value="${plant.plantNo}">

	<label>별명 <input type="text" name="nickname" value="${plant.nickname}" required></label><br>
	<label>물주기 간격 (일) <input type="number" name="userWaterInterval" value="${plant.userWaterInterval}">
	<c:if test="${empty plant.userWaterInterval}"><small>(기본 ${actualInterval}일)</small></c:if></label><br>

	<button type="submit">수정</button>
</form>

<form action="/plants/delete" method="post" onsubmit="return confirm('삭제하시겠습니까?');">
	<input type="hidden" name="plantNo" value="${plant.plantNo}">
	<button type="submit" style="background:#dc3545;color:#fff;">삭제</button>
</form>

<a href="/">← 홈으로</a>
<%@ include file="/views/layout/footer.jsp" %>
