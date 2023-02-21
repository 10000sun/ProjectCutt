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
			String zipno = request.getParameter("zipNo");
			String addr = request.getParameter("roadAddrPart1");
			String addrDetail = request.getParameter("addrDetail");
			String tel = request.getParameter("tel1")+"-"+request.getParameter("tel2")+"-"+request.getParameter("tel3");

			
			PreparedStatement pstmt = null;
			
			try{
				String sql = "update member set m_passwd = ?, m_tel = ?, m_zipno = ?, m_addr = ?, m_addrDetail = ?, m_tel = ? where m_id = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,passwd);
				pstmt.setString(2,tel);
				pstmt.setString(3,zipno);
				pstmt.setString(4,addr);
				pstmt.setString(5,addrDetail);
				pstmt.setString(6,tel);
				pstmt.setString(7,uid);
				pstmt.executeUpdate();
						
				response.sendRedirect("mypage.jsp");
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