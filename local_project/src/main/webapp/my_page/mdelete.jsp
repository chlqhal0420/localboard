<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	String method = request.getMethod();
	if(method.equals("GET")){
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href = "<%=request.getContextPath()%>";
	</script>
	<% 
	}
	String mnoPram = request.getParameter("memberId");

	int memberId = 0; 
	
	int result = 0;
	
	if(mnoPram != null && !mnoPram.equals("")){
		memberId = Integer.parseInt(mnoPram);
	} 
	
	Connection conn = null;
	PreparedStatement psmt = null;
	String url = "jdbc:mysql://localhost:3306/localboard";
	String user = "cteam";
	String pass = "1234";
	
	
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		String sql = "update member set status = 'Quit' where member_id = ?;";
		
		psmt = conn.prepareStatement(sql);
		psmt.setInt(1,memberId);
		
		result = psmt.executeUpdate();
	
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
	}
	
	if(result>0){
	%>
	<script>
		alert("탈퇴가 완료되었습니다.");
		location.href="<%=request.getContextPath()%>/login/logOut.jsp";
	</script>
	<% 
	}else{
	%>
	<script>
		alert("탈퇴에 실패했습니다. 관리자에게 문의하세요");
		location.href="myPageList.jsp";
	</script>
	<%
	}
%>
