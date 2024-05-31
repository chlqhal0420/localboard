<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//사용자가 입력하여 전달한 닉네임 값이 DB에 존재하는지 확인
	String email = request.getParameter("email");

	Connection conn = null;
	PreparedStatement psmt= null;
	ResultSet rs = null;
	String url = "jdbc:mysql://localhost:3306/localboard";
	String user = "cteam";
	String pass = "1234";
	
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "select count(*) as cnt from member where email = ?";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, email);
		
		rs = psmt.executeQuery();
		
		int cnt = 1;
		
		if(rs.next()){
			cnt = rs.getInt("cnt");
		}
		
		
		 out.print(cnt); //응답데이터
		 
		 
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
	}

%>