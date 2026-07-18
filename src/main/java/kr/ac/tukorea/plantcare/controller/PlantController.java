package kr.ac.tukorea.plantcare.controller;

import java.io.File;
import java.util.List;
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
import kr.ac.tukorea.plantcare.service.PlantService;
import kr.ac.tukorea.plantcare.service.ApiService;

@Controller
@RequestMapping("/plants")
public class PlantController {

	private final PlantService plantService;
	private final ApiService apiService;

	private static final String UPLOAD_DIR = "src/main/resources/static/images/plants/";

	public PlantController(PlantService plantService, ApiService apiService) {
		this.plantService = plantService;
		this.apiService = apiService;
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
		return "plantDetail";
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
		model.addAttribute("info", info);
		return "plantEncyclopediaDetail";
	}
}
