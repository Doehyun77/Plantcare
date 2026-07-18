<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/layout/header.jsp" %>
<h2>🌿 식물 도감</h2>

<section>
	<h3>🔍 식물 검색</h3>
	<input type="text" id="searchKeyword" placeholder="식물명을 입력하세요" autocomplete="off">
	<div id="searchResults" style="margin-top:10px;"></div>
</section>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
let debounceTimer;
$('#searchKeyword').on('input', function() {
	clearTimeout(debounceTimer);
	const keyword = $(this).val().trim();
	if (keyword.length < 1) { $('#searchResults').empty(); return; }

	debounceTimer = setTimeout(function() {
		$.get('/plants/search', { keyword: keyword }, function(data) {
			let html = '<ul style="list-style:none;padding:0;">';
			if (data.length === 0) {
				html += '<li>검색 결과가 없습니다.</li>';
			} else {
				data.forEach(function(item) {
					html += '<li style="padding:10px;border:1px solid #ddd;margin:6px 0;border-radius:10px;cursor:pointer;" '
						+ 'onclick="location.href=\'/plants/encyclopedia/detail?cntntsNo=' + item.cntntsNo + '\'">'
						+ (item.imageUrl ? '<img src="' + item.imageUrl + '" style="width:50px;height:50px;vertical-align:middle;border-radius:8px;"> ' : '')
						+ '<strong>' + escapeHtml(item.plantName) + '</strong>'
						+ '</li>';
				});
			}
			html += '</ul>';
			$('#searchResults').html(html);
		});
	}, 300);
});

function escapeHtml(text) {
	return $('<span>').text(text).html();
}
</script>

<%@ include file="/views/layout/footer.jsp" %>
