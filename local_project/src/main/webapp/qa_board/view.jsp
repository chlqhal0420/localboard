<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="local.vo.*"%>
<%@ page import="java.util.*"%>

<%
Member member = (Member) session.getAttribute("login");

String boardIdParam = request.getParameter("board_id");

int before = 0; // 이전글 변수 초기화
int after = 0; // 다음글 변수 초기화

int boardId = 0;
if (boardIdParam != null && !boardIdParam.equals("")) {
	boardId = Integer.parseInt(boardIdParam);
}

String fileOrdParam = request.getParameter("file_ord");

Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;
String url = "jdbc:mysql://localhost:3306/localboard";
String user = "cteam";
String pass = "1234";

BoardLike boardlike = new BoardLike();
Board board = new Board(); // 게시판 결과를 담을 객체
List<BoardFileDetail> bflist = new ArrayList<BoardFileDetail>(); // 게시글 첨부파일 목록 변수
List<Comment> clist = new ArrayList<Comment>(); // 댓글 목록 변수
List<Reply> rlist = new ArrayList<Reply>(); // 답글 목록 변수

try {
	//------------------------------- 쿠키 생성 -----------------------------------------
	boolean isBnoCookie = false; // 게시글 번호에 대한 쿠키가 있는지 여부를 나타내는 변수 초기화
	Cookie[] cookies = request.getCookies(); // 현재 요청으로부터 모든 쿠키를 가져옴

	// 모든 쿠키를 반복하면서 게시글 번호에 대한 쿠키가 있는지 확인
	for (Cookie tempCookie : cookies) {
		if (tempCookie.getName().equals("board_id" + boardId)) {
	isBnoCookie = true; // 해당 게시글 번호에 대한 쿠키가 있다면 변수를 true로 설정하고 반복문 종료
	break;
		}
	}
	// 해당 게시글 번호에 대한 쿠키가 없다면 새로운 쿠키를 생성하여 응답에 추가
	if (!isBnoCookie) {
		Cookie cookie = new Cookie("board_id" + boardId, "ok"); // 게시글 번호에 대한 쿠키 생성
		cookie.setMaxAge(60 * 60 * 24); // 쿠키의 유효 기간을 하루로 설정
		response.addCookie(cookie); // 응답에 쿠키 추가
	}
	//------------------------------- 쿠키 생성 -----------------------------------------

	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(url, user, pass);

	String sql = "";

	//------------------------- 쿠키를 사용하여 조회수 중복 방지 -------------------------------------------------

	// 게시글 번호에 대한 쿠키가 없는 경우에 해당하는 조건문입니다. 
	// 이 조건문은 쿠키가 없을 때 조회수를 증가시키는 작업을 수행

	if (!isBnoCookie) {

		// UPDATE 문을 사용하여 board 테이블에서 hit(조회수)를 1 증가시키는 쿼리입니다. 
		// 조건은 게시글 번호(bno)가 특정한 값일 때입니다.
		sql = "UPDATE board " + "	  SET hit = hit+1" + " WHERE board_id = ? ";

		psmt = conn.prepareStatement(sql);

		psmt.setInt(1, boardId); // PreparedStatement에 쿼리의 파라미터로 게시글 번호(bno)를 설정합니다.

		psmt.executeUpdate(); // 조회수를 1 증가시키는 쿼리를 실행하므로 해당 게시글의 조회수가 증가됩니다.

		if (psmt != null)
	psmt.close();
	}

	//------------------------- 쿠키를 사용하여 조회수 중복 방지 -------------------------------------------------

	//----------------------  게시판 목록 데이터 가져오기 ---------------------------------------------
	sql = "SELECT board_Id, content, title, m.nicknm, b.created_at, b.hit, b.comment_count" + "  FROM board b      "
	+ " INNER JOIN member m" + " ON b.created_by = m.member_id   " + " WHERE b.board_id = ? AND b.type = 'Q'"; // 자유게시판 T 데이터만 가져옴!

	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, boardId);
	rs = psmt.executeQuery();

	if (rs.next()) {
		board.setBoardId(rs.getInt("board_Id"));
		board.setContent(rs.getString("content"));
		board.setTitle(rs.getString("title"));
		board.setNicknm(rs.getString("nicknm"));
		board.setCreatedAt(rs.getString("created_at"));
		board.setHit(rs.getInt("hit"));
		board.setCommentCount(rs.getInt("comment_count")); //댓글수

	}
	//---------------------- 자유 게시판 목록 데이터 가져오기 ---------------------------------------------

	//------------------------ 이전글 board_id 가져오기 (페이징용)------------------------------------------------------
	if (psmt != null)
		psmt.close();
	if (rs != null)
		rs.close();

	sql = "SELECT * FROM board WHERE type = 'Q' and delyn='N' and board_id < ? order by board_id DESC limit 0,1 "; // ? -> 현재 페이지 board_id
	//"board" 테이블에서 "type"이 'F', "delyn"이 'N'이며 "board_id"가 18보다 작은 행을 내림차순으로 정렬하고, 그 중 첫 번째 행만 반환
	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, boardId);
	rs = psmt.executeQuery();

	if (rs.next()) {
		before = rs.getInt("board_id");
	}
	//------------------------ 이전글 board_id 가져오기 (페이징용)------------------------------------------------------

	//------------------------ 다음글 board_id 가져오기 (페이징용)------------------------------------------------------
	if (psmt != null)
		psmt.close();
	if (rs != null)
		rs.close();

	sql = "SELECT * FROM board WHERE type = 'Q' and delyn='N' and board_id > ? order by board_id ASC limit 0,1 "; // ? -> 현재 페이지 bno

	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, boardId);
	rs = psmt.executeQuery();

	if (rs.next()) {
		after = rs.getInt("board_id");
	}
	//------------------------ 다음글 board_id 가져오기 (페이징용)------------------------------------------------------

	//---------------------- 첨부 파일 데이터 가져오기 ---------------------------------------------

	if (psmt != null)
		psmt.close();
	if (rs != null)
		rs.close();

	sql = "select * from board_file_detail t inner join board b on t.file_id = b.file_id where board_id = ?";

	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, boardId);

	rs = psmt.executeQuery();

	while (rs.next()) {
		// 각 행의 데이터를 담을 BoardFile 객체를 생성합니다.
		BoardFileDetail bf = new BoardFileDetail();

		bf.setFileOrd(rs.getInt("file_ord")); // bfno 열의 값을 읽어와서 BoardFile 객체에 설정합니다.
		bf.setFileId(rs.getInt("file_id"));
		bf.setFileRealNm(rs.getString("file_real_nm"));
		bf.setFileOriginNm(rs.getString("file_origin_nm"));
		bf.setCreatedAt(rs.getString("created_at"));

		bflist.add(bf);
	}
	//---------------------- 첨부 파일 데이터 가져오기 ---------------------------------------------
	if (psmt != null)
		psmt.close();
	if (rs != null)
		rs.close();

	//------------------------------- 댓글 목록 가져오기 ------------------------------------------------------------
	sql = " SELECT c.comment_id, m.nicknm, c.content, c.created_at,  ce.modified_at " + "     FROM comment c "
	+ "     INNER JOIN member m ON c.created_by = m.member_id "
	+ "     LEFT JOIN comment_edit ce ON c.comment_id = ce.comment_id "
	+ "     WHERE c.board_id = ? AND c.delyn = 'N' " // 삭제된 댓글은 화면 출력 안됨!
	+ "     ORDER BY c.comment_id DESC"; // <--- 업데이트를 해도 최신 댓글의 내림차순이 유지됨

	// reply 테이블과 member 테이블을 조인하여 해당 게시글 (r.bno = ?)에 대한 
	// 댓글 정보와 작성자 정보를 가져오는 쿼리입니다.

	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, boardId);
	// ?를 게시글 번호 (board.getBno())로 설정합니다.
	rs = psmt.executeQuery();
	//쿼리를 실행하고 결과를 ResultSet 객체에 저장합니다.
	while (rs.next()) {
		Comment comment = new Comment();
		comment.setCommentId(rs.getInt("comment_id"));
		comment.setNicknm(rs.getString("nicknm"));
		comment.setContent(rs.getString("content"));
		comment.setCreatedAt(rs.getString("created_at"));
		comment.setModifiedAt(rs.getString("modified_at"));

		clist.add(comment);
	}

	//------------------------------- 답글 목록 가져오기 --------------------------------------------------------------------------------
	sql = "SELECT created_at, content, comment_id, reply_id from reply WHERE board_id = ? AND delyn = 'N' ORDER BY reply_id DESC";

	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, boardId);
	rs = psmt.executeQuery();

	while (rs.next()) {
		Reply reply = new Reply();
		reply.setCreatedAt(rs.getString("created_at"));
		reply.setContent(rs.getString("content"));
		reply.setCommentId(rs.getInt("comment_id"));
		reply.setReplyId(rs.getInt("reply_id"));

		rlist.add(reply);
	}

	//------------------------------ 좋아요 수 가져오기 --------------------------------------------
	if (psmt != null)
		psmt.close();
	if (rs != null)
		rs.close();

	sql = "SELECT COUNT(*) AS likeCount FROM board_like WHERE board_id = ? AND count = 1";
	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, boardId);
	rs = psmt.executeQuery();

	while (rs.next()) {
		boardlike.setCount(rs.getInt("likeCount"));
	}

} catch (Exception e) {
	e.printStackTrace();
} finally {
	if (conn != null)
		conn.close();
	if (psmt != null)
		psmt.close();
	if (rs != null)
		rs.close();
}
%>


