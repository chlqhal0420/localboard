<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="local.vo.*"%>
<%@ page import="java.sql.*"%>
<%@ page errorPage="errorPage.jsp" %>

<%

Member member = (Member) session.getAttribute("login");

if (member == null) {
%>
<script>
   alert("잘못된 접근입니다.");
   location.href = 'list.jsp';
</script>
<%
}

String lbIdParam = request.getParameter("board_id");

int lbId = 0;
if (lbIdParam != null && !lbIdParam.equals("")) {
	lbId = Integer.parseInt(lbIdParam);
}

String addrDetail=request.getParameter("addr_detail");

%>


<% 
Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;
String url = "jdbc:mysql://localhost:3306/localboard";
String user = "cteam";
String pass = "1234";

try {
	 Class.forName("com.mysql.cj.jdbc.Driver");
	 conn = DriverManager.getConnection(url, user, pass);
	 
	 String sql ="SELECT nicknm FROM member WHERE member_id = ? ";
	 
	  psmt = conn.prepareStatement(sql);
	   psmt.setInt(1, member.getMemberId());
	   rs = psmt.executeQuery();

	   if (rs.next()) {
	      member.setNicknm(rs.getString("nicknm"));
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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>
$(document).ready(function() {
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
							<h2>후기작성</h2>
						</div>
						<div class="text-right">
							<button onclick="location.href='list.jsp'" class="btn btn-secondary">목록</button>          
                		</div><br>

						<form action="reviewWriteOk.jsp?lb_id=<%=lbId%>" method="post" name="frm" enctype="multipart/form-data" id="frm">
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
									aria-label="With textarea" placeholder="<%=member.getNicknm() %>님 이웃에게 경험을 나눠주세요. 동네정보가 더욱 풍성해질거예요!"  rows="10" name="content"></textarea>
							</div>

							<br>
							<div class="card" style="width: 100%;">
								<div class="card-header">
									<i class="bi bi-camera-fill fs-3"></i> <span
										class="fs-4 fw-bold"
										style="font-weight: bold; font-size: 17px;"><%=addrDetail%>을 이용하신 사진을 한개 이상 공유해주세요!</span>
								</div>
							 <div class="card-body">
							<!-- --------------------------------------첨부파일---------------------------- -->
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
			</div>
		</div>
							<!-- ---------- 첨부파일 추가 및 삭제---------------------- -->
	
		 
		 <script>
/* 	폼 제출시 첨부파일이 추가가 안 된 입력양식을 삭제하는 자바스크립트 (시작) */
		
		 /* 
		  $(document).ready(function() {
		     $('#frm').on('submit', function() {
		         var leLength = $(".uploadUl li").length;
		         for(var i = 0; i < leLength; i++) {
		             if ($("input[name='file" + (i + 1) + "']").val() == "") {
		                 $("input[name='file" + (i + 1) + "']").parent("li").remove();
		             }
		         }
		     });
		 }); */ 
		
		/* 플러스 버튼을 눌렀을때  */
		
		$(document).on("click", ".btnP", function(){
			var target = $(this);
			var fileNum = Number(target.parent().parent("ul").find("li:last-child").find("input").attr("name").substring(4))+1;
			$('<li><input type="file" name="file'+fileNum+'" id="file" style="width:80%; height:30px;"><img class="btnP" src="<%=request.getContextPath() %>/images/plus.png" style="vertical-align:middle; width:1em; height:1em;"/><img class="btnM" src="<%=request.getContextPath() %>/images/minus.png" style="vertical-align:middle; width:1em; height:1em;"/></li>').insertAfter(target.parent().parent("ul").find("li:last-child")); 
		});
		
		/* 마이너스 버튼을 눌렀을때*/
		$(document).on("click", ".btnM", function(){
			var target = $(this);
			var liLen = $(this).parent().parent("ul").find("li").length;
			if(liLen!=1) target.parent().remove();
			else  alert("모두 지울 수 없습니다.");
			
		});
	
	</script>
							<!-- --------------------------------------첨부파일----------------------------------------->
						
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