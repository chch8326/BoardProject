package com.choi.board.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.choi.board.mapper.AttachMapper;
import com.choi.board.mapper.BoardMapper;
import com.choi.board.mapper.ReplyMapper;
import com.choi.board.model.AttachVO;
import com.choi.board.model.BoardVO;
import com.choi.board.model.Criteria;
import lombok.AllArgsConstructor;
import lombok.Setter;

@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper replyMapper;
	
	@Setter(onMethod_ = @Autowired)
	private AttachMapper attachMapper;
	
	@Override
	public List<BoardVO> getArticleList(Criteria cri) {
		return boardMapper.getList(cri);
	}

	@Override
	public long getTotalArticleCount(Criteria cri) {
		return boardMapper.getTotalCount(cri);
	}

	@Override
	public BoardVO articleView(long bno) {
		return boardMapper.view(bno);
	}

	@Override
	public void viewCountIncrease(long bno) {
		boardMapper.increase(bno);
	}

	@Transactional
	@Override
	public void articleRegister(BoardVO board) {
		boardMapper.register(board);
		
		if((board.getAttachList() == null) || (board.getAttachList().size() == 0)) {
			return;
		}
		
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.registerFile(attach);
		});
	}

	@Transactional
	@Override
	public boolean articleModfiy(BoardVO board) {
		attachMapper.deleteAllFiles(board.getBno());
		
		boolean modifyResult = boardMapper.modify(board) == 1;
		
		if(modifyResult && (board.getAttachList() != null) 
						&& (board.getAttachList().size() > 0)) {
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.registerFile(attach);
			});
		}
		
		return modifyResult;
	}

	@Transactional
	@Override
	public boolean articleDelete(long bno) {
		attachMapper.deleteAllFiles(bno);
		replyMapper.deleteAll(bno);
		return boardMapper.delete(bno) == 1;
	}

	@Override
	public List<AttachVO> getAttachFileList(long bno) {
		return attachMapper.getFile(bno);
	}

}
