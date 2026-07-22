package kr.ac.tukorea.plantcare.repository;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import kr.ac.tukorea.plantcare.dto.MyPlantDTO;

@Mapper
public interface MyPlantMapper {
	List<MyPlantDTO> findAllByUserId(String userId);
	MyPlantDTO findByPlantNo(int plantNo);
	void insert(MyPlantDTO myPlant);
	void update(MyPlantDTO myPlant);
	void delete(@Param("plantNo") int plantNo, @Param("userId") String userId);
}
