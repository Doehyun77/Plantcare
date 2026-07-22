<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/layout/header.jsp" %>

<div class="auth-wrap">
	<div class="auth-panel">
		<div class="auth-badge">🌿</div>
		<h2 class="auth-title">회원가입</h2>
		<p class="auth-sub">Plan-Ti와 함께 식물을 돌봐요</p>

		<c:if test="${not empty error}">
			<div class="auth-error">${error}</div>
		</c:if>

		<form action="/register" method="post" class="auth-form">
			<div class="form-field">
				<label for="userId">아이디</label>
				<input type="text" id="userId" name="userId" value="${user.userId}"
					required minlength="4" maxlength="20"
					placeholder="아이디" autocomplete="username">
				<span class="form-hint">영문+숫자 4~20자</span>
			</div>
			<div class="form-field">
				<label for="password">비밀번호</label>
				<input type="password" id="password" name="password"
					required minlength="4" placeholder="비밀번호" autocomplete="new-password">
				<span class="form-hint">4자 이상</span>
			</div>
			<div class="form-field">
				<label for="nickname">별명</label>
				<input type="text" id="nickname" name="nickname" value="${user.nickname}"
					required placeholder="사용할 별명">
			</div>
			<button type="submit" class="btn-primary auth-submit">가입하기</button>
		</form>

		<p class="auth-switch">이미 계정이 있으신가요? <a href="/login">로그인</a></p>
	</div>
</div>

<%@ include file="/views/layout/footer.jsp" %>
