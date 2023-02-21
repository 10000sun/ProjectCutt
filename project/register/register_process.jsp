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
		request.setCharacterEncoding("UTF-8");
	
		String id = request.getParameter("id");
		String passwd = request.getParameter("passwd");
		String name = request.getParameter("name");
		String zipno = request.getParameter("zipNo");
		String addr = request.getParameter("roadAddrPart1");
		String addrDetail = request.getParameter("addrDetail");
		String tel = request.getParameter("tel1")+"-"+request.getParameter("tel2")+"-"+request.getParameter("tel3");
		
		PreparedStatement pstmt = null;
		
		try{
			String sql = "insert into member(m_id,m_passwd,m_name,m_zipno,m_addr,m_addrdetail,m_tel,m_admin)";
			sql = sql+" values(?,?,?,?,?,?,?,0)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,id);
			pstmt.setString(2,passwd);
			pstmt.setString(3,name);
			pstmt.setString(4,zipno);
			pstmt.setString(5,addr);
			pstmt.setString(6,addrDetail);
			pstmt.setString(7,tel);
			pstmt.executeUpdate();
			
			response.sendRedirect("welcome.jsp");
		}catch(SQLException e){
			e.printStackTrace();
		}finally{
			if(pstmt != null) pstmt.close();
			if(conn != null) conn.close();
		}
	%>
</body>
</html>