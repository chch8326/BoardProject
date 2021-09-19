package com.choi.board.model;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
public class ReplyPageDTO {

	private int replyCount; // 한 게시 글의 댓글 수
	private List<ReplyVO> replyList; // 한 게시 글의 댓글
 	
}
