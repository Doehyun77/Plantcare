package kr.ac.tukorea.plantcare.dto;

import lombok.Data;

@Data
public class UserDTO {
    private String userId;        // PK, 영문+숫자 4~20자
    private String password;      // BCrypt 해싱 저장
    private String nickname;      // 필수, 중복 가능
    private String regDate;       // 가입일시 (DB DEFAULT NOW())
}
