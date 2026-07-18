<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ include file="/views/layout/header.jsp" %>

<c:choose>
	<c:when test="${empty info}">
		<h2>⚠️ 정보를 불러올 수 없습니다</h2>
		<a href="/plants/encyclopedia">← 도감으로 돌아가기</a>
	</c:when>
	<c:otherwise>
		<h2>🌿 ${info.plantName}</h2>

		<c:if test="${not empty info.imageUrl}">
			<img src="${info.imageUrl}" alt="${info.plantName}" style="max-width:300px;border-radius:12px;">
		</c:if>

		<table style="width:100%;border-collapse:collapse;margin-top:1rem;">
			<tr><td style="padding:8px;border-bottom:1px solid #ddd;font-weight:700;width:140px;">학명</td>
				<td style="padding:8px;border-bottom:1px solid #ddd;"><i>${info.plantSciName}</i></td></tr>

			<tr><td style="padding:8px;border-bottom:1px solid #ddd;font-weight:700;">유통명</td>
				<td style="padding:8px;border-bottom:1px solid #ddd;">${info.distbNm}</td></tr>

			<tr><td style="padding:8px;border-bottom:1px solid #ddd;font-weight:700;">원산지</td>
				<td style="padding:8px;border-bottom:1px solid #ddd;">${info.orgplceInfo}</td></tr>

			<tr><td style="padding:8px;border-bottom:1px solid #ddd;font-weight:700;">기능성</td>
				<td style="padding:8px;border-bottom:1px solid #ddd;">${info.fncltyInfo}</td></tr>

			<tr><td style="padding:8px;border-bottom:1px solid #ddd;font-weight:700;">특별 관리</td>
				<td style="padding:8px;border-bottom:1px solid #ddd;">${info.speclmanageInfo}</td></tr>

			<tr><td style="padding:8px;border-bottom:1px solid #ddd;font-weight:700;">독성 정보</td>
				<td style="padding:8px;border-bottom:1px solid #ddd;">${info.toxctyInfo}</td></tr>
		</table>

		<p style="margin-top:1.5rem;"><a href="/plants/encyclopedia">← 도감으로 돌아가기</a></p>
	</c:otherwise>
</c:choose>

<%@ include file="/views/layout/footer.jsp" %>
