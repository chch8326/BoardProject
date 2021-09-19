package com.choi.board.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.choi.board.model.Criteria;
import com.choi.board.model.ReplyVO;

public interface ReplyMapper {
	
	// 게시 글의 댓글 출력
	public List<ReplyVO> getList(@Param("cri") Criteria cri, @Param("bno") long bno);
	
	// 게시 글의 댓글 개수 반환
	public int getTotalCount(long bno);
	
	// 댓글 작성
	public int register(ReplyVO reply);
	
	// 댓글 조회
	public ReplyVO view(long rno);
	
	// 댓글 수정
	public int modify(ReplyVO reply);
	
	// 댓글 삭제
	public int delete(long rno);
	
	// 댓글 전체 삭제
	public void deleteAll(long bno);

}
