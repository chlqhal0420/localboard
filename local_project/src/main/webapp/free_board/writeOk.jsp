<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="local.vo.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<%
    request.setCharacterEncoding("UTF-8");

	String directory =  "D:\\workspaceBom\\local_project\\src\\main\\webapp\\upload";

    int sizeLimit = 100 * 1024 * 1024; // 100mb 제한

    MultipartRequest multi = new MultipartRequest(request, directory, sizeLimit, "UTF-8", new DefaultFileRenamePolicy());

    Member member = (Member) session.getAttribute("login");
  
    String method = request.getMethod();

    if (method.equals("GET") || member == null) {
        response.sendRedirect("list.jsp");
    }

    Board board = new Board();
    
    BoardFile boardfile = new BoardFile();
    
    board.setTitle(multi.getParameter("title"));
    board.setContent(multi.getParameter("content"));
    
    
    String memberIdParam = request.getParameter("member_id");

    int memberId = 0;
    if (memberIdParam != null && !memberIdParam.equals("")) {
    	memberId = Integer.parseInt(memberIdParam);
    }


    Connection conn = null;
    PreparedStatement psmt = null;
    String url = "jdbc:mysql://localhost:3306/localboard";
    String user = "cteam";
    String pass = "1234";

    // 현재 삽입된 등록한 회원 ID 기본키(memberId)값을 조회하세요.
    int result = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);



        String sql = "INSERT INTO board_file(created_by, created_at, created_ip, modified_at, modified_by, modified_ip) VALUES(?, now(), 'test', now(), ?, ?)";
        psmt = conn.prepareStatement(sql);

        psmt.setInt(1, memberId); // 현재 접속한 회원 ID를 가져옴!
        psmt.setInt(2, memberId); // 수정한 회원 ID로 변경
        psmt.setString(3, request.getRemoteAddr()); // 수정한 사람 IP로 변경

        psmt.executeUpdate();

        if (psmt != null) psmt.close();

        sql = "select max(file_id) as file_id from board_file";
        psmt = conn.prepareStatement(sql);

        ResultSet rs1 = psmt.executeQuery();

        int fileId = 0;
        if (rs1.next()) {
            fileId = rs1.getInt("file_id");
        }

        String realFileNM = multi.getFilesystemName("uploadFile");
        String originFileNM = multi.getOriginalFileName("uploadFile");
      
        
        if(realFileNM != null && originFileNM != null){  // 첨부파일 null 이면 DB 저장하지 않음!
        sql = "INSERT INTO board_file_detail (file_id, file_real_nm, file_origin_nm, file_extention, file_size) VALUES (?, ?, ?, '', 0)";
        psmt = conn.prepareStatement(sql);

        psmt.setInt(1, fileId);
        psmt.setString(2, realFileNM);
        psmt.setString(3, originFileNM);

        psmt.executeUpdate();
        }
        
        if (psmt != null) psmt.close();

		
        String ipAddress = request.getRemoteAddr();
        System.out.println("ipAddress: " + ipAddress);
        
  
       
        sql = "INSERT INTO board(title, content, type, file_id, created_ip, created_by, created_at, modified_by, modified_ip, modified_at) VALUES(?, ?, 'F', ?, ?, ?, now(), ?, 'TEST', now())";
        psmt = conn.prepareStatement(sql);

        psmt.setString(1, board.getTitle());
        psmt.setString(2, board.getContent());
        psmt.setInt(3, fileId);
        psmt.setString(4, ipAddress);
        psmt.setInt(5, memberId);
        psmt.setInt(6, memberId);
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
        alert("게시글이 등록되지 않았습니다. 제목과 내용을 입력해주세요!!");
        location.href = "write.jsp";
    </script>
<%
    }
%>
