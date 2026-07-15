package kr.ac.tukorea.plantcare.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.ac.tukorea.plantcare.dto.MyPlantDTO;
import kr.ac.tukorea.plantcare.service.WaterService;

@Controller
@RequestMapping("/water")
public class WaterController {

	private final WaterService waterService;

	public WaterController(WaterService waterService) {
		this.waterService = waterService;
	}

	/**
	 * 간편체크 (Ajax POST)
	 */
	@PostMapping("/check")
	@ResponseBody
	public String check(@RequestParam("plantNo") int plantNo) {
		waterService.checkWater(plantNo);
		return "ok";
	}

	/**
	 * 캘린더 데이터 (JSON) — 프론트팀에서 사용
	 */
	@GetMapping("/calendar-data")
	@ResponseBody
	public List<WaterService.CalendarDay> calendarData(
			@RequestParam("year") int year,
			@RequestParam("month") int month) {
		return waterService.getMonthlyWaterData(year, month, "default");
	}
}
