package com.choi.board.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AttachVO {
	
	private String uuid; // uuid
	private String uploadPath; // 업로드 파일 경로
	private String fileName; // 파일 이름
	private boolean fileType; // 파일 타입
	private long bno; // 글 번호

}
