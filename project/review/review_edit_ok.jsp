<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp" %>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Cutt : 리뷰 수정</title>
</head>
<body>
	<%
		request.setCharacterEncoding("UTF-8");
	
		int rv_no = Integer.parseInt(request.getParameter("rv_no"));
		String rv_title = request.getParameter("rv_title");
		String rv_content = request.getParameter("rvcontent");
		String menuname = request.getParameter("menuname");
		String companyname = request.getParameter("companyname");
		int rate = Integer.parseInt(request.getParameter("rvrate"));
		
		PreparedStatement pstmt = null;
		
		try{
				String sql = "update review set rv_title=?,rv_content=?,rv_menu=?,rv_name=?,rv_rate=? where rv_no=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,rv_title);
				pstmt.setString(2,rv_content);
				pstmt.setString(3,menuname);
				pstmt.setString(4,companyname);
				pstmt.setInt(5,rate);
				pstmt.setInt(6,rv_no);
				
				pstmt.executeUpdate();
					
				response.sendRedirect("review.jsp");
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();
		}
	%>
</body>
</html>
