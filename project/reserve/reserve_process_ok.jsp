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

		String uid = (String) session.getAttribute("uid");
		String cid = (String) session.getAttribute("cid");
		
		request.setCharacterEncoding("UTF-8");
	
		String c_name = request.getParameter("selcom");
		String s_menu = request.getParameter("selmenu");
		String r_date = request.getParameter("r_date");
		
		ResultSet rs = null;
		ResultSet rs2 = null;
		ResultSet rs3 = null;
		ResultSet rs4 = null;
		
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2 = null;
		PreparedStatement pstmt3 = null;
		PreparedStatement pstmt4 = null;
		
		try{
			String sql = "select m_no from member where m_id = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, uid);

			rs = pstmt.executeQuery();
			
			while(rs.next()){
				int m_no = rs.getInt("m_no");
				String sql2 ="select s_no from shopmenu where s_menu = ? and c_no = (select c_no from company where c_name = ?)";
				pstmt2 = conn.prepareStatement(sql2);
				pstmt2.setString(1, s_menu);
				pstmt2.setString(2, c_name);
				
				rs2 = pstmt2.executeQuery();
				while(rs2.next()){
					int s_no = rs2.getInt("s_no");
					String sql3 = "insert into reserve(r_date, r_menu, m_no, s_no) values(?, ?, ?, ?)";
					pstmt3 = conn.prepareStatement(sql3);
					pstmt3.setString(1,r_date);
					pstmt3.setString(2,s_menu);
					pstmt3.setInt(3,m_no);
					pstmt3.setInt(4,s_no);
					pstmt3.executeUpdate();
						
					response.sendRedirect("../mypage/mypage.jsp");
					}
				}
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			if(pstmt != null) pstmt.close();
			if(pstmt2 != null) pstmt2.close();
			if(pstmt3 != null) pstmt3.close();
			if(pstmt4 != null) pstmt4.close();
			
			if(rs != null) rs.close();
			if(rs2 != null) rs2.close();
			if(rs3 != null) rs3.close();
			if(rs4 != null) rs4.close();
			
			if(conn != null) conn.close();
		}
	%>
	<%=r_date %> <%=s_menu %> <%=c_name %>
</body>
</html>
