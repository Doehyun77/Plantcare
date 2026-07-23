<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/layout/header.jsp" %>

<div class="reg-wrap">
	<div class="reg-panel">
		<h3>📖 식물 도감 검색</h3>
		<div class="reg-search-wrap">
			<input type="text" id="searchKeyword" class="reg-search-input" placeholder="식물명을 입력하세요" autocomplete="off">
			<div id="searchResults" class="search-results"></div>
		</div>
	</div>

	<div id="encyclopediaDetail" class="reg-panel" style="display:none;"></div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
const EXAMPLE_PLANTS = ['몬스테라', '아이비', '산세베리아', '디펜바키아', '알로카시아', '칼라데아', '벤자민고무나무', '싱고니움'];
$('#searchKeyword').attr('placeholder', '식물명을 입력하세요 (예: ' + EXAMPLE_PLANTS[Math.floor(Math.random() * EXAMPLE_PLANTS.length)] + ')');

let debounceTimer;
$('#searchKeyword').on('input', function() {
	clearTimeout(debounceTimer);
	const keyword = $(this).val().trim();
	if (keyword.length < 1) { $('#searchResults').empty(); return; }

	debounceTimer = setTimeout(function() {
		$('#searchResults').html('<div class="search-loading"><span class="spinner"></span>검색 중...</div>');
		$.get('/plants/search', { keyword: keyword }, function(data) {
			let html = '';
			if (data.length === 0) {
				html += '<p class="search-empty">검색 결과가 없습니다.</p>';
			} else {
				data.forEach(function(item) {
					const thumb = item.imageUrl ? item.imageUrl.split('|')[0] : '';
					html += '<div class="search-row" onclick="showDetail(\'' + item.cntntsNo + '\')">'
						+ (thumb ? '<img src="' + thumb + '" alt="">' : '<span class="search-row-noimg">🌿</span>')
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

function showDetail(cntntsNo) {
	$('#searchResults').empty();
	$('#encyclopediaDetail').html('<div class="search-loading"><span class="spinner"></span>불러오는 중...</div>').show();
	$.get('/plants/encyclopedia/info', { cntntsNo: cntntsNo }, function(data) {
		renderDetail(data);
	}).fail(function() {
		$('#encyclopediaDetail').html('<p class="detail-warn">⚠️ 정보를 불러오지 못했어요.</p>').show();
	});
}

function renderDetail(data) {
	const info = data.info;
	if (!info) {
		$('#encyclopediaDetail').html('<p class="detail-warn">⚠️ 정보를 불러올 수 없습니다.</p>').show();
		return;
	}
	const thumb = info.imageUrl ? info.imageUrl.split('|')[0] : '';

	let html = '<div class="detail-head">';
	html += '<div class="detail-avatar">' + (thumb ? '<img src="' + thumb + '" alt="">' : '🌿') + '</div>';
	html += '<div><div class="detail-name">' + escapeHtml(info.plantName || info.distbNm || '이름 정보 없음') + '</div>';
	if (info.plantSciName) {
		html += '<div class="detail-species">' + escapeHtml(info.plantSciName) + '</div>';
	}
	html += '</div></div>';

	if (info.manageLevel) {
		html += '<div class="detail-stats"><div class="detail-stat">'
			+ '<span class="detail-stat-label">관리 난이도</span>'
			+ '<span class="detail-stat-value">' + escapeHtml(info.manageLevel) + '</span></div></div>';
	}

	html += '<h4 class="detail-subhead">📋 기본 정보</h4><div class="detail-facts">';
	html += fact('유통명', info.distbNm);
	html += fact('원산지', info.orgplceInfo);
	html += fact('기능성', info.fncltyInfo);
	html += fact('특별 관리', info.speclmanageInfo);
	html += fact('독성 정보', info.toxctyInfo);
	html += '</div>';

	html += '<h4 class="detail-subhead">💧 계절별 물주기</h4><div class="detail-facts">';
	html += seasonFact('spring', '봄', info.waterSpringDesc, data.springDays, data.season);
	html += seasonFact('summer', '여름', info.waterSummerDesc, data.summerDays, data.season);
	html += seasonFact('autumn', '가을', info.waterAutumnDesc, data.autumnDays, data.season);
	html += seasonFact('winter', '겨울', info.waterWinterDesc, data.winterDays, data.season);
	html += '</div>';

	$('#encyclopediaDetail').html(html).show();
}

function fact(label, value) {
	if (!value) return '';
	return '<div class="detail-fact"><span class="detail-fact-label">' + label + '</span>'
		+ '<span class="detail-fact-value">' + escapeHtml(value) + '</span></div>';
}

function seasonFact(key, label, desc, days, currentSeason) {
	const current = key === currentSeason ? 'current' : '';
	const dayText = days != null ? ' ' + days + '일에 한 번' : '';
	return '<div class="detail-fact ' + current + '"><span class="detail-fact-label">' + label + '</span>'
		+ '<span class="detail-fact-value">' + escapeHtml(desc || '') + dayText + '</span></div>';
}

function escapeHtml(text) {
	return $('<span>').text(text).html();
}
</script>

<%@ include file="/views/layout/footer.jsp" %>
