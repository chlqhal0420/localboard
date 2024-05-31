<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page errorPage="errorPage.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");

	String rcontent = request.getParameter("rcontent");
	String rnoParam = request.getParameter("rno");
	
	int rno = 0;
	if(rnoParam != null && !rnoParam.equals("")){
		rno = Integer.parseInt(rnoParam);
	}
	
	Connection conn = null;
	PreparedStatement psmt= null;
	String url = "jdbc:mysql://localhost:3306/localboard";
	String user = "cteam";
	String pass = "1234";
	
	try{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = " UPDATE comment "
				   + "    SET content = ? "
				   + "  WHERE comment_id = ? ";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, rcontent);
		psmt.setInt(2,rno);
		
		int result = psmt.executeUpdate();
		
		if(result > 0){
			out.print("SUCCESS");
		}else{
			out.print("FAIL");
		}
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
	}
%>



