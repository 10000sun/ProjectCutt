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
			int n_no = Integer.parseInt(request.getParameter("n_no").toString());
		
			PreparedStatement pstmt = null;
			
			try{
				String sql = "update notice set n_hits=n_hits+1 where n_no=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1,n_no);
				pstmt.executeUpdate();
				
				response.sendRedirect("notice_content.jsp?n_no="+n_no);
			}catch(SQLException e){
				e.printStackTrace();
			}finally{
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			}
		%>
</body>
</html>