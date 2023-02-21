<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp" %>    
<!DOCTYPE html>
<html>
<head>
<link rel = "stylesheet" href = "notice_edit.css">
<meta charset="UTF-8">
<title>게시판 수정</title>
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

			<% if( admin != 1){
			%>
				<script>
					alert("관리자만 접근이 가능합니다.");
					location.href="notice.jsp";
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
					<li><a href = "../review/review.jsp">리뷰</a></li>
					<li><a href = "notice.jsp">공지사항</a></li>
					<li><a href = "../question/question.jsp">고객센터</a></li>
				</ul>
            </nav>
        </header>
        <div id="contents">
	<%
		request.setCharacterEncoding("UTF-8");
	
		int n_no = Integer.parseInt(request.getParameter("n_no"));
		
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		
		try{
			String sql = "select n_title, n_content from notice where n_no = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,n_no);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				String n_title = rs.getString("n_title");
				String n_content = rs.getString("n_content");
	%>
				<h3>게시판 수정</h3>
			<form method="post" name="notice" action="notice_edit_ok.jsp">
				<input type="hidden" name="n_no" value="<%=n_no%>">
				제목 : <input type="text" name="n_title" id = "title" value = "<%=n_title%>"> <br>
				내용 : 
				<br><textarea rows="3" cols="30" name="n_content" id = "noticecontent" maxlength = "500" placeholder = "500자 이내로 작성해주세요."><%=n_content %></textarea> <br>
				<input type="submit" value="수정" id = "noticesubmit">
				<input type="button" value="작성취소" id = "noticereset" onclick="history.back()">
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