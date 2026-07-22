package kr.ac.tukorea.plantcare.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import jakarta.servlet.http.HttpSession;
import kr.ac.tukorea.plantcare.dto.UserDTO;
import kr.ac.tukorea.plantcare.service.UserService;

@Controller
public class RegisterController {

	private final UserService userService;

	public RegisterController(UserService userService) {
		this.userService = userService;
	}

	/**
	 * 회원가입 페이지
	 */
	@GetMapping("/register")
	public String registerForm(HttpSession session) {
		// 이미 로그인 상태면 홈으로
		if (session.getAttribute("userId") != null) {
			return "redirect:/";
		}
		return "register";
	}

	/**
	 * 회원가입 처리
	 */
	@PostMapping("/register")
	public String register(UserDTO user, Model model) {
		boolean success = userService.register(user);

		if (!success) {
			model.addAttribute("error", "아이디는 영문+숫자 4~20자, 비밀번호는 4자 이상, 별명은 필수입니다.");
			model.addAttribute("user", user);
			return "register";
		}

		// 가입 성공 → 로그인 페이지로
		return "redirect:/login";
	}
}
