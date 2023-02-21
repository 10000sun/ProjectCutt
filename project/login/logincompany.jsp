<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<link rel="stylesheet" href="login.css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Cutt : 기업회원 로그인</title>
<script type="text/javascript">
    var cid = "<%=(String) session.getAttribute("cid")%>";
	function logout() {
		window.location.href = "logout.jsp";
	}
	
	function regist(){
		window.location.href= "agree.jsp";
	}
</script>
</head>
<body>
	<div id = "container">
		<div id = "box">
			<script>
				if (cid == null) {
			</script>
			<div id="logo">
				<h1 id="logo1"><a href = "../main.jsp">Cutt</a></h1>
			</div>
			<div>
				<h2>기업회원 로그인</h2>
			</div>
			<div id = "logindiv">
				<form name="login" method="post" action="logincompany_check.jsp" id = "loginfrm">
					<table id = logintable>
						<tr>
							<td id = "tdname">
								아이디 : 
							</td>
							<td id = "tdinput">
								<input type="text" name="id" id = "loginid">
							</td>
						</tr>
						<tr>
							<td id = "tdname">
								패스워드 : 
							</td>
							<td id = "tdinput">
								<input type="password" name="passwd" id = "loginpw">
							</td>
						</tr>
					</table>
					<p id = "askp"> 일반회원 이신가요? <a href = "login.jsp">일반회원 로그인하기</a></p>
					<input type="submit" value="로그인" id = "btn">
					<input type="button" value="회원가입" id="btn" onclick="regist()">
				</form>
			</div>
			<br>
			<script>
				} else {
					alert("이미 로그인 된 상태입니다.");
					document.location.href = "../main.jsp";
				}
			</script>
			<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
			<script src="js/bootstrap.js"></script>
			<footer>
			<jsp:include page="../footer.jsp"/>
		</footer>
		</div>
	</div>
</body>
</html>