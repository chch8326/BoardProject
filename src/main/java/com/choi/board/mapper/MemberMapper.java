package com.choi.board.mapper;

import com.choi.board.model.AuthVO;
import com.choi.board.security.model.CustomUserDetails;

public interface MemberMapper {
	
	// 사용자 정보 반환
	public CustomUserDetails getUserById(String uid);
	
	// 회원가입
	public void create(CustomUserDetails user);
	
	// 권한 설정
	public void authSet(AuthVO auth);

}
