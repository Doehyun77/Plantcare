package kr.ac.tukorea.plantcare.service;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import kr.ac.tukorea.plantcare.dto.UserDTO;
import kr.ac.tukorea.plantcare.repository.UserMapper;

@Service
public class UserService {

	private final UserMapper userMapper;
	private final BCryptPasswordEncoder passwordEncoder;

	public UserService(UserMapper userMapper, BCryptPasswordEncoder passwordEncoder) {
		this.userMapper = userMapper;
		this.passwordEncoder = passwordEncoder;
	}

	/**
	 * user_id 유효성 검사 (영문+숫자, 4~20자)
	 */
	public boolean isValidUserId(String userId) {
		return userId != null && userId.matches("^[a-zA-Z0-9]{4,20}$");
	}

	/**
	 * user_id 중복 체크
	 */
	public boolean isDuplicateUserId(String userId) {
		return userMapper.countByUserId(userId) > 0;
	}

	/**
	 * 회원가입
	 * @return 성공 true, 실패(false) — 유효성/중복/차단
	 */
	public boolean register(UserDTO user) {
		// user_id 유효성 검사
		if (!isValidUserId(user.getUserId())) return false;
		// 'default' 차단
		if ("default".equals(user.getUserId())) return false;
		// 중복 체크
		if (isDuplicateUserId(user.getUserId())) return false;
		// 비밀번호 최소 4자
		if (user.getPassword() == null || user.getPassword().length() < 4) return false;
		// 별명 필수
		if (user.getNickname() == null || user.getNickname().isBlank()) return false;

		// BCrypt 해싱
		user.setPassword(passwordEncoder.encode(user.getPassword()));
		userMapper.insert(user);
		return true;
	}

	/**
	 * 로그인 검증
	 * @return 성공 시 UserDTO, 실패 시 null
	 */
	public UserDTO login(String userId, String rawPassword) {
		if (userId == null || rawPassword == null) return null;

		UserDTO user = userMapper.findByUserId(userId);
		if (user == null) return null;

		// BCrypt matches()로 비밀번호 검증
		if (passwordEncoder.matches(rawPassword, user.getPassword())) {
			return user;
		}
		return null;
	}
}
