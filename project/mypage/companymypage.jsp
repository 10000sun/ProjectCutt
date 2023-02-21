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
				<%
					ResultSet rs = null;
					PreparedStatement pstmt = null;
					
					try{
						String sql = "select c_name, c_tel, c_count from company where c_id = ?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, cid);
						rs = pstmt.executeQuery();
						
						if(rs.next()){
							String c_name = rs.getString("c_name");
							String c_tel = rs.getString("c_tel");
							int c_count = rs.getInt("c_count");
							%>
							<p><%=c_name %>님은 사람들이 <%=c_count %>번 이용했어요.
								<table name = "mypagetable">
									<tr>
										<td>회사 명 : </td>
										<td><input type="text" value="<%=c_name %>" id="mypageinput" readonly></td>
									</tr>
									<tr>
										<td>회사 전화번호 : </td>
										<td><input type="text" value="<%=c_tel %>" id="mypageinput" readonly></td>
									</tr>
									<tr>
										<td>회사 예약 수 : </td>
										<td><input type="text" value="<%=c_count %>" id="mypageinput" readonly></td>
									</tr>
									<tr>
										<td colspan="2"></td>
									</tr>
								</table>
							<%
							}
						%>
						<input type="button" value="메뉴 보기" id="mypagemodify" onclick="location.href='showmenu.jsp'">
						<input type="button" value="회원정보수정" id="mypagemodify" onclick="location.href='passwdcheck.jsp'">
						<%
					}catch(SQLException e){
						e.printStackTrace();
					}finally{
						if(rs != null) rs.close();
						if(pstmt != null) pstmt.close();
						if(conn != null) conn.close();
					}
				%>	
					
			</div>
		
	</div>
		<jsp:include page="../footer.jsp" />
</div>
</body>
</html>