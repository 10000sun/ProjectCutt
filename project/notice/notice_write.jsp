<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel = "stylesheet" href = "notice_write.css">
<title>Cutt : 공지사항</title>
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

			<% if( uid  == null && cid == null){%>
				<ul>
           			<li id = "liafter"><a href = "../login/login.jsp">로그인</a></li>
            		<li><a href = "../register/agree.jsp">회원가입</a></li>
            	</ul>
			<%} else { %>

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
							<li><a href = "../mypage/mypage.jsp">마이페이지</a></li>
							<li><a href = "../reserve/reserve.jsp">실시간 예약</a></li>
							<%
						} else if(cid != null && uid == null){
							 %>
							<li><a href = "../mypage/companymypage.jsp">마이페이지</a></li>
							<li><a href = "../mypage/shopmenu.jsp">메뉴 추가</a></li>
							<%
						}
					 %>
					<li><a href = "../review/review.jsp">리뷰</a></li>
					<li><a href = "notice.jsp">공지사항</a></li>
					<li><a href = "../question/question.jsp">고객센터</a></li>
				</ul>
            </nav>
        </header>
        <div id="contents">
	       <h3>공지사항 작성</h3>
			<form method="post" name="notice" action="notice_write_ok.jsp">
				제목 : <input type="text" name="title" id = "title" maxlength="50" placeholder = "50자 이내로 작성해주세요."> <br>
				내용 : 
				<br><textarea rows="3" cols="30" name="content" id = "noticecontent" maxlength = "500" placeholder = "500자 이내로 작성해주세요."></textarea> <br>
				<input type="submit" value="게시판작성" id = "noticesubmit">
				<input type="reset" value="작성취소" id = "noticereset">
			</form>
        </div>
			<jsp:include page="../footer.jsp" />
</div>
</body>
</html>