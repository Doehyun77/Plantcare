package kr.ac.tukorea.plantcare.repository;

import org.apache.ibatis.annotations.Mapper;
import kr.ac.tukorea.plantcare.dto.PlantInfoDTO;

@Mapper
public interface PlantInfoMapper {
	PlantInfoDTO findByCntntsNo(String cntntsNo);
	void insert(PlantInfoDTO plantInfo);
	void updateImageUrl(String cntntsNo, String imageUrl);
	void updateWaterInfo(PlantInfoDTO plantInfo);
}
