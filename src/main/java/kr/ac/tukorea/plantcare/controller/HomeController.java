package kr.ac.tukorea.plantcare.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import kr.ac.tukorea.plantcare.dto.MyPlantDTO;
import kr.ac.tukorea.plantcare.service.CalendarService;
import kr.ac.tukorea.plantcare.service.PlantService;

@Controller
public class HomeController {

	private final PlantService plantService;
	private final CalendarService calendarService;

	public HomeController(PlantService plantService, CalendarService calendarService) {
		this.plantService = plantService;
		this.calendarService = calendarService;
	}

	@GetMapping("/")
	public String home(Model model) {
		List<MyPlantDTO> plants = plantService.getMyPlants("default");

		List<PlantWithWater> result = plants.stream().map(p -> {
			// 계절별 물주기 간격 계산
			int interval = plantService.getWateringInterval(p);
			boolean needsWater = calendarService.needsWaterToday(
				p.getLastWaterDate(), interval);
			return new PlantWithWater(p, needsWater);
		}).collect(Collectors.toList());

		model.addAttribute("plants", result);
		return "home";
	}

	public static class PlantWithWater {
		private final MyPlantDTO plant;
		private final boolean needsWater;

		public PlantWithWater(MyPlantDTO plant, boolean needsWater) {
			this.plant = plant;
			this.needsWater = needsWater;
		}

		public int getPlantNo() { return plant.getPlantNo(); }
		public String getNickname() { return plant.getNickname(); }
		public String getLastWaterDate() { return plant.getLastWaterDate(); }
		public boolean isNeedsWater() { return needsWater; }
	}
}
