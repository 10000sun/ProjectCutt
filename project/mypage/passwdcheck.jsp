<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../db/dbconn.jsp" %>
<html>
<head>
<link rel="stylesheet" href="companymypage.css">
<meta charset="UTF-8">
<title>Cutt : 비밀번호 확인</title>
    <%
		String uid = (String) session.getAttribute("uid"); 
 	   	String cid = (String) session.getAttribute("cid");
    %>
    <script>
    	function check(){
    		if(document.passwdfrm.passwd.value == ""){
    			alert("비밀번호를 입력해주세요");
    			document.passwdfrm.passwd.focus();
    			return false;
    		}
    		document.passwdfrm.submit();
    	}
    </script>
</head>
<body>
<div id="container">
		<header>
			<div id="logo">
				<h1 id="logo1"><a href = "main.jsp">Cutt</a></h1>
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
			<div id = "companyinfo">
				<%
					ResultSet rs = null;
					PreparedStatement pstmt = null;
					
					try{
						if (uid != null || cid == null){
							String sql = "select m_passwd from member where m_id = ?";
							pstmt = conn.prepareStatement(sql);
							pstmt.setString(1, uid);
							rs = pstmt.executeQuery();
							
							while(rs.next()){
								String m_passwd = rs.getString("m_passwd");
							
								%>
									<p>회원정보를 수정하시려면 비밀번호를 입력해주세요.
									<form name = "passwdfrm" action = "userpasswdcheck_process.jsp" method = "post">
										<input type = "password" name = "passwd" id = "passwdinput" placeholder = "비밀번호를 입력해주세요"><br>
										<input type = "button" id = "btn" value = "확인" onclick = "check()">
										<input type = "button" id = "btn" value = "취소" onclick = "history.back()">
									</form>
								<%
							}
							}else if (cid != null && uid == null){
								String sql = "select c_passwd from company where c_id = ?";
								pstmt = conn.prepareStatement(sql);
								pstmt.setString(1, cid);
								rs = pstmt.executeQuery();
						
								while(rs.next()){
									String c_passwd = rs.getString("c_passwd");
						
							%>
								<p>회원정보를 수정하시려면 비밀번호를 입력해주세요.
								<form name = "passwdfrm" action = "companypasswdcheck_process.jsp" method = "post">
									<input type = "password" name = "passwd" id = "passwdinput" placeholder = "비밀번호를 입력해주세요"><br>
									<input type = "button" id = "btn" value = "확인" onclick = "check()">
									<input type = "button" id = "btn" value = "취소" onclick = "history.back()">
								</form>
							<%
						}
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
		
	</div>
		<jsp:include page="../footer.jsp" />
</div>
</body>
</html>