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
		String cid = "";
		String cpasswd = "";
		if (request.getParameter("cid") == "") {
	%>
	<script>
		alert("아이디를 입력하세요");
		document.location.href = 'login.jsp';
	</script>
	<%
		} else if (request.getParameter("cpasswd") == "") {
	%>
	<script>
		alert("비밀번호를 입력하세요");
		document.location.href = 'logincompany.jsp';
	</script>
	<%
		} else {
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			cid = request.getParameter("id"); //ID값 가져옴
			cpasswd = request.getParameter("passwd"); //PW값 가져옴
			
			try{
				String sql = "select c_id, c_passwd from company where c_id = ? AND c_passwd = ? ";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1,cid);
				pstmt.setString(2,cpasswd);
				rs = pstmt.executeQuery();
				
				Boolean check = false;
				while (rs.next()){
					String c_id = rs.getString("c_id"); //DB에 있는 ID가져옴
					session.setAttribute("cid", c_id); //DB값을 세션에 넣음
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
		document.location.href = 'logincompany.jsp';
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