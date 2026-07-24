package kr.ac.tukorea.plantcare.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpSession;
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
	public String home(HttpSession session, Model model) {
		String userId = (String) session.getAttribute("userId");
		if (userId == null) return "redirect:/login";

		List<MyPlantDTO> plants = plantService.getMyPlants(userId);

		List<PlantWithWater> result = plants.stream().map(p -> {
			int interval = plantService.getWateringInterval(p);
			boolean needsWater = calendarService.needsWaterToday(
				p.getLastWaterDate(), interval);
			String imageUrl = null;
			if (p.getCntntsNo() != null) {
				var info = plantService.getPlantInfo(p.getCntntsNo());
				if (info != null) imageUrl = info.getImageUrl();
			}
			int daysTogether = plantService.getDaysTogether(p.getRegDate());
			String growthTier = plantService.getGrowthTier(daysTogether);
			return new PlantWithWater(p, needsWater, imageUrl, daysTogether, growthTier);
		}).collect(Collectors.toList());

		model.addAttribute("plants", result);
		return "home";
	}

	public static class PlantWithWater {
		private final MyPlantDTO plant;
		private final boolean needsWater;
		private final String imageUrl;
		private final int daysTogether;
		private final String growthTier;

		public PlantWithWater(MyPlantDTO plant, boolean needsWater, String imageUrl,
				int daysTogether, String growthTier) {
			this.plant = plant;
			this.needsWater = needsWater;
			this.imageUrl = imageUrl;
			this.daysTogether = daysTogether;
			this.growthTier = growthTier;
		}

		public int getPlantNo() { return plant.getPlantNo(); }
		public String getNickname() { return plant.getNickname(); }
		public String getLastWaterDate() { return plant.getLastWaterDate(); }
		public String getPhotoPath() { return plant.getPhotoPath(); }
		public String getImageUrl() { return imageUrl; }
		public boolean isNeedsWater() { return needsWater; }
		public int getDaysTogether() { return daysTogether; }
		public String getGrowthTier() { return growthTier; }
	}
}
