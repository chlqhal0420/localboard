<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page errorPage="errorPage.jsp" %>
<%
    String reviewIdParam = request.getParameter("reviewId");
%>




<%
    int reviewId = 0;
    if (reviewIdParam != null && !reviewIdParam.equals("")) {
    	reviewId = Integer.parseInt(reviewIdParam);
    }

    Connection conn = null;
    PreparedStatement psmt = null;
    String url = "jdbc:mysql://localhost:3306/localboard";
    String user = "cteam";
    String pass = "1234";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);

        String sql = "UPDATE review SET delyn = 'Y' WHERE review_id = ?";
        psmt = conn.prepareStatement(sql);
        psmt.setInt(1, reviewId);

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
