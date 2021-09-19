<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ include file="../include/header.jsp" %>
	<div class="row">
		<div class="col-lg-12">
			<h2 class="page-header">View</h2>
		</div>
		<!-- end col-lg-12 -->
	</div>
	<!-- end row -->
	
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">게시 글</div>
				<div class="panel-body">
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
						<input class="form-control" name="title" value="<c:out value='${board.title}' />" readonly="readonly">
					</div>
					<div class="form-group">
						<label>작성자</label>
						<input class="form-control" name="writer" value="<c:out value='${board.writer}' />" readonly="readonly">
					</div>
					<div class="form-group">
						<label>내용</label>
						<textarea class="form-control" name="content" rows="15" readonly="readonly"><c:out value="${board.content}" /></textarea>
					</div>
					<div class="form-group">
						<label>작성일</label>
						<input class="form-control" name="registerDate" value="<fmt:formatDate pattern='yyyy-MM-dd' value='${board.registerDate}' />" readonly="readonly">
					</div>
					<div class="form-group">
						<label>수정일</label>
						<input class="form-control" name="updateDate" value="<fmt:formatDate pattern='yyyy-MM-dd' value='${board.updateDate}' />" readonly="readonly">
					</div>
					
					<!-- 게시 글 작성자이거나 username에 admin이 포함되어 있을 경우 수정 버튼을 출력 -->
					<sec:authentication var="pinfo" property="principal" />
					<c:set var="isAdmin" value="${pinfo.username}" />
					<sec:authorize access="isAuthenticated()">
						<c:if test="${isAdmin == board.writer || fn:contains(isAdmin, 'admin')}">
							<button class="btn btn-info" data-oper="modify">수정</button>&nbsp;&nbsp;&nbsp;
						</c:if>
					</sec:authorize>
					<button class="btn btn-default" data-oper="list">게시판</button>	
					
					<form id="operForm" action="/board/modify" method="get">
						<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum}' />">
						<input type="hidden" name="amount" value="<c:out value='${cri.amount}' />">
						<input type="hidden" name="type" value="<c:out value='${cri.type}' />">
						<input type="hidden" name="keyword" value="<c:out value='${cri.keyword}' />">
						<input type="hidden" name="bno" value="<c:out value='${board.bno}' />">
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
				<div class="panel-heading">이미지</div>
				<div class="panel-body">
					<div class="uploadedImage">
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
	
	<div class="row">
    	<div class="col-lg-12">
    		<div class="panel panel-default">
    			<div class="panel-heading">첨부 파일</div>
    			<div class="panel-body">
    				<div class="uploadedFile">
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
	
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					<i class="fa fa-comments fa-fw"></i>댓글 
					<sec:authorize access="isAuthenticated()">
						<button class="btn btn-primary btn-xs pull-right" id="registerReplyBtn">댓글 작성</button>
					</sec:authorize>
				</div>
				<div class="panel-body">
					<div class="form-group">
						<label>작성자</label>
						<input class="form-control" name="replyer" value="${pinfo.username}" readonly="readonly">
					</div>
					<div class="form-group">
						<label>댓글</label>
						<textarea class="form-control" name="reply" rows="5"></textarea>
					</div>
				</div>
				<div class="panel-body">
					<ul class="chat">
        			</ul>
        			<div class="more">
        			</div>
				</div>
				<div class="panel-footer"></div>
				<!-- end panel-footer -->
			</div>
			<!-- end panel -->
		</div>
		<!-- end col-lg-12 -->
	</div>
	<!-- end row -->
	
	<!-- 이미지 원본 -->
	<div class="pictureWrapper">
		<div class="picture">
		</div>
	</div>
	<!-- end pictureWrapper -->
	
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    	<div class="modal-dialog">
    		<div class="modal-content">
    			<div class="modal-header">
    				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
    				<h4 class="modal-title" id="myModalLabel">댓글 수정</h4>
    			</div>
    			<div class="modal-body">
    				<div class="form-group">
						<label>작성자</label>
						<input class="form-control" name="modReplyer">	
					</div>
					<div class="form-group">
						<label>댓글</label>
						<textarea class="form-control" name="modReply"></textarea>	
					</div>
					<div class="form-group">
						<label>작성일</label>
						<input class="form-control" name="modReplyDate">
					</div>
    			</div>
    			<div class="modal-footer">
					<button id="modalModifyBtn" type="button" class="btn btn-info">Modify</button>
					<button id="modalCloseBtn" type="button" class="btn btn-default">Close</button>
				</div>
    		</div>
    	</div>
    </div>	
    <!-- end modal -->
    
    <script type="text/javascript" src="/resources/js/reply.js"></script>
    
    <script type="text/javascript" src="/resources/js/upload.js"></script>
    
	<script type="text/javascript">
		$(document).ready(function() {
			var operForm = $("#operForm");
			
			$("button[data-oper = 'modify']").on("click", function() {
				operForm.submit();
			});
			
			$("button[data-oper = 'list']").on("click", function() {
				operForm
					.find("input[name = 'bno']")
					.remove();
				
				operForm
					.attr("action", "/board/list")
					.submit();
			});
		});
	</script>
	
	<script type="text/javascript">
		$(document).ready(function() {
			var bno = "<c:out value='${board.bno}' />";
			var imgUl = $(".uploadedImage ul");
			var fileUl = $(".uploadedFile ul");
			var imgStr = "";
			var fileStr = "";
			var data = { bno:bno };
			
			// 업로드된 파일 출력
			uploadService.getAttachFileList(data, function(attachFiles) {
				$(attachFiles).each(function(i, obj) {
					if(obj.fileType) {
						var path = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
						
						imgStr += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' " + 
									"data-filename='" + obj.fileName + "' data-filetype='" + obj.fileType + "'>";
						imgStr += "    <div>";
						imgStr += "        <span>" + obj.fileName + "</span><br>";
						imgStr += "        <img src='/fileDisplay?fileName=" + path + "' width='450' height='300'>";
						imgStr += "    </div>";
						imgStr += "</li>";
						imgStr += "<br><br>";
					} else {
						var path = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
						
						fileStr += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' " + 
									"data-filename='" + obj.fileName + "' data-filetype='" + obj.fileType + "'>";
						fileStr += "	<div>";
						fileStr += "	<span>";
						fileStr += "		<a class='download' href='/fileDownload?fileName=" + path + "'>" + 
											obj.fileName + "</a>";
						fileStr += "	</span><br>";
						fileStr += "	</div>";
						fileStr += "</li>";
					}
				});
				
				imgUl.append(imgStr);
				fileUl.append(fileStr);
			});
			
			// 이미지 원본 띄우기
			$(".uploadedImage").on("click", "img", function() {
				var liObj = $(this).closest("li");
				var path = encodeURIComponent(liObj.data("path") + "/" + 
							liObj.data("uuid") + "_" + liObj.data("filename"));
				
				$(".pictureWrapper")
					.css("display", "flex")
					.show();
				
				$(".picture")
					.html("<img src='/fileDisplay?fileName=" + path + "'>")
					.animate({ "width":"100%", "height":"100%" });
				
				$(".pictureWrapper").on("click", function() {
					$(this).hide();
				});
			});
		});
	</script>
	
	<script type="text/javascript">
		var bno = "<c:out value='${board.bno}' />";
		var replyUl = $(".chat");
		var pageNum = 1;
		
		showReplyList(pageNum);
	
		// 댓글 출력
		function showReplyList(page) {
			var data = { bno:bno, page:page || pageNum };
			
			replyService.getReplyList(data, function(replyCount, replyList) {
				var str = "";
				var endPage = Math.ceil(replyCount / 5.0);
			
				if(!replyList || replyList.length == 0) {
					return;
				}
			
				/*
			 	* 댓글 작성 시 page 값으로 0을 삽입
			 	* 댓글 작성 시 현재 페이지가 마지막 페이지가 아닐 경우 페이지를 1씩 더해 마지막 페이지까지 댓글을 모두 출력
			 	* 댓글 작성 시 현재 페이지가 마지막 페이지일 경우 작성된 댓글을 출력
				*/
				if(page == 0) {
					if(pageNum != endPage) {
						for(var i = pageNum + 1; i <= endPage; i++) {
							showReplyList(i);
						}
					
						pageNum = endPage;
					} else {
						var i = (replyCount - 1) % 5;
						replys(i);
						replyUl.append(str);
					}
				
					return;
				} else {
					$(replyList).each(function(i) {
						replys(i);
					});
					
					replyUl.append(str);
				}
				
				/*
				* 댓글의 개수가 한 페이지 당 5개가 되면 더 보기 버튼을 출력
				* 댓글의 개수가 한 페이지 당 5개 미만이거나 현재 페이지가 마지막 페이지가 되면 더 보기 버튼을 제거
				*/
				if(replyList.length == 5) {
					$(".more")
						.css("text-align", "center")
						.html("<button class='btn btn-default'>더 보기</button>");
				
					if(pageNum == endPage) {
						$(".more").remove();
					}
				} else {
					$(".more").remove();
				}
				
				function replys(i) {
					<sec:authorize access='isAuthenticated()'>
					var isAdmin = "<sec:authentication property='principal.username' />";
					</sec:authorize>
					
					str += "<li class='left clearfix' data-rno='" + replyList[i].rno + "'>";
					str += "	<div>";
					str += "		<div class='header'>";
					str += "			<strong class='primary-font'>" + replyList[i].replyer + "</strong>";
					str += "			<small class='pull-right text-muted'>" + 
										replyService.displayTime(replyList[i].replyDate) + "</small>";
					str += "		</div>";
					str += "		<p>" + replyList[i].reply + "</p>";
					
					// 댓글 작성자이거나 username에 admin이 포함되어 있을 경우 댓글 수정, 삭제가 가능
					if((isAdmin == replyList[i].replyer) || (isAdmin.indexOf("admin") != -1)) {
						str += "		<a href='javascript:void(0);' onClick='replyModify();'>";
						str += "			<small>수정</small>";
						str += "		</a>&nbsp;&nbsp;&nbsp;";
						str += "		<a href='javascript:void(0);' onClick='replyRemove();'>";
						str += "			<small>삭제</small>";
						str += "		</a>";
					}
					
					str += "	</div>";
					str += "</li>";
					
					return str;
				}
			});
		} // end showReplyList
	
		// 댓글 더 보기
		$(".more").on("click", "button", function() {
			pageNum++;
			showReplyList(pageNum);
		});
		
		var header = $("meta[name = '_csrf_header']").attr("content");
		var token = $("meta[name = '_csrf']").attr("content");
		
		$(document).ajaxSend(function(e, xhr, optios) {
			xhr.setRequestHeader(header, token);
		});

		// 댓글 작성
		$("#registerReplyBtn").on("click", function() {
			var inputReplyer = $("input[name = 'replyer']");
			var inputReply = $("textarea[name = 'reply']");
			var data = { bno:bno, replyer:inputReplyer.val(), reply:inputReply.val() };

			replyService.register(data, function(result) {
				if(result == "success") {
					inputReply.val("");
					showReplyList(0);
				}
			});
		});
		
		<sec:authorize access="isAuthenticated()">
		var replyer = "<sec:authentication property='principal.username' />";
		</sec:authorize>
		
		// 댓글 수정
		function replyModify() {
			var modal = $(".modal");
			var inputReplyer = $("input[name = 'modReplyer']");
			var inputReply = $("textarea[name = 'modReply']");
			var inputReplyDate = $("input[name = 'modReplyDate']");
			var modify = $("#modalModifyBtn");
			var close = $("#modalCloseBtn");
			
			replyUl.one("click", "li", function() {
				var rno = $(this).data("rno");
				
				// 모달창 생성
				replyService.view(rno, function(reply) {
					inputReplyer
						.val(replyer)
						.attr("readonly", "readonly");
					
					inputReply
						.val(reply.reply);
					
					inputReplyDate
						.val(replyService.displayTime(reply.replyDate))
						.attr("readonly", "readonly");
					
					modal.modal("show");
				});
				
				modify.on("click", function() {
					var data = { rno:rno, replyer:replyer, reply:inputReply.val() };
					
					replyService.modify(data, function(result) {
						if(result == "success") {
							modal.modal("hide");
							$(".chat li").remove();
							
							for(var i = 1; i <= pageNum; i++) {
								showReplyList(i);
							}
						}
					});
				});
			});
			
			// 모달창 닫기
			close.on("click", function() {
				modal.modal("hide");
			});
		}
		
		// 댓글 삭제
		function replyRemove() {
			replyUl.one("click", "li", function() {
				var rno = $(this).data("rno");
				
				replyService.remove(rno, replyer, function(result) {
					if(result == "success") {
						$(".chat li").remove();
						
						for(var i = 1; i <= pageNum; i++) {
							showReplyList(i);
						}
					}
				});
			});
		}
	</script>
<%@ include file="../include/footer.jsp" %>