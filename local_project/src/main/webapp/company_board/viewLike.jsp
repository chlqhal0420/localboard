<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="local.vo.*"%>
<%@ page import="java.util.*"%>	
<%@ page import="java.util.ArrayList"%>
<%@ page errorPage="errorPage.jsp" %>

<%
//후기 이미지가 있는 것이 먼저 출력되고, 이미지 없는 것은 나중에 출력되는 소스

Member member = (Member) session.getAttribute("login");

String board_idParam = request.getParameter("board_id");
int board_id = 0;
if (board_idParam != null && !board_idParam.equals("")) {
   board_id = Integer.parseInt(board_idParam);
}


/* 업체주소 정보를 받을 변수 */
	String local_extra = null;
    String post_code = null;  
    String addr = null;
    String addr_detail = null;

Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;
String url = "jdbc:mysql://localhost:3306/localboard";
String user = "cteam";
String pass = "1234";
BoardLike boardlike = new BoardLike(); // 좋아요
Board board = new Board(); // 동네업체 게시판 결과를 담을 객체
List<BoardFileDetail> bflist = new ArrayList<BoardFileDetail>(); // 게시글 첨부파일 목록 변수
ArrayList<Map<String,String>> rlist = new ArrayList<Map<String,String>>();
ArrayList<Map<String,String>> isNotFileRlist = new ArrayList<Map<String,String>>();