<!DOCTYPE html>
<html>
<head>
<!-- Basic -->
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<!-- Mobile Metas -->
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />
<!-- Site Metas -->
<meta name="keywords" content="" />
<meta name="description" content="" />
<meta name="author" content="" />

<title>동네커뮤니티</title>

<!-- slider stylesheet -->
<link rel="stylesheet" type="text/css"
	href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.1.3/assets/owl.carousel.min.css" />

<!-- bootstrap core css -->
<link rel="stylesheet" type="text/css"
	href="<%=request.getContextPath()%>/css/bootstrap.css" />

<!-- fonts style -->
<link
	href="https://fonts.googleapis.com/css?family=Poppins:400,600,700&display=swap"
	rel="stylesheet">
<!-- Custom styles for this template -->
<link href="<%=request.getContextPath()%>/css/style.css"
	rel="stylesheet" />
<!-- responsive style -->
<link href="<%=request.getContextPath()%>/css/responsive.css"
	rel="stylesheet" />
<!-- 부트스트랩 아이콘 -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

<script>
//-------------------------------- 댓글 작성 함수 -------------------------------------------------
function commentInsertFn() {
    let loginMember = '<%=member%>';
    let isModify; // 변수를 선언

    if (loginMember != 'null') {
        let params = $("form[name=replyfrm]").serialize();
        console.log(params);
        $.ajax({
            url: "commentWriteOk.jsp",
            type: "post",
            data: params,
            success: function (data) {
                if (data.trim() != "FAIL") {
                    $(".commentArea").prepend(data.trim());
                   /*  alert("댓글이 작성되었습니다."); */
                    // 댓글 작성 후 댓글 수 업데이트
                    updateCommentCount();
                    location.reload();
                }
            },
            error: function () {
                console.log("error");
            }
        });
    } else {
        alert("로그인 후에 처리하세요");
    }

    $("input[name=content]").val("");
}
//-------------------------------- 댓글 삭제 함수 -------------------------------------------------
function replyDelFn(commentid, obj) {
    $.ajax({
        url: "deleteCommentOk.jsp",
        type: "post",
        data: "commentid=" + commentid,
        success: function (data) {
            console.log(data);
            if (data.trim() == 'SUCCESS') {
                alert("댓글이 삭제되었습니다.");
                // 댓글 삭제 후 댓글 수 업데이트
                updateCommentCount();
                let target = $(obj).parent().parent();
                target.remove();
            } else {
                alert("댓글이 삭제되지 못했습니다. 답글을 먼저 삭제해 주세요!");
            }
        },
        error: function () {
            console.log("error");
        }
    });
}

