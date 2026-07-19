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
	 * 자동완성 검색 (Ajax, JSON 응답)
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
	public String registerForm() {
		return "plantRegister";
	}

	/**
	 * 등록 처리 (사진 업로드 포함)
	 */
	@PostMapping("/register")
	public String register(MyPlantDTO myPlant,
			@RequestParam(value = "photo", required = false) MultipartFile photo) {
		myPlant.setUserId("default");
		// 빈 문자열을 null로 변환 (DB DATE 타입 호환)
		if (myPlant.getLastWaterDate() != null && myPlant.getLastWaterDate().isEmpty()) {
			myPlant.setLastWaterDate(null);
		}

		// 사진 업로드 처리
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
	public String detail(@RequestParam("plantNo") int plantNo, Model model) {
		MyPlantDTO plant = plantService.getMyPlant(plantNo);
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

	/**
	 * 계절별 물주기 코드 -> 일수 (코드 없으면 null, 화면에 표시 안 함)
	 */
	private Integer codeToDays(String code) {
		return code != null ? calendarService.getIntervalFromCode(code) : null;
	}

	/**
	 * gardenDtl API 응답엔 이미지 URL이 없으므로, 캐시된 검색 결과에서 이미지 복원
	 */
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
	public String update(MyPlantDTO myPlant) {
		plantService.updatePlant(myPlant);
		return "redirect:/";
	}

	/**
	 * 삭제 처리
	 */
	@PostMapping("/delete")
	public String delete(@RequestParam("plantNo") int plantNo) {
		plantService.deletePlant(plantNo);
		return "redirect:/";
	}

	/**
	 * 도감: 식물 검색 페이지
	 */
	@GetMapping("/encyclopedia")
	public String encyclopediaForm() {
		return "plantEncyclopedia";
	}

	/**
	 * 도감: 식물 상세 정보 (API에서 직접 조회)
	 */
	@GetMapping("/encyclopedia/detail")
	public String encyclopediaDetail(@RequestParam("cntntsNo") String cntntsNo, Model model) {
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
	 * 도감: 식물 상세 정보 (Ajax, JSON 응답 - 검색 화면에서 바로 펼쳐 보여주기용)
	 */
	@GetMapping("/encyclopedia/info")
	@ResponseBody
	public Map<String, Object> encyclopediaInfo(@RequestParam("cntntsNo") String cntntsNo) {
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
