package kr.ac.tukorea.plantcare.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.ac.tukorea.plantcare.dto.MyPlantDTO;
import kr.ac.tukorea.plantcare.dto.PlantDiaryDTO;
import kr.ac.tukorea.plantcare.repository.MyPlantMapper;
import kr.ac.tukorea.plantcare.repository.PlantDiaryMapper;

@Service
public class PlantDiaryService {

	private final PlantDiaryMapper plantDiaryMapper;
	private final MyPlantMapper myPlantMapper;

	public PlantDiaryService(PlantDiaryMapper plantDiaryMapper, MyPlantMapper myPlantMapper) {
		this.plantDiaryMapper = plantDiaryMapper;
		this.myPlantMapper = myPlantMapper;
	}

	public List<PlantDiaryDTO> getDiaries(int plantNo) {
		return plantDiaryMapper.findByPlantNo(plantNo);
	}

	public void addDiary(PlantDiaryDTO diary) {
		plantDiaryMapper.insert(diary);
	}

	/**
	 * 본인 소유 식물에 달린 일지일 때만 삭제
	 */
	public boolean deleteDiary(int diaryNo, String userId) {
		PlantDiaryDTO diary = plantDiaryMapper.findByDiaryNo(diaryNo);
		if (diary == null) return false;

		MyPlantDTO plant = myPlantMapper.findByPlantNo(diary.getPlantNo());
		if (plant == null || !userId.equals(plant.getUserId())) return false;

		plantDiaryMapper.delete(diaryNo);
		return true;
	}
}
