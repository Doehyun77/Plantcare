package kr.ac.tukorea.plantcare.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.ac.tukorea.plantcare.dto.MyPlantDTO;
import kr.ac.tukorea.plantcare.dto.PlantInfoDTO;
import kr.ac.tukorea.plantcare.repository.MyPlantMapper;
import kr.ac.tukorea.plantcare.repository.PlantInfoMapper;

@Service
public class PlantService {

	private final ApiService apiService;
	private final PlantInfoMapper plantInfoMapper;
	private final MyPlantMapper myPlantMapper;
	private final CalendarService calendarService;

	public PlantService(ApiService apiService, PlantInfoMapper plantInfoMapper,
			MyPlantMapper myPlantMapper, CalendarService calendarService) {
		this.apiService = apiService;
		this.plantInfoMapper = plantInfoMapper;
		this.myPlantMapper = myPlantMapper;
		this.calendarService = calendarService;
	}

	/**
	 * API 검색 (자동완성용)
	 */
	public List<PlantInfoDTO> searchPlants(String keyword) {
		List<PlantInfoDTO> results = apiService.searchPlants(keyword);
		// 검색 결과를 DB에 캐시 (이미지 URL 포함)
		for (PlantInfoDTO item : results) {
			if (item.getCntntsNo() == null || item.getImageUrl() == null) continue;
			PlantInfoDTO existing = plantInfoMapper.findByCntntsNo(item.getCntntsNo());
			if (existing == null) {
				plantInfoMapper.insert(item);
			} else if (existing.getImageUrl() == null) {
				// 기존 레코드에 이미지 URL이 없으면 업데이트
				plantInfoMapper.updateImageUrl(item.getCntntsNo(), item.getImageUrl());
			}
		}
		return results;
	}

	/**
	 * cntntsNo로 식물 정보 조회 (로컬 캐시 먼저, 없으면 API)
	 */
	public PlantInfoDTO getPlantInfo(String cntntsNo) {
		// 로컬 캐시 조회
		PlantInfoDTO cached = plantInfoMapper.findByCntntsNo(cntntsNo);
		if (cached != null) return cached;

		// API 상세 조회 후 캐시 저장
		PlantInfoDTO detail = apiService.getPlantDetail(cntntsNo);
		if (detail != null) {
			plantInfoMapper.insert(detail);
		}
		return detail;
	}

	/**
	 * 내 식물 목록 조회
	 */
	public List<MyPlantDTO> getMyPlants(String userId) {
		return myPlantMapper.findAllByUserId(userId);
	}

	/**
	 * 식물 등록 (API / 수동 모두 처리)
	 */
	public void registerPlant(MyPlantDTO myPlant) {
		String cntntsNo = myPlant.getCntntsNo();
		if (cntntsNo != null) {
			PlantInfoDTO existing = plantInfoMapper.findByCntntsNo(cntntsNo);
			if (existing == null) {
				PlantInfoDTO info = new PlantInfoDTO();
				info.setCntntsNo(cntntsNo);
				if (cntntsNo.startsWith("MANUAL_")) {
					info.setPlantName(myPlant.getNickname());
					info.setIsManual("Y");
				} else {
					// API 식물: 상세정보 조회해서 저장
					PlantInfoDTO detail = apiService.getPlantDetail(cntntsNo);
					if (detail != null) {
						info = detail;
					} else {
						info.setPlantName(myPlant.getNickname());
					}
				}
				plantInfoMapper.insert(info);
			}
		}
		myPlantMapper.insert(myPlant);
	}

	/**
	 * 특정 식물의 현재 물주기 간격(일) 계산
	 */
	public int getWateringInterval(MyPlantDTO plant) {
		if (plant.getUserWaterInterval() != null) {
			return plant.getUserWaterInterval();
		}
		String cntntsNo = plant.getCntntsNo();
		if (cntntsNo != null) {
			PlantInfoDTO info = plantInfoMapper.findByCntntsNo(cntntsNo);
			if (info != null) {
				String seasonCode = calendarService.getSeasonWaterCode(
					new CalendarService.PlantInfoForWatering() {
						public String getWaterSpring() { return info.getWaterSpring(); }
						public String getWaterSummer() { return info.getWaterSummer(); }
						public String getWaterAutumn() { return info.getWaterAutumn(); }
						public String getWaterWinter() { return info.getWaterWinter(); }
					});
				if (seasonCode != null) {
					return calendarService.getIntervalFromCode(seasonCode);
				}
			}
		}
		return CalendarService.DEFAULT_INTERVAL;
	}

	/**
	 * 내 식물 상세
	 */
	public MyPlantDTO getMyPlant(int plantNo) {
		return myPlantMapper.findByPlantNo(plantNo);
	}

	/**
	 * 식물 수정
	 */
	public void updatePlant(MyPlantDTO myPlant) {
		myPlantMapper.update(myPlant);
	}

	/**
	 * 식물 삭제
	 */
	public void deletePlant(int plantNo) {
		myPlantMapper.delete(plantNo);
	}
}
