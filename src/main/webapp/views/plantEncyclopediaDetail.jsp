<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ include file="/views/layout/header.jsp" %>

<div class="reg-wrap">

	<a href="/plants/encyclopedia" class="detail-back">← 도감으로 돌아가기</a>

	<c:choose>
		<c:when test="${empty info}">
			<div class="reg-panel">
				<p class="detail-warn">⚠️ 정보를 불러올 수 없습니다.</p>
			</div>
		</c:when>
		<c:otherwise>
			<div class="reg-panel">
				<div class="detail-head">
					<div class="detail-avatar">
						<c:choose>
							<c:when test="${not empty info.imageUrl}">
								<img src="${fn:split(info.imageUrl, '|')[0]}" alt="">
							</c:when>
							<c:otherwise>🌿</c:otherwise>
						</c:choose>
					</div>
					<div>
						<div class="detail-name">${not empty info.plantName ? info.plantName : (not empty info.distbNm ? info.distbNm : '이름 정보 없음')}</div>
						<c:if test="${not empty info.plantSciName}">
							<div class="detail-species">${info.plantSciName}</div>
						</c:if>
					</div>
				</div>

				<c:if test="${not empty info.manageLevel}">
					<div class="detail-stats">
						<div class="detail-stat">
							<span class="detail-stat-label">관리 난이도</span>
							<span class="detail-stat-value">${info.manageLevel}</span>
						</div>
					</div>
				</c:if>
			</div>

			<div class="reg-panel">
				<h3>📋 기본 정보</h3>
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
			</div>

			<div class="reg-panel">
				<h3>💧 계절별 물주기</h3>
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
		</c:otherwise>
	</c:choose>

</div>

<%@ include file="/views/layout/footer.jsp" %>