$(document).ready(function () {
    // 새로고침 버튼 클릭 이벤트
    $("#refreshButton").click(function () {
        // 댓글 수 업데이트
        updateCommentCount();
    });
});

function updateCommentCount() {
    // board.getBoardId()의 값을 가져옴
    var boardId = <%=board.getBoardId()%>;

    // AJAX 요청
    $.ajax({
        type: "POST", // 또는 "GET"
        url: "commentCount.jsp", // 실제 서버 엔드포인트 주소로 변경해야 함
        data: { boardId: boardId },
        success: function (response) {
            // 성공 시 댓글 수 업데이트
            // 여기에서 필요한 업데이트 작업을 수행
            location.reload(); 
        },
        error: function () {
            alert("댓글 수 업데이트에 실패했습니다.");
        }
    });
}

//-------------------------------- 댓글 수정 함수 -------------------------------------------------
let isModify = false;
function modifyFn(obj, rno){
    
    if(!isModify){
        //입력양식 초기값 얻어오기
        let value = $(obj).parent().prev("span").text().trim();
        console.log(value);
        
        let html = "<input type='text' name='rcontent' value='"+value+"' style='width: 700px;'>"; // 수정 입력창 길이 조절!
        html += "<input type='hidden' name='rno' value='"+rno+"'>";
        html += "<input type='hidden' name='oldRcontent' value='"+value+"'>";
        
        $(obj).parent().prev("span").html(html);
        
        html = "<button onclick='saveFn(this)' class='btn btn-primary'>저장</button>"
             +"<button onclick='cancleFn(this)' class='btn btn-primary'>취소</button>";
        
        $(obj).parent().html(html);
        
        isModify = true;
    }else{
        alert("수정중인 댓글을 저장하세요.");
    }
}

