<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 저장</title>
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
</head>
<body>
<%		
		request.setCharacterEncoding("UTF-8");

		String title = request.getParameter("title");
		String content = request.getParameter("content");
		String menuname = request.getParameter("menuname");
		String companyname = request.getParameter("companyname");
		int rate = Integer.parseInt(request.getParameter("rvrate"));
		
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		
		try{
			String sql = "select m_no from member where m_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, uid);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				String m_no = rs.getString("m_no");
				
				sql = "insert into review(rv_title,rv_content,m_no,rv_date,rv_rate,rv_name,rv_menu) values(?,?,?,sysdate(),?,?,?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,title);
				pstmt.setString(2,content);
				pstmt.setString(3,m_no);
				pstmt.setInt(4,rate);
				pstmt.setString(5,companyname);
				pstmt.setString(6,menuname);
				pstmt.executeUpdate();
				
				sql = "ALTER TABLE review AUTO_INCREMENT=1";
				pstmt = conn.prepareStatement(sql);
				pstmt.executeUpdate();
				
				sql = "SET @COUNT = 0;";
				pstmt = conn.prepareStatement(sql);
				pstmt.executeUpdate();
				
				sql = "UPDATE review SET rv_no = @COUNT:=@COUNT+1;";
				pstmt = conn.prepareStatement(sql);
				pstmt.executeUpdate();
						
				response.sendRedirect("review.jsp");
			}
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