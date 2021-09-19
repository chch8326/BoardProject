package com.choi.board.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.choi.board.model.AttachVO;
import com.choi.board.model.BoardPageDTO;
import com.choi.board.model.BoardVO;
import com.choi.board.model.Criteria;
import com.choi.board.service.BoardService;
import lombok.AllArgsConstructor;

@Controller
@AllArgsConstructor
@RequestMapping("/board/*")
public class BoardController {
	
	private BoardService boardService;
	
	/*
	 * 게시 글 출력
	 * 권한이 부여되지 않아도 사용 가능
	 */
	@GetMapping("/list")
	public void getArticleListController(Criteria cri, Model model) {
		long totalArticleCount = boardService.getTotalArticleCount(cri);
		model.addAttribute("articleList", boardService.getArticleList(cri));
		model.addAttribute("page", new BoardPageDTO(cri, totalArticleCount));
	}
	
	/*
	 * 게시 글 조회
	 * 권한이 부여되지 않아도 사용 가능
	 */
	@GetMapping("/view")
	public void articleViewController(@RequestParam("bno") long bno, 
			@ModelAttribute("cri") Criteria cri, Model model) {
		boardService.viewCountIncrease(bno);
		model.addAttribute("board", boardService.articleView(bno));
	}
	
	/*
	 * 게시 글 작성 페이지 이동
	 * 권한이 있어야 함
	 */
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/register")
	public void articleRegisterController() {}
	
	/*
	 * 게시 글 작성
	 * 권한이 있어야 게시 글 작성 가능
	 */
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/register")
	public String articleRegisterController(BoardVO board, RedirectAttributes rattr) {
		boardService.articleRegister(board);
		rattr.addFlashAttribute("result", board.getBno());
		return "redirect:/board/list";
	}
	
	/*
	 * 게시 글 수정 페이지 이동
	 */
	@GetMapping("/modify")
	public void articleModifyController(@RequestParam("bno") long bno, 
			@ModelAttribute("cri") Criteria cri, Model model) {
		model.addAttribute("board", boardService.articleView(bno));
	}
	
	/*
	 * 게시 글 수정
	 * 자신이 쓴 글만 수정 가능
	 * 권한이 ROLE_ADMIN일 경우 모든 게시 글 수정 가능
	 */
	@PreAuthorize("(principal.username == #board.writer) or hasRole('ROLE_ADMIN')")
	@PostMapping("/modify")
	public String articleModifyController(@ModelAttribute("cri") Criteria cri, 
			BoardVO board, RedirectAttributes rattr) {
		if(boardService.articleModfiy(board)) {
			rattr.addFlashAttribute("result", "success");
		}
		
		rattr.addAttribute("pageNum", cri.getPageNum());
		rattr.addAttribute("amount", cri.getAmount());
		rattr.addAttribute("type", cri.getType());
		rattr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list";
	}
	
	/*
	 * 게시 글 삭제
	 * 자신이 쓴 글만 삭제 가능
	 * 권한이 ROLE_ADMIN일 경우 모든 게시 글 삭제 가능
	 */
	@PreAuthorize("(principal.username == #writer) or hasRole('ROLE_ADMIN')")
	@PostMapping("/delete")
	public String articleDeleteController(@RequestParam("bno") long bno, 
			@ModelAttribute("cri") Criteria cri, RedirectAttributes rattr, String writer) {
		List<AttachVO> attachFileList = boardService.getAttachFileList(bno);
		
		if(boardService.articleDelete(bno)) {
			deleteAllFiles(attachFileList);
			rattr.addFlashAttribute("result", "success");
		}

		rattr.addAttribute("pageNum", cri.getPageNum());
		rattr.addAttribute("amount", cri.getAmount());
		rattr.addAttribute("type", cri.getType());
		rattr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list";
	}
	
	/*
	 * 데이터베이스에 저장된 게시 글의 파일 출력
	 */
	@GetMapping(value = "/getAttachFile", 
				produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachVO>> getAttachFileListController(long bno) {
		return new ResponseEntity<List<AttachVO>>(boardService.getAttachFileList(bno), HttpStatus.OK);
	}
	
	/*
	 * 게시 글 삭제 시 게시 글에 등록된 모든 파일 삭제
	 */
	private void deleteAllFiles(List<AttachVO> attachFileList) {
		if(attachFileList == null || attachFileList.size() == 0) {
			return;
		}
		
		attachFileList.forEach(attachFile -> {
			try {
				Path filePath = Paths.get("D:\\upload\\" + attachFile.getUploadPath() + "\\" + 
						attachFile.getUuid() + "_" + attachFile.getFileName());
				Files.deleteIfExists(filePath);
			} catch(Exception e) {
				e.printStackTrace();
			}
		});
	}

}
