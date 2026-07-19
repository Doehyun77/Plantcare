<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/layout/header.jsp" %>

<div class="reg-wrap">
	<div class="reg-panel">
		<h3>🔍 식물 검색</h3>
		<div class="reg-search-wrap">
			<input type="text" id="searchKeyword" class="reg-search-input" placeholder="식물명을 입력하세요 (예: 스투키)" autocomplete="off">
			<div id="searchResults" class="search-results"></div>
		</div>
		<div id="selectedBadge" class="selected-badge"></div>
	</div>

	<div class="reg-panel">
		<h3>🌱 등록 정보</h3>
		<form id="registerForm" action="/plants/register" method="post" enctype="multipart/form-data" novalidate>
			<input type="hidden" name="cntntsNo" id="cntntsNo">

			<div class="form-field">
				<label for="nickname">별명</label>
				<input type="text" name="nickname" id="nickname" required>
				<span class="field-error" id="nickname-error">별명을 입력해주세요.</span>
			</div>
			<div class="form-field">
				<label for="photo">사진</label>
				<input type="file" name="photo" id="photo" accept="image/*">
			</div>
			<div class="form-field">
				<label for="userWaterInterval">물주기 간격 (일)</label>
				<input type="number" name="userWaterInterval" id="userWaterInterval" placeholder="입력하지 않아도 자동으로 들어가요 !">
			</div>
			<div class="form-field">
				<label for="lastWaterDate">마지막 물 준 날짜</label>
				<input type="date" name="lastWaterDate" id="lastWaterDate" min="1900-01-01" max="2099-12-31">
			</div>

			<button type="submit" class="btn-primary">등록하기</button>
		</form>
	</div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
let debounceTimer;
$('#searchKeyword').on('input', function() {
	clearTimeout(debounceTimer);
	$('#cntntsNo').val('');
	$('#selectedBadge').removeClass('show').empty();
	$(this).removeClass('confirmed');
	const keyword = $(this).val().trim();
	if (keyword.length < 1) { $('#searchResults').empty(); return; }

	debounceTimer = setTimeout(function() {
		$('#searchResults').html('<div class="search-loading"><span class="spinner"></span>검색 중...</div>');
		$.get('/plants/search', { keyword: keyword }, function(data) {
			let html = '';
			if (data.length === 0) {
				html += '<p class="search-empty">검색 결과가 없습니다. <a href="#" id="manualBtn">수동 입력</a></p>';
			} else {
				data.forEach(function(item) {
					const thumb = item.imageUrl ? item.imageUrl.split('|')[0] : '';
					html += '<div class="search-row" onclick="selectPlant(\'' + item.cntntsNo + '\', \'' + escapeHtml(item.plantName) + '\')">'
						+ (thumb ? '<img src="' + thumb + '" alt="">' : '<span class="search-row-noimg">🌱</span>')
						+ '<span class="name">' + escapeHtml(item.plantName) + '</span>'
						+ '</div>';
				});
			}
			$('#searchResults').html(html);
		}).fail(function() {
			$('#searchResults').html('<p class="search-empty">검색 중 오류가 발생했어요. 다시 시도해주세요.</p>');
		});
	}, 300);
});

function selectPlant(cntntsNo, name) {
	$('#cntntsNo').val(cntntsNo);
	$('#nickname').val(name);
	$('#searchKeyword').val(name).addClass('confirmed');
	$('#searchResults').empty();
	$('#selectedBadge').html('✅ 선택됨 · ' + escapeHtml(name)).addClass('show');
}

$('#searchResults').on('click', '#manualBtn', function(e) {
	e.preventDefault();
	$('#cntntsNo').val('MANUAL_' + Date.now());
	$('#searchKeyword').addClass('confirmed');
	$('#searchResults').empty();
	$('#selectedBadge').html('📝 수동 입력 모드로 등록해요').addClass('show');
});

function escapeHtml(text) {
	return $('<span>').text(text).html();
}

$('#registerForm').on('submit', function(e) {
	const nickname = $('#nickname').val().trim();
	if (!nickname) {
		e.preventDefault();
		$('#nickname').addClass('invalid');
		$('#nickname-error').addClass('show');
		$('#nickname').trigger('focus');
	}
});

$('#nickname').on('input', function() {
	if ($(this).val().trim()) {
		$(this).removeClass('invalid');
		$('#nickname-error').removeClass('show');
	}
});
</script>

<%@ include file="/views/layout/footer.jsp" %>
