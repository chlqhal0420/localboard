<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="local.vo.Member"%>
<%@ page errorPage="errorPage.jsp" %>
 <!-- 파일 유효성 검사 테스트 중 -->

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
<!-- 아이콘 -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

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

                <h2 class="text-center">직접 가본 동네 리뷰</h2>
                <div class="text-right">
					<button onclick="location.href='list.jsp'" class="btn btn-secondary">목록</button>          
                </div><br>

                <form action="writeOk.jsp?member_id=<%=member.getMemberId()%>" method="post" name="frm" enctype="multipart/form-data" class="text-center">
                    <div class="input-group flex-nowrap">
                        <span class="input-group-text" id="addon-wrapping">제목</span>
                        <input type="text" class="form-control" placeholder="제목을 입력하세요." aria-label="Username" aria-describedby="addon-wrapping" name="title"  required>
                    </div>
                    <br>

                    <div>
                        <span class="input-group-text justify-content-center">내용</span>
                        <textarea required id="summernote" class="form-control" aria-label="With textarea" rows="10" name="content"></textarea>

                        <script>
                            $('#summernote').summernote({
                                placeholder: '<%=member.getNicknm() %> 님 다녀온 곳의 리뷰를 써보세요',
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

						<div class="card" style="width: 100%;">
							<div class="card-header">
								<i class="bi bi-camera-fill fs-3"></i> <span
									class="fs-4 fw-bold">썸네일 이미지를 등록해주세요.</span>
							</div>
							<div class="card-body">
								<input type="file" class="form-control" id="inputGroupFile02"
									name="uploadFile" onchange="displayImagePreview(this)"  required>

							</div>
							<div id="image-preview"></div>
							<br>
						</div>
						<div style="padding-top: 20px;">
						<button type="submit" class="btn btn-info">저장</button>
                   		</div>
                </form>
            </div>
        </div>
    </div>
</section>

<!-- 이미지 미리보기 기능 -->
<script>

$(document).ready(function(){
    // 파일 유형, 크기, 이름 길이를 검증하는 함수
    function validFileType(filename) {
        const fileTypes = ["png", "jpg", "jpeg"];
        return fileTypes.indexOf(filename.substring(filename.lastIndexOf(".")+1).toLowerCase()) >= 0;
    }
    
    function validFileSize(file){
        if(file.size > 10000000){ //10MB
            return false;
        }else{
            return true;
        }
    }

    function validFileNameSize(filename){
        if(filename.length > 30){ //30자
            return false;
        }else{
            return true;
        }
    }

    // 동적으로 추가된 파일 입력에 대한 이벤트 핸들러
    $(document).on('change', 'input[type="file"]', function(){
        var fileInput = $(this)[0];
        if(fileInput.files && fileInput.files[0]){
            var filename = fileInput.files[0].name;
            var file = fileInput.files[0];

            // 파일 유효성 검사
            if(!validFileType(filename) || !validFileSize(file) || !validFileNameSize(filename)){
                if(!validFileType(filename)){
                    alert("허용되지 않는 확장자의 파일입니다.");
                }else if(!validFileSize(file)){
                    alert("파일 크기가 10MB를 초과합니다.");
                }else if(!validFileNameSize(filename)){
                    alert("파일명이 30자를 초과합니다.");
                }
                $(this).val(''); // 파일 입력 초기화
                $('#image-preview').html(''); // 이미지 미리보기 초기화
                return false;
            }else{
                // 파일 유효성 검사를 통과한 경우에만 이미지 미리보기 기능 활성화
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#image-preview').html('<img src="' + e.target.result + '" alt="uploaded image" style="width:300px;height:300px;object-fit:cover;">');
                };
                reader.readAsDataURL(file);
            }
        }
    });
});
</script>

	
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