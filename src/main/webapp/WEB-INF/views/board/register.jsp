<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="../include/header.jsp" %>
	<div class="row">
		<div class="col-lg-12">
			<h2 class="page-header">Register</h2>
		</div>
		<!-- end col-lg-12 -->
	</div>
	<!-- end row -->
	
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">게시 글 작성</div>
				<div class="panel-body">
					<form role="form" action="/board/register" method="post">
						<div class="form-group">
							<label>제목</label>
							<input class="form-control" name="title">
						</div>
						<div class="form-group">
							<label>작성자</label>
							<input class="form-control" name="writer" value="<sec:authentication property='principal.username' />" readonly="readonly">
						</div>
						<div class="form-group">
							<label>내용</label>
							<textarea class="form-control" name="content" rows="15"></textarea>
						</div>
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
						
						<button class="btn btn-info" type="submit">작성</button>&nbsp;&nbsp;&nbsp;
						<button class="btn btn-warning" type="reset">초기화</button>
					</form>
				</div>
                <!-- end panel body -->
                <div class="panel-footer">
                </div>
				<!-- end panel-footer -->
			</div>
            <!-- end panel -->     
		</div>
        <!-- end col-lg-12 -->
	</div>
    <!-- end row -->
         
    <div class="row">
    	<div class="col-lg-12">
    		<div class="panel panel-default">
    			<div class="panel-heading">첨부 파일</div>
    			<div class="panel-body">
    				<div class="form-group uploadDiv">
    					<input type="file" name="uploadFile" multiple="multiple">
    				</div>
    				<div class="uploadFile">
    					<ul>
    					</ul>
    				</div>
    			</div>
    			<!-- end panel body -->
    		</div>
    		<!-- end panel -->
    	</div>
    	<!-- end col-lg-12 -->
    </div>
    <!-- end row -->
    
    <script type="text/javascript" src="/resources/js/upload.js"></script>
    
    <script type="text/javascript">
    	$(document).ready(function() {
			var formObj = $("form");
    		
    		$("button[type='submit']").on("click", function(e) {
    			e.preventDefault();
    			var str = "";
    			
    			$(".uploadFile ul li").each(function(i, obj) {
    				str += "<input type='hidden' name='attachList[" + i + "].uploadPath' " + 
    						"value='" + $(obj).data("path") + "'>";
    				
    				str += "<input type='hidden' name='attachList[" + i + "].uuid' " + 
							"value='" + $(obj).data("uuid") + "'>";
					
    				str += "<input type='hidden' name='attachList[" + i + "].fileName' " + 
							"value='" + $(obj).data("filename") + "'>";
					
    				str += "<input type='hidden' name='attachList[" + i + "].fileType' " + 
							"value='" + $(obj).data("filetype") + "'>";
    			});
    			
    			formObj.append(str).submit();
    		});    		
    	});
    </script>
    
    <script type="text/javascript">
    	$(document).ready(function() {
    		var header = $("meta[name = '_csrf_header']").attr("content");
    		var token = $("meta[name = '_csrf']").attr("content");
    		
    		$(document).ajaxSend(function(e, xhr, optios) {
    			xhr.setRequestHeader(header, token);
    		});
    		
    		// 파일 업로드
    		$("input[name = 'uploadFile']").change(function() {
    			var formData = new FormData();
    			var inputFile = $("input[name = 'uploadFile']");
    			var files = inputFile[0].files;
    			
    			for(var i = 0; i < files.length; i++) {
    				if(!isCheckFile(files[i].name, files[i].size)) {
    					return false;
    				}
    				
    				formData.append("uploadFile", files[i]);
    			}
    			
    			uploadService.fileUpload(formData, function(attachFiles) {
    				showUploadedFile(attachFiles);
    			});
    		});
    		
    		// 파일이 저장되는 디렉터리에 있는 클릭된 파일 삭제
    		$(".uploadFile").on("click", "button", function() {
    			var targetFile = $(this).data("file");
    			var targetLI = $(this).closest("li");
    			var data = { fileName:targetFile };
    			
    			uploadService.fileInRepositoryRemove(data, function(result) {
    				if(result == "success") {
    					targetLI.remove();
    				}
    			});
    		});
    		
    		var regex = new RegExp("(.*?)\.(exe|sh|alz)$");
    		var maxSize = 5242880;
    		
    		// 첨부 파일 검사
    		function isCheckFile(fileName, fileSize) {
    			if(regex.test(fileName)) {
    				alert("해당 종류의 파일은 업로드 할 수 없습니다.");
    				return false;
    			}
    			
    			if(fileSize >= maxSize) {
    				alert("파일 크기 초과");
    				return false;
    			}
    			
    			return true;
    		} // isCheckFile
    		
    		// 업로드 할 파일 출력
    		function showUploadedFile(attachFiles) {
    			if(!attachFiles || attachFiles.length == 0) {
    				return false;
    			}
    			
    			var fileUl = $(".uploadFile ul");
    			var str = "";
    			
    			$(attachFiles).each(function(i, obj) {
					var path = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
    				
    				if(obj.image) { // 업로드 할 파일이 이미지인 경우
    					str += "<li class='imgLi' data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' " + 
    							"data-filename='" + obj.fileName + "' data-filetype='" + obj.image + "'>";
    				} else { // 업로드 할 파일이 이미지가 아닌 경우
    					str += "<li class='fileLi' data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' " + 
								"data-filename='" + obj.fileName + "' data-filetype='" + obj.image + "'>";
    				} 
    				
    				str += "	<div>";
    				str += "		<span>" + obj.fileName + "</span>";
    				str += "		<button type='button' data-file='" + path + "'>";
    				str += "			<b>x</b>";
    				str += "		</button>";
    				str += "	</div>";
    				str += "</li>" 
    			});
    			
    			fileUl.append(str);	
    			$(".imgLi").css("list-style-image", "url('/resources/img/attach_img.png')");
    			$(".fileLi").css("list-style-image", "url('/resources/img/attach_file.png')");
    		} // showUploadedFile
    	});
    </script>
<%@ include file="../include/footer.jsp" %>