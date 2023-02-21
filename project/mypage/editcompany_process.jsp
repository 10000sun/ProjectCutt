<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
<%@ include file = "../db/dbconn.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <% 
    String uid = (String) session.getAttribute("uid");
    String cid = (String) session.getAttribute("cid");
    %>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
			request.setCharacterEncoding("UTF-8");
			
			String id = request.getParameter("id");
			String passwd = request.getParameter("passwd");
			String name = request.getParameter("name");
			String tel = request.getParameter("tel1")+"-"+request.getParameter("tel2")+"-"+request.getParameter("tel3");
			String ceoname = request.getParameter("ceoname");
			
			PreparedStatement pstmt = null;
			
			try{
				String sql = "update company set c_passwd = ?, c_name = ?, c_tel = ?, c_ceo = ?, c_tel = ? where c_id = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,passwd);
				pstmt.setString(2,name);
				pstmt.setString(3,tel);
				pstmt.setString(4,ceoname);
				pstmt.setString(5,tel);
				pstmt.setString(6,cid);
				pstmt.executeUpdate();
						
				response.sendRedirect("companymypage.jsp");
			%>

							
			<%
			} catch(SQLException e) {
				e.printStackTrace();
			}finally{
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			}
	%>
</body>
</html>