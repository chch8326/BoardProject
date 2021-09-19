package com.choi.board.service;

import java.util.List;
import com.choi.board.model.AttachVO;
import com.choi.board.model.BoardVO;
import com.choi.board.model.Criteria;

public interface BoardService {
	
	// 게시글 출력
	public List<BoardVO> getArticleList(Criteria cri);
		
	// 총 게시 글 개수 반환
	public long getTotalArticleCount(Criteria cri);
		
	// 게시 글 조회
	public BoardVO articleView(long bno);
		
	// 조회 수 증가
	public void viewCountIncrease(long bno);
		
	// 게시 글 작성
	public void articleRegister(BoardVO board);
		
	// 게시 글 수정
	public boolean articleModfiy(BoardVO board);
		
	// 게시 글 삭제
	public boolean articleDelete(long bno);
		
	// 파일 목록 반환
	public List<AttachVO> getAttachFileList(long bno);

}
