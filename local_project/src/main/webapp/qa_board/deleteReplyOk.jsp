<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
    String replyIdParam = request.getParameter("replyId");
%>

<jsp:useBean id="reply" class="local.vo.Reply" />
<jsp:setProperty name="reply" property="*" />

<%
    int replyId = 0;
    if (replyIdParam != null && !replyIdParam.equals("")) {
        replyId = Integer.parseInt(replyIdParam);
    }

    Connection conn = null;
    PreparedStatement psmt = null;
    String url = "jdbc:mysql://localhost:3306/localboard";
    String user = "cteam";
    String pass = "1234";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);

        String sql = "UPDATE reply SET delyn = 'Y' WHERE reply_id = ?";
        psmt = conn.prepareStatement(sql);
        psmt.setInt(1, replyId);

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
