<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="local.vo.Member" %>
<%@ page errorPage="errorPage.jsp" %>
<%
	Member member = (Member)session.getAttribute("login");
	int member_id =0;
	if(member != null){
		member_id = member.getMemberId();
		}

	String fileOrdParam = request.getParameter("fileOrd");

	int fileOrd =0; 
	if(fileOrdParam != null && !fileOrdParam.equals("")){
		fileOrd = Integer.parseInt(fileOrdParam);
	}
	
	Connection conn = null;
	PreparedStatement psmt= null;
	ResultSet rs = null;
	String url = "jdbc:mysql://localhost:3306/localboard";
    String user = "cteam";
    String pass = "1234";
	
	
	try{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		//------------- 수정된 파일 정보를 변경하기 위해 file_id 를 가져옴 ---------
		String sql=" SELECT file_id FROM board_file_detail WHERE file_ord = ? ";
		
		psmt = conn.prepareStatement(sql);
		psmt.setInt(1,fileOrd);
		rs=psmt.executeQuery();
		
		int file_id=0;
		if(rs.next()){
			file_id=rs.getInt("file_id");
		}
		System.out.println(file_id);		
		
		if(rs != null) rs.close();
		if(psmt != null) psmt.close();
		
		//------------------수정된 정보를 입력함 ----------------------
		
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
		
		// ---------------- modify페이지에서 삭제 버튼이 클릭된 파일을 삭제함------- 
		
		sql = " delete from board_file_detail where file_ord = ?";
		
		psmt = conn.prepareStatement(sql);
		psmt.setInt(1,fileOrd);
		
		int result = psmt.executeUpdate();
		
		if(result > 0){
			out.print("SUCCESS");
		}else{
			out.print("FAIL");
		}
		
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt !=  null) psmt.close();
	}
%>