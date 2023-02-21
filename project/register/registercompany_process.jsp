<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp" %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
		request.setCharacterEncoding("UTF-8");
	
		String id = request.getParameter("id");
		String passwd = request.getParameter("passwd");
		String name = request.getParameter("name");
		String tel = request.getParameter("tel1")+"-"+request.getParameter("tel2")+"-"+request.getParameter("tel3");
		String ceoname = request.getParameter("ceoname");
		
		PreparedStatement pstmt = null;
		
		try{
			String sql = "insert into company(c_id,c_passwd,c_name,c_tel,c_ceo,c_count)";
			sql = sql+" values(?,?,?,?,?,0)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,id);
			pstmt.setString(2,passwd);
			pstmt.setString(3,name);
			pstmt.setString(4,tel);
			pstmt.setString(5,ceoname);
			pstmt.executeUpdate();
			
			response.sendRedirect("welcome.jsp");
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();
		}
	%>
</body>
</html>