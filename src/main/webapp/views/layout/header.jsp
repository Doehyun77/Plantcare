<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Plan-Ti</title>
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
<c:set var="reqUri" value="${empty requestScope['jakarta.servlet.forward.request_uri'] ? pageContext.request.requestURI : requestScope['jakarta.servlet.forward.request_uri']}" />
<header>
	<h1>
		<a href="/" class="logo">
			<span>Plan</span>
			<svg class="logo-leaf" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
				<path d="M12 21c0-6 3-9 8-10-1 6-3 9-8 10Z"/>
			</svg>
			<span class="logo-accent">Ti</span>
		</a>
	</h1>
	<nav>
		<c:if test="${not empty sessionScope.nickname}">
			<a href="/" class="${reqUri == '/' ? 'active' : ''}"><span class="nav-ico">🏠</span>홈</a>
			<a href="/calendar" class="${fn:startsWith(reqUri, '/calendar') ? 'active' : ''}"><span class="nav-ico">📅</span>캘린더</a>
			<a href="/plants/register" class="${fn:startsWith(reqUri, '/plants/register') ? 'active' : ''}"><span class="nav-ico">🌿</span>식물등록</a>
			<a href="/plants/encyclopedia" class="${fn:startsWith(reqUri, '/plants/encyclopedia') ? 'active' : ''}"><span class="nav-ico">📖</span>도감</a>
		</c:if>
		<c:choose>
			<c:when test="${not empty sessionScope.nickname}">
				<a href="/logout" id="logoutLink" class="nav-logout"><span class="nav-ico">🚪</span>로그아웃</a>
			</c:when>
			<c:otherwise>
				<a href="/login" class="nav-login"><span class="nav-ico">🔐</span>로그인</a>
			</c:otherwise>
		</c:choose>
	</nav>
</header>
<main>
