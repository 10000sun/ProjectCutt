<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<script language="javascript">
		// opener관련 오류가 발생하는 경우 아래 주석을 해지하고, 사용자의 도메인정보를 입력합니다. ("팝업API 호출 소스"도 동일하게 적용시켜야 합니다.)
		//document.domain = "abc.go.kr";
		function validate(){
			var cid = document.getElementById("id");
			var cpasswd = document.getElementById("passwd");
			var cpasswd2 = document.getElementById("passwd2");
			var cname = document.getElementById("name");
			var ctel1 = document.getElementById("tel1");
			var ctel2 = document.getElementById("tel2");
			var ctel3 = document.getElementById("tel3");
			
			var regidpw = /^[a-zA-Z0-9]{4,12}$/;
			
			if (cid.value == ""){
				alert("아이디를 입력해주세요.");
				cid.focus();
				return false;
			}
			if (!regidpw.test(cid.value)){
				alert("아이디는 4~12자의 대소문자와 숫자로만 입력 가능합니다.");
				cid.focus();
		        return false;
		    }
			if (cpasswd.value == ""){
				alert("비밀번호를 입력해주세요.");
				cpasswd.focus();
				return false;
			}
			if (!regidpw.test(cpasswd.value)){
				alert("비밀번호 4~12자의 대소문자와 숫자로만 입력 가능합니다.");
				cpasswd.focus();
		        return false;
		    }
			if (cpasswd.value != cpasswd2.value){
				alert("비밀번호가 일치하지 않습니다.");
				cpasswd.focus();
				return false;
			}
			if (cname.value == ""){
				alert("이름을 입력해주세요.");
				cname.focus();
				return false;
			}
			if (ctel1.value == ""||ctel2.value == ""||ctel3.value == ""){
		        alert("전화번호를 입력하지 않았습니다.");
		        ctel1.focus();
		        return false;
		    }
			document.form.submit();
		}
	
	</script>
	<link rel="stylesheet" href="register.css">
	<title>Cutt : 회원가입</title>
</head>
<body>
	<div id="container">
		<div id="box">
			<div id="logo">
				<h1 id="logo1"><a href = "main.jsp">Cutt</a></h1>
			</div>
			<form name="form" id="form" method="post" action="registercompany_process.jsp">
				<table id="frmtable">
					<tr>
						<td id="tdname">업체 아이디</td>
						<td><input type="text" name="id" class="tdinput" id="id" minlength = "4" maxlength = "20"></td>
					</tr>
					<tr>
						<td id="tdname">업체 비밀번호</td>
						<td><input type="password" name="passwd" class="tdinput" id="passwd" minlength = "4" maxlength = "20"></td>
					</tr>
					<tr>
						<td id="tdname">업체 비밀번호 확인</td>
						<td><input type="password" name="passwd2" class="tdinput" id="passwd2" minlength = "4" maxlength = "20"></td>
					</tr>
					<tr>
						<td id="tdname">업체 이름</td>
						<td><input type="text" name="name" class="tdinput" id="name"></td>
					</tr>
					<tr>
						<td id="tdname">업체 전화번호</td>
						<td>
						<input type="text" name="tel1" class="tdtel" maxlength="4" id="tel1"> - 
						<input type="text" name="tel2" class="tdtel" maxlength="4" id="tel2"> - 
						<input type="text" name="tel3" class="tdtel" maxlength="4" id="tel3"></td>

					</tr>
					<tr>
						<td id="tdname">업체 대표자 이름</td>
						<td><input type="text" name="ceoname" class="tdinput" id="name"></td>
					</tr>
					<tr>
						<td colspan="2"><input type="button" value="전송" class="tdsubmit" id="tdsubmit" onclick="validate()">
							<input type="reset" value="취소" id="tdreset"></td>
					</tr>
				</table>
			</form>
			<jsp:include page="../footer.jsp" />
		</div>
	</div>

</body>
</html>
</body>
</html>