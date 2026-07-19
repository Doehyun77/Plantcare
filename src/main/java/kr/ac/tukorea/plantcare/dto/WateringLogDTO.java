package kr.ac.tukorea.plantcare.dto;

import lombok.Data;

@Data
public class WateringLogDTO {
	private int logNo;
	private int plantNo;
	private String waterDate;
	private String regDate;
	private String nickname; // findByMonth 조회 시에만 채워짐 (my_plant 조인)
}
