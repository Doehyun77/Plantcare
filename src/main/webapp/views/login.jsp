<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/views/layout/header.jsp" />

<h2>로그인</h2>

<c:if test="${not empty error}">
	<p style="color: red;">${error}</p>
</c:if>

<form action="/login" method="post">
	<div>
		<label for="userId">아이디</label>
		<input type="text" id="userId" name="userId" required placeholder="아이디">
	</div>
	<div>
		<label for="password">비밀번호</label>
		<input type="password" id="password" name="password" required placeholder="비밀번호">
	</div>
	<button type="submit">로그인</button>
</form>

<p>계정이 없으신가요? <a href="/register">회원가입</a></p>

<jsp:include page="/views/layout/footer.jsp" />