//-------------------------------- 댓글 수정 저장 함수 -------------------------------------------------
function saveFn(obj){
    
    isModify = false;
    
    let value = $(obj).parent().prev("span")
                    .find("input[name=rcontent]").val();
    let rno = $(obj).parent().prev("span")
                    .find("input[name=rno]").val();
    let originalValue = $(obj).parent().prev("span")
                            .find("input[name=oldRcontent]").val();
    
    $.ajax({
        url : "commentModifyOk.jsp",
        type : "post",
        data : {rcontent : value, rno : rno},
        success : function(data){
            if(data.trim() == 'SUCCESS'){
                $(obj).parent().prev("span").text(value);
                let html = '<button onclick="modifyFn(this,'+rno+')" class="btn btn-primary">수정</button>'
                        +  '<button onclick="replyDelFn('+rno+',this)" class="btn btn-primary">삭제</button>';
                $(obj).parent().html(html);                            
            }else{
                $(obj).parent().prev("span").text(originalValue);
                let html = '<button onclick="modifyFn(this,'+rno+')" class="btn btn-primary">수정</button>'
                        +  '<button onclick="replyDelFn('+rno+',this)" class="btn btn-primary">삭제</button>';
                $(obj).parent().html(html);        
            }
        },error:function(){
            console.log("error");
        }
    });
    
}
//-------------------------------- 댓글 수정 취소 함수 -------------------------------------------------
function cancleFn(obj){
    let originalValue = $(obj).parent().prev("span").find("input[name=oldRcontent]").val();
    console.log(originalValue);

    let rno = $(obj).parent().prev("span").find("input[name=rno]").val();
    
    $(obj).parent().prev("span").text(originalValue);
    
    
    let html = "<button onclick='modifyFn(this, "+rno+")' class='btn btn-primary'>수정</button>";
    html += "<button onclick='replyDelFn("+rno+",this)' class='btn btn-primary'>삭제</button>";
    
    $(obj).parent().html(html);
    
    isModify = false;
    
}
</script>
</head>

