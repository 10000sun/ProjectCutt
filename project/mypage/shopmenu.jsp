<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="shopmenu.css">
    <meta charset="UTF-8">
    <title>Cutt : 메뉴 추가</title>
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
    
    <script>
    	function menucheck(){
    		if(document.shopmenu.menu.value == ""){
    			alert("메뉴를 입력해주세요.");
    			document.shopmenu.menu.focus();
    			return false;
    		}
    		if (document.shopmenu.price.value == ""){
    			alert("가격을 입력해주세요.");
    			document.shopmenu.price.focus();
    			return false;
    		}
    		document.shopmenu.submit();
    	}
    </script>
</head>
<body>
<div id="container">
		<header>
			<div id="logo">
				<h1 id="logo1"><a href = "main.jsp">Cutt</a></h1>
			</div>
			<nav id="navregister">

			<% if(cid == null || uid != null){
			%>
				<script>
					alert("기업회원 로그인이 필요한 서비스입니다.");
					location.href="login/logincompany.jsp";
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
        <div id="contents">
        	<%
					ResultSet rs = null;
					PreparedStatement pstmt = null;
					
					try{
						String sql = "select * from company where c_id = ?";
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, cid);
						rs = pstmt.executeQuery();
						
						if(rs.next()){
							String c_name = rs.getString("c_name");
							%>
								<h3><%=c_name %> 메뉴 추가</h3>
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
            <form action = "shopmenu_process.jsp" method = "post" name = "shopmenu">
            <div id = "shopmenu">
            	시술 내용을 입력해주세요. <input type = "text" id = "inputbox" name = "menu"><br/>
            	시술 가격을 입력해주세요. <input type = "text" id = "inputbox" name = "price"><br/>
            	<input type = "button" onclick = "menucheck()" value = "추가하기" id = "btn">
            	<input type = "reset" value = "취소하기" id = "btnreset">
            	</div>
            	
            </form>
        </div>
			<jsp:include page="../footer.jsp" />
</div>
</body>
</html>