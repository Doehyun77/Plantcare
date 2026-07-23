package kr.ac.tukorea.plantcare.dto;

import lombok.Data;

@Data
public class PlantDiaryDTO {
	private int diaryNo;
	private int plantNo;
	private String content;
	private String photoPath;
	private String regDate;
}
