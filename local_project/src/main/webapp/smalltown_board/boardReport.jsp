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
       
        
        String boardIdParam = request.getParameter("boardId"); // 게시글 정보
        int boardId = 0;
        if(boardIdParam != null && !boardIdParam.equals("")){
        	boardId = Integer.parseInt(boardIdParam);
        }
        
        // 신고한 사람
        String memberIdParam = request.getParameter("memberId"); //추가됨
        int memberId = 0;
        if(memberIdParam != null && !memberIdParam.equals("")){
        	memberId = Integer.parseInt(memberIdParam);
        } 
        
 		// 신고된 사람
        String createBydParam = request.getParameter("createdBy");
        int createdBy = 0;
        if(createBydParam != null && !createBydParam.equals("")){
        	createdBy = Integer.parseInt(createBydParam);
        }
        
        
        
        
        String reportReason = request.getParameter("reportReason");
  
        
        String sql = "INSERT INTO board_report "
                + "(board_id, created_by, created_ip, created_at, modified_by, modified_ip, modified_at, reason, board_code, board_no) "
                + "VALUES(?, ?, '1.0', NOW(), ?, '1.0', NOW(), ?, 'S', ?)";

        psmt = conn.prepareStatement(sql);
        psmt.setInt(1, boardId); 		 //board_id
        psmt.setInt(2, memberId);		 //created_by = 신고한 사람
        psmt.setInt(3, createdBy); 		 //modified_by = 신고된 사람
        psmt.setString(4, reportReason); //reason
        psmt.setInt(5, boardId);		 //board_no
      

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