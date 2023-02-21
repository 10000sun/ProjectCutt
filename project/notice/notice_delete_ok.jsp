<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 삭제</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	int n_no = Integer.parseInt(request.getParameter("n_no"));
	
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	
	try{
		
		String sql = "delete from notice where n_no=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1,n_no);
		pstmt.executeUpdate();
				
		response.sendRedirect("notice.jsp");
	}catch(SQLException e){
		e.printStackTrace();
	}finally{
		if(rs != null) rs.close();
		if(pstmt != null) pstmt.close();
		if(conn != null) conn.close();
	}
%>
</body>
</html>