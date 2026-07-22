<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/views/layout/header.jsp" />

<h2>회원가입</h2>

<c:if test="${not empty error}">
	<p style="color: red;">${error}</p>
</c:if>

<form action="/register" method="post">
	<div>
		<label for="userId">아이디</label>
		<input type="text" id="userId" name="userId" value="${user.userId}"
			required minlength="4" maxlength="20"
			placeholder="영문+숫자 4~20자">
	</div>
	<div>
		<label for="password">비밀번호</label>
		<input type="password" id="password" name="password"
			required minlength="4" placeholder="4자 이상">
	</div>
	<div>
		<label for="nickname">별명</label>
		<input type="text" id="nickname" name="nickname" value="${user.nickname}"
			required placeholder="사용할 별명">
	</div>
	<button type="submit">가입하기</button>
</form>

<p>이미 계정이 있으신가요? <a href="/login">로그인</a></p>

<jsp:include page="/views/layout/footer.jsp" />
