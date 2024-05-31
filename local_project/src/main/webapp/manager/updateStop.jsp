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
       
        
        String memberIdParam = request.getParameter("member_id");
        int memberId = 0;
        if(memberIdParam != null && !memberIdParam.equals("")){
        	memberId = Integer.parseInt(memberIdParam);
        }            
        
        String stopReason = request.getParameter("stop_reason");
        String status = request.getParameter("status");
        String stopStartDate = request.getParameter("stop_start_date");
        String stopEndDate = request.getParameter("stop_end_date");
  
        
        String sql = " UPDATE member "
                   + " SET stop_reason = ?, status = ?, stop_start_date = ?, stop_end_date = ? "
                   + " WHERE member_id = ?";

        psmt = conn.prepareStatement(sql);
        psmt.setString(1, stopReason); 		 
        psmt.setString(2, status);		
        psmt.setString(3, stopStartDate); 		
        psmt.setString(4, stopEndDate); 
        psmt.setInt(5, memberId); 
       

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