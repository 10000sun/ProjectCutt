<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="reserve.css">
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
    
    <script
    src="https://code.jquery.com/jquery-3.6.3.js" 
    integrity="sha256-nQLuAZGRRcILA+6dMBOvcRh5Pe310sBpanc6+QBmyVM=" 
    crossorigin="anonymous"></script>
    
    <script>
    $(document).ready(function() {
        calendarInit();
    });
    /*
        달력 렌더링 할 때 필요한 정보 목록 

        현재 월(초기값 : 현재 시간)
        금월 마지막일 날짜와 요일
        전월 마지막일 날짜와 요일
    */

    function calendarInit() {

        // 날짜 정보 가져오기
        var date = new Date(); // 현재 날짜(로컬 기준) 가져오기
        var utc = date.getTime() + (date.getTimezoneOffset() * 60 * 1000); // uct 표준시 도출
        var kstGap = 9 * 60 * 60 * 1000; // 한국 kst 기준시간 더하기
        var today = new Date(utc + kstGap); // 한국 시간으로 date 객체 만들기(오늘)
      
        var thisMonth = new Date(today.getFullYear(), today.getMonth(), today.getDate());
        // 달력에서 표기하는 날짜 객체
      
        
        var currentYear = thisMonth.getFullYear(); // 달력에서 표기하는 연
        var currentMonth = thisMonth.getMonth(); // 달력에서 표기하는 월
        var currentDate = thisMonth.getDate(); // 달력에서 표기하는 일

        // kst 기준 현재시간
        // console.log(thisMonth);

        // 캘린더 렌더링
        renderCalender(thisMonth);

        function renderCalender(thisMonth) {

            // 렌더링을 위한 데이터 정리
            currentYear = thisMonth.getFullYear();
            currentMonth = thisMonth.getMonth();
            currentDate = thisMonth.getDate();

            // 이전 달의 마지막 날 날짜와 요일 구하기
            var startDay = new Date(currentYear, currentMonth, 0);
            var prevDate = startDay.getDate();
            var prevDay = startDay.getDay();

            // 이번 달의 마지막날 날짜와 요일 구하기
            var endDay = new Date(currentYear, currentMonth + 1, 0);
            var nextDate = endDay.getDate();
            var nextDay = endDay.getDay();

            // console.log(prevDate, prevDay, nextDate, nextDay);

            // 현재 월 표기
            $('.year-month').text(currentYear + '.' + (currentMonth + 1));

            // 렌더링 html 요소 생성
            calendar = document.querySelector('.dates');
            calendar.innerHTML = '';
            
            // 지난달
            for (var i = prevDate - prevDay + 1; i <= prevDate; i++) {
                calendar.innerHTML = calendar.innerHTML + '<div class="day prev disable">' + i + '</div>';
            }
            // 이번달
            for (var i = 1; i <= nextDate; i++) {
                calendar.innerHTML = calendar.innerHTML + '<div class="day current"><a href = "reserve_process.jsp?r_date='+currentYear+'/'+(currentMonth+1)+'/'+i+'">' + i + '</a></div>';
            }
            // 다음달
            for (var i = 1; i <= (7 - nextDay == 7 ? 0 : 7 - nextDay); i++) {
                calendar.innerHTML = calendar.innerHTML + '<div class="day next disable">' + i + '</div>';
            }

            // 오늘 날짜 표기
            if (today.getMonth() == currentMonth) {
                todayDate = today.getDate();
                var currentMonthDate = document.querySelectorAll('.dates .current');
                currentMonthDate[todayDate -1].classList.add('today');
            }
        }

        // 이전달로 이동
        $('.go-prev').on('click', function() {
            thisMonth = new Date(currentYear, currentMonth - 1, 1);
            renderCalender(thisMonth);
        });

        // 다음달로 이동
        $('.go-next').on('click', function() {
            thisMonth = new Date(currentYear, currentMonth + 1, 1);
            renderCalender(thisMonth); 
        });
        
        window.onload = function () {
            var el = document.querySelector(".day current");
            el.onclick = hello;
        }

        function hello()  {
          alert('안녕하세요');
        }
        
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

			<% if( uid  == null && cid != null){
			%>
				<script>
					alert("회원 로그인이 필요한 서비스입니다.");
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
							<li><a href = "../mypage.jsp">마이페이지</a></li>
							<li><a href = "reserve.jsp">실시간 예약</a></li>
							<%
						} else if(cid != null && uid == null){
							 %>
							<li><a href = "../companymypage.jsp">마이페이지</a></li>
							<li><a href = "../shopmenu.jsp">메뉴 추가</a></li>
							<%
						}
					 %>
					<li><a href = "#">리뷰</a></li>
					<li><a href = "../notice/notice.jsp">공지사항</a></li>
					<li><a href = "../question/question.jsp">고객센터</a></li>
				</ul>
            </nav>
        </header>
	        <div id="contents">
	        <h3>실시간 예약</h3>
	            <div class="sec_cal">
				  <div class="cal_nav">
				    <a href="javascript:;" class="nav-btn go-prev">prev</a>
				    <div class="year-month"></div>
				    <a href="javascript:;" class="nav-btn go-next">next</a>
				  </div>
				  <div class="cal_wrap">
				    <div class="days">
				      <div class="day">MON</div>
				      <div class="day">TUE</div>
				      <div class="day">WED</div>
				      <div class="day">THU</div>
				      <div class="day">FRI</div>
				      <div class="day">SAT</div>
				      <div class="day">SUN</div>
				    </div>
				   	<div class="dates"></div>
				  </div>
				</div>
				<div><p style="text-align:center; padding-top:10px;">원하시는 날짜를 선택해주세요</p></div>
						<jsp:include page="../footer.jsp" />
	     	</div>

</div>
</body>
</html>