<body class="sub_page">

	<div class="hero_area">
		<!-- header section strats -->
		<%@ include file="/include/header.jsp"%>
		<!-- end header section -->
	</div>

	<!-- view section -->
	<section class="about_section layout_padding">
		<div class="container">
			<div class="row">
				<div class="col-md-12">
					<div class="heading_container">
						<h2 class="mb-4">Q&amp;A 게시판 상세보기</h2>
					</div>
					<div class="text-right">
						<button onclick="location.href='list.jsp'" type="button"
							class="btn btn-secondary">목록</button>

						<!-------------------------------------------------- 이전글, 다음글, 목록 버튼 위치 -------------------------------------------------->

						<!-- 이전 글 -->
						<%
						if (before != 0) { // before의 값이 0이 아닌 경우 아래 버튼이 보여짐!
							// before의 값이 0인 경우 아래 버튼이 숨겨짐!
						%>
						<button onclick="location.href='view.jsp?board_id=<%=before%>'"
							class="btn btn-primary me-md-3" type="button">이전글</button>
						<%
						}
						%>

						<!-- 다음 글 -->
						<%
						if (after != 0) { // after 값이 0이 아닌 경우 아래 버튼이 보여짐!
							// after 값이 0인 경우 아래 버튼이 숨겨짐!
						%>

						<button onclick="location.href='view.jsp?board_id=<%=after%>'"
							class="btn btn-primary me-md-3" type="button">다음글</button>
						<%
						}
						%>
					</div>
					<br>

					<!---------------------------------------------- 게시판 목록 데이터 보여주기 -------------------------------------------------------->

					<h3 class="mb-3">
						제 목 :
						<%=board.getTitle()%></h3>
					<p class="mb-2">
						작성일 :
						<%=board.getCreatedAt()%>
						| 조회수 :
						<%=board.getHit()%></p>
					<p class="mb-2">
						닉네임 :
						<%=board.getNicknm()%></p>
					<hr>

	<!--------------------------------------------- 좋아요 ------------------------------------------------------->
					
					
					<div class="container mt-4">
						<button type="button" class="btn btn-light" id="likeButton"
							onclick="toggleLike(<%=board.getBoardId()%>, this)">
							<i class="bi bi-heart" id="heartIcon"></i> 좋아요 
							<span id="likeCount"><%=boardlike.getCount()%></span>
						</button>
					</div>
					
