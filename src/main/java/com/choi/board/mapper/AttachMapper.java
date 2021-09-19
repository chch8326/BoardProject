package com.choi.board.mapper;

import java.util.List;
import com.choi.board.model.AttachVO;

public interface AttachMapper {
	
	// 게시 글의 파일 출력
	public List<AttachVO> getFile(long bno);
	
	// 파일 등록
	public void registerFile(AttachVO attach);
	
	// 파일 삭제
	public int deleteFile(String uuid);
	
	// 파일 전체 삭제
	public void deleteAllFiles(long bno);

}
