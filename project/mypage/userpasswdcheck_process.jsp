<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
	String uid = (String) session.getAttribute("uid"); 
	String cid = (String) session.getAttribute("cid");
%>
<!DOCTYPE>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
<%
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			String upasswd = request.getParameter("passwd"); //PW값 가져옴
			
			try{
				String sql = "select * from member where m_id = ? AND m_passwd = ? ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,uid);
				pstmt.setString(2,upasswd);
				rs = pstmt.executeQuery();
				
				Boolean check = false;
				while (rs.next()){
					String m_id = rs.getString("m_id");
					check = true;
				}
				if (check) {
					%>
					<script>
						document.location.href = 'edituser.jsp';
					</script>
					<%			
				} else { //ID,PW가 일치하지 않는 경우
			
	%>
	<script>
		alert("비밀번호를 잘못 입력했습니다.");
		document.location.href = 'passwdcheck.jsp';
	</script>
	<%
				}
			} catch(SQLException e) {
				e.printStackTrace();
			}finally{
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			}
	%>

</html>