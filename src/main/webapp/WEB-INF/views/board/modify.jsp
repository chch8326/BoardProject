<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="../include/header.jsp" %>
	<div class="row">
		<div class="col-lg-12">
			<h2 class="page-header">Modify / Remove</h2>
		</div>
		<!-- end col-lg-12 -->
	</div>
	<!-- end row -->
	
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">게시 글 조회 / 삭제</div>
				<div class="panel-body">
					<form role="form" action="/board/modify" method="post">
						<div class="form-group">
							<label>번호</label>
							<input class="form-control" name="bno" value="<c:out value='${board.bno}' />" readonly="readonly">
						</div>
						<div class="form-group">
							<label>조회 수</label>
							<input class="form-control" name="viewCount" value="<c:out value='${board.viewCount}' />" readonly="readonly">
						</div>
						<div class="form-group">
							<label>제목</label>
							<input class="form-control" name="title" value="<c:out value='${board.title}' />">
						</div>
						<div class="form-group">
							<label>작성자</label>
							<input class="form-control" name="writer" value="<c:out value='${board.writer}' />" readonly="readonly">
						</div>		
						<div class="form-group">
							<label>내용</label>
							<textarea class="form-control" name="content" rows="15"><c:out value="${board.content}" /></textarea>
						</div>	
						<div class="form-group">
							<label>작성일</label>
							<input class="form-control" value="<fmt:formatDate pattern='yyyy-MM-dd' value='${board.registerDate}' />" readonly="readonly">
						</div>
						<div class="form-group">
							<label>수정일</label>
							<input class="form-control" value="<fmt:formatDate pattern='yyyy-MM-dd' value='${board.updateDate}' />" readonly="readonly">
						</div>
						
						<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum}' />">
						<input type="hidden" name="amount" value="<c:out value='${cri.amount}' />">
						<input type="hidden" name="type" value="<c:out value='${cri.type}' />">
						<input type="hidden" name="keyword" value="<c:out value='${cri.keyword}' />">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
						
						<!-- 게시 글 작성자이거나 username에 admin이 포함되어 있을 경우 수정, 삭제 버튼을 출력 -->
						<sec:authentication var="pinfo" property="principal" />
						<c:set var="isAdmin" value="${pinfo.username}" />
						<sec:authorize access="isAuthenticated()">
							<c:if test="${isAdmin == board.writer || fn:contains(isAdmin, 'admin')}">
								<button class="btn btn-info" data-oper="modify" type="submit">수정</button>&nbsp;&nbsp;&nbsp;	
								<button class="btn btn-danger" data-oper="delete" type="submit">삭제</button>&nbsp;&nbsp;&nbsp;
							</c:if>
						</sec:authorize>
						<button class="btn btn-default" data-oper="list" type="submit">게시판</button>	
					</form>
				</div>
                <!-- end panel body -->
                <div class="panel-footer"></div>
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
		
			$("button").on("click", function(e) {
				e.preventDefault();
				var operation = $(this).data("oper");
			
				if(operation === "delete") {
					formObj.attr("action", "/board/delete");	
				} else if(operation === "list") {
					var pageNumTag = $("input[name = 'pageNum']").clone();
					var amountTag = $("input[name = 'amount']").clone();
					var typeTag = $("input[name = 'type']").clone();
					var keywordTag = $("input[name = 'keyword']").clone();
				
					formObj.attr("action", "/board/list").attr("method", "get");
					formObj.empty();
					formObj.append(pageNumTag);
					formObj.append(amountTag);
					formObj.append(typeTag);
					formObj.append(keywordTag);
				} else {
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
				
					formObj.append(str);
				}
			
				formObj.submit();
			});
		});		
    </script>
    
    <script type="text/javascript">
    	$(document).ready(function() {
    		var bno = "<c:out value='${board.bno}' />";
    		var fileUl = $(".uploadFile ul");
    		var str = "";
    		var data = { bno:bno };
    		
    		// 압로드 된 파일 출력
    		uploadService.getAttachFileList(data, function(attachFiles) {
    			$(attachFiles).each(function(i, obj) {
    				var path = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
    				
    				if(obj.fileType) { // 업로드된 파일이 이미지인 경우
    					str += "<li class='imgLi' data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' " + 
								"data-filename='" + obj.fileName + "' data-filetype='" + obj.fileType + "'>";
    				} else { // 업로드된 파일이 이미지가 아닌 경우
    					str += "<li class='fileLi' data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' " + 
								"data-filename='" + obj.fileName + "' data-filetype='" + obj.fileType + "'>";
    				}
    				
    				str += "	<div>";
    				str += "		<span>" + obj.fileName + "</span>";
    				str += "		<button type='button' data-file='" + path + "' data-uuid='" + obj.uuid + "'>";
    				str += "			<b>x</b>";
    				str += "		</button>";		
    				str += "	</div>";
    				str += "</li>"     				
    			});
    			
    			fileUl.append(str);	
    			$(".imgLi").css("list-style-image", "url('/resources/img/attach_img.png')");
    			$(".fileLi").css("list-style-image", "url('/resources/img/attach_file.png')");
    		});
    		
    		var header = $("meta[name = '_csrf_header']").attr("content");
    		var token = $("meta[name = '_csrf']").attr("content");
    		
    		$(document).ajaxSend(function(e, xhr, optios) {
    			xhr.setRequestHeader(header, token);
    		});
    		
    		// 파일 삭제 시 데이터베이스와 파일이 저장되는 디렉터리에서 파일 삭제
    		$(".uploadFile").on("click", "button", function() {
    			var targetUuid = $(this).data("uuid");
        		var targetFile = $(this).data("file");
        		var targetLi = $(this).closest("li");
        		var uuidData = { uuid:targetUuid };
        		var fileNameData = { fileName:targetFile };
        			
        		if(confirm("파일을 삭제하시겠습니까?"))	{
        			uploadService.fileDelete(uuidData, function(result) {
        				if(result == "success") {
        					uploadService.fileInRepositoryRemove(fileNameData, function(result) {
        						if(result == "success") {
    								targetLi.remove();
    							}
        					});
        				}
        			});
        		}
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
    		} // end showUploadedFile
    	});
    </script>
<%@ include file="../include/footer.jsp" %>