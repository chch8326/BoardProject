package com.choi.board.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.choi.board.mapper.BoardMapper;
import com.choi.board.mapper.ReplyMapper;
import com.choi.board.model.Criteria;
import com.choi.board.model.ReplyPageDTO;
import com.choi.board.model.ReplyVO;
import lombok.AllArgsConstructor;
import lombok.Setter;

@Service
@AllArgsConstructor
public class ReplyServiceImpl implements ReplyService {
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper replyMapper;
	
	@Override
	public ReplyPageDTO getReplyList(Criteria cri, long bno) {
		return new ReplyPageDTO(replyMapper.getTotalCount(bno), 
				replyMapper.getList(cri, bno));
	}

	@Transactional
	@Override
	public int replyRegister(ReplyVO reply) {
		boardMapper.getReplyCount(reply.getBno(), 1);
		return replyMapper.register(reply);
	}
	
	@Override
	public ReplyVO replyView(long rno) {
		return replyMapper.view(rno);
	}

	@Override
	public int replyModify(ReplyVO reply) {
		return replyMapper.modify(reply);
	}

	@Transactional
	@Override
	public int replyDelete(long rno) {
		ReplyVO reply = replyMapper.view(rno);
		boardMapper.getReplyCount(reply.getBno(), -1);
		return replyMapper.delete(rno);
	}

}
