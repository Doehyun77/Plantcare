package kr.ac.tukorea.plantcare.service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public class CalendarService {

	// API 물주기 코드 -> 일수 변환 (농촌진흥청 실제 코드 기준)
	// 053002 = 흙을 촉촉하게 유지함          -> 3일 (자주)
	// 053003 = 토양 표면이 말랐을때 충분히 관수함 -> 7일 (보통)
	// 053004 = 화분 흙 대부분 말랐을때 충분히 관수함 -> 14일 (조금)
	public static final Map<String, Integer> WATER_CYCLE_MAP = Map.of(
		"053002", 3,
		"053003", 7,
		"053004", 14
	);

	// 기본 물주기 (코드 없을 경우)
	public static final int DEFAULT_INTERVAL = 7;

	/**
	 * 현재 계절 코드 반환 (한국 기준)
	 * 봄: 3-5월, 여름: 6-8월, 가을: 9-11월, 겨울: 12-2월
	 */
	public String getCurrentSeasonCode() {
		return getSeasonCode(LocalDate.now());
	}

	public String getSeasonCode(LocalDate date) {
		int month = date.getMonthValue();
		if (month >= 3 && month <= 5) return "spring";
		if (month >= 6 && month <= 8) return "summer";
		if (month >= 9 && month <= 11) return "autumn";
		return "winter";
	}

	/**
	 * plant_info의 계절별 물주기 코드 중 현재 계절에 해당하는 코드 반환
	 */
	public String getSeasonWaterCode(PlantInfoForWatering plant) {
		String season = getCurrentSeasonCode();
		switch (season) {
			case "spring": return plant.getWaterSpring();
			case "summer": return plant.getWaterSummer();
			case "autumn": return plant.getWaterAutumn();
			case "winter": return plant.getWaterWinter();
			default: return null;
		}
	}

	/**
	 * 물주기 코드 -> 일수 반환
	 */
	public int getIntervalFromCode(String code) {
		if (code == null) return DEFAULT_INTERVAL;
		return WATER_CYCLE_MAP.getOrDefault(code, DEFAULT_INTERVAL);
	}

	/**
	 * 오늘 물을 줘야 하는지 여부 판단
	 * @param lastWaterDate 마지막 물 준 날짜 (NULL이면 물 필요)
	 * @param interval 물주기 간격(일)
	 */
	public boolean needsWaterToday(String lastWaterDate, int interval) {
		if (lastWaterDate == null || lastWaterDate.isBlank()) return true;
		try {
			LocalDate last = LocalDate.parse(lastWaterDate);
			long daysSince = ChronoUnit.DAYS.between(last, LocalDate.now());
			return daysSince >= interval;
		} catch (Exception e) {
			return true; // 날짜 파싱 실패 → 안전하게 물 필요로 처리
		}
	}

	/**
	 * my_plant에 저장된 인터페이스 (CalendarService가 의존하는 최소 정보)
	 */
	public interface PlantInfoForWatering {
		String getWaterSpring();
		String getWaterSummer();
		String getWaterAutumn();
		String getWaterWinter();
	}
}
