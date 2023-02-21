<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="header.css">
<script>
	<% String uid = (String) session.getAttribute("uid"); %>
</script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<header>
		<div id="logo">
					<h1 id="logo1"><a href = "main.jsp">Cutt</a></h1>
				</div>
				<nav id="navregister">
	
				<% if( uid  == null){
				%>
					<ul>
	           			<li id = "liafter"><a href = "login/login.jsp">로그인</a></li>
	            		<li><a href = "agree.jsp">회원가입</a></li>
	            	</ul>
	
				<% } else { %>
	
					<ul>
						<li><a href = "login/logout.jsp">로그아웃</a></li>
					</ul>
				<%
				}
				%>
					
	            </nav>
	            <nav id="navmenu">
					<ul>
						<li id = "mypage"><a href = "#">마이페이지</a></li>
						<li id = "review"><a href = "#">리뷰</a></li>
						<li id = "notice"><a href = "#">공지사항</a></li>
						<li id = "customerservice"><a href = "#">고객센터</a></li>
					</ul>
	            </nav>
	</header>
</body>
</html>