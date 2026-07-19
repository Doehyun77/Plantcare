package kr.ac.tukorea.plantcare.config;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;

@ControllerAdvice
public class GlobalExceptionHandler {

	@ExceptionHandler(Exception.class)
	public ModelAndView handleException(HttpServletRequest req, Exception e) {
		e.printStackTrace();

		ModelAndView mav = new ModelAndView("error");
		mav.addObject("message", "요청을 처리하는 중 오류가 발생했어요. 다시 시도해주세요.");
		return mav;
	}
}
