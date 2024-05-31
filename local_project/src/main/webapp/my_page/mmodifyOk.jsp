<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.math.BigInteger" %>
<%
    request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="member" class="local.vo.Member" scope="page" />
<jsp:setProperty name="member" property="*" />

<%
    if (member != null) {
        System.out.println(member.toString());
    }

    Connection conn = null;
    PreparedStatement psmt = null;
    ResultSet rs = null;
    int result = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/localboard";
        String user = "cteam";
        String pass = "1234";
        conn = DriverManager.getConnection(url, user, pass);

        // 1. 사용자의 Salt를 DB에서 가져옴
        String getSaltQuery = "SELECT salt FROM member WHERE member_id=?";
        psmt = conn.prepareStatement(getSaltQuery);
        psmt.setInt(1, member.getMemberId());
        rs = psmt.executeQuery();

        String salt = null;

        if (rs.next()) {
            salt = rs.getString("salt");
        }
        if(psmt != null) psmt.close();
        
        // 2. 새로운 비밀번호를 가져오는 부분
        String newPassword = member.getPassword();
		
        // 3. 가져온 Salt를 이용하여 비밀번호를 해시화
        if (salt != null && newPassword != null && !newPassword.isEmpty()) {
            String hashedPassword = hashPassword(newPassword, salt);

            // 4. 회원 정보 업데이트 쿼리
            String updateQuery = "UPDATE member "
                               + "   SET password = ? "
                               + "     , phone = ? "
                               + "     , nicknm = ? "
                               + " WHERE member_id = ? ";

            psmt = conn.prepareStatement(updateQuery);

            psmt.setString(1, hashedPassword);
            psmt.setString(2, member.getPhone());
            psmt.setString(3, member.getNicknm());
            psmt.setInt(4, member.getMemberId());

            System.out.println("New hashed password: " + hashedPassword);

            result = psmt.executeUpdate();
        }
    } catch (Exception e) {
        e.printStackTrace();

        // 예외 메시지를 로그에 기록
        try {
            javax.servlet.ServletContext context = application.getContext("/");
            java.io.File logfile = new java.io.File(context.getRealPath("/WEB-INF/logs"), "your_log_file.log");
            java.io.PrintWriter log = new java.io.PrintWriter(new java.io.FileWriter(logfile, true));
            log.println("Exception in mmodifyOk.jsp: " + e.getMessage());
            e.printStackTrace(log);
            log.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    } finally {
        try {
            if (rs != null) rs.close();
            if (psmt != null) psmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    if (result > 0) {
%>
    <script>
        alert("수정이 완료되었습니다.");
        location.href="myPageList.jsp?memberId=<%=member.getMemberId() %>";
    </script>
<%
    } else {
%>
    <script>
        alert("수정이 완료되지 않았습니다.");
        location.href="myPageList.jsp?memberId=<%=member.getMemberId() %>";
    </script>
<%
    }
%>

<%!
    private String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");

            // 비밀번호에 salt 추가
            String passwordWithSalt = password + salt;
            byte[] bytes = md.digest(passwordWithSalt.getBytes());
            BigInteger bigInt = new BigInteger(1, bytes);
            String hashedPassword = bigInt.toString(16);

            // 32자리가 되지 않을 경우 앞에 0을 채워줌
            while (hashedPassword.length() < 32) {
                hashedPassword = "0" + hashedPassword;
            }

            return hashedPassword;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            // 예외 처리 - 적절한 방식으로 처리하세요.
            return null;
        }
    }
%>
