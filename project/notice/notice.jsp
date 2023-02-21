<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../db/dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<link rel = "stylesheet" href = "notice.css">
    <meta charset="UTF-8">
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
        <h2>공지사항</h2>
			<table id = noticetable>
				<tr>
					<td>번호</td>
					<td>작성자</td>
					<td><strong>제목</strong></td>
					<td>작성일</td>
					<td>조회수</td>
				</tr>
				<%
					ResultSet rs = null;
					PreparedStatement pstmt = null;
					
					try{
						String sql = "select m_name, n_no, n_title, n_content, n_date, n_hits from notice n join member m on n.m_no = m.m_no";
						pstmt = conn.prepareStatement(sql);
						rs = pstmt.executeQuery();
						
						while(rs.next()){
							String m_name = rs.getString("m_name");
							int n_no = rs.getInt("n_no");
							String n_title = rs.getString("n_title");
							String n_date = rs.getString("n_date");
							int n_hits = rs.getInt("n_hits");
							
							if(n_title.length()>=10){
								n_title = n_title.substring(0, 10)+"...";
							}
				%>		
							<tr>
								<td><%=n_no %></td>
								<td><%=m_name %></td>
								<td><a href="notice_hits.jsp?n_no=<%=n_no%>"><%=n_title%></a></td>
								<td><%=n_date %></td>
								<td><%=n_hits %></td>
							</tr>	
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
			</table>
			<%if (admin == 1){ %>
			<a href="notice_write.jsp"><input type = "button" id = "btn" value = "공지 작성"></a> <br><br>
			<%} %>
        </div>
        <div id = "footer">
        	<jsp:include page="../footer.jsp" />
        </div>
</div>
</body>
</html>