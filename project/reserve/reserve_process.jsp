<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="reserve_process.css">
    <meta charset="UTF-8">
    <title>Cutt</title>
       <% 
    String uid = (String) session.getAttribute("uid");
    String cid = (String) session.getAttribute("cid");
    String r_date = request.getParameter("r_date");
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
    
    <script
    src="https://code.jquery.com/jquery-3.6.3.js" 
    integrity="sha256-nQLuAZGRRcILA+6dMBOvcRh5Pe310sBpanc6+QBmyVM=" 
    crossorigin="anonymous"></script>
    
    <script>
    	function checkradio(){
    		if(document.radiofrm.selcom.checked === false){
    			alert("업체를 선택해주세요.");
    			return false;
    		}
    		if(document.radiofrm.selmenu.checked === false){
    			alert("메뉴를 선택해주세요.");
    			return false;
    		}
    		document.radiofrm.submit();
    	}
    </script>
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
				<ul>
           			<li id = "liafter"><a href = "../login/login.jsp">로그인</a></li>
            		<li><a href = "../register/agree.jsp">회원가입</a></li>
            	</ul>

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
					<li><a href = "../mypage/mypage.jsp">마이페이지</a></li>
					<li><a href = "reserve.jsp">실시간 예약</a></li>
					<li><a href = "#">리뷰</a></li>
					<li><a href = "../notice/notice.jsp">공지사항</a></li>
					<li><a href = "../question/question.jsp">고객센터</a></li>
				</ul>
            </nav>
        </header>
	        <div id="contents">
	        <h3>실시간 예약</h3>
	           <div id = "selectcompany">
	           		<p>업체와 메뉴를 선택해 주세요 </p>
	           		<form name = "radiofrm" action = "reserve_process_ok.jsp" method = "post">
	           		<input type = "hidden" name = "r_date" value = "<%=r_date %>">
	           		<table id = seltable>
	<%
					ResultSet rs = null;
					ResultSet rs2 = null;
					PreparedStatement pstmt = null;
					PreparedStatement pstmt2 = null;
					
					try{
						String sql = "select c_name from company";
						pstmt = conn.prepareStatement(sql);
						rs = pstmt.executeQuery();
						
						while(rs.next()){
							String c_name = rs.getString("c_name");

				%>		
							<tr>
								<td>업체이름</td>
								<td><label for = "<%=c_name%>"><%=c_name %></label></td>
								<td><input type = "radio" name = "selcom" value = "<%=c_name %>"></td>
							</tr>
									<%
										String sql2 = "select s_menu, c_no from shopmenu where c_no = (select c_no from company where c_name = ?)";
										pstmt2 = conn.prepareStatement(sql2);
										pstmt2.setString(1, c_name);
										rs2 = pstmt2.executeQuery();
										
										while(rs2.next()){
											String s_menu = rs2.getString("s_menu");
											int c_no = rs2.getInt("c_no");
									%>
									<tr>
										<td>메뉴</td>
										<td><label for = "selmenu"><%=s_menu %></label></td>
										<td><input type = "radio" name = "selmenu" value = "<%=s_menu %>"></td>
									</tr>
	      <%
							}
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
					<input type = "button" id = "btn" value = "예약하기" onclick = "checkradio()">
					<input type = "button" id = "btn" value = "취소하기" onclick = "history.back()">
				</form>
		<jsp:include page="../footer.jsp" />
</div>
</body>
</html>