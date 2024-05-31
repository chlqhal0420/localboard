<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="local.vo.*"%>
<%@ page errorPage="errorPage.jsp" %>
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
        
        String reviewIdParam = request.getParameter("reviewId"); // 게시글 정보
        int reviewId = 0;
        if(reviewIdParam != null && !reviewIdParam.equals("")){
        	reviewId = Integer.parseInt(reviewIdParam);
        }             

        String createBydParam = request.getParameter("createdBy");
        int createdBy = 0;
        if(createBydParam != null && !createBydParam.equals("")){
        	createdBy = Integer.parseInt(createBydParam); 
        	/*  createdBy : 현재 로그인해서 신고버튼을 누른 사람 */ 
        }        
      
        String reportReason = request.getParameter("reportReason");
  
        
        String sql = "INSERT INTO review_report "
                + "(review_id, created_by, created_ip, created_at, reason) "
                + "VALUES(?, ?, ?, now(), ?)";

        psmt = conn.prepareStatement(sql);
        psmt.setInt(1, reviewId); 		
        psmt.setInt(2, createdBy);	
        psmt.setString(3, request.getRemoteAddr());
        psmt.setString(4, reportReason); 		 
     		

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