<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page errorPage="errorPage.jsp" %>
<%
    String boardIdParam = request.getParameter("boardId");
    int boardId = 0;

    if (boardIdParam != null && !boardIdParam.equals("")) {
    	boardId = Integer.parseInt(boardIdParam);
    }
%>

<jsp:useBean id="board" class="local.vo.Board" />
<jsp:setProperty name="board" property="*" />

<% 
    Connection conn = null;
    PreparedStatement psmt = null;
    String url = "jdbc:mysql://localhost:3306/localboard";
    String user = "cteam";
    String pass = "1234";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);

        String sql = "UPDATE board b SET b.comment_count = (SELECT COUNT(comment_id) FROM comment WHERE board_id = ? AND delyn = 'N') WHERE b.board_id = ?;";
        psmt = conn.prepareStatement(sql);
        psmt.setInt(1, boardId);
        psmt.setInt(2, boardId);

        int result = psmt.executeUpdate();

        if (result > 0) {
            out.print("SUCCESS");
            
        
            
        } else {
            out.print("FAIL");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (conn != null) {
                conn.close();
            }
            if (psmt != null) {
                psmt.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
