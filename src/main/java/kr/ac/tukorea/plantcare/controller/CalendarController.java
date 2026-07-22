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

import jakarta.servlet.http.HttpSession;
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
			HttpSession session,
			Model model) {

		String userId = (String) session.getAttribute("userId");
		if (userId == null) return "redirect:/login";

		LocalDate now = LocalDate.now();
		if (year == null) year = now.getYear();
		if (month == null) month = now.getMonthValue();

		YearMonth ym = YearMonth.of(year, month);
		LocalDate firstDay = ym.atDay(1);
		int startDayOfWeek = firstDay.getDayOfWeek().getValue();
		int daysInMonth = ym.lengthOfMonth();

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

		Map<Integer, Integer> waterCounts = waterService.getMonthlyWaterCounts(year, month, userId);
		Map<Integer, List<String>> waterDetail = waterService.getMonthlyWaterDetail(year, month, userId);

		model.addAttribute("year", year);
		model.addAttribute("month", month);
		model.addAttribute("weeks", weeks);
		boolean isCurrentMonth = (year == now.getYear() && month == now.getMonthValue());
		model.addAttribute("today", isCurrentMonth ? now.getDayOfMonth() : -1);
		model.addAttribute("waterCounts", waterCounts);
		model.addAttribute("waterDetail", waterDetail);

		YearMonth prev = ym.minusMonths(1);
		YearMonth next = ym.plusMonths(1);
		model.addAttribute("prevYear", prev.getYear());
		model.addAttribute("prevMonth", prev.getMonthValue());
		model.addAttribute("nextYear", next.getYear());
		model.addAttribute("nextMonth", next.getMonthValue());

		return "calendar";
	}
}
