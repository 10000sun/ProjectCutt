<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../db/dbconn.jsp" %>
<html>
<head>
<link rel="stylesheet" href="companymypage.css">
<meta charset="UTF-8">
<title>Cutt : 마이페이지</title>
    <%
		String uid = (String) session.getAttribute("uid"); 
 	   	String cid = (String) session.getAttribute("cid");
    %>
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
					location.href="login/login.jsp";
				</script>

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
					<%
						if (uid != null || cid == null){
							 %>
							<li><a href = "mypage.jsp">마이페이지</a></li>
							<li><a href = "../reserve.jsp">실시간 예약</a></li>
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
				<h3>메뉴 확인</h3>
				<table>
					<tr>
						<td>메뉴 이름</td>
						<td>메뉴 가격</td>
					</tr>

				<%
					ResultSet rs = null;
					PreparedStatement pstmt = null;
					
					try{
						String sql = "select s_menu, s_price from shopmenu s join company c on s.c_no = c.c_no where c_id = ?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, cid);
						rs = pstmt.executeQuery();
						
						while(rs.next()){
							String s_menu = rs.getString("s_menu");
							int s_price = rs.getInt("s_price");
							%>
									<tr>
										<td><%=s_menu %> </td>
										<td><%=s_price %></td>
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
			</div>
		
	</div>
		<jsp:include page="../footer.jsp" />
</div>
</body>
</html>