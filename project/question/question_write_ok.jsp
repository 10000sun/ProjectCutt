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
			String sql = "select m_no, m_passwd from member where m_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,uid);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				String passwd = rs.getString("m_passwd");
				int m_no = rs.getInt("m_no");
				sql = "insert into question(q_title, q_content, q_passwd, q_date, m_no) values(?, ?, ?, sysdate(), ?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,title);
				pstmt.setString(2,content);
				pstmt.setString(3,passwd);
				pstmt.setInt(4,m_no);
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
						
				response.sendRedirect("question.jsp");
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