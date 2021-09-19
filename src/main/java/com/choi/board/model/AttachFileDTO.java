package com.choi.board.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AttachFileDTO {

	private String uploadPath; // 파일 업로드 경로
	private String uuid; // uuid
	private String fileName; // 파일 이름
	private boolean image; // 이미지 파일 구분
	
}