<script>
//좋아요 토글 함수 정의
function toggleLike(boardId, button) {
    // 좋아요 개수 업데이트를 표시할 엘리먼트 가져오기
    var likeCountElement = document.getElementById("likeCount");
    
    // 현재 좋아요 개수 가져오기
    var likeCount = parseInt(likeCountElement.innerText);

    // jQuery를 이용한 AJAX 호출
    $.ajax({
        // 서버로 요청할 URL
        url: "boardLike.jsp",
        
        // HTTP 메서드 설정 (POST)
        method: "POST",
        
        // 전송할 데이터 설정
        data: { 
            boardId: <%=board.getBoardId()%>,  // 게시물 ID
            action: $("#heartIcon").hasClass("bi-heart") ? "like" : "unlike",  // 좋아요 추가 또는 취소 여부
            likeCount: likeCount  // 현재 좋아요 개수
        },
        
        // 성공 시 실행되는 콜백 함수
        success: function(data) {
            // 서버에서 받아온 데이터가 "FAIL"이 아닌 경우
            if (data.trim() != "FAIL") {
                // 특정 버튼 내에서 하트 아이콘을 찾아 클래스를 토글
                $(button).find("#heartIcon").toggleClass("bi-heart bi-heart-fill text-danger");

                // 좋아요 개수 업데이트
                likeCountElement.innerText = data.trim();
                
            } else {
                // 서버에서 "FAIL"을 받은 경우 알림 표시
                alert("좋아요 정보 업데이트에 실패했습니다.");
            }
        },
        
        // 오류 발생 시 실행되는 콜백 함수
        error: function(error) {
            console.error("Error:", error);
        }
    });
}
</script>

					<div class="col text-right">
						<h5>첨부파일</h5>
						<%
						for (BoardFileDetail tempbf : bflist) {
						%>
						<a
							href="download.jsp?realNM=<%=tempbf.getFileRealNm()%>&originNM=<%=tempbf.getFileOriginNm()%>"><%=tempbf.getFileOriginNm()%></a><br>
						<%
						}
						%>
					</div>
					<br>

					<div class="card mb-4">
						<div class="card-body"
							style="background-color: rgba(255, 0, 0, 0.2);">
							<!-- 배경색 변경 가능! -->
							<p class="card-text"><%=board.getContent()%></p>
						</div>
					</div>
					<div class="text-center">
						<button
							onclick="location.href='modify.jsp?board_id=<%=board.getBoardId()%>'"
							type="button" class="btn btn-info">수정</button>

						<button onclick="delFn()" type="button" class="btn btn-info">삭제</button>
					</div>
					<script>
						function delFn() {
							let isDel = confirm("정말 삭제하시겠습니까?");

							if (isDel) {
								document.frm.submit();
							}
						}
					</script>
					<form name="frm" action="delete.jsp" method="post">
						<input type="hidden" name="board_id"
							value="<%=board.getBoardId()%>">
					</form>
					<br>

					<!-------------------------------------------- 댓글의 개수 표시하기 ----------------------------------------------------->

					<h5 class="font-weight-bold">
						댓글
						<%=board.getCommentCount()%>
					</h5>

					<!---------------------------------------------------- 댓글 영역 ------------------------------------------------------->

					<form name="replyfrm" class="form-inline mx-auto">
						<!-- 댓글 폼 -->
						<input type="hidden" name="board_id"
							value="<%=board.getBoardId()%>">
						<div class="input-group col-md-12">
							<input type="text" class="form-control" name="content"
								placeholder="댓글을 입력해주세요">
							<div class="input-group-append">
								<button type="button" class="btn btn-primary" id="refreshButton"
									onclick="commentInsertFn()">저장</button>
							</div>
						</div>
					</form>

					<br>
					<div class="commentArea">
						<%
						for (Comment comment : clist) {
						%>
						<div>
							<%=comment.getNicknm()%><br>
							<%=comment.getCreatedAt()%><br> <span> <%=comment.getContent()%></span>
							<span>
								<button onclick="modifyFn(this,<%=comment.getCommentId()%>)"
									class="btn btn-primary text-right">수정</button>
								<button id="refreshButton"
									onclick="replyDelFn(<%=comment.getCommentId()%>,this)"
									class="btn btn-primary">삭제</button>
							</span>
							<button onclick="replyFn(<%=comment.getCommentId()%>)"
								class="btn btn-primary">답글</button>
						</div>
						<hr>

						<!-- 각 댓글에 대한 답글 폼과 내용 -->
						<form name="replyfrm_<%=comment.getCommentId()%>"
							style="display: none;">

							<div class="replyArea">
								<%
								for (Reply reply : rlist) {
									if (comment.getCommentId() == reply.getCommentId()) {
								%>
								<div>
									<script>
           							 // JavaScript로 작성자 닉네임 앞에 띄어쓰기 추가
           							 var commenterNick = '<%=comment.getNicknm()%>';
           							 var indentedCommenterNick = '&nbsp;&nbsp;&nbsp;&nbsp;' + commenterNick; // 띄어쓰기 4칸으로 조절
           							 document.write(indentedCommenterNick);
       								 </script>
									<br>
									<script>
           							 var commenterNick = '<%=reply.getCreatedAt()%>';
           							 var indentedCommenterNick = '&nbsp;&nbsp;&nbsp;&nbsp;' + commenterNick; // 띄어쓰기 4칸으로 조절
           							 document.write(indentedCommenterNick);
           							 </script>
									<br>
									<script>
           							 var commenterNick = '<%=reply.getContent()%>';
           							 var indentedCommenterNick = '&nbsp;&nbsp;&nbsp;&nbsp;' + commenterNick; // 띄어쓰기 4칸으로 조절
           							 document.write(indentedCommenterNick);							
           							 </script>


									<span>
										<button onclick="deleteReplyFn(<%=reply.getReplyId()%>,this)"
											class="btn btn-primary">삭제</button>
									</span>
									<hr>
								</div>
								<%
								}
								}
								%>
							</div>

							<input type="hidden" name="board_id"
								value="<%=board.getBoardId()%>"><input type="text"
								name="content" placeholder="답글을 입력해주세요">
							<button type="button"
								onclick="replyInsertFn(<%=comment.getCommentId()%>)"
								class="btn btn-primary">저장</button>

							<hr>
						</form>
						<%
						}
						%>
					</div>

					<script>
