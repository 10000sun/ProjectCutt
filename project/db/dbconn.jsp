<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<% 
		Connection conn = null;
		
		String url = "jdbc:mysql://localhost:3306/reservation?serverTimezone=UTC&allowMultiQueries=true";
		String user = "root";
		String password = "12345";
		
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(url, user, password);
	%>
</body>
</html>