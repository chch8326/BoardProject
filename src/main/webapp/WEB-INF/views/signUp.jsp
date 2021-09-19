<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>SB Admin 2 - Bootstrap Admin Theme</title>

    <!-- Bootstrap Core CSS -->
    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
</head>
<body>
    <div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="login-panel panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">회원가입</h3>
                    </div>
                    <div class="panel-body">
                        <form role="form" action="/signUp" method="post">
                            <fieldset>
                                <div class="form-group">
                                    <input class="form-control" name="username" type="text" placeholder="아이디" autofocus>
                                </div>
                                <br>
                                <div class="form-group">
                                    <input class="form-control" name="password" type="password" placeholder="비밀번호" autofocus>
                                </div>
                                <br>
                                <div class="form-group">
                                    <input class="form-control" name="checkPassword" type="password" placeholder="비밀번호 확인" autofocus>
                                    <br>
                                    <div class="alert alert-success" id="success">비밀번호가 일치합니다.</div>
                                    <div class="alert alert-danger" id="danger">비밀번호가 일치하지 않습니다.</div>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" name="uname" type="text" placeholder="이름" autofocus>
                                </div>
                                <br>
                                <div class="form-group">
                                    <input class="form-control" name="uemail" type="text" placeholder="이메일" autofocus>
                                </div>
                                <button class="btn btn-lg btn-success btn-block" type="submit">회원가입</button>
                            </fieldset>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="/resources/vendor/jquery/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="/resources/vendor/bootstrap/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="/resources/vendor/metisMenu/metisMenu.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="/resources/dist/js/sb-admin-2.js"></script>
    
    <script type="text/javascript">
    	$(document).ready(function() {
    		$("#success").hide();
        	$("#danger").hide();
        	
        	// 비밀번호 확인
        	$("input").keyup(function() {
        		var password = $("input[name = 'password']").val();
        		var checkPassword = $("input[name = 'checkPassword']").val();
        		
        		if(password != "" || checkPassword != "") {
        			if(password == checkPassword) {
        				$("#success").show();
        				$("#danger").hide();
        				$(".btn-success").removeAttr("disabled");
        			} else {
        				$("#success").hide();
        				$("#danger").show();
        				$(".btn-success").attr("disabled", "disabled");
        			}
        		}
        	});
    	});
    </script>
</body>
</html>