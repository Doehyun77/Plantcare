package kr.ac.tukorea.plantcare.dto;

import lombok.Data;

@Data
public class PlantInfoDTO {
	private String cntntsNo;
	private String plantName;
	private String plantSciName;
	private String plantEngName;
	private String distbNm;
	private String imageUrl;
	private String waterSpring;
	private String waterSummer;
	private String waterAutumn;
	private String waterWinter;
	private String manageLevel;
	private String growthInfo;
	private String isManual;
	private String fncltyInfo;      // 기능성 정보
	private String orgplceInfo;     // 원산지
	private String speclmanageInfo; // 특별 관리 정보
	private String toxctyInfo;      // 독성 정보
	private String regDate;
}
