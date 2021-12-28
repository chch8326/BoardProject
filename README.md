# 게시판

> Spring MVC, Spring Security와 REST를 활용한 게시판입니다.

~~~
대용량 페이징 처리

SELECT bno, title, content
FROM(
    SELECT /*+INDEX_DESC(tbl_board pk_board) */ rownum rn, bno, title, content
    FROM tbl_board
    WHERE rownum <= 10
)
WHERE rn > 0;
~~~

<img src="https://user-images.githubusercontent.com/42902371/134123875-29998653-795a-4a1f-9501-058f14f18d45.PNG" width="700" height="400">
<img src="https://user-images.githubusercontent.com/42902371/134125221-1fba5ebb-caa1-4842-a13c-868dd22cf56f.png" width="700" height="450">
<img src="https://user-images.githubusercontent.com/42902371/134125961-fc85f5ec-f034-4888-a88e-df8d2ae28dcf.png" width="700" height="450">

### 전략 패턴
> 전략 패턴을 활용하여 결합도를 낮추고, 응집도를 높였으며, 불필요한 코드의 변경은 줄고, 관심사의 기능은 자유롭게 확장, 변경할 수 있어 개방-페쇄의 원칙을 준수하도록 했습니다.

### 모델 패턴
> jquery 코드와 ajax 코드가 뒤섞여 javascript 코드가 복잡해지는 것을 방지하기 위해 모듈 패턴으로 자주 사용되는 함수들을 별도의 파일로 분리해 독립을 시켜 모듈화 하고, 외부에서 접근하지 못하도록 캡슐화를 했습니다.

### 개발환경
* 운영체제: Windows 10
* 개발도구: STS 3.9.12 RELEASE
* 서버: Apache Tomcat 9.0.26
* DB: MySQL 8.0
* 언어: Java, JSP, HTML/CSS, Javascript
* 프레임워크: Spring, MyBatis
* 라이브러리: JQuery, Ajax

