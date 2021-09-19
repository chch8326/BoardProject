package com.choi.board.model;

import java.util.Date;
import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardVO {
	
	private long bno; // 글 번호
	private String writer; // 작성자
	private String title; // 글 제목
	private String content; // 글 내용
	private int viewCount; // 조회 수
	private int replyCount; // 댓글 수
	private Date registerDate; // 글 작성일
	private Date updateDate; // 글 수정일
	private List<AttachVO> attachList; // 파일 목록

}
