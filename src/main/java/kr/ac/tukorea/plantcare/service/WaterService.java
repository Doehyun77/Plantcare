package kr.ac.tukorea.plantcare.service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import kr.ac.tukorea.plantcare.dto.MyPlantDTO;
import kr.ac.tukorea.plantcare.dto.WateringLogDTO;
import kr.ac.tukorea.plantcare.repository.MyPlantMapper;
import kr.ac.tukorea.plantcare.repository.WateringLogMapper;

@Service
public class WaterService {

	private final WateringLogMapper wateringLogMapper;
	private final MyPlantMapper myPlantMapper;
	private final CalendarService calendarService;
	private final PlantService plantService;

	public WaterService(WateringLogMapper wateringLogMapper,
			MyPlantMapper myPlantMapper, CalendarService calendarService,
			PlantService plantService) {
		this.wateringLogMapper = wateringLogMapper;
		this.myPlantMapper = myPlantMapper;
		this.calendarService = calendarService;
		this.plantService = plantService;
	}

	/**
	 * 간편체크
	 */
	public void checkWater(int plantNo) {
		WateringLogDTO log = new WateringLogDTO();
		log.setPlantNo(plantNo);
		String today = LocalDate.now().toString();
		log.setWaterDate(today);
		wateringLogMapper.insert(log);

		MyPlantDTO plant = myPlantMapper.findByPlantNo(plantNo);
		if (plant != null) {
			plant.setLastWaterDate(today);
			myPlantMapper.update(plant);
		}
	}

	/**
	 * 월별 물주기 데이터 (계절별 간격 반영)
	 */
	public List<CalendarDay> getMonthlyWaterData(int year, int month, String userId) {
		List<MyPlantDTO> plants = myPlantMapper.findAllByUserId(userId);

		return plants.stream()
			.filter(p -> "N".equals(p.getDelYn()))
			.map(p -> {
				int interval = plantService.getWateringInterval(p);
				return new CalendarDay(p.getPlantNo(), p.getNickname(),
					p.getLastWaterDate(), interval);
			})
			.collect(Collectors.toList());
	}

	/**
	 * 월별 실제 물준 기록 (watering_log 기준)
	 */
	public Map<Integer, Integer> getMonthlyWaterCounts(int year, int month, String userId) {
		List<WateringLogDTO> logs = wateringLogMapper.findByMonth(year, month, userId);
		Map<Integer, Integer> counts = new HashMap<>();
		for (WateringLogDTO log : logs) {
			if (log.getWaterDate() == null) continue;
			int day = LocalDate.parse(log.getWaterDate()).getDayOfMonth();
			counts.merge(day, 1, Integer::sum);
		}
		return counts;
	}

	/**
	 * 날짜별로 그날 물 준 식물 별명 목록 (달력에서 날짜 클릭 시 보여주기용)
	 */
	public Map<Integer, List<String>> getMonthlyWaterDetail(int year, int month, String userId) {
		List<WateringLogDTO> logs = wateringLogMapper.findByMonth(year, month, userId);
		Map<Integer, List<String>> detail = new HashMap<>();
		for (WateringLogDTO log : logs) {
			if (log.getWaterDate() == null) continue;
			int day = LocalDate.parse(log.getWaterDate()).getDayOfMonth();
			detail.computeIfAbsent(day, k -> new java.util.ArrayList<>()).add(log.getNickname());
		}
		return detail;
	}

	public static class CalendarDay {
		private final int plantNo;
		private final String nickname;
		private final String lastWaterDate;
		private final int interval;

		public CalendarDay(int plantNo, String nickname,
				String lastWaterDate, int interval) {
			this.plantNo = plantNo;
			this.nickname = nickname;
			this.lastWaterDate = lastWaterDate;
			this.interval = interval;
		}

		public int getPlantNo() { return plantNo; }
		public String getNickname() { return nickname; }
		public String getLastWaterDate() { return lastWaterDate; }
		public int getInterval() { return interval; }
	}
}
