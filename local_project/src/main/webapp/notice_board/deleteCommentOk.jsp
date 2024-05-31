<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
    String commentIdParam = request.getParameter("commentid");
    int commentId = 0;

    if (commentIdParam != null && !commentIdParam.isEmpty()) {
        try {
            commentId = Integer.parseInt(commentIdParam);
        } catch (NumberFormatException e) {
            out.print("유효하지 않은 commentid입니다.");
            return;
        }
    } else {
        out.print("commentid가 제공되지 않았습니다.");
        return;
    }

    Connection conn = null;
    PreparedStatement psmt = null;
    ResultSet resultSet = null;

    String url = "jdbc:mysql://localhost:3306/localboard";
    String user = "cteam";
    String pass = "1234";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);

        // 댓글을 업데이트하기 전에 reply 테이블의 delyn 컬럼 값 확인
        String checkReplySql = "SELECT delyn FROM reply WHERE comment_id = ?";
        psmt = conn.prepareStatement(checkReplySql);
        psmt.setInt(1, commentId);
        resultSet = psmt.executeQuery();

        if (resultSet.next()) {
            String replyDelyn = resultSet.getString("delyn");

            if ("N".equals(replyDelyn)) {
                // 만약 reply 테이블의 delyn이 'N'이라면 댓글 업데이트 중지
                out.print("답글이 존재합니다.");
            } else {
            	 if (psmt != null) psmt.close();
                // 그렇지 않으면 댓글 업데이트 진행
                String updateCommentSql = "UPDATE comment SET delyn = 'Y' WHERE comment_id = ?";
                psmt = conn.prepareStatement(updateCommentSql);
                psmt.setInt(1, commentId);

                int result = psmt.executeUpdate();

                if (result > 0) {
                    out.print("SUCCESS");
                } else {
                    out.print("댓글 업데이트 실패");
                }
            }
        } else {
            if (psmt != null) psmt.close();
            // 처음 댓글을 달았을 때 바로 삭제 
            String updateCommentSql = "UPDATE comment SET delyn = 'Y' WHERE comment_id = ?";
            psmt = conn.prepareStatement(updateCommentSql);
            psmt.setInt(1, commentId);

            int result = psmt.executeUpdate();

            if (result > 0) {
                out.print("SUCCESS");
            } else {
                out.print("댓글 삭제 실패");
            }
        }
    } catch (ClassNotFoundException | SQLException e) {
        out.print("데이터베이스 오류: " + e.getMessage());
    } finally {
        try {
            if (resultSet != null) resultSet.close();
            if (psmt != null) psmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
