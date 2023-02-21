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
		
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		
		try{
			String sql = "insert into notice(n_title,n_content,m_no,n_hits,n_date) values(?,?,?,0,sysdate())";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,title);
			pstmt.setString(2,content);
			pstmt.setInt(3,admin);
			pstmt.executeUpdate();
			
			sql = "ALTER TABLE notice AUTO_INCREMENT=1";
			pstmt = conn.prepareStatement(sql);
			pstmt.executeUpdate();
			
			sql = "SET @COUNT = 0;";
			pstmt = conn.prepareStatement(sql);
			pstmt.executeUpdate();
			
			sql = "UPDATE notice SET n_no = @COUNT:=@COUNT+1;";
			pstmt = conn.prepareStatement(sql);
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