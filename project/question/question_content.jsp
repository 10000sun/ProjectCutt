<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
<script>
	function deletebtn(){
		 if (confirm("정말 삭제하시겠습니까?") == true) {
             deletefrm.submit();
         }
	}
</script>
<link rel = "stylesheet" href = "question_content.css">
<meta charset="UTF-8">
<title>Cutt : 고객센터 상세보기</title>
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
					<li><a href = "../mypage.jsp">마이페이지</a></li>
					<li><a href = "../reserve.jsp">예약하기</a></li>
					<li><a href = "#">리뷰</a></li>
					<li><a href = "notice.jsp">공지사항</a></li>
					<li><a href = "question.jsp">고객센터</a></li>
				</ul>
            </nav>
        </header>
        <div id="contents">
	      <h3>공지사항 상세보기</h3>
	<%
		request.setCharacterEncoding("UTF-8");
	
		int q_no = Integer.parseInt(request.getParameter("q_no"));
	
		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try{
			String sql = "select m_name,m_id, q_title, q_content, q_date, q_passwd from question q join member m on q.m_no = m.m_no where q.q_no = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,q_no);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				String m_id = rs.getString("m_id");
				String m_name = rs.getString("m_name");
				String q_title = rs.getString("q_title");
				String q_content = rs.getString("q_content");
				String q_date = rs.getString("q_date");
				String q_passwd = rs.getString("q_passwd");
	%>
				제목 : <input type="text" name="title" id = "title" maxlength="50" value = "<%=q_title %>"> <br>
				내용 : 
				<br><textarea rows="3" cols="30" name="content" id = "questioncontent" maxlength = "500" ><%=q_content %></textarea> <br>
				글 비밀번호 : <input type="password" name="passwd" id="questionpasswd" placeholder="글 비밀번호는 홈페이지 비밀번호와 동일합니다."> <br>
				<input type="submit" value="문의수정" id = "questionsubmit">
				<input type="reset" value="작성취소" id = "questionreset">
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
			<form name = "deletefrm" method = "post" action = "notice_delete_ok.jsp">
				<input type="hidden" name="q_no" value="<%=q_no%>">
				<a href="question.jsp"><input type = "button" value = "문의 목록" id = "btn"></a>
				<input type = "button" value = "문의 삭제" id = "btn" onclick = "deletebtn()">
			</form>
        </div>
			<jsp:include page="../footer.jsp" />
</div>
	
</body>
</html>