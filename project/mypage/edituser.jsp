<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../db/dbconn.jsp" %>
<html>
<head>
<link rel="stylesheet" href="edituser.css">
<meta charset="UTF-8">
<title>Cutt : 회원정보 수정</title>
    <%
		String uid = (String) session.getAttribute("uid"); 
 	   	String cid = (String) session.getAttribute("cid");
    %>
    <script language="javascript">
		// opener관련 오류가 발생하는 경우 아래 주석을 해지하고, 사용자의 도메인정보를 입력합니다. ("팝업API 호출 소스"도 동일하게 적용시켜야 합니다.)
		//document.domain = "abc.go.kr";
		
		function goPopup(){
			// 주소검색을 수행할 팝업 페이지를 호출합니다.
			// 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(https://business.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
			var pop = window.open("../register/jusoPopup.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
			
			// 모바일 웹인 경우, 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(https://business.juso.go.kr/addrlink/addrMobileLinkUrl.do)를 호출하게 됩니다.
		    //var pop = window.open("/popup/jusoPopup.jsp","pop","scrollbars=yes, resizable=yes"); 
		}
		
		
		function jusoCallBack(roadAddrPart1,addrDetail, zipNo){
				// 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.
				document.form.roadAddrPart1.value = roadAddrPart1;
				document.form.addrDetail.value = addrDetail;
				document.form.zipNo.value = zipNo;
				
		}
		
		function validate(){
			var uid = document.getElementById("id");
			var upasswd = document.getElementById("passwd");
			var upasswd2 = document.getElementById("passwd2");
			var uname = document.getElementById("name");
			var utel2 = document.getElementById("tel2");
			var utel3 = document.getElementById("tel3");
			var uaddr1 = document.getElementById("addr");
			var uaddr2 = document.getElementById("addrDetail");
			var addrbtn = document.getElementById("addrfind");
			
			var regname = /^[가-힝a-zA-Z]{2,}$/;
			var regidpw = /^[a-zA-Z0-9]{4,12}$/;
			
			if (uid.value == ""){
				alert("아이디를 입력해주세요.");
				uid.focus();
				return false;
			}
			if (!regidpw.test(uid.value)){
				alert("아이디는 4~12자의 대소문자와 숫자로만 입력 가능합니다.");
				uid.focus();
		        return false;
		    }
			if (upasswd.value == ""){
				alert("비밀번호를 입력해주세요.");
				upasswd.focus();
				return false;
			}
			if (!regidpw.test(upasswd.value)){
				alert("비밀번호 4~12자의 대소문자와 숫자로만 입력 가능합니다.");
				upasswd.focus();
		        return false;
		    }
			if (upasswd.value != upasswd2.value){
				alert("비밀번호가 일치하지 않습니다.");
				upasswd.focus();
				return false;
			}
			if (uname.value == ""){
				alert("이름을 입력해주세요.");
				uname.focus();
				return false;
			}
			if (!regname.test(uname.value)){
				alert("이름을 잘못 입력하셨습니다.");
				uname.focus();
		        return false;
		    }
			
			if (utel2.value == ""||utel3.value == ""){
		        alert("전화번호를 입력하지 않았습니다.");
		        utel2.focus();
		        return false;
		    }
			if (uaddr1.value == ""){
		        alert("주소를 입력하지 않았습니다.");
		        addbtn.focus();
		        return false;
		    }
			document.form.submit();
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
						String sql = "select * from member where m_id = ?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, uid);
						rs = pstmt.executeQuery();
						
						while(rs.next()){
							int m_no = rs.getInt("m_no");
							String m_id = rs.getString("m_id");
							String m_passwd = rs.getString("m_passwd");
							String m_name = rs.getString("m_name");
							String m_tel = rs.getString("m_tel");
						
							%>
							<h3> 회원 정보 수정</h3>
			<form name="form" id="form" method="post" action="edituser_process.jsp">
				<table id="frmtable">
					<tr>
						<td id="tdname">아이디</td>
						<td><input type="text" name="id" class="tdinput" id="id" minlength = "4" maxlength = "20" value = "<%=m_id %>" readonly></td>
					</tr>
					<tr>
						<td id="tdname">비밀번호</td>
						<td><input type="password" name="passwd" class="tdinput" id="passwd" minlength = "4" maxlength = "20"></td>
					</tr>
					<tr>
						<td id="tdname">비밀번호 확인</td>
						<td><input type="password" name="passwd2" class="tdinput" id="passwd2" minlength = "4" maxlength = "20"></td>
					</tr>
					<tr>
						<td id="tdname">이름</td>
						<td><input type="text" name="name" class="tdinput" id="name" value = "<%=m_name %>"></td>
					</tr>
					<tr>
						<td id="tdname">전화번호</td>
						<td><select id="telselect" name = "tel1" id="tel1">
								<option value="010">010</option>
								<option value="011">011</option>
								<option value="016">016</option>
								<option value="017">017</option>
								<option value="018">018</option>
						</select> - <input type="text" name="tel2" class="tdtel" maxlength="4" id="tel2"> - <input
							type="text" name="tel3" class="tdtel" maxlength="4" id="tel3"></td>

					</tr>
					<tr>
						<td id="tdname">주소</td>
						<td id = "addrtd">
						<input type="text" name="zipNo" class="tdzipNo" readonly id="zipNo">
						<input type="button" value="주소찾기" onclick="goPopup()" id="addrfind"></td>
					</tr>
					<tr>
						<td></td>
						<td id = "addrtd"><input type="text" name="roadAddrPart1" class="tdinput" id="addr" readonly></td>
					</tr>
					<tr>
						<td></td>
						<td><input type="text" name="addrDetail" class="tdinput" id="addrDetail" readonly></td>
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