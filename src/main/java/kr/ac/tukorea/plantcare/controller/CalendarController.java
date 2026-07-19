package kr.ac.tukorea.plantcare.controller;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.ac.tukorea.plantcare.service.WaterService;

@Controller
public class CalendarController {

	private final WaterService waterService;

	public CalendarController(WaterService waterService) {
		this.waterService = waterService;
	}

	@GetMapping("/calendar")
	public String calendar(
			@RequestParam(value = "year", required = false) Integer year,
			@RequestParam(value = "month", required = false) Integer month,
			Model model) {

		LocalDate now = LocalDate.now();
		if (year == null) year = now.getYear();
		if (month == null) month = now.getMonthValue();

		YearMonth ym = YearMonth.of(year, month);
		LocalDate firstDay = ym.atDay(1);
		int startDayOfWeek = firstDay.getDayOfWeek().getValue(); // 1=월..7=일
		int daysInMonth = ym.lengthOfMonth();

		// 달력 그리드 (일요일 시작 = 0)
		int startSunday = (startDayOfWeek == 7) ? 0 : startDayOfWeek;
		List<List<Integer>> weeks = new ArrayList<>();
		List<Integer> week = new ArrayList<>();
		for (int i = 0; i < startSunday; i++) week.add(0);
		for (int d = 1; d <= daysInMonth; d++) {
			week.add(d);
			if (week.size() == 7) {
				weeks.add(week);
				week = new ArrayList<>();
			}
		}
		if (!week.isEmpty()) {
			while (week.size() < 7) week.add(0);
			weeks.add(week);
		}

		// 실제 물준 기록 (watering_log 기준)
		Map<Integer, Integer> waterCounts = waterService.getMonthlyWaterCounts(year, month, "default");
		Map<Integer, List<String>> waterDetail = waterService.getMonthlyWaterDetail(year, month, "default");

		model.addAttribute("year", year);
		model.addAttribute("month", month);
		model.addAttribute("weeks", weeks);
		// 현재 보고 있는 달이 이번 달일 때만 오늘 강조
		// -1: 빈 칸(패딩)의 day 값인 0과 절대 겹치지 않도록 함 (다른 달에서 빈 칸이 "오늘"로 잘못 강조되는 버그 방지)
		boolean isCurrentMonth = (year == now.getYear() && month == now.getMonthValue());
		model.addAttribute("today", isCurrentMonth ? now.getDayOfMonth() : -1);
		model.addAttribute("waterCounts", waterCounts);
		model.addAttribute("waterDetail", waterDetail);

		// 이전/다음 달
		YearMonth prev = ym.minusMonths(1);
		YearMonth next = ym.plusMonths(1);
		model.addAttribute("prevYear", prev.getYear());
		model.addAttribute("prevMonth", prev.getMonthValue());
		model.addAttribute("nextYear", next.getYear());
		model.addAttribute("nextMonth", next.getMonthValue());

		return "calendar";
	}

	@GetMapping("/api/calendar-data")
	@ResponseBody
	public Map<Integer, Integer> getCalendarData(
			@RequestParam("year") int year,
			@RequestParam("month") int month) {
		return waterService.getMonthlyWaterCounts(year, month, "default");
	}
}
