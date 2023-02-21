<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../db/dbconn.jsp"%>
<%
request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
	<%
		String uid = "";
		String upasswd = "";
		if (request.getParameter("uid") == "") {
	%>
	<script>
		alert("아이디를 입력하세요");
		document.location.href = 'login.jsp';
	</script>
	<%
		} else if (request.getParameter("upasswd") == "") {
	%>
	<script>
		alert("비밀번호를 입력하세요");
		document.location.href = 'login.jsp';
	</script>
	<%
		} else {
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			uid = request.getParameter("id"); //ID값 가져옴
			upasswd = request.getParameter("passwd"); //PW값 가져옴
			
			try{
				String sql = "select m_id, m_passwd, m_admin from member where m_id = ? AND m_passwd = ? ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,uid);
				pstmt.setString(2,upasswd);
				rs = pstmt.executeQuery();
				
				Boolean check = false;
				while (rs.next()){
					String m_id = rs.getString("m_id");
					int m_admin = rs.getInt("m_admin"); //DB에 있는 ID가져옴
					session.setAttribute("uid", m_id);
					session.setAttribute("admin", m_admin); //DB값을 세션에 넣음
					check = true;
				}
				if (check) {
					%>
					<script>
						document.location.href = '../main.jsp';
					</script>
					<%			
				} else { //ID,PW가 일치하지 않는 경우
			
	%>
	<script>
		alert("ID 또는 PW를 잘못 입력했습니다.");
		document.location.href = 'login.jsp';
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
		}
	%>

</html>