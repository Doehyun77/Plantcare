package kr.ac.tukorea.plantcare.controller;

import java.io.File;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import kr.ac.tukorea.plantcare.dto.MyPlantDTO;
import kr.ac.tukorea.plantcare.dto.PlantInfoDTO;
import kr.ac.tukorea.plantcare.repository.PlantInfoMapper;
import kr.ac.tukorea.plantcare.service.PlantService;
import kr.ac.tukorea.plantcare.service.ApiService;
import kr.ac.tukorea.plantcare.service.CalendarService;

@Controller
@RequestMapping("/plants")
public class PlantController {

	private final PlantService plantService;
	private final ApiService apiService;
	private final CalendarService calendarService;
	private final PlantInfoMapper plantInfoMapper;

	private static final String UPLOAD_DIR = System.getProperty("user.dir") + "/uploads/images/plants/";

	public PlantController(PlantService plantService, ApiService apiService, CalendarService calendarService, PlantInfoMapper plantInfoMapper) {
		this.plantService = plantService;
		this.apiService = apiService;
		this.calendarService = calendarService;
		this.plantInfoMapper = plantInfoMapper;
	}

	/**
	 * 자동완성 검색 (Ajax, JSON 응답) — 인증 불필요
	 */
	@GetMapping("/search")
	@ResponseBody
	public List<PlantInfoDTO> search(@RequestParam("keyword") String keyword) {
		return plantService.searchPlants(keyword);
	}

	/**
	 * 등록 페이지
	 */
	@GetMapping("/register")
	public String registerForm(HttpSession session) {
		if (session.getAttribute("userId") == null) return "redirect:/login";
		return "plantRegister";
	}

	/**
	 * 등록 처리 (사진 업로드 포함)
	 */
	@PostMapping("/register")
	public String register(MyPlantDTO myPlant,
			@RequestParam(value = "photo", required = false) MultipartFile photo,
			HttpSession session) {
		String userId = (String) session.getAttribute("userId");
		if (userId == null) return "redirect:/login";

		myPlant.setUserId(userId);
		if (myPlant.getLastWaterDate() != null && myPlant.getLastWaterDate().isEmpty()) {
			myPlant.setLastWaterDate(null);
		}

		if (photo != null && !photo.isEmpty()) {
			try {
				String fileName = UUID.randomUUID().toString() + "_"
					+ photo.getOriginalFilename();
				File dest = new File(UPLOAD_DIR + fileName);
				dest.getParentFile().mkdirs();
				photo.transferTo(dest);
				myPlant.setPhotoPath("/images/plants/" + fileName);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		plantService.registerPlant(myPlant);
		return "redirect:/";
	}

	/**
	 * 상세 페이지
	 */
	@GetMapping("/detail")
	public String detail(@RequestParam("plantNo") int plantNo, Model model,
			HttpSession session) {
		String userId = (String) session.getAttribute("userId");
		if (userId == null) return "redirect:/login";

		MyPlantDTO plant = plantService.getMyPlant(plantNo);
		if (plant == null || !userId.equals(plant.getUserId())) return "redirect:/";
		model.addAttribute("plant", plant);
		int interval = plantService.getWateringInterval(plant);
		model.addAttribute("actualInterval", interval);
		String cntntsNo = plant.getCntntsNo();
		PlantInfoDTO info = (cntntsNo != null) ? plantService.getPlantInfo(cntntsNo) : null;
		model.addAttribute("info", info);
		model.addAttribute("needsWater",
			calendarService.needsWaterToday(plant.getLastWaterDate(), interval));
		model.addAttribute("season", calendarService.getCurrentSeasonCode());

		if (info != null) {
			model.addAttribute("springDays", codeToDays(info.getWaterSpring()));
			model.addAttribute("summerDays", codeToDays(info.getWaterSummer()));
			model.addAttribute("autumnDays", codeToDays(info.getWaterAutumn()));
			model.addAttribute("winterDays", codeToDays(info.getWaterWinter()));
		}
		return "plantDetail";
	}

	private Integer codeToDays(String code) {
		return code != null ? calendarService.getIntervalFromCode(code) : null;
	}

	private void restoreImageIfMissing(PlantInfoDTO info, String cntntsNo) {
		if (info != null && info.getImageUrl() == null) {
			PlantInfoDTO cached = plantInfoMapper.findByCntntsNo(cntntsNo);
			if (cached != null && cached.getImageUrl() != null) {
				info.setImageUrl(cached.getImageUrl());
			}
		}
	}

	/**
	 * 수정 처리
	 */
	@PostMapping("/update")
	public String update(MyPlantDTO myPlant, HttpSession session) {
		String userId = (String) session.getAttribute("userId");
		if (userId == null) return "redirect:/login";
		// 폼에서 온 userId는 무시하고 세션 값으로 덮어써서, 남의 식물을 수정하지 못하게 함
		myPlant.setUserId(userId);
		plantService.updatePlant(myPlant);
		return "redirect:/";
	}

	/**
	 * 삭제 처리
	 */
	@PostMapping("/delete")
	public String delete(@RequestParam("plantNo") int plantNo, HttpSession session) {
		String userId = (String) session.getAttribute("userId");
		if (userId == null) return "redirect:/login";
		plantService.deletePlant(plantNo, userId);
		return "redirect:/";
	}

	/**
	 * 도감 페이지
	 */
	@GetMapping("/encyclopedia")
	public String encyclopediaForm(HttpSession session) {
		if (session.getAttribute("userId") == null) return "redirect:/login";
		return "plantEncyclopedia";
	}

	/**
	 * 도감: 식물 상세
	 */
	@GetMapping("/encyclopedia/detail")
	public String encyclopediaDetail(@RequestParam("cntntsNo") String cntntsNo,
			Model model, HttpSession session) {
		if (session.getAttribute("userId") == null) return "redirect:/login";

		PlantInfoDTO info = apiService.getPlantDetail(cntntsNo);
		restoreImageIfMissing(info, cntntsNo);
		model.addAttribute("info", info);
		model.addAttribute("season", calendarService.getCurrentSeasonCode());
		if (info != null) {
			model.addAttribute("springDays", codeToDays(info.getWaterSpring()));
			model.addAttribute("summerDays", codeToDays(info.getWaterSummer()));
			model.addAttribute("autumnDays", codeToDays(info.getWaterAutumn()));
			model.addAttribute("winterDays", codeToDays(info.getWaterWinter()));
		}
		return "plantEncyclopediaDetail";
	}

	/**
	 * 도감: 식물 상세 JSON
	 */
	@GetMapping("/encyclopedia/info")
	@ResponseBody
	public Map<String, Object> encyclopediaInfo(@RequestParam("cntntsNo") String cntntsNo,
			HttpSession session) {
		if (session.getAttribute("userId") == null) return null;

		PlantInfoDTO info = apiService.getPlantDetail(cntntsNo);
		restoreImageIfMissing(info, cntntsNo);
		Map<String, Object> result = new LinkedHashMap<>();
		result.put("info", info);
		result.put("season", calendarService.getCurrentSeasonCode());
		if (info != null) {
			result.put("springDays", codeToDays(info.getWaterSpring()));
			result.put("summerDays", codeToDays(info.getWaterSummer()));
			result.put("autumnDays", codeToDays(info.getWaterAutumn()));
			result.put("winterDays", codeToDays(info.getWaterWinter()));
		}
		return result;
	}
}
