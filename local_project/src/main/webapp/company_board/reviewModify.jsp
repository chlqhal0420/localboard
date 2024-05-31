<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="local.vo.*"%>
<%@ page import="java.util.*"%>
<%@ page errorPage="errorPage.jsp" %>	

<%

Member member = (Member) session.getAttribute("login");

String reviewIdparam = request.getParameter("review_id");

int reviewId = 0;
if (reviewIdparam != null && !reviewIdparam.equals("")) {
	reviewId = Integer.parseInt(reviewIdparam);
}

String lbIdParam = request.getParameter("board_id");
int lbId = 0;
if (lbIdParam != null && !lbIdParam.equals("")) {
	lbId = Integer.parseInt(lbIdParam);
}


Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;
String url = "jdbc:mysql://localhost:3306/localboard";
String user = "cteam";
String pass = "1234";

Review review = new Review(); // 동네업체 게시판 결과를 담을 객체
List<BoardFileDetail> bflist = new ArrayList<BoardFileDetail>(); // 게시글 첨부파일 목록 변수
int fileId=0;

try {
   Class.forName("com.mysql.cj.jdbc.Driver");
   conn = DriverManager.getConnection(url, user, pass);

   //---------------------- 동네업체 게시판 목록 데이터 가져오기 ---------------------------------------------
   String sql =  " select content, file_id from review where review_id = ? "; 
   
	
   psmt = conn.prepareStatement(sql);
   psmt.setInt(1, reviewId);
   rs = psmt.executeQuery();

   if (rs.next()) {
      review.setContent(rs.getString("content"));
      review.setFileId(rs.getInt("file_id"));
      
      fileId= review.getFileId(); //후기가 가지고 있는 첨부파일ID를 담음. 첨부파일이 없으면 0 
   }
   //---------------------- 업체 게시판 목록 데이터 가져오기 ---------------------------------------------

   //---------------------- 첨부 파일 데이터 가져오기 ---------------------------------------------

   if(fileId!=0){ //첨부파일이 있을때만 실행됨. 
	   
   if (psmt != null)
      psmt.close();
   if (rs != null)
      rs.close();

   sql = "select * from board_file_detail bfd inner join review r on bfd.file_id = r.file_id where review_id = ?";

   psmt = conn.prepareStatement(sql);
   psmt.setInt(1, reviewId);

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

<!------------------------- 스마트 에디터 --------------------------------->
<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" 
		crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script> 
<!------------------------- 스마트 에디터 --------------------------------->

<style>
.detail-box {
	text-align: center;
}
</style>
<!-- 첨부파일  -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
$(document).ready(function(){
    $('#frm').on('submit', function(e) {
        // 첨부파일 입력 여부 확인
        var fileInputExists = false;
        $('.uploadUl li input[type="file"]').each(function() {
            if ($(this).val() !== "") {
                fileInputExists = true;
                return false; // 하나라도 찾으면 루프 중단
            }
        });
        if (!fileInputExists) {
            alert("사진을 1개 이상 업로드해주세요.");
            e.preventDefault(); // 폼 제출 중단
            return false;
        }

        // 파일 입력이 있는 경우, 빈 파일 입력 필드 제거
        var leLength = $(".uploadUl li").length;
        for(var i = 0; i < leLength; i++) {
            if ($("input[name='file" + (i + 1) + "']").val() == "") {
                $("input[name='file" + (i + 1) + "']").parent("li").remove();
            }
        }
    });
});
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
			<div class="row">
				<div class="col-md-12">
					<div class="detail-box">
						<div class="heading_container d-flex justify-content-center">
							<h2>후기</h2>
						</div>
						<div class="text-right">
							<button onclick="location.href='list.jsp'" class="btn btn-secondary">목록</button>          
                		</div><br>

						<form action="reviewModifyOk.jsp?" method="post" name="frm" enctype="multipart/form-data" id="frm">
							<input type="hidden" name="review_id" value="<%=reviewId%>">
							<input type="hidden" name="lb_id" value="<%=lbId%>">
							<!-- <div class="input-group flex-nowrap">
								<span class="input-group-text" id="addon-wrapping">제목</span> <input
									type="text" class="form-control" placeholder="제목을 입력하세요."
									aria-label="Username" aria-describedby="addon-wrapping"
									name="title">
							</div> -->
							<br>

							<div>
								<span class="input-group-text justify-content-center" class="fs-4 fw-bold"
										style="font-weight: bold; font-size: 17px;">내용</span>
								<textarea required class="form-control"
									aria-label="With textarea"  rows="10" name="content"><%=review.getContent()%></textarea>
							</div>

							<br>


							<!-- --------------------------------------첨부파일---------------------------- -->
							<div class="card" style="width: 100%;">
								<div class="card-header">
									<i class="bi bi-camera-fill fs-3"></i> <span
										class="fs-4 fw-bold"
										style="font-weight: bold; font-size: 17px;">사진을 한개 이상 공유해주세요!</span>
								</div>
							 <div class="card-body">
							<!--  후기에 등록된 첨부파일이 있는 경우 출력해서 보여줌 -->
						<% if(fileId!=0){ %>
						<ul class="uploadUl mb8" style="list-style-type: none; padding-left: 0;">
							<%
								for(int i=0; i<bflist.size(); i++){
									BoardFileDetail tempbf = (BoardFileDetail) bflist.get(i);
							%>
								<li>
									<input type="text" id="file" name="file<%=i+1%>" value="<%= tempbf.getFileOriginNm()%>" style="width:80%; height:30px;" readonly>
									
									<img class="btnP" src="<%=request.getContextPath() %>/images/plus.png" style="vertical-align:middle; width:1em; height:1em;"/>
									<img class="btnM" src="<%=request.getContextPath() %>/images/minus.png" style="vertical-align:middle; width:1em; height:1em;" data-myparam="<%= tempbf.getFileOrd()%>"/>
								</li>
								
							<% 	
								}

							%>
							</ul>
							
							<% 	
								}
							%>
							
							<!-- ---------- 첨부파일 추가 및 삭제---------------------- -->
							<!-- 후기에 첨부된 파일이 하나도 없는 경우 파일을 첨부할 수 있는 양식을 보여줌 -->
							<% if(fileId==0){ %>
		 					<ul class="uploadUl mb8"
								style="list-style-type: none; padding-left: 0;">

								<li><input type="file" name="file1" id="file" style="width: 80%; height: 30px;" /> 
									<img class="btnP" src="<%=request.getContextPath() %>/images/plus.png" style="vertical-align: middle; width: 1em; height: 1em;" /> 
									<img class="btnM" src="<%=request.getContextPath() %>/images/minus.png" style="vertical-align: middle; width: 1em; height: 1em;" />
								</li>

								<li><input type="file" name="file2" id="file" style="width: 80%; height: 30px;"> 
									<img class="btnP" src="<%=request.getContextPath() %>/images/plus.png" style="vertical-align: middle; width: 1em; height: 1em;" /> 
									<img class="btnM" src="<%=request.getContextPath() %>/images/minus.png" style="vertical-align: middle; width: 1em; height: 1em;" />
								</li>

								<li><input type="file" name="file3" id="file" style="width: 80%; height: 30px;" /> 
									<img class="btnP" src="<%=request.getContextPath() %>/images/plus.png" style="vertical-align: middle; width: 1em; height: 1em;" /> 
									<img class="btnM" src="<%=request.getContextPath() %>/images/minus.png" style="vertical-align: middle; width: 1em; height: 1em;" />
								</li>
							</ul>
							
							<% 	
								}
							
							%>
		 					
		 					<!-- 후기에 첨부된 파일이 하나도 없는 경우 -->
		 	</div>
		</div>
<!-- ----------------폼 제출시 첨부파일이 추가가 안 된 입력양식을 삭제함  ----------- -->
<script>
//---------------------마이너스 버튼을 눌렀을때 첨부파일을 삭제하는 함수(ajax통신 이용)-------------------
	$(document).on("click", ".btnM", function(){
			var target = $(this);
			var liLen = $(this).parent().parent("ul").find("li").length;
			if(liLen!=1) target.parent().remove();
			else  alert("모두 지울 수 없습니다.");
			
			if(liLen!=1 && $(this).data('myparam')!=null){
				var myParam = $(this).data('myparam'); //삭제할 파일번호
			    console.log("매개변수 값:"+ myParam);
				
			$.ajax({
				url : "fileDeleteOk.jsp",
				type : "post",
				data : "fileOrd="+myParam,
				success:function(data){
					if(data.trim() == 'SUCCESS'){
						alert("파일이 삭제되었습니다.");
						
					}else{
						alert("파일이 삭제되지 못했습니다.");
					}
				},error:function(){
					console.log("error");
				}
			});
			
			}
		});

	/* 플러스 버튼을 눌렀을때  */
		$(document).on("click", ".btnP", function(){
			var target = $(this);
			console.log("target:"+target);
			var fileNum = Number(target.parent().parent("ul").find("li:last-child").find("input").attr("name").substring(4))+1;
			$('<li><input type="file" name="file'+fileNum+'" id="file" style="width:80%; height:30px;"><img class="btnP" src="<%=request.getContextPath() %>/images/plus.png" style="vertical-align:middle; width:1em; height:1em;"/><img class="btnM" src="<%=request.getContextPath() %>/images/minus.png" style="vertical-align:middle; width:1em; height:1em;"/></li>').insertAfter(target.parent().parent("ul").find("li:last-child")); 
		});
		
	</script> 
						
							<hr>
							<button type="submit" class="btn btn-info">저장</button>
						</form>
					</div>
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
	
	
