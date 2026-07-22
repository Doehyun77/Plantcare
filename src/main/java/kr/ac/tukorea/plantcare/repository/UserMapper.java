package kr.ac.tukorea.plantcare.repository;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.ac.tukorea.plantcare.dto.UserDTO;

@Mapper
public interface UserMapper {

    /** user_id로 사용자 조회 (로그인 검증용) */
    UserDTO findByUserId(@Param("userId") String userId);

    /** user_id 존재 여부 확인 (중복 체크용) */
    int countByUserId(@Param("userId") String userId);

    /** 회원가입 */
    void insert(UserDTO user);
}
