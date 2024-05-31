<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>    
<%@ page import="local.vo.*" %>
<%@ page errorPage="errorPage.jsp" %>    

<%

	Member member = (Member)session.getAttribute("login");

	String boardIdParam = request.getParameter("board_id");

	int boardId = 0;
	if (boardIdParam != null && !boardIdParam.equals("")) {
		boardId = Integer.parseInt(boardIdParam);
	}
	
	
	Connection conn = null;
	PreparedStatement psmt= null;
	ResultSet rs = null;
	String url = "jdbc:mysql://localhost:3306/localboard";
	String user = "cteam";
	String pass = "1234";
	
	Board board = new Board();
	BoardFileDetail bf = new BoardFileDetail(); // 파일 수정 테스트
	
	
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "SELECT board_id, title, b.created_by, m.nicknm, b.created_at, b.content, b.hit, m.member_id "
				   + "  FROM board b"
				   + " INNER JOIN member m"
				   + " ON b.created_by = m.member_id"
				   + " WHERE b.board_id = ?";
		
		psmt = conn.prepareStatement(sql);
		psmt.setInt(1,boardId);
		rs = psmt.executeQuery();
		
		if(rs.next()){
			board.setCreatedBy(rs.getInt("created_by"));
			board.setTitle(rs.getString("title"));
			board.setNicknm(rs.getString("nicknm"));
			board.setCreatedAt(rs.getString("created_at"));
			board.setContent(rs.getString("content"));
			board.setHit(rs.getInt("hit"));
			board.setBoardId(rs.getInt("board_id"));
			/* board.setMemberId(rs.getInt("member_id")); */
			
		}
		
		
	// ------------------파일 수정-----------------------------
		
		if(psmt != null) psmt.close(); // 파일 수정 테스트 위해 연결 종료
		if(rs != null) rs.close();	   // 파일 수정 테스트 위해 연결 종료
	
		sql = "select * from board_file_detail t inner join board b on t.file_id = b.file_id where board_id = ?";
		
		psmt = conn.prepareStatement(sql);
		psmt.setInt(1, boardId);
		rs = psmt.executeQuery();
		
		while (rs.next()){
			bf.setFileOrd(rs.getInt("file_ord"));
			bf.setFileId(rs.getInt("file_id"));
			bf.setBoardId(rs.getInt("board_id"));
			bf.setFileRealNm(rs.getString("file_real_nm"));
			bf.setFileOriginNm(rs.getString("file_origin_nm"));
			bf.setCreatedAt(rs.getString("created_at"));
			
		}
	// ------------------파일 수정 -----------------------------	
		

	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
	}
	
	if(member == null || board.getCreatedBy() != member.getMemberId()){
		%>
			<script>
				alert("잘못된 접근입니다.");
				location.href='list.jsp';
			</script>
		<%
			}
%>   
<!DOCTYPE html>
<html>
<head>
  <!-- Basic -->
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <!-- Mobile Metas -->
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <!-- Site Metas -->
  <meta name="keywords" content="" />
  <meta name="description" content="" />
  <meta name="author" content="" />

   <title>동네커뮤니티</title>

  <!-- slider stylesheet -->
  <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.1.3/assets/owl.carousel.min.css" />

  <!-- bootstrap core css -->
  <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/bootstrap.css" />

  <!-- fonts style -->
  <link href="https://fonts.googleapis.com/css?family=Poppins:400,600,700&display=swap" rel="stylesheet">
  <!-- Custom styles for this template -->
  <link href="<%=request.getContextPath()%>/css/style.css" rel="stylesheet" />
  <!-- responsive style -->
  <link href="<%=request.getContextPath()%>/css/responsive.css" rel="stylesheet" />
  
  <!------------------------- 스마트 에디터 --------------------------------->
  <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" 
		crossorigin="anonymous"></script>
  <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script> 
  <!------------------------- 스마트 에디터 --------------------------------->
  
  
  <!---------------------------------------- 파일 수정 테스트 ------------------------------------------------------>
	<script>
	function boardFileDeleteFn(obj){
		let value = $(obj).parent().prev("span").text().trim();
		console.log(value);
		
		let html = "<input type='file' name='uploadFile' required>" // 새로 첨부파일을 넣을 수 있는 양식으로 교체됨
				  + "<input type='hidden' name='file_ord' value='"+ <%=bf.getFileOrd()%> +"'>"; // 삭제할 파일 번호
				  
				  $(obj).parent().prev("span").html(html);
				  
				  html = "";
				  $(obj).parent().html(html);
				  
	}

	//첨부파일 번호인 bfno(PK값) 을 넘겨주어야 modifyOk.jsp에서 삭제를 할 수 있다. 
	// 그런데 bfno를 밑에서 아무조건없이 무조건 넘기게 되면 파일삭제여부와 상관없이 
	//modifyOk.jsp에서 첨부파일을 무조건 삭제시키게 된다. 
	//그러므로 (기존파일을) 삭제버튼 누를때만 bfno 를 넘겨주면 된다. 
	//즉, 새로운 첨부파일 보낼때 같이hidden 사용해서 보내면 된다. 

	function cancleModifyFn(){
		
		<%
     	if(bf.getFileOriginNm() != null){
     	%>
     	
		let html= "<%= bf.getFileOriginNm()%>";
		
		$("#target").html(html);
		
		html ="<button type='button' onclick='boardFileDeleteFn(this)' class='btn btn-danger'>삭제</button>";
		$("#del").html(html);
		
		
		<%
     	}
		%>
		
		let content= '<%=board.getContent()%>';  /* 기존 내용을 가져와서*/
	      
        $(".note-editable").html(content);		  /* 스마트 에디터 내용에 넣어준다 */
	}
	</script>
