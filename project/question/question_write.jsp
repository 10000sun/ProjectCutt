<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel = "stylesheet" href = "question_write.css">
<title>Cutt : 고객센터</title>
       <% 
    String uid = (String) session.getAttribute("uid");
    String cid = (String) session.getAttribute("cid");
    String admin2 = (String) String.valueOf(session.getAttribute("admin"));
    int admin = 0;
    
    try{
    	if(admin2!=null){
            admin = Integer.parseInt(String.valueOf(admin2));
        }
    } catch (NumberFormatException e){
    	e.printStackTrace();
    }
    
    %>
</head>
<body>
<div id="container">
		<header>
			<div id="logo">
				<h1 id="logo1"><a href = "../main.jsp">Cutt</a></h1>
			</div>
			<nav id="navregister">

			<% if( uid  == null && cid != null){
			%>
				<script>
					alert("회원 로그인이 필요한 서비스입니다.");
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
					<li><a href = "../mypage.jsp">마이페이지</a></li>
					<li><a href = "../reserve.jsp">예약하기</a></li>
					<li><a href = "#">리뷰</a></li>
					<li><a href = "../notice/notice.jsp">공지사항</a></li>
					<li><a href = "question.jsp">고객센터</a></li>
				</ul>
            </nav>
        </header>
        <div id="contents">
	       <h3>문의사항 작성</h3>
			<form method="post" name="question" action="question_write_ok.jsp">
				제목 : <input type="text" name="title" id = "title" maxlength="50" placeholder = "50자 이내로 작성해주세요."> <br>
				내용 : 
				<br><textarea rows="3" cols="30" name="content" id = "questioncontent" maxlength = "500" placeholder = "500자 이내로 작성해주세요."></textarea> <br>
				글 비밀번호 : <input type="password" name="passwd" id="passwd" value="" readonly> 글 비밀번호는 홈페이지 비밀번호와 동일합니다. <br>
				<input type="submit" value="문의작성" id = "questionsubmit">
				<input type="reset" value="작성취소" id = "questionreset">
			</form>
        </div>
			<jsp:include page="../footer.jsp" />
</div>
</body>
</html>