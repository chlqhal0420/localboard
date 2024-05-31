<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="local.vo.*"%>
<%
    request.setCharacterEncoding("UTF-8");

    Member member = (Member) session.getAttribute("login");

    Connection conn = null;
    PreparedStatement psmt= null;
    String url = "jdbc:mysql://localhost:3306/localboard";
    String user = "cteam";
    String pass = "1234";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url,user,pass);

        // FormData에서 전송된 값들을 받아오기
       
        
        String lrIdParam = request.getParameter("lr_id");
        int lrId = 0;
        if(lrIdParam != null && !lrIdParam.equals("")){
        	lrId = Integer.parseInt(lrIdParam);
        }       
        
        String status = request.getParameter("status");
        
        String sql = " UPDATE local_report "
                   + " SET status = ? "
                   + " WHERE lr_id = ?";

        psmt = conn.prepareStatement(sql);
        psmt.setString(1, status); 	
        psmt.setInt(2, lrId); 		 
      
       

        int result = psmt.executeUpdate();

        if(result > 0){
 	
        	
            out.print("SUCCESS");
        } else {
            out.print("FAIL");
        }

    } catch(Exception e){
        e.printStackTrace();
    } finally {
        if(conn != null) conn.close();
        if(psmt != null) psmt.close();
    }
%>