### 기능
**1. Spring Security**
* [Spring Security 설정(SecurityConfig.java)](https://github.com/chch8326/BoardProject/blob/main/src/main/java/com/choi/board/config/SecurityConfig.java?ts=4)
* 로그인과 회원가입 및 비밀번호 암호화
* 권한부여를 통한 게시판 기능 제한
  * id에 admin이 포함되면 ROLE_ADMIN과 ROLE_USER 권한을 모두 부여하고, 포함되지 않으면 ROLE_USER 권한만 부여
  * 권한이 ROLE_ADMIN인 사용자는 모든 게시 글과 댓글을 수정, 삭제가 가능
  * 권한이 ROLE_USER인 사용자는 자신이 쓴 게시 글과 댓글만 수정, 삭제가 가능
  ~~~
  한 사용자에게 여러 권한을 부여할 수 있는 1:N 관계 형성
  <resultMap id="memberMap" type="com.choi.board.security.model.CustomUserDetails">
      <id property="uid" column="uid" />
      <result property="uid" column="uid" />
      <result property="upassword" column="upassword" />
      <result property="uname" column="uname" />
      <result property="uemail" column="uemail" />
      <result property="registerDate" column="registerDate" />
      <collection property="authList" resultMap="authMap" />
  </resultMap>
  
  <select id="getUserById" resultMap="memberMap">
      SELECT member.uid,
             upassword,
             uname,
             uemail,
             registerDate,
             auth
      FROM tbl_member as member
      LEFT OUTER JOIN tbl_member_auth as auth
      ON member.uid = auth.uid
      WHERE member.uid = #{uid}
  </select>
  ~~~
  ~~~
  인증이 되어야 즉, 로그인을 해야 게시 글 작성 페이지로 이동이 가능
  @PreAuthorize("isAuthenticated()")
  @GetMapping("/register")
  public void articleRegisterController() {}
  
  댓글 작성자이거나 ROLE_ADMIN 권한을 가진 사용자만 댓글 수정이 가능
  @PreAuthorize("(principal.username == #reply.replyer) or hasRole('ROLE_ADMIN')")
  @RequestMapping(value = "/{rno}",
                  method = { RequestMethod.PUT, RequestMethod.PATCH },
                  consumes = "application/json")
  public ResponseEntity<String> replyModifyController(@RequestBody ReplyVO reply, @PathVariable("rno") Long rno) {
      reply.setRno(rno);
      return replyService.replyModify(reply) == 1 ?
              new ResponseEntity<String>("success", HttpStatus.OK) :
              new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
  }
  ~~~
  ~~~
  게시 글 작성자이거나 id에 admin이 포함된 사용자만 게시 글 수정, 삭제 버튼을 출력
  <sec:authentication var="pinfo" property="principal" />
  <c:set var="isAdmin" value="${pinfo.username}" />
  <sec:authorize access="isAuthenticated()">
      <c:if test="${isAdmin == board.writer || fn:contains(isAdmin, 'admin')}">
          <button class="btn btn-info" data-oper="modify" type="submit">수정</button>	
          <button class="btn btn-danger" data-oper="delete" type="submit">삭제</button>
      </c:if>
  </sec:authorize>
  
  댓글 작성자이거나 id에 admin이 포함된 사용자만 댓글 수정, 삭제 버튼을 출력
  if((isAdmin == replyList[i].replyer) || (isAdmin.indexOf("admin") != -1)) {
      str += "<a href='javascript:void(0);' onClick='replyModify();'>";
      str += "<small>수정</small>";
      str += "</a>";
      str += "<a href='javascript:void(0);' onClick='replyRemove();'>";
      str += "<small>삭제</small>";
      str += "</a>";
  }
  ~~~

**2. 게시 글 조회 / 작성 / 수정 / 삭제 / 검색**
* [게시 글 처리(BoardController.java)](https://github.com/chch8326/BoardProject/blob/main/src/main/java/com/choi/board/controller/BoardController.java?ts=4)
* 트랜잭션 적용([게시 글 트랜잭션 적용(BoardServiceImpl.java)](https://github.com/chch8326/BoardProject/blob/main/src/main/java/com/choi/board/service/BoardServiceImpl.java?ts=4), [댓글 트랜잭션 적용(ReplyServiceImpl.java)](https://github.com/chch8326/BoardProject/blob/main/src/main/java/com/choi/board/service/ReplyServiceImpl.java?ts=4))
  * 게시 글 작성 시 파일이 다 업로드 되지 않을 경우 게시 글 작성이 되지 않도록 함
  * 게시 글 수정 시 파일이 다 업로드 되지 않을 경우 게시 글 작성이 되지 않도록 함
  * 게시 글 삭제 시 댓글과 파일이 다 삭제되지 않을 경우 게시 글 삭제가 되지 않도록 함
  * 댓글 작성 시 전체 댓글 수가 증가되지 않을 경우 댓글 작성이 되지 않도록 함
  * 댓글 삭제 시 전체 댓글 수가 감소되지 않을 경우 댓글 작성이 되지 않도록 함
* [동적 MyBatis를 활용한 게시글 검색(BoardMapper.xml)](https://github.com/chch8326/BoardProject/blob/main/src/main/resources/com/choi/board/mapper/BoardMapper.xml?ts=4)

**3. Ajax를 활용한 댓글 출력 / 작성 / 수정 / 삭제**
* [REST를 활용한 댓글 처리(ReplyController.java)](https://github.com/chch8326/BoardProject/blob/main/src/main/java/com/choi/board/controller/ReplyController.java?ts=4)
  * 댓글 출력: URI는 /replies/{bno}/{page} 로 GET method 사용
  * 댓글 작성: URI는 /replies/new 로 POST method 사용
  * 댓글 조회: URI는 /replies/{rno} 로 GET method 사용
  * 댓글 수정: URI는 /replies/{rno} 로 PUT method 사용
  * 댓글 삭제: URI는 /replies/{rno} DELETE method 사용
* [모듈 패턴을 통한 모듈화, 캡슐화(reply.js)](https://github.com/chch8326/BoardProject/blob/main/src/main/webapp/resources/js/reply.js?ts=4)
* [댓글 더 보기를 활용한 페이징 처리(view.jsp 291줄 ~ 362줄)](https://github.com/chch8326/BoardProject/blob/main/src/main/webapp/WEB-INF/views/board/view.jsp?ts=4)
  * 댓글의 수가 5개 미만인 경우 더 보기 버튼이 출력되지 않음
  * 댓글의 수가 5개 이상인 경우 더 보기 버튼 출력
  * 더 보기 버튼을 누르면 page가 1씩 더해지면서 댓글들이 5개씩 더 출력되고, 마지막 페이지에서 더 보기 버튼을 제거
  * 댓글 작성 시 현재 페이지가 마지막 페이지일 경우 맨 마지막에 작성된 댓글을 출력
  * 댓글 작성 시 현재 페이지가 마지막 페이지가 아닐 경우 마지막 페이지까지 댓글을 모두 출력하고, 맨 마지막에 작성된 댓글을 출력

**4. Ajax를 활용한 파일 출력 / 업로드 / 다운로드 / 수정 / 삭제**
* [REST를 활용한 파일 처리(UploadController.java)](https://github.com/chch8326/BoardProject/blob/main/src/main/java/com/choi/board/controller/UploadController.java?ts=4)
  * 파일 출력: URI는 /board/getAttachFile 로 GET method 사용
  * 파일 업로드: URI는 /fileUpload 로 POST method 사용
  * 파일 저장소와 DB에서 파일 삭제: URI는 /fileInRepositoryRemove, /fileDelete 로 POST method 사용
* [모듈 패턴을 통한 모듈화, 캡슐화(upload.js)](https://github.com/chch8326/BoardProject/blob/main/src/main/webapp/resources/js/upload.js?ts=4)
