<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
	session.invalidate();
%>
<!DOCTYPE html>
<html>
	<script>
		alert("로그아웃 되었습니다.")
		location.href="../main.jsp";
	</script>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>