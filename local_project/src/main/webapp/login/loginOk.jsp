<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="local.vo.Member" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.math.BigInteger" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement psmt = null;
    ResultSet rs = null;
    String url = "jdbc:mysql://localhost:3306/localboard";
    String user = "cteam";
    String pass = "1234";

    boolean isLogin = false;

    Member member = null;
    int reportCount = 0; // 신고 횟수 조회
    String boardReportStatus = "";
    String boardCode = "";
    int boardId = 0;
    String commentBoardCode = "";
    int commentBoardId = 0;
    String commentStatus = "";
    String  campanyStatus = "";
    int campanyLbId = 0;
    int cbLbId = 0;
    String cbStatus = "";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);

        // 1. 사용자의 salt를 DB에서 가져옴
        String getSaltQuery = "SELECT salt FROM member WHERE email=?";
        psmt = conn.prepareStatement(getSaltQuery);
        psmt.setString(1, email);
        rs = psmt.executeQuery();

        String salt = null;

        if (rs.next()) {
            salt = rs.getString("salt");
        }
        
        
        if(rs != null) rs.close();
		if(psmt != null) psmt.close();
		
        if (salt != null) {
        	rs =  null;
            // 2. 입력받은 비밀번호와 DB에서 가져온 salt를 사용하여 해싱
            String hashedPassword = hashPassword(password, salt);
			System.out.println(hashedPassword);
            // 3. 로그인을 위한 쿼리 수행
            String loginQuery = " SELECT email, nicknm, member_Id, code_Id, status, created_at, member_id, code_id, stop_start_date, stop_end_date "
                              + " FROM member WHERE email=? AND password=?";
            psmt = conn.prepareStatement(loginQuery);
            psmt.setString(1, email);
            psmt.setString(2, hashedPassword);
            rs = psmt.executeQuery();

            if (rs.next()) {
                member = new Member();
                member.setMemberId(rs.getInt("member_Id"));
                member.setEmail(rs.getString("email"));
                member.setNicknm(rs.getString("nicknm"));
                member.setCodeId(rs.getString("code_Id").charAt(0));
                member.setStatus(rs.getString("status"));
                member.setCreatedAt(rs.getString("created_at"));
                member.setStopStartDate(rs.getString("stop_start_date"));
                member.setStopEndDate(rs.getString("stop_end_date"));

                // 4. 세션에 로그인 정보 저장
                /* session.setAttribute("login", member);
                isLogin = true; */
            }
        }
        
        if (psmt != null)
            psmt.close();
        if (rs != null)
            rs.close();

        // 현재 로그인한 회원의 신고 게시글, 신고 댓글 총 개수 업데이트
        String updateSql = " UPDATE member m "
           				 + " SET m.report_count = ( "
           				 + "    SELECT COUNT(*) "
           				 + "    FROM comment_report cr " // 신고 댓글
           				 + "    WHERE cr.created_by = m.member_id " 
           				 + " ) "  
           				 + " + ( "  
           				 + "    SELECT COUNT(*) "
           				 + "    FROM board_report br "  // 신고 게시글
           				 + "    WHERE br.modified_by = m.member_id "  
           				 + " ) "   
           				 + " + ( "  
           				 + "    SELECT COUNT(*) "
           				 + "    FROM review_report rr "  // 신고 후기 
           				 + "    WHERE rr.created_by = m.member_id "       				 
 						 + " ) " 
           				 + " WHERE m.member_id = ? ";

        psmt = conn.prepareStatement(updateSql);
        psmt.setInt(1, member.getMemberId());
        psmt.executeUpdate();

        // 현재 로그인한 회원의 신고된 횟수가 n번 이상이면 경고창 띄우기
        String warningsCountSql = "SELECT report_count FROM member WHERE member_id = ? ";

        psmt = conn.prepareStatement(warningsCountSql);
        psmt.setInt(1, member.getMemberId());
        rs = psmt.executeQuery();
        if (rs.next()){
            reportCount = rs.getInt("report_count");       
        }
        
        // 신고 게시글 경고 주기
        String boardWarning = " SELECT status, board_code, board_id "
        					+ " FROM board_report "
        					+ " WHERE modified_by = ? "
        					+ " ORDER BY created_at DESC "; // 신고 게시글 최신순 검색!
        psmt = conn.prepareStatement(boardWarning);
        psmt.setInt(1, member.getMemberId());
        rs = psmt.executeQuery();
        
        if (rs.next()){
            boardReportStatus = rs.getString("status"); // 신고 게시글 처리상태      
            boardCode = rs.getString("board_code");  	// 신고 게시글 코드     
            boardId = rs.getInt("board_id");   			// 신고 게시글 번호        
        }
        
        // 신고 댓글 경고 주기
        String commentWarning = " SELECT c.board_code, c.board_id, cr.status "
        					  + " FROM comment c "
        					  + " JOIN comment_report cr ON c.comment_id = cr.comment_id "
        			     	  + " WHERE c.created_by = ? "
       					      + " ORDER BY cr.created_at DESC "; // 신고 댓글 최신순 검색!
        
        psmt = conn.prepareStatement(commentWarning);
        psmt.setInt(1, member.getMemberId());
        rs = psmt.executeQuery();
        
        if (rs.next()){
            commentBoardCode = rs.getString("board_code"); 		// 신고 댓글에 속한 게시글 코드   
            commentBoardId = rs.getInt("board_id");  			// 신고 댓글에 속한 게시글 번호    
            commentStatus = rs.getString("status");   			// 신고 댓글 처리 상태 
        }
        
        
        // 동네업체 후기 경고 주기
        String companyWarning = " SELECT rr.status, r.lb_id "
        					  + " FROM review r "
        					  + " JOIN review_report rr ON r.review_id = rr.review_id "
        	   				  + "	WHERE r.created_by = ? "
        	   				  + " ORDER BY rr.created_at DESC;";
        	   				  
        psmt = conn.prepareStatement(companyWarning);
        psmt.setInt(1, member.getMemberId());
        rs = psmt.executeQuery();
        
        if (rs.next()){
        	campanyStatus = rs.getString("status");  // 후기 처리 상태
        	campanyLbId = rs.getInt("lb_id");		// 후기 게시글 번호
        }
        
        // 동네업체 게시글 경고 주기
        String campanyboardWarning = "SELECT lb_id, status FROM local_report WHERE created_by = ? ;";
        
        psmt = conn.prepareStatement(campanyboardWarning);
        psmt.setInt(1, member.getMemberId());
        rs = psmt.executeQuery();
        
        if(rs.next()){
        	cbLbId = rs.getInt("lb_id");
        	cbStatus = rs.getString("status");
        }
        
        
        

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (conn != null) conn.close();
            if (psmt != null) psmt.close();
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

  //member가 null인 경우, 즉 아이디와 비밀번호가 일치하지 않는 경우
    if (member == null) {
    %>
    <script>
     alert("아이디와 비밀번호를 확인하세요.");
     location.href="login.jsp";
    </script>
    <%
    } else {
    	// 게시글 신고를 받은 회원에게 경고 메세지 전달
    	if (boardReportStatus != null && boardReportStatus.equals("경고")) {
    	    %>
    	    <script>
    	        // JavaScript를 사용하여 경고 메시지를 alert로 표시
    	        alert("게시글 '<%=boardCode%>'의 번호 '<%=boardId%>'에 대한 신고가 접수 되었습니다. 수정해주세요!");
    	    </script>
    	<%
    	}
    	
    	// 댓글 신고를 받은 회원에게 경고 메세지 전달
    	if(commentStatus != null && commentStatus.equals("경고")) {
    		 %>
     	    <script>
     	        // JavaScript를 사용하여 경고 메시지를 alert로 표시
     	        alert("게시글 '<%=commentBoardCode%>'의 번호 '<%=commentBoardId%>'에 대한 댓글 신고가 접수 되었습니다. 수정해주세요!");
     	    </script>
     	<%
    	}
		
    	// 후기 신고를 받은 회원에게 경고 메세지 전달
    	if (campanyStatus != null && campanyStatus.equals("경고")){
    		 %>
    		<script>
 	        // JavaScript를 사용하여 경고 메시지를 alert로 표시
 	        alert("동네업체 게시글의 번호 '<%=campanyLbId%>'에 대한 후기 신고가 접수 되었습니다. 수정해주세요!");
 	    </script>
 	    <%
    	}
    	
    	// 동네업체 게시글 신고를 받은 회원에게 경고 메세지 전달
    	if(cbStatus != null && cbStatus.equals("경고")){
    		 %>
     		<script>
  	        // JavaScript를 사용하여 경고 메시지를 alert로 표시
  	        alert("동네업체 게시글의 번호 '<%=cbLbId%>'에 대한 신고가 접수 되었습니다. 수정해주세요!");
  	    </script>
  	    <%	
    		
    	}
    	
    		
     // 임계값 설정
     int warningThreshold = 6; // 예시: n회 이상 신고를 받으면 경고 메시지 표시

     // 경고 횟수에 따라 메시지 설정
     if (reportCount >= warningThreshold) {
    %>
    <script>
     // JavaScript를 사용하여 경고 메시지를 alert로 표시
     alert("경고: 사용자님, 현재까지 <%= reportCount %>회의 신고를 받으셨습니다. 주의해주세요!");
    </script>
    <%
     }
     

     // member의 회원 상태에 따라 로그인 처리를 분기
     if (member.getStatus().equals("quit")) { // 탈퇴한 회원
    %>
    <script>
     alert("탈퇴한 계정은 이용할 수 없습니다.");
     location.href="<%=request.getContextPath()%>/index.jsp";
    </script>
    <%
     } else if (member.getStatus().equals("active")) {
         // 정지 시작일과 종료일이 설정된 경우
         if (member.getStopStartDate() != null && member.getStopEndDate() != null) {
             Date currentDate = new Date();
             SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
             String formattedCurrentDate = sdf.format(currentDate);

             // 현재 날짜가 정지 기간에 속하는지 확인
             if (formattedCurrentDate.compareTo(member.getStopStartDate()) >= 0 && formattedCurrentDate.compareTo(member.getStopEndDate()) <= 0) {
    %>
    <script>
     alert("계정이 <%=member.getStopStartDate()%>부터 <%=member.getStopEndDate()%>까지 정지되었습니다.");
     location.href="<%=request.getContextPath()%>/index.jsp";
    </script>
    <%
             } else {
                 // 정지 기간이 아니므로 로그인을 허용합니다.
                 session.setAttribute("login", member);
    %>
    <script>
     alert("로그인 되었습니다");
     location.href="<%=request.getContextPath()%>/index.jsp";
    </script>
    <%
             }
         } else {
             // 정지 시작일 또는 종료일이 지정되지 않았으므로 로그인을 진행합니다.
             session.setAttribute("login", member);
    %>
    <script>
     alert("로그인 되었습니다");
     location.href="<%=request.getContextPath()%>/index.jsp";
    </script>
    <%
         }
     } else if (member.getStatus().equals("stop")) {  // 정지된 회원
    %>
    <script>
     alert("계정이 정지되었습니다.");
     location.href="<%=request.getContextPath()%>/index.jsp";
    </script>
    <%
     } else {
    %>
    <script>
     alert("계정 인증정보에 오류가 발생했습니다. 다른 계정으로 로그인하세요.")
     location.href = "login.jsp";
    </script>
    <%
     }
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

            while (hashedPassword.length() < 32) {
                hashedPassword = "0" + hashedPassword;
            }

            return hashedPassword;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
%>
