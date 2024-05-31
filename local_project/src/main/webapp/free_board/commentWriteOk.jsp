<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="local.vo.*"%>
<%@ page import="java.sql.*"%>
<%
request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="comment" class="local.vo.Comment" />
<jsp:setProperty name="comment" property="*" />
<%
Member member = (Member) session.getAttribute("login");

if (member != null) {
	comment.setCreatedBy(member.getMemberId());

	// 수정: 댓글이 속한 게시판의 board_id를 파라미터로 받기
	int boardId = Integer.parseInt(request.getParameter("board_id"));
	comment.setBoardId(boardId);

	Board board = new Board();

	Connection conn = null;
	PreparedStatement psmt = null;
	String url = "jdbc:mysql://localhost:3306/localboard";
	String user = "cteam";
	String pass = "1234";

	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url, user, pass);

		String sql = "INSERT INTO comment( " + "   board_id " + " , created_by " + " , content " + " , created_ip "
		+ " , created_at, board_code ) VALUES( " + "   ?" + " , ?" + " , ?" + " , 1.0" // IP test                        
		+ " , now(), 'F') ";

		psmt = conn.prepareStatement(sql);
		psmt.setInt(1, comment.getBoardId());
		psmt.setInt(2, comment.getCreatedBy());
		psmt.setString(3, comment.getContent());

		int result = psmt.executeUpdate();

		if (result > 0) {
	// 수정: 댓글이 등록된 후 comment_id를 가져와 comment 객체에 설정
	if (psmt != null)
		psmt.close();

	sql = "SELECT MAX(comment_id) AS comment_id FROM comment";

	psmt = conn.prepareStatement(sql);

	ResultSet rs = psmt.executeQuery();

	int commentId = 0;
	if (rs.next()) {
		commentId = rs.getInt("comment_id");
		comment.setCommentId(commentId); // comment_id를 reply 객체에 설정
	}

	if (rs != null)
		rs.close();
%>
<%-- <div class="commentRow">
	<%=member.getNicknm()%>
	: <span> <%=comment.getContent()%>
	</span> <span>
		<button onclick="modifyFn(this,<%=commentId%>)" class="btn btn-primary">수정</button>
		<button onclick="replyDelFn(<%=commentId%>,this)" class="btn btn-primary">삭제</button>
	</span>
	<button onclick="replyFn(<%=commentId%>,this)" class="btn btn-primary">답글</button>
</div>
<hr>


<form name="replyfrm_<%=commentId%>" style="display: none;">

	<input type="hidden" name="board_id" value="<%=comment.getBoardId()%>">
	답글 : <input type="text" name="content">
	<button type="button" onclick="replyInsertFn(<%=commentId%>)" class="btn btn-primary">저장</button>
	<hr>
</form>


<script>
              function replyFn(commentId, button) {
            	   // 해당 댓글에 대한 답글 폼의 표시 여부를 전환합니다.
            	   var replyForm = document.forms["replyfrm_" + commentId];
            	   replyForm.style.display = (replyForm.style.display === 'none' || replyForm.style.display === '') ? 'block' : 'none';
           		   }
</script> --%>

<%
} else {
out.print("FAIL");
}

} catch (Exception e) {
out.print("FAIL: " + e.getMessage());
} finally {
if (conn != null)
conn.close();
if (psmt != null)
psmt.close();
}
} else {
out.print("FAIL");
}
%>
