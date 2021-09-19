<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../include/header.jsp" %>
	<div class="row">
		<div class="col-lg-12">
			<h2 class="page-header">Home Page</h2>
		</div>
		<!-- end col-lg-12 -->
	</div>
	<!-- end row -->
	
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					게시판
					<button class="btn btn-primary btn-xs pull-right" id="registerBtn" type="button">글 작성</button>
				</div>
				<div class="panel-body">
					<table width="100%" class="table table-striped table-bordered table-hover">
						<thead>
							<tr>
								<th>번호</th>
								<th>작성자</th>
								<th>제목</th>
								<th>작성일</th>
								<th>수정일</th>
							</tr>
						</thead>
						<c:forEach var="board" items="${articleList}">
							<tr>
								<td>
									<c:out value="${board.bno}" />
								</td>
								<td>
									<c:out value="${board.writer}" />
								</td>
								<td>
									<a class="move" href="<c:out value='${board.bno}' />">
										<c:out value="${board.title}" />
									</a>
									&nbsp;<b>[<c:out value="${board.replyCount}" />]</b>
								</td>
								<td>
									<fmt:formatDate pattern="yyyy-MM-dd" value="${board.registerDate}" />
								</td>
								<td>
									<fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate}" />
								</td>
							</tr>
						</c:forEach>
					</table>
					
					<div class="row">
						<div class="col-lg-12">
							<form id="searchForm" action="/board/list" method="get">
								<input type="hidden" name="pageNum" value="${page.cri.pageNum}">
								<input type="hidden" name="amount" value="${page.cri.amount}">
								<select name="type">
									<option value="" <c:out value="${page.cri.type == null ? 'selected' : ''}" />>
										선택
									</option>
									<option value="W" <c:out value="${page.cri.type == 'W' ? 'selected' : ''}" />>
										작성자
									</option>
									<option value="T" <c:out value="${page.cri.type == 'T' ? 'selected' : ''}" />>
										제목
									</option>
									<option value="C" <c:out value="${page.cri.type == 'C' ? 'selected' : ''}" />>
										내용
									</option>
									<option value="TW" <c:out value="${page.cri.type == 'TW' ? 'selected' : ''}" />>
										제목 or 작성자
									</option>
									<option value="TC" <c:out value="${page.cri.type == 'TC' ? 'selected' : ''}" />>
										제목 or 내용
									</option>
									<option value="TCW" <c:out value="${page.cri.type == 'TCW' ? 'selected' : ''}" />>
										제목 or 내용 or 작성자
									</option>
								</select>
								<input type="text" name="keyword" value="${page.cri.keyword}">
								<button class="btn btn-default">검색</button>
							</form>
						</div>
						<!-- end col-lg-12 -->
					</div>
					<!-- end row -->
					
					<div class="pull-right">
						<ul class="pagination">
							<c:if test="${page.prev}">
								<li class="paginate_button previous">
									<a href="${page.startPage - 1}">prev</a>
								</li>
							</c:if>
							<c:forEach var="num" begin="${page.startPage}" end="${page.endPage}">
								<li class="paginate_button ${page.cri.pageNum == num ? 'active' : ''}">
									<a href="${num}">${num}</a>
								</li>
							</c:forEach>
							<c:if test="${page.next}">
								<li class="paginate_button next">
									<a href="${page.endPage + 1}">next</a>
								</li>
							</c:if>
						</ul>
					</div>
					<!-- end pull-right -->
					
					<form id="actionForm" action="/board/list" method="get">
						<input type="hidden" name="pageNum" value="<c:out value='${page.cri.pageNum}' />">
						<input type="hidden" name="amount" value="<c:out value='${page.cri.amount}' />">
						<input type="hidden" name="type" value="<c:out value='${page.cri.type}' />">
						<input type="hidden" name="keyword" value="<c:out value='${page.cri.keyword}' />">
					</form>
				</div>
				<!-- end panel-body -->
				<div class="panel-footer">
				</div>
				<!-- end panel-footer -->
			</div>
			<!-- end panel -->
		</div>
		<!-- end col-lg-12 -->
	</div>
	<!-- end row -->
	
	<script type="text/javascript">
		$(document).ready(function() {
			var result = "<c:out value='${result}' />";
			callRegisteredBno(result);
			history.replaceState({}, null, null);
			
			// 게시 글 등록 알림
			function callRegisteredBno(result) {
				if(result == "" || history.state) {
					return;
				}
				
				if(parseInt(result) > 0) {
					alert(parseInt(result) + "번 게시 글이 등록되었습니다.");
				}
			} // end callRegisteredBno
			
			// 게시 글 작성 페이지 이동
			$("#registerBtn").on("click", function() {
				self.location = "/board/register";
			});
			
			var actionForm = $("#actionForm");
			
			// 게시 글 조회
			$(".move").on("click", function(e) {
				e.preventDefault();
				actionForm.attr("action", "/board/view");
				actionForm.append("<input type='hidden' name='bno' value='" + $(this).attr("href") + "'>");
				actionForm.submit();
			});
			
			// 페이지 이동
			$(".paginate_button a").on("click", function(e) {
				e.preventDefault();
				actionForm.find("input[name = 'pageNum']").val($(this).attr("href"));
				actionForm.submit();
			});
			
			var searchForm = $("#searchForm");
			
			// 게시 글 검색
			$("#searchForm button").on("click", function(e) {
				e.preventDefault();
				
				if(!searchForm.find("option:selected").val()) {
					alert("검색 종류를 선택하세요.");
					return;
				}
				
				if(!searchForm.find("input[name = 'keyword']").val()) {
					alert("키워드를 입력하세요.");
					return;
				}
				
				searchForm.find("input[name = 'pageNum']").val(1);
				searchForm.submit();
			});
		});
	</script>
<%@ include file="../include/footer.jsp" %>	