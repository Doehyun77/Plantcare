package kr.ac.tukorea.plantcare.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;
import kr.ac.tukorea.plantcare.dto.UserDTO;
import kr.ac.tukorea.plantcare.service.UserService;

@Controller
public class LoginController {

	private final UserService userService;

	public LoginController(UserService userService) {
		this.userService = userService;
	}

	/**
	 * 로그인 페이지
	 */
	@GetMapping("/login")
	public String loginForm(HttpSession session) {
		// 이미 로그인 상태면 홈으로
		if (session.getAttribute("userId") != null) {
			return "redirect:/";
		}
		return "login";
	}

	/**
	 * 로그인 처리
	 */
	@PostMapping("/login")
	public String login(
			@RequestParam("userId") String userId,
			@RequestParam("password") String password,
			HttpSession session,
			Model model) {

		UserDTO user = userService.login(userId, password);
		if (user != null) {
			// 로그인 성공: 세션에 사용자 정보 저장
			session.setAttribute("userId", user.getUserId());
			session.setAttribute("nickname", user.getNickname());
			return "redirect:/";
		}

		// 로그인 실패
		model.addAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다.");
		return "login";
	}

	/**
	 * 로그아웃
	 */
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/login";
	}
}
