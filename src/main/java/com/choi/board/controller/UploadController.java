package com.choi.board.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.choi.board.model.AttachFileDTO;
import com.choi.board.service.AttachService;
import lombok.AllArgsConstructor;

@RestController
@AllArgsConstructor
public class UploadController {
	
	private AttachService attachService;
	
	/*
	 * 화면에 파일, 이미지 출력
	 */
	@GetMapping("/fileDisplay")
	public ResponseEntity<byte[]> fileDisplayController(String fileName) {
		ResponseEntity<byte[]> result = null;
		HttpHeaders header = new HttpHeaders();
		File file = new File("D:\\upload\\" + fileName);
		
		try {
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file), HttpStatus.OK);
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}

	/*
	 * 회면에 출력된 파일 다운로드
	 */
	@GetMapping(value = "/fileDownload", 
				produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	public ResponseEntity<Resource> fileDownloadController(
			@RequestHeader("User-Agent") String userAgent, String fileName) {
		HttpHeaders header = new HttpHeaders();
		Resource resource = new FileSystemResource("D:\\upload\\" + fileName);
		
		if(!resource.exists()) {
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		String resourceName = resource.getFilename();
		String originalResourceName = resourceName.substring(resourceName.indexOf("_") + 1);
		
		try {
			String downloadName = null;
			
			if(userAgent.contains("Trident")) { // 인터넷 익스프롤러에서 파일 다운로드 설정
				downloadName = URLEncoder.encode(originalResourceName, "UTF-8").replace("\\+", " ");
			} else if(userAgent.contains("Edge")) { // 마이크로소프트 엣지에서 파일 다운로드 설정
				downloadName = URLEncoder.encode(originalResourceName, "UTF-8"); 
			} else { // 크롬에서 파일 다운로드 설정
				downloadName = new String(originalResourceName.getBytes("UTF-8"), "iso-8859-1"); 
			}
			
			header.add("Content-Disposition", "attachment; fileName=" + downloadName);
		} catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
	}
	
	/*
	 * 파일이 저장되는 디렉터리에 파일, 이미지 저장
	 * 권한이 있어야 함 
	 */
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/fileUpload", 
				 produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	public ResponseEntity<List<AttachFileDTO>> fileUploadController(MultipartFile[] uploadFile) {
		List<AttachFileDTO> attachFileList = new ArrayList<AttachFileDTO>();
		String uploadFolder = "D:\\upload\\";
		String uploadFolderPath = getFolder();
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		
		if(!uploadPath.exists()) {
			uploadPath.mkdirs();
		}
		
		for(MultipartFile file : uploadFile) {
			AttachFileDTO dto = new AttachFileDTO();
			String fileName = file.getOriginalFilename();
			fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
			dto.setFileName(fileName);
			
			// 파일 이름 중복 방지
			UUID uuid = UUID.randomUUID();
			fileName = uuid.toString() + "_" + fileName;
			
			dto.setUuid(uuid.toString());
			dto.setUploadPath(uploadFolderPath);
			
			try {
				File saveFile = new File(uploadPath, fileName);
				file.transferTo(saveFile);
				
				if(isCheckImage(saveFile)) {
					dto.setImage(true);
				}
				
				attachFileList.add(dto);
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
		
		return new ResponseEntity<List<AttachFileDTO>>(attachFileList, HttpStatus.OK);
	}
	
	/*
	 * 파일이 저장되는 디렉터리에 있는 파일, 이미지 삭제
	 * 권한이 있어야 함 
	 */
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/fileInRepositoryRemove")
	public ResponseEntity<String> fileInRepositoryRemoveController(String fileName) {		
		try {
			File file = new File("D:\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));
			file.delete();
		} catch(UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity<String>("success", HttpStatus.OK);
	}
	
	/*
	 * 화면에 출력된 파일, 이미지 데이터베이스에서 삭제
	 * 권한이 있어야 함
	 */
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/fileDelete")
	public ResponseEntity<String> uploadedFileDeleteController(String uuid) {
		return attachService.uploadedFileDelete(uuid) == 1 ? 
				new ResponseEntity<String>("success", HttpStatus.OK) : 
				new ResponseEntity<String>(HttpStatus.NOT_FOUND);
	}	
	
	/*
	 * 년\월\일이라는 이름의 폴더 생성 
	 */
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String folderName = sdf.format(date);
		return folderName.replace("-", File.separator);
	}
	
	/*
	 * 파일이 이미지 인지 구분
	 */
	private boolean isCheckImage(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			return contentType.startsWith("image");
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return false;
	}
	
}
