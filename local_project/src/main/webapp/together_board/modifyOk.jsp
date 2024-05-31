<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="local.vo.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%
	request.setCharacterEncoding("UTF-8");

	String method = request.getMethod();
	if(method.equals("GET")){
	%>
		<script>
			alert("잘못된 접근입니다.");
			location.href='list.jsp';
		</script>
	<%
	}
	
	// 업로드된 파일이 저장될 디렉토리 경로를 지정합니다. 이 경로는 프로젝트의 실제 파일 시스템 경로입니다.
		String directory = "D:\\workspaceBom\\local_project\\src\\main\\webapp\\upload";
		int sizeLimit = 100*1024*1024;//100mb 제한

		MultipartRequest multi = new MultipartRequest(request 	// 클라이언트의 HTTP 요청 객체입니다.
											, directory			// 파일이 저장될 디렉토리 경로입니다.
											, sizeLimit			// 업로드할 파일의 최대 크기 제한입니다.
											, "UTF-8"			// 요청 및 파일 업로드시 사용할 문자 인코딩 방식을 설정합니다.
											, new DefaultFileRenamePolicy()); // 파일명 중복 시 새로운 파일명을 부여하는 정책을 설정합니다. 여기서는 기본 정책을 사용하고 있습니다.
		

	
	Board board = new Board();
	board.setTitle(multi.getParameter("title"));
	board.setContent(multi.getParameter("content"));
	
	
	int boardId=0;
 	if(multi.getParameter("board_id")!=null && !multi.getParameter("board_id").equals("")){
 		boardId= Integer.parseInt(multi.getParameter("board_id"));
 	}
	board.setBoardId(boardId);
 	
 	%>

	<%
	BoardFileDetail bf = new BoardFileDetail();
	
	
	//첨부파일 삭제하기 위해 bfno 가져옴 
	String fileOrdParam = multi.getParameter("file_ord");
	int fileOrd=0;
	if(multi.getParameter("file_ord")!=null && !multi.getParameter("file_ord").equals("")){
		fileOrd = Integer.parseInt(multi.getParameter("file_ord"));
	}
	
	
	Connection conn = null;
	PreparedStatement psmt= null;
	String url = "jdbc:mysql://localhost:3306/localboard";
	String user = "cteam";
	String pass = "1234";
	
	

	int result = 0;
	try{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "UPDATE board        "
				   + "   SET title   = ? "
				   + "     , content = ? "
				   + "     , modified_at = now() "   // 자유게시글 수정시간
				   + " WHERE board_id = ? "; 
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, board.getTitle());
		psmt.setString(2, board.getContent());
		psmt.setInt(3, boardId);
		
		
		result = psmt.executeUpdate();
		
		
		//-------------------기존 파일 삭제하기 ----------------------
		
		if(psmt != null) psmt.close();
		
		 sql = "DELETE FROM board_file_detail WHERE file_ord = ?";
		
		 psmt = conn.prepareStatement(sql);
		 psmt.setInt(1,fileOrd);
			
		 psmt.executeUpdate();
		

		//------------------- 새로운 파일 등록하기 ----------------------
		
		if(psmt != null) psmt.close();
		

	        sql = "select max(file_id) as file_id from board_file";
	        psmt = conn.prepareStatement(sql);

	        ResultSet rs1 = psmt.executeQuery();

	        int fileId = 0;
	        if (rs1.next()) {
	            fileId = rs1.getInt("file_id");
	        }
		
		//업로드 된 실제 파일명
		String realFileNM = multi.getFilesystemName("uploadFile");
		
		//원본 파일명
		String originFileNM = multi.getOriginalFileName("uploadFile");
		
		if(realFileNM != null && originFileNM != null){
			
		
		sql = "INSERT INTO "
			+ "  board_file_detail (file_id"
			+"			 , file_real_nm"
			+"			 , file_origin_nm"
			+"			 , file_extention"
			+"			 , file_size)"
			+"	VALUES( ?, ?, ?, '', 0)";
		
		psmt = conn.prepareStatement(sql);
		
		psmt.setInt(1,fileId);
		psmt.setString(2,realFileNM);
		psmt.setString(3,originFileNM);
		
		psmt.executeUpdate();		
		
		}
		

	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
	}

	if(result>0){
		%>
		<script>
			alert("수정되었습니다.");
			location.href='view.jsp?board_id=<%=boardId%>';
		</script>
		<%
	}else{
		%>
		<script>
			alert("수정되지 않았습니다.");
			location.href='view.jsp?board_id=<%=boardId%>';
		</script>
		<%
	}
%>