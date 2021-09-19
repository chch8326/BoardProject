package com.choi.board.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardPageDTO {
	
	private int startPage, endPage;
	private long totalArticleCount;
	private boolean prev, next;
	private Criteria cri;
	
	public BoardPageDTO(Criteria cri, long totalArticleCount) {
		this.cri = cri;
		this.totalArticleCount = totalArticleCount;
		
		this.endPage = (int)(Math.ceil(cri.getPageNum() / 10.0)) * 10;
		this.startPage = endPage - 9;
		int realEndPage = (int)(Math.ceil((totalArticleCount * 1.0) / cri.getAmount()));
		if(endPage > realEndPage) endPage = realEndPage;
		
		this.prev = startPage > 1;
		this.next = endPage < realEndPage;
	}

}
