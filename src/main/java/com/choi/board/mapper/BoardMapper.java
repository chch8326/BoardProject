package com.choi.board.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.choi.board.model.BoardVO;
import com.choi.board.model.Criteria;

public interface BoardMapper {
	
	// 게시 글 출력
	public List<BoardVO> getList(Criteria cri);
	
	// 전체 게시 글 개수 반환
	public long getTotalCount(Criteria cri);
	
	// 게시 글 조회
	public BoardVO view(long bno);
	
	// 조회 수 증가
	public void increase(long bno);
	
	// 게시 글 작성
	public void register(BoardVO board);
	
	// 게시 글 수정
	public int modify(BoardVO board);
	
	// 게시 글 삭제
	public int delete(long bno);
	
	// 게시 글의 댓글 수 반환
	public int getReplyCount(@Param("bno") long bno, @Param("amount") int amount);

}
