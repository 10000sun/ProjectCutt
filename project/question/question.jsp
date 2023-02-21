<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../db/dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<link rel = "stylesheet" href = "question.css">
    <meta charset="UTF-8">
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

			<% if( uid  == null && cid != null){%>
				<script>
					alert("회원 로그인이 필요한 서비스입니다.");
					location.href="../login/login.jsp";
				</script>
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
					<li><a href = "../mypage.jsp">마이페이지</a></li>
					<li><a href = "../reserve.jsp">예약하기</a></li>
					<li><a href = "#">리뷰</a></li>
					<li><a href = "../notice/notice.jsp">공지사항</a></li>
					<li><a href = "question.jsp">고객센터</a></li>
				</ul>
            </nav>
        </header>
        <div id="contents">
        <h2>고객센터</h2>
			<table id = noticetable>
				<tr>
					<td>번호</td>
					<td>작성자</td>
					<td><strong>제목</strong></td>
					<td>작성일</td>
				</tr>
				<%
					ResultSet rs = null;
					PreparedStatement pstmt = null;
					
					try{
						String sql = "select m_name, q_no, q_title, q_date from question q join member m on q.m_no = m.m_no";
						pstmt = conn.prepareStatement(sql);
						rs = pstmt.executeQuery();
						
						while(rs.next()){
							int q_no = rs.getInt("q_no");
							String m_name = rs.getString("m_name");
							String q_title = rs.getString("q_title");
							String q_date = rs.getString("q_date");
							
							if(m_name.length()>=3){
								m_name = m_name.substring(0, 1)+"**";
							}
							if(q_title.length()>=10){
								q_title = q_title.substring(0, 10)+"...";
							}
				%>		
							<tr>
								<td><%=q_no %></td>
								<td><%=m_name %></td>
								<td><a href="question_content.jsp?q_no=<%=q_no%>"><%=q_title%></a></td>
								<td><%=q_date %></td>
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
			<%if (uid != null || cid != null){ %>
			<a href="question_write.jsp"><input type = "button" id = "btn" value = "문의 작성"></a> <br><br>
			<%} %>
        </div>
        <div id = "footer">
        	<jsp:include page="../footer.jsp" />
        </div>
</div>
</body>
</html>