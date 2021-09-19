package com.choi.board.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AuthVO {

	private String uid; // 사용자 아이디
	private String auth; // 사용자 권한
	
}
