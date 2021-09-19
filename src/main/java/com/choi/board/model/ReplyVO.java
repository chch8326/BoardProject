package com.choi.board.model;

import java.util.Date;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReplyVO {

	private long rno; // 댓글 번호
	private long bno; // 글 번호
	private String replyer; // 댓글 작성자
	private String reply; // 댓글
	private Date replyDate; // 댓글 작성일
	private Date updateDate; // 댓글 수정일
	
}
