package com.choi.board.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import com.choi.board.model.Criteria;
import com.choi.board.model.ReplyPageDTO;
import com.choi.board.model.ReplyVO;
import com.choi.board.service.ReplyService;
import lombok.AllArgsConstructor;

@RestController
@AllArgsConstructor
@RequestMapping("/replies/")
public class ReplyController {
	
	private ReplyService replyService;
	
	/*
	 * 게시 글의 댓글 출력 
	 */
	@GetMapping(value = "/{bno}/{page}", 
				produces = { MediaType.APPLICATION_XML_VALUE, 
							 MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyPageDTO> getReplyListController(
			@PathVariable("bno") Long bno, @PathVariable("page") Integer page) {
		Criteria cri = new Criteria(page, 5);
		return new ResponseEntity<ReplyPageDTO>(replyService.getReplyList(cri, bno), HttpStatus.OK);
	}
	
	/*
	 * 댓글 작성
	 * 권한이 있어야 댓글 작성 가능
	 */
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/new", 
				 consumes = "application/json", 
				 produces = MediaType.TEXT_PLAIN_VALUE)
	public ResponseEntity<String> replyRegisterController(@RequestBody ReplyVO reply) {
		return replyService.replyRegister(reply) == 1 ? 
				new ResponseEntity<String>("success", HttpStatus.OK) : 
				new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	/*
	 * 댓글 조회 
	 */
	@GetMapping(value = "/{rno}", 
				produces = { MediaType.APPLICATION_XML_VALUE, 
							 MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyVO> replyViewController(@PathVariable("rno") Long rno) {
		return new ResponseEntity<ReplyVO>(replyService.replyView(rno), HttpStatus.OK);
	}
	
	/*
	 * 댓글 작성
	 * 자신이 쓴 댓글만 수정 가능
	 * 권한이 ROLE_ADMIN일 경우 모든 댓글 수정 가능
	 */
	@PreAuthorize("(principal.username == #reply.replyer) or hasRole('ROLE_ADMIN')")
	@RequestMapping(value = "/{rno}", 
					method = { RequestMethod.PUT, RequestMethod.PATCH }, 
					consumes = "application/json")
	public ResponseEntity<String> replyModifyController(
			@RequestBody ReplyVO reply, @PathVariable("rno") Long rno) {
		reply.setRno(rno);
		return replyService.replyModify(reply) == 1 ? 
				new ResponseEntity<String>("success", HttpStatus.OK) : 
				new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);	
	}
	
	/*
	 * 댓글 삭제
	 * 자신이 쓴 댓글만 삭제 가능
	 * 권한이 ROLE_ADMIN일 경우 모든 댓글 삭제 가능
	 */
	@PreAuthorize("principal.username == #reply.replyer or hasRole('ROLE_ADMIN')")
	@DeleteMapping("/{rno}")
	public ResponseEntity<String> replyRemoveController(
			@RequestBody ReplyVO reply, @PathVariable("rno") Long rno) {
		return replyService.replyDelete(rno) == 1 ? 
				new ResponseEntity<String>("success", HttpStatus.OK) : 
				new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
		
}
