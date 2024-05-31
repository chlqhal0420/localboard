<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="local.vo.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page errorPage="errorPage.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

	 
String directory = "D:\\workspaceBom\\local_project\\src\\main\\webapp\\upload";
    int sizeLimit = 100 * 1024 * 1024; // 100mb 제한
	String path_files = directory.split("webapp")[1]; 

	
    MultipartRequest multi = new MultipartRequest(request, directory, sizeLimit, "UTF-8", new DefaultFileRenamePolicy());

    Member member = (Member) session.getAttribute("login");

    String method = request.getMethod();
	if (method.equals("GET") || member == null) {
        response.sendRedirect("list.jsp");
    }

	//넘어온 게시글번호
	int lbId=0;
	if (multi.getParameter("lb_id") != null && !multi.getParameter("lb_id").equals("")) {
		lbId = Integer.parseInt(multi.getParameter("lb_id"));
	}
	
	//ReviewVO에 넘어온 파라미터를 담기
    Review review = new Review();
    review.setContent(multi.getParameter("content"));
    review.setLbId(lbId);
   	review.setMemberId(member.getMemberId());
    
    Connection conn = null;
    PreparedStatement psmt = null;
    ResultSet rs = null;

 	/* String url = "jdbc:mysql://192.168.0.88:3306/localboard";  */
 	String url = "jdbc:mysql://localhost:3306/localboard"; 
    String user = "cteam";
    String pass = "1234";

    int fileId = 0;
    int result = 0;
    int reviewId =0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
        
    	Enumeration fileNames= multi.getFileNames();
    	
    	int count = 0;
    	
		while(fileNames.hasMoreElements()){
			String parameter=(String)fileNames.nextElement();
			//업로드 된 실제 파일명
			String realFileNM = multi.getFilesystemName(parameter);
			
			//원본 파일명
			String originFileNM = multi.getOriginalFileName(parameter);
			
			if(originFileNM==null) continue;
      
        
	        if(realFileNM != null && originFileNM != null){  // 첨부파일 null 이면 DB 저장하지 않음!
	        	 String sql="";
	        	 
	        	if(count == 0){
        		    sql = "INSERT INTO board_file(created_by, created_at, created_ip, modified_at, modified_by, modified_ip) "
        		    		+ " VALUES(?, now(), ? , now(), ?, ?) ";
        	        psmt = conn.prepareStatement(sql);

        	        psmt.setInt(1, review.getMemberId()); // 현재 접속한 회원 ID를 가져옴!
        	        psmt.setString(2, request.getRemoteAddr());
        	        psmt.setInt(3, review.getMemberId()); // 수정한 회원 ID로 변경
        	        psmt.setString(4, request.getRemoteAddr());// 수정한 사람 IP로 변경
					
        	        psmt.executeUpdate();

        	        if (psmt != null) psmt.close();

        	        sql = "select max(file_id) as file_id from board_file";
        	        psmt = conn.prepareStatement(sql);

        	       	rs = psmt.executeQuery();
        	        if (rs.next()) {
        	            fileId = rs.getInt("file_id");
        	        }
					count++;
				}
	        	
	        if (psmt != null) psmt.close();
	        if (rs != null) rs.close();
	
	        
	        sql = "INSERT INTO board_file_detail (file_id, file_real_nm, file_origin_nm, file_thumbnail_nm, file_extention, file_size) VALUES (?, ?, ?, ?, '', 0)";
	        psmt = conn.prepareStatement(sql);
	
	        psmt.setInt(1, fileId);
	        psmt.setString(2, realFileNM);
	        psmt.setString(3, originFileNM);
	        psmt.setString(4, path_files);
	        psmt.executeUpdate();
	        
        	}
	        if (psmt != null) psmt.close();
		}
        
        if (psmt != null) psmt.close();

        String sql="";
		if(fileId!=0){
			sql = "INSERT INTO review(lb_id, file_id, created_by, created_at, created_ip, content )"
   			+" VALUES(?, ?, ?, now(), ?, ? )";
       
    	psmt = conn.prepareStatement(sql);
    	psmt.setInt(1,review.getLbId()); 
    	psmt.setInt(2,fileId);
    	psmt.setInt(3,review.getMemberId());
        psmt.setString(4, request.getRemoteAddr());
        psmt.setString(5, review.getContent());// 수정한 사람 IP로 변경 
        
		}else{
			sql = "INSERT INTO review(lb_id, created_by, created_at, created_ip, content )"
		   			+" VALUES(?, ?, now(), ?, ? )";
		       
		    	psmt = conn.prepareStatement(sql);
		    	psmt.setInt(1,review.getLbId()); // 현재 접속한 회원 ID를 가져옴!
		    	psmt.setInt(2,review.getMemberId());
		        psmt.setString(3, request.getRemoteAddr());
		        psmt.setString(4, review.getContent());// 수정한 사람 IP로 변경 
		           
		}
		
		result= psmt.executeUpdate();
		
		
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (conn != null) conn.close();
            if (psmt != null) psmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    if (result > 0) {
%>
<script>
        alert("후기가 등록되었습니다.");
        location.href ="<%=request.getContextPath()%>/company_board/view.jsp?board_id=<%=lbId%>";
    </script>
<%
    } else {
%>
<script>
        alert("후기가 등록되지 않았습니다.");
        location.href ="<%=request.getContextPath()%>/company_board/view.jsp?board_id=<%=lbId%>";
    </script>
<%
    }
%>