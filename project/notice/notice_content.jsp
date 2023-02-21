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
<link rel = "stylesheet" href = "notice_content.css">
<meta charset="UTF-8">
<title>Cutt : 공지사항 상세보기</title>
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
					<li><a href = "../review/review.jsp">리뷰</a></li>
					<li><a href = "notice.jsp">공지사항</a></li>
					<li><a href = "../question/question.jsp">고객센터</a></li>
				</ul>
            </nav>
        </header>
        <div id="contents">
	      <h3>공지사항 상세보기</h3>
	<%
		request.setCharacterEncoding("UTF-8");
	
		int n_no = Integer.parseInt(request.getParameter("n_no"));
	
		ResultSet rs = null;
		PreparedStatement pstmt = null;

		try{
			String sql = "select m_name, n_title, n_content, n_date, n_hits from notice n join member m on n.m_no = m.m_no where n.n_no = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,n_no);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				String m_name = rs.getString("m_name");
				String n_title = rs.getString("n_title");
				String n_content = rs.getString("n_content");
				String n_date = rs.getString("n_date");
				int n_hits = rs.getInt("n_hits");
	%>
			<div id = "contenttitle">
				제목 : <input type="text" name="title" id = "title" value = "<%=n_title %>" readonly>
			</div>
			<div id = "contentinfo">
				작성자 : <%=m_name %> | 작성일 : <%=n_date %> | 조회수 : <%=n_hits %>
			</div>
			<div id = "contentcontent">
			내용 : 
			<br><textarea rows="3" cols="30" name="content" id = "noticecontent" maxlength = "500" readonly><%=n_content %></textarea> <br>
			</div>
			
						
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
				<input type="hidden" name="n_no" value="<%=n_no%>">
				<a href="notice.jsp"><input type = "button" value = "공지 목록" id = "btn"></a>
			<% if(admin==1){ %>
				<a href="notice_edit.jsp?n_no=<%= n_no%>"><input type = "button" value = "공지 수정" id = "btn"></a> 
				<input type = "button" value = "공지 삭제" id = "btn" onclick = "deletebtn()">
			<%} %>
			</form>
        </div>
			<jsp:include page="../footer.jsp" />
</div>
	
</body>
</html>