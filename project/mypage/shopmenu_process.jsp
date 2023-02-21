<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메뉴 추가</title>
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

		String menu = request.getParameter("menu");
		int price = Integer.parseInt(request.getParameter("price").toString());
		
		ResultSet rs = null;
		PreparedStatement pstmt = null;
		
		try{
			String sql = "select c_no, c_name from company where c_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,cid);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				int c_no = rs.getInt("c_no");
				String c_name = rs.getString("c_name");
				sql = "insert into shopmenu(s_menu, s_price, c_no) values(?, ?, ?)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,menu);
				pstmt.setInt(2,price);
				pstmt.setInt(3,c_no);
				pstmt.executeUpdate();
					
				response.sendRedirect("companymypage.jsp");
			}
		}catch(SQLException e){
			e.printStackTrace();
			%>
			<script>
				alert("오류가 발생했습니다. 다시한번 시도해주세요.");
			</script>
			<%
		}finally{
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();
		}
	%>
</body>
</html>