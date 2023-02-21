<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="db/dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="main.css">
    <meta charset="UTF-8">
    <title>Cutt</title>
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
				<h1 id="logo1"><a href = "main.jsp">Cutt</a></h1>
			</div>
			<nav id="navregister">

			<% if( uid  == null && cid == null){
			%>
				<ul>
           			<li id = "liafter"><a href = "login/login.jsp">로그인</a></li>
            		<li><a href = "register/agree.jsp">회원가입</a></li>
            	</ul>

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
							<li><a href = "mypage/mypage.jsp">마이페이지</a></li>
							<li><a href = "reserve/reserve.jsp">실시간 예약</a></li>
							<%
						} else if(cid != null && uid == null){
							 %>
							<li><a href = "mypage/companymypage.jsp">마이페이지</a></li>
							<li><a href = "mypage/shopmenu.jsp">메뉴 추가</a></li>
							<%
						}
					 %>
					<li><a href = "review/review.jsp">리뷰</a></li>
					<li><a href = "notice/notice.jsp">공지사항</a></li>
					<li><a href = "question/question.jsp">고객센터</a></li>
				</ul>
            </nav>
        </header>
        <div id="contents">
            <div id="shops">
				<span id = "bigchar"> Cutt</span>는 사람들을 위해 만들어졌습니다. 어디가 어떻게 잘 자르고, 얼마나 더 싸고, 
				어느 정도의 실력인지 잘 모르는 사람들, 미용에 별로 관심이 없어 집앞 프랜차이즈 미용실만 가는 사람들, 무조건 가격만 저렴하다면 찾는 사람들,
				낯을 많이 가려 미용실을 갈때마다 늘 머리를 실패해서 오는 사람들을 위해 만들어졌습니다. 왜 쇼핑몰 가격비교 사이트는 넘쳐나는데, 
				미용실 가격비교는 없을까? 왜 우리는 미용실을 더 저렴하고 좋은 품질에 이용을 하지 못할까? 하는 마음에서 만들어졌습니다. 
				이제 Cutt를 알게 된 여러분들은 로션을 살때 성분을 비교하듯이, 우유를 살때 유통기한을 확인 하듯이, 미용실에서도 가격비교와
				리뷰를 통해, 더욱 꼼꼼하고 현명하고 슬기로운 소비를 하실 수 있습니다. 그것이 Cutt가 만들어지고 존재하는 이유입니다. 우리는 더 나은 
				미용실 가격 문화의 정착을 위해 힘씁니다.
            </div>
        </div>
			<jsp:include page="footer.jsp" />
</div>
</body>
</html>