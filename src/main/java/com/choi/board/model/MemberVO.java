package com.choi.board.model;

import java.util.Date;
import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberVO {

	private String uid; // 아이디
	private String upassword; // 비밀번호
	private String uname; // 이름
	private String uemail; // 이메일
	private Date registerDate; // 가입일
	List<AuthVO> authList; // 부여 받은 권한 
	
}