try {
	//------------------------------- 쿠키 생성 -----------------------------------------
		boolean isBnoCookie = false; // 게시글 번호에 대한 쿠키가 있는지 여부를 나타내는 변수 초기화
		Cookie[] cookies = request.getCookies(); // 현재 요청으로부터 모든 쿠키를 가져옴
		
		// 모든 쿠키를 반복하면서 게시글 번호에 대한 쿠키가 있는지 확인
		for (Cookie tempCookie : cookies) {
			if (tempCookie.getName().equals("board_id" + board_id)) {
		isBnoCookie = true; // 해당 게시글 번호에 대한 쿠키가 있다면 변수를 true로 설정하고 반복문 종료
		break;
		
			}
		}
		// 해당 게시글 번호에 대한 쿠키가 없다면 새로운 쿠키를 생성하여 응답에 추가
		if (!isBnoCookie) {
			Cookie cookie = new Cookie("board_id" + board_id, "ok"); // 게시글 번호에 대한 쿠키 생성
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
		sql = " UPDATE local_board " + "	 SET hit = hit+1" + " WHERE lb_id = ? ";

		psmt = conn.prepareStatement(sql);

		psmt.setInt(1, board_id); // PreparedStatement에 쿼리의 파라미터로 게시글 번호(bno)를 설정합니다.

		psmt.executeUpdate(); // 조회수를 1 증가시키는 쿼리를 실행하므로 해당 게시글의 조회수가 증가됩니다.

		if (psmt != null)psmt.close();
	}

	//------------------------- 쿠키를 사용하여 조회수 중복 방지 -------------------------------------------------
	
	
	
	
   //---------------------- 동네업체 게시판 데이터 가져오기 ---------------------------------------------
   sql = "SELECT lb_id, content, title, m.nicknm, b.created_by, b.created_at, b.hit , b.local_extra, b.post_code, b.addr, b.addr_detail " + "  FROM local_board b      "
   + " INNER JOIN member m" + " ON b.created_by = m.member_id   " + " WHERE b.lb_id = ? "; 

   psmt = conn.prepareStatement(sql);
   psmt.setInt(1, board_id);
   rs = psmt.executeQuery();

   if (rs.next()) {
      board.setBoardId(rs.getInt("lb_Id"));
      board.setContent(rs.getString("content"));
      board.setTitle(rs.getString("title"));
      board.setNicknm(rs.getString("nicknm"));
      board.setCreatedAt(rs.getString("created_at"));
      board.setCreatedBy(rs.getInt("created_by"));
      board.setHit(rs.getInt("hit"));
      local_extra = rs.getString("local_extra");
      post_code = rs.getString("post_code");
      addr = rs.getString("addr");
      addr_detail = rs.getString("addr_detail");

   }
 
   //---------------------- 업체 게시판 목록 데이터 가져오기 ---------------------------------------------

   //---------------------- 첨부 파일 데이터 가져오기 ---------------------------------------------

   if (psmt != null) psmt.close();
   if (rs != null) rs.close();
   
   sql = "select * from board_file_detail bfd inner join local_board lb on bfd.file_id = lb.file_id where lb_id = ?";

   psmt = conn.prepareStatement(sql);
   psmt.setInt(1, board_id);

   rs = psmt.executeQuery();

   while (rs.next()) {
      // 각 행의 데이터를 담을 BoardFile 객체를 생성합니다.
      BoardFileDetail bfd = new BoardFileDetail();

      bfd.setFileOrd(rs.getInt("file_ord")); // bfno 열의 값을 읽어와서 BoardFile 객체에 설정합니다.
      bfd.setFileId(rs.getInt("file_id"));
      bfd.setFileRealNm(rs.getString("file_real_nm"));
      bfd.setFileOriginNm(rs.getString("file_origin_nm"));
      bfd.setCreatedAt(rs.getString("created_at"));
      bfd.setFileThumbnailNm(rs.getString("file_thumbnail_nm"));
      bflist.add(bfd);
   }
   

   if (psmt != null) psmt.close();
   if (rs != null) rs.close();
  //---------------------------------후기 출력 ---------------------------------------------
  

 
 
/*  파일이 있는 후기만 가져오는 쿼리문*/
sql ="  select  r.review_id, m.nicknm  , r.content,   r.created_at, r.created_by, "
	+" bfd.file_id , bfd.file_ord , bfd.file_real_nm ,  bfd.file_thumbnail_nm FROM review r "
    +" inner join  member m on r.created_by = m.member_id "
	+" INNER JOIN board_file_detail bfd ON r.file_id = bfd.file_id WHERE  lb_id = ? and r.delyn = 'N'"; 
 
//모든 후기를 가져오는 쿼리문
/*  sql=" SELECT lb.lb_id, r.review_id, m.nicknm, r.content, r.created_at, "
		    +" bfd.file_id, bfd.file_ord, bfd.file_real_nm, bfd.file_thumbnail_nm "
		+" FROM local_board lb INNER JOIN member m ON lb.created_by = m.member_id "
		+" INNER JOIN review r ON r.lb_id = lb.lb_id "
		+" LEFT JOIN board_file_detail bfd ON r.file_id = bfd.file_id "
		+" WHERE lb.lb_id = ? ";
 */
		  
	  psmt = conn.prepareStatement(sql);
	  psmt.setInt(1, board_id);
	  rs = psmt.executeQuery();
  
	  while(rs.next()){
		  	HashMap<String, String> map =new HashMap<>(); 
		  	map.put("reviewId", rs.getString("review_id"));
		  	map.put("nicknm", rs.getString("nicknm"));
		  	map.put("content", rs.getString("content"));
			map.put("createdAt", rs.getString("created_at"));
			map.put("createdBy", rs.getString("created_by"));
			map.put("fileId", rs.getString("file_id"));
		  	map.put("fileOrd", rs.getString("file_ord"));
		  	map.put("fileRealNm", rs.getString("file_real_nm"));
		  	map.put("fileThumbnailNm", rs.getString("file_thumbnail_nm"));
		  
		  	rlist.add(map);
	  }
/* 	  System.out.println(rlist.size()); */

	   if (psmt != null) psmt.close();
	   if (rs != null) rs.close();
	   
	   // file이 없는 후기만 가져오는 쿼리문
	   sql= "SELECT  r.review_id, m.nicknm  , r.content,   r.created_at, r.created_by FROM review r "
			  + " inner join  member m on r.created_by = m.member_id "
			  +" WHERE file_id IS NULL  AND lb_id = ? and r.delyn = 'N' "; 
		  
		  psmt = conn.prepareStatement(sql);
		  psmt.setInt(1, board_id);
		  rs = psmt.executeQuery();
	   
		  while(rs.next()){
			  	HashMap<String, String> map =new HashMap<>(); 
			  	map.put("reviewId", rs.getString("review_id"));
			  	map.put("nicknm", rs.getString("nicknm"));
			  	map.put("content", rs.getString("content"));
				map.put("createdAt", rs.getString("created_at"));
				map.put("createdBy", rs.getString("created_by"));
				
			  	isNotFileRlist.add(map);
		  }
		  
/* 좋아요 수 가져오기 */	
		if (psmt != null) psmt.close();
	if (rs != null) rs.close();

	sql = "SELECT COUNT(*) AS likeCount FROM local_like WHERE lb_id = ? AND count = 1";
	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, board_id);
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

<!-- 스와이퍼 -->
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1" />
  <!-- Link Swiper's CSS -->
 <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />

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
<link href="<%=request.getContextPath()%>/css/companyBoardView.css"
	rel="stylesheet" />
	
<!-- 부트스트랩 아이콘 -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.6.4.min.js">	


