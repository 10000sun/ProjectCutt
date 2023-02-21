<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp" %>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Cutt : 공지 수정</title>
</head>
<body>
	<%
		request.setCharacterEncoding("UTF-8");
	
		int n_no = Integer.parseInt(request.getParameter("n_no"));
		String n_title = request.getParameter("n_title");
		String n_content = request.getParameter("n_content");
		
		PreparedStatement pstmt = null;
		
		try{
				String sql = "update notice set n_title=?,n_content=? where n_no=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,n_title);
				pstmt.setString(2,n_content);
				pstmt.setInt(3,n_no);
				pstmt.executeUpdate();
					
				response.sendRedirect("notice.jsp");
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();
		}
	%>
</body>
</html>