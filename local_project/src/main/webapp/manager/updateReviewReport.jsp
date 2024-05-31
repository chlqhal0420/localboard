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
       
        
        String reviewReportIdParam = request.getParameter("review_report_id");
        int reviewReportId = 0;
        if(reviewReportIdParam != null && !reviewReportIdParam.equals("")){
        	reviewReportId = Integer.parseInt(reviewReportIdParam);
        }       
        
        String status = request.getParameter("status");
        
        String sql = " UPDATE review_report "
                   + " SET status = ? "
                   + " WHERE review_report_id = ?";

        psmt = conn.prepareStatement(sql);
        psmt.setString(1, status); 	
        psmt.setInt(2, reviewReportId); 		 
      
       

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