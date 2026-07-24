package kr.ac.tukorea.plantcare.repository;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import kr.ac.tukorea.plantcare.dto.PlantDiaryDTO;

@Mapper
public interface PlantDiaryMapper {
	List<PlantDiaryDTO> findByPlantNo(int plantNo);
	PlantDiaryDTO findByDiaryNo(int diaryNo);
	void insert(PlantDiaryDTO diary);
	void delete(int diaryNo);
}
