<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../db/dbconn.jsp" %>
<html>
<head>
<link rel="stylesheet" href="editcompany.css">
<meta charset="UTF-8">
<title>Cutt : 회원정보 수정</title>
    <%
		String uid = (String) session.getAttribute("uid"); 
 	   	String cid = (String) session.getAttribute("cid");
    %>
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
			var cceoname = document.getElementById("ceoname");
			
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
			if (cceoname.value == ""){
		        alert("대표 이름을 입력하지 않았습니다.");
		        cceoname.focus();
		        return false;
		    }
			document.form.submit()
		}
	
	</script>
</head>
<body>
<div id="container">
		<header>
			<div id="logo">
				<h1 id="logo1"><a href = "../main.jsp">Cutt</a></h1>
			</div>
			<nav id="navregister">

			<% if( uid  == null && cid == null){
			%>
				<script>
					alert("로그인이 필요한 서비스입니다.");
					location.href="../login/login.jsp";
				</script>

			<% } else { %>

				<ul>
					<li><a href = "../login/logout.jsp">로그아웃</a></li>
				</ul>
			<%
			}
			%>
				
            </nav>
            <nav id="navmenu">
				<ul>
					<%
						if (uid != null || cid == null){
							 %>
							<li><a href = "mypage.jsp">마이페이지</a></li>
							<li><a href = "../reserve/reserve.jsp">실시간 예약</a></li>
							<%
						} else if(cid != null && uid == null){
							 %>
							<li><a href = "companymypage.jsp">마이페이지</a></li>
							<li><a href = "shopmenu.jsp">메뉴 추가</a></li>
							<%
						}
					 %>
					<li><a href = "../review/review.jsp">리뷰</a></li>
					<li><a href = "../notice/notice.jsp">공지사항</a></li>
					<li><a href = "../question/question.jsp">고객센터</a></li>
				</ul>
            </nav>
        </header>
		<div id = contents>
				<%
					ResultSet rs = null;
					PreparedStatement pstmt = null;
					
					try{
						String sql = "select * from company where c_id = ?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, cid);
						rs = pstmt.executeQuery();
						
						while(rs.next()){
							int c_no = rs.getInt("c_no");
							String c_id = rs.getString("c_id");
							String c_passwd = rs.getString("c_passwd");
							String c_name = rs.getString("c_name");
							String c_tel = rs.getString("c_tel");
							String c_ceo = rs.getString("c_ceo");
						
							%>
							<h3> 회원 정보 수정</h3>
			<form name="form" id="form" method="post" action="editcompany_process.jsp">
				<table id="frmtable">
					<tr>
						<td id="tdname">업체 아이디</td>
						<td><input type="text" name="id" class="tdinput" id="id" minlength = "4" maxlength = "20" value = "<%=c_id %>" readonly></td>
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
						<td><input type="text" name="name" class="tdinput" id="name" value = "<%=c_name %>"></td>
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
						<td><input type="text" name="ceoname" class="tdinput" id="ceoname" value = "<%=c_ceo %>"></td>
					</tr>
					<tr>
						<td colspan="2"><input type="button" value="전송" class="tdsubmit" id="tdsubmit" onclick="validate()">
							<input type="reset" value="취소" id="tdreset"></td>
					</tr>
				</table>
				</form>
							
							<%
						}
					}catch(SQLException e){
						e.printStackTrace();
					}finally{
						if(rs != null) rs.close();
						if(pstmt != null) pstmt.close();
						if(conn != null) conn.close();
					}
				%>		
		
	</div>
		<jsp:include page="../footer.jsp" />
</div>
</body>
</html>