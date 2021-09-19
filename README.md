## Spring 게시판

> Spring MVC, Spring Security와 REST를 활용한 게시판입니다. 전략 패턴을 이용하여 한 쪽의 기능 변화가 다른 쪽의 변경을 요구하지 않도록 하여 불필요한 코드 변경을 줄이고, 결합도를 낮췄으며, 자신의 관심사에만 집중할 수 있게 하여 응집도를 높였습니다. 또한 불필요한 변화가 발생하지 않도록 막아주고, 자신이 사용하는 외부 오브젝트의 기능은 자유롭게 확장, 변경이 가능해져 개방-폐쇄의 원칙을 준수하도록 했습니다.

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
  * 권한이 ROLE_ADMIN인 사용자는 모든 게시 글과 댓글을 수정, 삭제가 가능
  * 권한이 ROLE_USER인 사용자는 자신이 쓴 게시 글과 댓글만 수정, 삭제가 가능

**2. 게시 글 조회 / 작성 / 수정 / 삭제 / 검색**
* 트랜잭션([게시 글 트랜잭션 적용(BoardServiceImpl.java)](https://github.com/chch8326/BoardProject/blob/main/src/main/java/com/choi/board/service/BoardServiceImpl.java?ts=4), [댓글 트랜잭션 적용(ReplyServiceImpl.java)](https://github.com/chch8326/BoardProject/blob/main/src/main/java/com/choi/board/service/ReplyServiceImpl.java?ts=4))
  * 게시 글 작성 시 파일이 다 업로드 되지 않을 경우 에러 발생
  * 게시 글 수정 시 파일이 다 업로드 되지 않을 경우 에러 발생
  * 게시 글 삭제 시 댓글과 파일이 다 삭제되지 않을 경우 에러 발생
  * 댓글 작성 시 전체 댓글 수가 증가되지 않을 경우 에러 발생
  * 댓글 삭제 시 전체 댓글 수가 감소되지 않을 경우 에러 발생
* [동적 MyBatis를 활용한 게시글 검색(BoardMapper.xml)](https://github.com/chch8326/BoardProject/blob/main/src/main/resources/com/choi/board/mapper/BoardMapper.xml?ts=4)

**3. 댓글 작성 / 수정 / 삭제**
* [REST 활용(ReplyController.java)](https://github.com/chch8326/BoardProject/blob/main/src/main/java/com/choi/board/controller/ReplyController.java?ts=4)
* [모듈 패턴과 Ajax를 활용한 댓글 처리(reply.js)](https://github.com/chch8326/BoardProject/blob/main/src/main/webapp/resources/js/reply.js?ts=4)
* 댓글 더 보기를 활용한 페이징 처리
  * 댓글의 개수가 한 페이지에 5개가 되면 더 보기 버튼을 출력
  * 댓글의 개수가 한 페이지에 5개 미만이거나 댓글의 현재 페이지가 마지막 페이지가 되면 더 보기 버튼을 제거  
  * 댓글 작성 시 현재 페이지가 마지막 페이지일 경우 맨 뒤에 작성한 댓글을 출력
  * 댓글 작성 시 현재 페이지가 마지막 페이지가 아닐 경우 마지막 페이지까지 댓글을 모두 출력하고 그 뒤에 작성한 댓글을 출력

**4. 파일 업로드 / 다운로드 / 수정 / 삭제**
* [REST 활용(UploadController.java)](https://github.com/chch8326/BoardProject/blob/main/src/main/java/com/choi/board/controller/UploadController.java?ts=4)
* [모듈 패턴과 Ajax를 활용한 파일 처리(upload.js)](https://github.com/chch8326/BoardProject/blob/main/src/main/webapp/resources/js/upload.js?ts=4)