<!--------------------------------------------- 파일 수정 테스트 --------------------------------------------->
  
  <!-- 아이콘 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  
  
</head>

<body class="sub_page">

  	<div class="hero_area">
    <!-- header section strats -->
    <%@ include file="/include/header.jsp" %>
    <!-- end header section -->
  	</div>


  <!-- about section -->
<section class="about_section layout_padding">
    <div class="container">
        <div class="row justify-content-center align-items-center">
            <div class="col-md-12">
                <h2 class="text-center mb-4 font-weight-bold">직접 가본 동네 리뷰</h2>
            
                <div class="text-right">
              	 	 <button onclick="location.href='view.jsp?board_id=<%=board.getBoardId()%>'" class="btn btn-secondary">뒤로가기</button>
                </div>
                
                <form name="frm" action="modifyOk.jsp" method="post" enctype="multipart/form-data">
                 <!-- 파일 수정을 위해 enctype="multipart/form-data" 추가됨 
		 				해당 폼이 파일 업로드와 같은 이진 데이터를 서버로 전송할 때 사용
	 				-->
                    <input type="hidden" name="board_id" value="<%=board.getBoardId()%>">

                    <div class="mb-3">
                        <label for="title" class="form-label font-weight-bold">제목 :</label>
                        <input type="text" class="form-control" id="title" name="title" value="<%=board.getTitle()%>">
                    </div>

                    <div class="mb-3">
                        <label for="content" class="form-label font-weight-bold">내용 :</label>
                        <textarea class="form-control" id="summernote" name="content" rows="10" cols="50"><%=board.getContent()%></textarea>
                        <script>
                            $('#summernote').summernote({
                                placeholder: '내용을 입력하세요.',
                                tabsize: 2,
                                height: 400,
                                toolbar: [
                                    ['style', ['style']],
                                    ['font', ['bold', 'underline', 'clear']],
                                    ['color', ['color']],
                                    ['para', ['ul', 'ol', 'paragraph']],
                                    ['table', ['table']],
                                    ['insert', ['link', 'picture', 'video']],
                                    ['view', ['fullscreen', 'codeview', 'help']]
                                ]
                            });
                        </script>
                    </div>
<!---------------------------------------------- 파일 수정 테스트 ------------------------------------------------------------->
  	
 <div class="card" style="width: 100%;">
  <div class="card-header">
    <i class="bi bi-camera-fill fs-3"></i> <span class="fs-4 fw-bold">썸네일 이미지를 등록해주세요.</span> 
  </div>
  <div class="card-body">
		<p class="card-text"><%
     	if(bf.getFileOriginNm() != null){
     %>
    	<span id="target"><%=bf.getFileOriginNm()%></span>&nbsp&nbsp
    	<span id="del"><button type="button" onclick="boardFileDeleteFn(this)" class="btn btn-danger">삭제</button></span>
    <%
     	}else{
    %>	<span id="target"></span>
    	<span id="del"><button type="button" onclick="boardFileDeleteFn(this)" class="btn btn-warning">추가</button></span>
    	<%
     	}
    	%></p>
	</div>
  
</div>
 <!----------------------------------------------- 파일 수정 테스트 ------------------------------------------------------------->
<br>
                    <div class="text-center">
                        <button class="btn btn-info">저장</button>
                        <input type="reset" value="초기화" onclick="cancleModifyFn()" class="btn btn-primary">
                    </div>
                </form>
            </div>
        </div>
    </div>
</section>

  

  <!-- info section -->
  <%@ include file="/include/info.jsp" %>
  <!-- end info section -->

  <!-- footer section -->
   <%@ include file="/include/footer.jsp" %>
  <!-- footer section -->


  <script src="<%=request.getContextPath()%>/js/jquery-3.4.1.min.js"></script>
  <script src="<%=request.getContextPath()%>/js/bootstrap.js"></script>

</body>
</html>