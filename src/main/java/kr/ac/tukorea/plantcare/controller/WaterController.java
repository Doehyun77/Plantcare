package kr.ac.tukorea.plantcare.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.ac.tukorea.plantcare.service.WaterService;

@Controller
@RequestMapping("/water")
public class WaterController {

	private final WaterService waterService;

	public WaterController(WaterService waterService) {
		this.waterService = waterService;
	}

	@PostMapping("/check")
	@ResponseBody
	public String check(@RequestParam("plantNo") int plantNo, HttpSession session) {
		String userId = (String) session.getAttribute("userId");
		if (userId == null) return "unauthorized";
		boolean success = waterService.checkWater(plantNo, userId);
		return success ? "ok" : "unauthorized";
	}
}
