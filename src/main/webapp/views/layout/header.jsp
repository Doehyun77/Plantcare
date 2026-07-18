<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>식물집사</title>
<link rel="stylesheet" href="/css/style.css">
</head>
<body>
<c:set var="reqUri" value="${empty requestScope['jakarta.servlet.forward.request_uri'] ? pageContext.request.requestURI : requestScope['jakarta.servlet.forward.request_uri']}" />
<header>
	<h1><a href="/">🌱 식물집사</a></h1>
	<nav>
		<a href="/" class="${reqUri == '/' ? 'active' : ''}"><span class="nav-ico">🏠</span>홈</a>
		<a href="/calendar" class="${fn:startsWith(reqUri, '/calendar') ? 'active' : ''}"><span class="nav-ico">📅</span>캘린더</a>
		<a href="/plants/register" class="${fn:startsWith(reqUri, '/plants/register') ? 'active' : ''}"><span class="nav-ico">🌿</span>식물등록</a>
		<a href="/plants/encyclopedia" class="${fn:startsWith(reqUri, '/plants/encyclopedia') ? 'active' : ''}"><span class="nav-ico">📖</span>도감</a>
	</nav>
</header>
<main>
