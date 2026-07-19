<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/layout/header.jsp" %>

<div style="text-align:center;padding:3rem 1rem;">
	<div style="font-size:4rem;margin-bottom:1rem;">😵</div>
	<h2 style="margin-bottom:.8rem;">앗, 뭔가 잘못됐어요</h2>
	<p style="color:var(--sub);margin-bottom:.5rem;">${message}</p>
	<p style="color:#999;font-size:.85rem;margin-bottom:2rem;">
		같은 문제가 반복되면 개발자에게 알려주세요.
	</p>
	<a href="/" class="btn-primary">홈으로 가기</a>
</div>

<%@ include file="/views/layout/footer.jsp" %>
