<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="local.vo.*"%>
<%@ page errorPage="errorPage.jsp" %>
<jsp:useBean id="boardlike" class="local.vo.BoardLike" />
<jsp:setProperty name="boardlike" property="*" />

<%
    Member member = (Member) session.getAttribute("login");
    String boardIdParam = request.getParameter("boardId");
    int boardId = 0;

    if (boardIdParam != null && !boardIdParam.equals("")) {
        boardId = Integer.parseInt(boardIdParam);
    }

    Connection conn = null;
    PreparedStatement psmt = null;
    ResultSet rs = null;
    
    String url = "jdbc:mysql://localhost:3306/localboard";
    String user = "cteam";
    String pass = "1234";
		
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);

        String action = request.getParameter("action");
        if ("like".equals(action)) {
            // 사용자가 이미 좋아요를 눌렀는지 확인
            String checkLikeSql = "SELECT * FROM board_like WHERE board_id = ? AND created_by = ?";
            psmt = conn.prepareStatement(checkLikeSql);
            psmt.setInt(1, boardId);
            psmt.setInt(2, member.getMemberId());
            rs = psmt.executeQuery();

            
            
            if (!rs.next()) {
                // 사용자가 아직 좋아요를 누르지 않았으면 좋아요 추가
                String insertSql = "INSERT INTO board_like(board_id, created_by, created_ip, created_at, count) VALUES(?, ?, 1.0, now(), 1)";
                psmt = conn.prepareStatement(insertSql);
                psmt.setInt(1, boardId);
                psmt.setInt(2, member.getMemberId());
                psmt.executeUpdate();
            }
        } else if ("unlike".equals(action)) {
            // 좋아요 삭제
            String deleteSql = "DELETE FROM board_like WHERE board_id = ? AND created_by = ?";
            psmt = conn.prepareStatement(deleteSql);
            psmt.setInt(1, boardId);
            psmt.setInt(2, member.getMemberId());
            psmt.executeUpdate();
        }

        // 좋아요 개수 조회
        String selectCountSql = "SELECT COUNT(*) AS likeCount FROM board_like WHERE board_id = ? AND count = 1";
        psmt = conn.prepareStatement(selectCountSql);
        psmt.setInt(1, boardId);
        rs = psmt.executeQuery();

        // 좋아요 개수 설정
        if (rs.next()) {
            int likeCount = rs.getInt("likeCount");
            boardlike.setCount(likeCount);
        }

%>
    <%=boardlike.getCount()%> 
<%
    } catch (Exception e) {
        out.print("FAIL");
        e.printStackTrace();
    } finally {
        try {
            if (conn != null) {
                conn.close();
            }
            if (psmt != null) {
                psmt.close();
            }
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
