package kr.ac.tukorea.plantcare.repository;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import kr.ac.tukorea.plantcare.dto.WateringLogDTO;

@Mapper
public interface WateringLogMapper {
	List<WateringLogDTO> findByPlantNo(int plantNo);
	void insert(WateringLogDTO wateringLog);
	List<WateringLogDTO> findByMonth(int year, int month, String userId);
}
