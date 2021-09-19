package com.choi.board.controller;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import com.choi.board.security.CustomUserDetailsService;
import com.choi.board.security.model.CustomUserDetails;
import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
public class SecurityController {
	
	private CustomUserDetailsService userService;
	
	private PasswordEncoder passwordEncoder;
	
	/*
	 * 로그인 페이지 이동, 로그인
	 */
	@RequestMapping(value = "/boardLogin", 
					method = { RequestMethod.GET, RequestMethod.POST })
	public void loginController() {}
	
	/*
	 * 회원가입 페이지 이동
	 */
	@GetMapping("/signUp")
	public void signUpController() {}

	/*
	 * 회원가입
	 */
	@PostMapping("/signUp")
	public String signUpController(CustomUserDetails user) {
		String encodedPassword = passwordEncoder.encode(user.getPassword());
		user.setPassword(encodedPassword);
		userService.signUp(user);
		return "redirect:/boardLogin";
	}
	
}
