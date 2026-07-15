package kr.ac.tukorea.plantcare.dto;

import lombok.Data;

@Data
public class WateringLogDTO {
	private int logNo;
	private int plantNo;
	private String waterDate;
	private String regDate;
}
