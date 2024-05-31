<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="local.vo.*"%>
<%
    request.setCharacterEncoding("UTF-8");

    Member member = (Member) session.getAttribute("login");

    Connection conn = null;
    PreparedStatement psmt = null;
    String url = "jdbc:mysql://localhost:3306/localboard";
    String user = "cteam";
    String pass = "1234";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);

        String boardIdParam = request.getParameter("board_id");
        int boardId = 0;
        if (boardIdParam != null && !boardIdParam.equals("")) {
        	boardId = Integer.parseInt(boardIdParam);
        }

        System.out.println(boardId);
        
        String sql = "UPDATE board SET delyn = 'Y' WHERE board_id = ?";
        psmt = conn.prepareStatement(sql);
        psmt.setInt(1, boardId);

        int result = psmt.executeUpdate();

        if (result > 0) {
            out.print("SUCCESS");
        } else {
            out.print("FAIL");
        }

    } catch(SQLException e) {
        // 예외 처리 - 사용자에게 메시지를 전달하거나 로깅을 수행
        out.print("FAIL: " + e.getMessage());
    } catch(Exception e){
        // 기타 예외 처리
        e.printStackTrace();
    } finally {
        try {
            if (conn != null) conn.close();
            if (psmt != null) psmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>