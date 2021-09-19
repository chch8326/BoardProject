package com.choi.board.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {

	private int pageNum; // 페이지 번호
	private int amount; // 한 페이지 당 게시글 수
	private String type; // 게시 글 검색 종류
	private String keyword; // 게시 글 키워드
	
	public Criteria() {
		this(1, 10);
	}
	
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	public int getBoardPageStart() {
		return (this.pageNum - 1) * amount;
	}
	
	public int getReplyPageStart() {
		return (this.pageNum - 1) * amount;
	}
	
	// 검색 조건이 각 글자(W, T, C)로 구성되어 있으므로 검색 조건을 배열로 만들어서 한 번에 처리하기 위함
	public String[] getTypeArr() {
		return type == null ? new String[] {} : type.split("");
	}
	
}
