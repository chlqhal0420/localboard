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
        
        String commentIdParam = request.getParameter("commentId"); // 게시글 정보
        int commentId = 0;
        if(commentIdParam != null && !commentIdParam.equals("")){
        	commentId = Integer.parseInt(commentIdParam);
        }             

        String createBydParam = request.getParameter("createdBy");
        int createdBy = 0;
        if(createBydParam != null && !createBydParam.equals("")){
        	createdBy = Integer.parseInt(createBydParam);
        }        
      
        String reportReason = request.getParameter("reportReason");
  
        
        String sql = "INSERT INTO comment_report "
                + "(comment_id, created_by, created_ip, created_at, reason) "
                + "VALUES(?, ?, '1.0', now(), ?)";

        psmt = conn.prepareStatement(sql);
        psmt.setInt(1, commentId); 		
        psmt.setInt(2, createdBy);		
        psmt.setString(3, reportReason); 		 
     		

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