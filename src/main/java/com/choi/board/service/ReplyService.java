package com.choi.board.service;

import com.choi.board.model.Criteria;
import com.choi.board.model.ReplyPageDTO;
import com.choi.board.model.ReplyVO;

public interface ReplyService {
	
	// 게시 글의 댓글 출력
	public ReplyPageDTO getReplyList(Criteria cri, long bno);
	
	// 댓글 작성
	public int replyRegister(ReplyVO reply);
	
	// 댓글 조회
	public ReplyVO replyView(long rno);
	
	// 댓글 수정
	public int replyModify(ReplyVO reply);
	
	// 댓글 삭제
	public int replyDelete(long rno);

}