<!--  -->
<script>
//-------------------------------- 댓글 삭제 함수 -------------------------------------------------
function reviewDelFn(reviewId, obj) {
    $.ajax({
        url: "reviewDeleteOk.jsp",
        type: "post",
        data: "reviewId=" + reviewId,
        success: function (data) {
            console.log(data);
            if (data.trim() == 'SUCCESS') {
                alert("후기가 삭제되었습니다.");
                let target = $(obj).parent().parent().parent();
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

//---------------------------------------------------------------------------------------------------------
</script>
</head>

<body class="sub_page">

	<div class="hero_area">
		<!-- header section strats -->
		<%@ include file="/include/header.jsp"%>
		<!-- end header section -->
	</div>

	<!-- about section -->
	
	<section class="about_section layout_padding">

		<div class="container">
			
			<div class="row justify-content-center">
			
				<!-- 중앙 정렬 클래스 추가 -->
				<div class="col-md-8">
				<div>
	<!----------------- 닉네임, 작성일------------- -->
				<h2><%=board.getTitle()%></h2>
				<div class="text-right">
					<span><%=board.getNicknm()%></span>
					  &nbsp&nbsp 
					 <span><%=board.getCreatedAt()%></span>
	<!------------------------- 좋아요버튼-------------------------- -->
							<button type="button" class="btn btn-light" id="likeButton" onclick="toggleLike(<%=board.getBoardId()%>, this)">
								<i class="bi bi-heart" id="heartIcon"></i> 좋아요 <span id="likeCount"><%=boardlike.getCount()%></span>
							</button>
						</div> 
				</div>
				<script src="<%=request.getContextPath()%>/js/localLike.js"></script> <!-- 좋아요 기능 자바스크립트 -->
				<hr>
	<!--------------------------------------- 썸네일 사진 출력부분---------------------------- -->
					<div id="carouselExample" class="carousel slide"
						data-ride="carousel">
						<div class="carousel-inner">

							<%
								for(int i=0; i<bflist.size(); i++){
									BoardFileDetail tempbf = (BoardFileDetail) bflist.get(i);
									if(i==0){
										%>
										<div class="carousel-item active">
								<img src="<%=request.getContextPath()%><%=tempbf.getFileThumbnailNm()%>/<%= tempbf.getFileRealNm()%>"
									class="d-block w-100" height="500" alt="음식1">
							</div>
							<% 
									}
									else{
							%>
								<div class="carousel-item">
								<img src="<%=request.getContextPath()%>/upload/<%= tempbf.getFileRealNm()%>"
									class="d-block w-100" height="500" alt="음식1">
								</div>
							<% 
									}
	
								}
							%>
						</div>
						<a class="carousel-control-prev" href="#carouselExample"
							role="button" data-slide="prev"> <span
							class="carousel-control-prev-icon" aria-hidden="true"></span> <span
							class="visually-hidden">Previous</span>
						</a> <a class="carousel-control-next" href="#carouselExample"
							role="button" data-slide="next"> <span
							class="carousel-control-next-icon" aria-hidden="true"></span> <span
							class="visually-hidden">Next</span>
						</a>
					</div>
		<!--------------------------------------- 썸네일 사진 출력부분 끝---------------------------- -->
					<br>
					
					<p><%=board.getContent()%></p>
					<hr>
					<div>
						<h4>찾아오시는 곳 : </h4>
						<h5><%=addr%> <%=addr_detail %></h5>
					</div>
		<!-- --------------------------지도영역 -------------------------------------------->
					<p style="margin-top:-12px">
					    <!-- <em class="link">
					        <a href="javascript:void(0);" onclick="window.open('http://fiy.daum.net/fiy/map/CsGeneral.daum', '_blank', 'width=981, height=650')">
					            혹시 주소 결과가 잘못 나오는 경우에는 여기에 제보해주세요.
					        </a>
					    </em> -->
					</p>
					<div id="map" style="width:100%;height:350px;"></div>
					<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=3e6966c60a48445d631248661740e9d0&libraries=services"></script>
					<script>
					 var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
										    mapOption = {
										        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
										        level: 3 // 지도의 확대 레벨
										    };  
										
										// 지도를 생성합니다    
										var map = new kakao.maps.Map(mapContainer, mapOption); 
										
										// 주소-좌표 변환 객체를 생성합니다
										var geocoder = new kakao.maps.services.Geocoder();
										
										// 주소로 좌표를 검색합니다
										geocoder.addressSearch('<%=addr%>', function(result, status) {
										
										    // 정상적으로 검색이 완료됐으면 
										     if (status === kakao.maps.services.Status.OK) {
										
										        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
										
										        // 결과값으로 받은 위치를 마커로 표시합니다
										        var marker = new kakao.maps.Marker({
										            map: map,
										            position: coords
										        });
										
										        // 인포윈도우로 장소에 대한 설명을 표시합니다
										        var infowindow = new kakao.maps.InfoWindow({
										            content: '<div style="width:150px;text-align:center;padding:6px 0;"><%=addr_detail%></div>'
										        });
										        infowindow.open(map, marker);
										
										        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
										        map.setCenter(coords);
										    } 
										});
					
					</script> 
			<!-- -------------------------------------지도영역 끝--------------------------------- -->
					
			<!-- ----게시글 수정 삭제 버튼 --------------------------------------------------------- -->
			<%
				if (member != null && member.getMemberId() == board.getCreatedBy()){
			%>
					<hr>
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
					<%
					}
					%>
					
					<form name="frm" action="delete.jsp" method="post">
						<input type="hidden" name="board_id"
							value="<%=board.getBoardId()%>">
					</form>
				<!-- ----게시글 수정 삭제 버튼 끝 ------------------------------------------------- -->
				<!------------- 후기 작성페이지로 이동---------------------------------------- -->
				<hr>
				<div class="text-center">
					<h4><%=board.getNicknm()%>님 <%=addr_detail%> 을 이용하셨나요?</h4>
					이웃에게 이용 경험을 알려보세요. 
					<button onclick="location.href='reviewWrite.jsp?board_id=<%=board.getBoardId()%>'"
							type="button" class="btn btn-info">후기작성</button>
				</div>	
				<!------------- 후기 작성페이지로 이동 끝--------------------- -->
					<hr>
				
		<!-- --------------------------------후기 1개 보여주기 ------------------------------------------------------------ -->
	<% 
	int count=0;
 //list안의 원소 확인용
/* for(int i=0 ; i<rlist.size();i++) {
			System.out.println(rlist.get(i));}  */


			String nowReviewId = "";
			String precontent ="";
			
			// 향상된 for 루프를 사용하여 리스트 순회
			for(Map<String, String> map : rlist) {
			    // map.get 메서드를 사용하여 키의 값을 얻음
			   	String reviewId = map.get("reviewId");
			   	String nicknm = map.get("nicknm");
			    String content = map.get("content");
			    String createdAt = map.get("createdAt");
			    String createdBy = map.get("createdBy");
			    String fileId = map.get("fileId");
			    String fileOrd = map.get("fileOrd");
			    String fileRealNm = map.get("fileRealNm");
			    String fileThumbnailNm = map.get("fileThumbnailNm");
			    
			    int created_by = 0;
			    if (createdBy != null && !createdBy.equals("")) {
			    	created_by = Integer.parseInt(createdBy);
			    }
			    
			    if(!reviewId.equals(nowReviewId)){
			    	if(count ==0){ //제일 처음 후기가 생성될때 카드형태		    	
%>
		<div class="card">
		<div class="card-body">
			<!-- ----------자신이 작성한 후기에만 수정삭제버튼이 보임---------- -->
<%	
	
	if (member != null && member.getMemberId() == created_by ){
%>
						<div class="text-right">
							<button
								onclick="location.href='reviewModify.jsp?review_id=<%=reviewId%>'"
								type="button" class="btn btn-info">수정</button>

							<button onclick="reviewDelFn(<%=reviewId%>,this)" type="button" class="btn btn-info">삭제</button>
						</div>
<%
    }
%>							
			<!-- ----------수정삭제버튼----------- -->
			
			<h5 class="card-title"><%=nicknm %></h5>
							 <p class="card-subtitle mb-2 text-muted">작성일: <%=createdAt %></p> 
			<div class="container">
				<div class="row">
														
					<div class="swiper mySwiper">
					  <div class="swiper-wrapper">
					     <div class="swiper-slide"><img src="<%=request.getContextPath()%><%=fileThumbnailNm %>/<%=fileRealNm %>" /></div>					     
<%			    	
				count++;
			    	}else{ //두번째부터 후기 카드가 생성되는 로직. 
			    	//reviewId가 다르면 앞에 있던 카드를 닫아주고 새 카드를 연다.(이때, 닫아주는 카드에는 앞에 있던 후기 내용을 넣은 후 닫아줘야 한다. precontent에 앞전에 있던 후기내용이 담겨있다.)
			    	
			    	
%>
			
			</div> <!-- 이미지 부분을 닫아준다.  -->
					  <div class="swiper-pagination"></div>
					</div>
					<div><%=precontent %></div> <!-- 앞전에 있던 후기의 내용을 삽입해준다. -->
				</div>
			</div>
		</div>
	</div>
	<br> <!-- 여기서부터는 새 후기카드를 생성하는 로직 -->
			<div class="card">
		<div class="card-body">
			<!-- ----------자신이 작성한 후기에만 수정삭제버튼이 보임---------- -->
<%	
	
	if (member != null && member.getMemberId() == created_by ){
%>
						<div class="text-right">
							<button
								onclick="location.href='reviewModify.jsp?review_id=<%=reviewId%>'"
								type="button" class="btn btn-info">수정</button>

							<button onclick="reviewDelFn(<%=reviewId%>,this)" type="button" class="btn btn-info">삭제</button>
						</div>
<%
    }
%>							
			<!-- ----------수정삭제버튼----------- -->
			<h5 class="card-title"><%=nicknm %></h5>
							 <p class="card-subtitle mb-2 text-muted">작성일: <%=createdAt %></p> 
			<div class="container">
				<div class="row">
														
					<div class="swiper mySwiper">
					  <div class="swiper-wrapper">
					     <div class="swiper-slide"><img src="<%=request.getContextPath()%><%=fileThumbnailNm %>/<%=fileRealNm %>" /></div>					         	
<% 			    	
			    	}	
			    }else{ //reivewId가 같으면 이미지만 추가해준다.
%>
				<div class="swiper-slide"><img src="<%=request.getContextPath()%><%=fileThumbnailNm %>/<%=fileRealNm %>" /></div> 
<%
			    }
			    nowReviewId = reviewId;
			    precontent = content;
%>
	<%			
		}
	%>	
	
	<!-- 재일 마지막에 등록되는 후기를 닫아주는 로직. 이때, 마지막 후기내용을 넣고 닫아준다. -->
	</div>
					  <div class="swiper-pagination"></div>
					</div>
					<div><%=precontent %></div>
				</div>
			</div>
		</div>
	</div>
	<br>
	<!-- -------------------------------이미지가 없는 후기 출력하기---------------------- -->

	
<% 
		 //list안의 원소 확인용
	/* 	for(int i=0 ; i<isNotFileRlist.size();i++) {
			System.out.println(rlist.get(i));}  */

			// 향상된 for 루프를 사용하여 리스트 순회
			for(Map<String, String> map : isNotFileRlist) {
			    // map.get 메서드를 사용하여 키의 값을 얻음
			   	String reviewId = map.get("reviewId");
			   	String nicknm = map.get("nicknm");
			    String content = map.get("content");
			    String createdAt = map.get("createdAt");
			    String createdBy = map.get("createdBy");
			    
			    int created_by = 0;
			    if (createdBy != null && !createdBy.equals("")) {
			    	created_by = Integer.parseInt(createdBy);
			    }
%>
		<div class="card">
		<div class="card-body">
				<!-- ----------자신이 작성한 후기에만 수정삭제버튼이 보임---------- -->
<%	
	
	if (member != null && member.getMemberId() == created_by ){
%>
						<div class="text-right">
							<button
								onclick="location.href='reviewModify.jsp?review_id=<%=reviewId%>'"
								type="button" class="btn btn-info">수정</button>

							<button onclick="reviewDelFn(<%=reviewId%>,this)" type="button" class="btn btn-info">삭제</button>
						</div>
<%
    }
%>							
			<!-- ----------수정삭제버튼----------- -->
			<h5 class="card-title"><%=nicknm %></h5>
							 <p class="card-subtitle mb-2 text-muted">작성일: <%=createdAt %></p> 
			<div class="container">
				<div class="row">
				<div><%=content %></div>
				</div>
			</div>
		</div>
	</div>
	<br>
	
	
	<%
			}
	%>
	
	
	
	<!-- ---------------------------------------------------------------------- -->
  <!-- 후기 스와이퍼 JS -->
  <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

  <!-- 후기 자바스크립트 -->
  <script>
    var swiper = new Swiper(".mySwiper", {
      slidesPerView: 3,
      spaceBetween: 30,
      freeMode: true,
      pagination: {
        el: ".swiper-pagination",
        clickable: true,
      },
    });
  </script>
								</div>
							</div>
						</div>
					</div>
					
								

	
<!----------------------------------후기 영역 끝-------------------------------------------------------------->		
				</div>
			</div>
		</div>
	</section>
	<!-- end about section -->


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