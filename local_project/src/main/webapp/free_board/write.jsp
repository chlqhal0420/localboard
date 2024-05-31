<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="local.vo.Member"%>


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
        .right-align {
            text-align: right;
        }
    </style>
</head>

<body class="sub_page">

	<div class="hero_area">
		<!-- header section strats -->
		<%@ include file="/include/header.jsp"%>
		<!-- end header section -->
	</div>


	<!------------ write section ----------->
	
	<section class="about_section layout_padding d-flex justify-content-center align-items-center">
    <div class="container">
        <div class="row">
            <div class="col-md-12">

                <h2 class="text-center">새 글 작성</h2>
                <div class="text-right">
					<button onclick="location.href='list.jsp'" class="btn btn-secondary">목록</button>          
                </div><br>

                <form action="writeOk.jsp?member_id=<%=member.getMemberId()%>" method="post" name="frm" enctype="multipart/form-data" class="text-center">
                    <div class="input-group flex-nowrap">
                        <span class="input-group-text" id="addon-wrapping">제목</span>
                        <input type="text" class="form-control" placeholder="제목을 입력하세요." aria-label="Username" aria-describedby="addon-wrapping" name="title">
                    </div>
                    <br>

                    <div>
                        <span class="input-group-text justify-content-center">내용</span>
                        <textarea id="summernote" class="form-control" aria-label="With textarea" rows="10" name="content"></textarea>

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

                    <br>
                    <div class="input-group mb-3">
                        <input type="file" class="form-control" id="inputGroupFile02" name="uploadFile">
                        <label class="input-group-text" for="inputGroupFile02">Upload</label>
                    </div>
                    
                    <button type="submit" class="btn btn-info">저장</button>
                   
                </form>
            </div>
        </div>
    </div>
</section>



	
	<!-- end write section -->


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