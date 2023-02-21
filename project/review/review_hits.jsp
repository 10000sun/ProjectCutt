<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "../db/dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
			int rv_no = Integer.parseInt(request.getParameter("rv_no").toString());
		
			PreparedStatement pstmt = null;
			
			try{
				String sql = "update review set rv_hits=rv_hits+1 where rv_no=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1,rv_no);
				pstmt.executeUpdate();
				
				response.sendRedirect("review_content.jsp?rv_no="+rv_no);
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			}
		%>
</body>
</html>