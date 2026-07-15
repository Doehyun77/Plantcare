package kr.ac.tukorea.plantcare.dto;

import lombok.Data;

@Data
public class MyPlantDTO {
	private int plantNo;
	private String userId;
	private String cntntsNo;
	private String nickname;
	private String photoPath;
	private Integer userWaterInterval;
	private String lastWaterDate;
	private String regDate;
	private String delYn;
}
