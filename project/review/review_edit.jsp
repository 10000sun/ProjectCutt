<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp" %>    
<!DOCTYPE html>
<html>
<head>
<link rel = "stylesheet" href = "review_edit.css">
<meta charset="UTF-8">
<title>Cutt : 리뷰 수정</title>
</head>
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
					<li><a href = "review.jsp">리뷰</a></li>
					<li><a href = "../notice/notice.jsp">공지사항</a></li>
					<li><a href = "../question/question.jsp">고객센터</a></li>
				</ul>
            </nav>
        </header>
        <div id="contents">
	<%
		request.setCharacterEncoding("UTF-8");
	
		int rv_no = Integer.parseInt(request.getParameter("rv_no"));
		
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		
		try{
			String sql = "select rv_title, rv_content, rv_menu, rv_name from review where rv_no = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,rv_no);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				String rv_title = rs.getString("rv_title");
				String rv_content = rs.getString("rv_content");
				String rv_menu = rs.getString("rv_menu");
				String rv_name = rs.getString("rv_name");
	%>
				<h3>리뷰 수정</h3>
			<form method="post" name="review" action="review_edit_ok.jsp">
				<input type="hidden" name="rv_no" value="<%=rv_no%>">
				제목 : <input type="text" name="rv_title" id = "title" value = "<%=rv_title%>"> <br>
				업체명 : <input type="text" name="companyname" id = "nameinput" value = "<%=rv_menu%>">
				시술명 : <input type="text" name="menuname" id = "nameinput" value = "<%=rv_name%>">
				평점 : <select name = "rvrate" id = "rvrate">
					<option value = "">평점을 선택해주세요</option>
					<option value = "1">1점</option>
					<option value = "2">2점</option>
					<option value = "3">3점</option>
					<option value = "4">4점</option>
					<option value = "5">5점</option>
				
				</select> <br>
				내용 : 
				<br><textarea rows="3" cols="30" name="rvcontent" id = "reviewcontent" maxlength = "500" placeholder = "500자 이내로 작성해주세요."><%=rv_content %></textarea> <br>
				<input type="submit" value="수정" id = "reviewsubmit">
				<input type="button" value="작성취소" id = "reviewreset" onclick="history.back()">
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