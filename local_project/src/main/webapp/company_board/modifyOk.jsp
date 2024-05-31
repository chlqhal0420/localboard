<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="local.vo.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.*"%>
<%@ page errorPage="errorPage.jsp" %>	


<%
    request.setCharacterEncoding("UTF-8");
	//업로드된 파일이 저장될 디렉토리 경로를 지정
/* 	String directory = "C:\\Users\\MYCOM\\git\\local-project\\local-project\\src\\main\\webapp\\upload";  */
	String directory = "D:\\workspaceBom\\local_project\\src\\main\\webapp\\upload";
    int sizeLimit = 100 * 1024 * 1024; // 100mb 제한
	String path_files = directory.split("webapp")[1]; 
	System.out.println("path_files : " + path_files);
	
    MultipartRequest multi = new MultipartRequest(request, directory, sizeLimit, "UTF-8", new DefaultFileRenamePolicy());

    Member member = (Member) session.getAttribute("login");
    int member_id =0;
	if(member != null){
		member_id = member.getMemberId();
		}

    //get방식으로 넘어온 경우 차단
    String method = request.getMethod();

    if (method.equals("GET") || member == null) {
        response.sendRedirect("list.jsp");
    }
	//게시글에 해당하는 파라미터
    LocalBoard board = new LocalBoard();
    board.setTitle(multi.getParameter("title"));
    board.setContent(multi.getParameter("content"));
    board.setPostCode(multi.getParameter("postCode"));
    board.setAddr(multi.getParameter("addr"));
    board.setAddrDetail(multi.getParameter("addrDetail"));
    board.setLocalExtra(multi.getParameter("localExtra"));
    
    int lbId=0;
 	if(multi.getParameter("lb_id")!=null && !multi.getParameter("lb_id").equals("")){
 		lbId= Integer.parseInt(multi.getParameter("lb_id"));
 	}
	board.setLbId(lbId);
	
	
    Connection conn = null;
    PreparedStatement psmt = null;
    ResultSet rs = null;
    
    String url = "jdbc:mysql://localhost:3306/localboard";
    String user = "cteam";
    String pass = "1234";

    // 현재 삽입된 등록한 회원 ID 기본키(memberId)값을 조회하세요.
    int result = 0;
	int file_id=0;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
			
        String sql = "UPDATE local_board        "
				   + "   SET title   = ? "
				   + "     , content = ? "
					+ "     , local_extra = ? "
					+ "     , post_code = ? "
					+ "     , addr = ? "
					+ "     , addr_detail = ? "
				  + "      , modified_by = ? "	   
				  + "       , modified_ip = ? "	   
				   + "     , modified_at = now() "// 자유게시글 수정시간
				   + " WHERE lb_id = ? "; 
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, board.getTitle());
		psmt.setString(2, board.getContent());
		psmt.setString(3, board.getLocalExtra());
		psmt.setString(4, board.getPostCode());
		psmt.setString(5, board.getAddr());
		psmt.setString(6, board.getAddrDetail());
		psmt.setInt(7, member_id); // 수정한 회원 ID로 변경
	    psmt.setString(8, request.getRemoteAddr()); // 수정한 사람 IP로 변경
		psmt.setInt(9, lbId);
		
		
		result = psmt.executeUpdate();
        
		//--------------- 게시글에 해당하는 파일 id 조회해오기-----
		
		if (psmt != null) psmt.close();
		 sql= " SELECT file_id FROM local_board WHERE lb_id = ? ";
		 
		 psmt = conn.prepareStatement(sql);
		 psmt.setInt(1, lbId);
		 rs = psmt.executeQuery();	
		 
		 if(rs.next()){
			file_id= rs.getInt("file_id");
		 }

	     //------------------------새로 추가된 파일만 등록 ----------------------
	     
	     
	    	Enumeration fileNames= multi.getFileNames();
			while(fileNames.hasMoreElements()){
				String parameter=(String)fileNames.nextElement();
				//업로드 된 실제 파일명
				String realFileNM = multi.getFilesystemName(parameter);
				//원본 파일명
				String originFileNM = multi.getOriginalFileName(parameter);
				if(originFileNM==null) continue;
	      
	        
		        if(realFileNM != null && originFileNM != null){  // 첨부파일 null 이면 DB 저장하지 않음!
			        sql = "INSERT INTO board_file_detail (file_id, file_real_nm, file_origin_nm, file_thumbnail_nm, file_extention, file_size) VALUES (?, ?, ?, ?, '', 0)";
			        psmt = conn.prepareStatement(sql);
			
			        psmt.setInt(1, file_id);
			        psmt.setString(2, realFileNM);
			        psmt.setString(3, originFileNM);
			        psmt.setString(4, path_files);
			        psmt.executeUpdate();
			        
			        if (psmt != null) psmt.close();
	        	}
		       
		        
		        
		        //--------------------새로 등록된 파일이 있다면 board_file에서도 수정된 정보로 변경하기 
				 
				  if(realFileNM != null && originFileNM != null){
						  
					 sql=" Update board_file "
						+" SET modified_by = ? " 
						+" , modified_ip = ?  "
						+" , modified_at = now() "
						+" WHERE file_id = ? ";
					 
					 psmt = conn.prepareStatement(sql);
					 psmt.setInt(1, member_id); // 수정한 회원 ID로 변경
				     psmt.setString(2, request.getRemoteAddr()); // 수정한 사람 IP로 변경
				     psmt.setInt(3, file_id);
				     psmt.executeUpdate();

			     if (psmt != null) psmt.close();
		        
		        }
        
			}
        
        
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
        alert("게시글이 수정되었습니다.");
        location.href ="<%=request.getContextPath()%>/company_board/view.jsp?board_id=<%=lbId%>";
    </script>
<%
    } else {
%>
<script>
        alert("게시글이 수정되지 않았습니다.");
        location.href ="<%=request.getContextPath()%>/company_board/view.jsp?board_id=<%=lbId%>";
    </script>
<%
    }
%>