//---------------------------------------- 해당 댓글에 대한 답글 폼의 표시 여부를 전환합니다 ----------------------------------------
function replyFn(commentId) {
    
    var replyForm = document.forms["replyfrm_" + commentId];
    replyForm.style.display = (replyForm.style.display === 'none' || replyForm.style.display === '') ? 'block' : 'none';
}

//---------------------------------------------- 답글 저장 -------------------------------------------------------------------
function replyInsertFn(parentCommentId) {
    // 답글 추가를 처리하는 함수를 수정합니다.
    var replyForm = document.forms["replyfrm_" + parentCommentId];
    var content = replyForm.elements["content"].value;
    var boardId = replyForm.elements["board_id"].value;
    // AJAX를 사용하여 서버에 데이터를 전송합니다.
    $.ajax({
        type: "POST",
        url: "replyWriteOk.jsp", // 서버의 처리 페이지 URL
        data: {
            parentCommentId: parentCommentId,
            content: content,
            board_id: boardId 
        },
        success: function(data) {
            // 성공 시 서버의 응답에 대한 처리를 수행합니다.
            // response 변수에 서버에서 전송한 내용이 들어있습니다.
            
            if(data.trim() != "FAIL"){
				$(".replyArea").prepend(data.trim());
			}
        },
        error: function(error) {
            // 오류 발생 시 처리를 수행합니다.
            alert("답글 등록에 실패했습니다. 오류: " + error);
        }
    });

   replyForm.elements["content"].value = ''; 
}

//-------------------------------------- 답글 삭제 ------------------------------------------------------
function deleteReplyFn(replyId, obj) {
    $.ajax({
        url: "deleteReplyOk.jsp",
        type: "post",
        data: "replyId=" + replyId,
        success: function (data) {
            if (data.trim() === 'SUCCESS') {
            	
                alert("답글이 삭제되었습니다.");
                
            	let target = $(obj).parent().parent();
				target.remove();
                
            } else {
                alert("답글이 삭제되지 못했습니다.");
            }
        },
        error: function () {
            console.log("error");
        }
    });
    // 제출 후 답글 폼을 숨깁니다.
  /*  replyForm.style.display = 'block';  */
}

</script>

				</div>
			</div>
		</div>

	</section>


	<!-- end view section -->


	<!-- info section -->
	<%@ include file="/include/info.jsp"%>
	<!-- end info section -->

	<!-- footer section -->
	<%@ include file="/include/footer.jsp"%>
	<!-- footer section -->
	<script src="<%=request.getContextPath()%>/js/jquery-3.4.1.min.js"></script>
	<script src="<%=request.getContextPath()%>/js/bootstrap.js"></script>
</body>
</html>