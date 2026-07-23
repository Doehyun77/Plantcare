<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/layout/header.jsp" %>

<div class="auth-wrap">
	<div class="auth-panel">
		<div class="auth-badge">🌱</div>
		<h2 class="auth-title">로그인</h2>
		<p class="auth-sub">Plan-Ti에서 다시 만나요</p>

		<c:if test="${not empty error}">
			<div class="auth-error">${error}</div>
		</c:if>

		<form action="/login" method="post" class="auth-form">
			<div class="form-field">
				<label for="userId">아이디</label>
				<input type="text" id="userId" name="userId" required placeholder="아이디" autocomplete="username">
			</div>
			<div class="form-field">
				<label for="password">비밀번호</label>
				<input type="password" id="password" name="password" required placeholder="비밀번호" autocomplete="current-password">
			</div>
			<button type="submit" class="btn-primary auth-submit">로그인</button>
		</form>

		<p class="auth-switch">계정이 없으신가요? <a href="/register">회원가입</a></p>
	</div>
</div>

<%@ include file="/views/layout/footer.jsp" %>
