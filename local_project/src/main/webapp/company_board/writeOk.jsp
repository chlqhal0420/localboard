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

	/* String directory = "C:\\Users\\MYCOM\\git\\local-project\\local-project\\src\\main\\webapp\\upload";  */
	String directory = "D:\\workspaceBom\\local_project\\src\\main\\webapp\\upload";
    int sizeLimit = 100 * 1024 * 1024; // 100mb 제한
	String path_files = directory.split("webapp")[1]; 
	System.out.println("path_files : " + path_files);
	
    MultipartRequest multi = new MultipartRequest(request, directory, sizeLimit, "UTF-8", new DefaultFileRenamePolicy());

    Member member = (Member) session.getAttribute("login");

    String method = request.getMethod();
	if (method.equals("GET") || member == null) {
        response.sendRedirect("list.jsp");
    }

    Board board = new Board();
    board.setTitle(multi.getParameter("title"));
    board.setContent(multi.getParameter("content"));
    
    /* 입력한 업체 정보를 받아옴 */
    String local_extra = multi.getParameter("local_extra");
    String post_code = multi.getParameter("post_code");    
    String addr = multi.getParameter("addr");
    String addr_detail = multi.getParameter("addr_detail");
    
    String member_idParam = request.getParameter("member_id");
    int member_id = 0;
    if (member_idParam != null && !member_idParam.equals("")) {
       member_id = Integer.parseInt(member_idParam);
    }


    Connection conn = null;
    PreparedStatement psmt = null;
    String url = "jdbc:mysql://localhost:3306/localboard";
    String user = "cteam";
    String pass = "1234";

   
    int result = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);



        String sql = "INSERT INTO board_file(created_by, created_at, created_ip, modified_at, modified_by, modified_ip) VALUES(?, now(), ? , now(), ?, ?)";
        psmt = conn.prepareStatement(sql);

        psmt.setInt(1, member_id); // 현재 접속한 회원 ID를 가져옴!
        psmt.setString(2, request.getRemoteAddr());
        psmt.setInt(3, member_id); // 수정한 회원 ID로 변경
        psmt.setString(4, request.getRemoteAddr());// 수정한 사람 IP로 변경

        psmt.executeUpdate();

        if (psmt != null) psmt.close();

        sql = "select max(file_id) as file_id from board_file";
        psmt = conn.prepareStatement(sql);

        ResultSet rs1 = psmt.executeQuery();

        int fileId = 0;
        if (rs1.next()) {
            fileId = rs1.getInt("file_id");
        }
		
        
    	Enumeration fileNames= multi.getFileNames();
		while(fileNames.hasMoreElements()){
			String parameter=(String)fileNames.nextElement();
			//업로드 된 실제 파일명
			String realFileNM = multi.getFilesystemName(parameter);
			System.out.println("realFileNM:"+ realFileNM);
			//원본 파일명
			String originFileNM = multi.getOriginalFileName(parameter);
			System.out.println(originFileNM);
			if(originFileNM==null) continue;
      
        
	        if(realFileNM != null && originFileNM != null){  // 첨부파일 null 이면 DB 저장하지 않음!
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

        String ipAddress = request.getRemoteAddr();

        sql = "INSERT INTO local_board "
        		+" ( title, content, local_id, file_id, created_ip, created_by, created_at "
        		+" , modified_by, modified_ip, modified_at "
        		+" , local_extra, post_code, addr, addr_detail ) "
        		+" VALUES(?, ?, 'JJ', ?, ?, ?, now(), ?, ? , now() , ? , ? , ? , ? ) ";
        psmt = conn.prepareStatement(sql);

        psmt.setString(1, board.getTitle());
        psmt.setString(2, board.getContent());
        psmt.setInt(3, fileId);
        psmt.setString(4, ipAddress);
        psmt.setInt(5, member_id);
        psmt.setInt(6, member_id);
        psmt.setString(7, ipAddress);
        psmt.setString(8, local_extra);
        psmt.setString(9, post_code);
        psmt.setString(10, addr);
        psmt.setString(11, addr_detail);
        result = psmt.executeUpdate();

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
        alert("게시글이 등록되었습니다.");
        location.href = "list.jsp";
    </script>
<%
    } else {
%>
<script>
        alert("게시글이 등록되지 않았습니다.");
        location.href = "list.jsp";
    </script>
<%
    }
%>