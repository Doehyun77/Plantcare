<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/layout/header.jsp" %>
<h2>🌱 식물 등록</h2>

<!-- API 검색 -->
<section>
	<h3>🔍 식물 검색</h3>
	<input type="text" id="searchKeyword" placeholder="식물명을 입력하세요 (예: 스투키)" autocomplete="off">
	<div id="searchResults" style="margin-top:10px;"></div>
</section>

<hr>

<!-- 등록 폼 -->
<form id="registerForm" action="/plants/register" method="post" enctype="multipart/form-data">
	<input type="hidden" name="cntntsNo" id="cntntsNo">

	<label>별명 <input type="text" name="nickname" id="nickname" required></label><br>
	<label>사진 <input type="file" name="photo" accept="image/*"></label><br>
	<label>물주기 간격 (일) <input type="number" name="userWaterInterval" id="userWaterInterval" placeholder="비우면 API 기본값"></label><br>

	<button type="submit">등록</button>
</form>

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
				html += '<li>검색 결과가 없습니다. <a href="#" id="manualBtn">수동 입력</a></li>';
			} else {
				data.forEach(function(item) {
					html += '<li style="padding:8px;border:1px solid #ddd;margin:4px 0;cursor:pointer;" '
						+ 'onclick="selectPlant(\'' + item.cntntsNo + '\', \'' + escapeHtml(item.plantName) + '\')">'
						+ (item.imageUrl ? '<img src="' + item.imageUrl + '" style="width:50px;height:50px;vertical-align:middle;"> ' : '')
						+ '<strong>' + escapeHtml(item.plantName) + '</strong>'
						+ '</li>';
				});
			}
			html += '</ul>';
			$('#searchResults').html(html);
		});
	}, 300);
});

function selectPlant(cntntsNo, name) {
	$('#cntntsNo').val(cntntsNo);
	$('#nickname').val(name);
	$('#searchResults').html('<p>✅ 선택됨: <strong>' + escapeHtml(name) + '</strong></p>');
}

$('#searchResults').on('click', '#manualBtn', function(e) {
	e.preventDefault();
	$('#cntntsNo').val('MANUAL_' + Date.now());
	$('#searchResults').html('<p>📝 수동 입력 모드</p>');
});

function escapeHtml(text) {
	return $('<span>').text(text).html();
}
</script>

<%@ include file="/views/layout/footer.jsp" %>
