<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="local.vo.Member"%>
<%@ page errorPage="errorPage.jsp" %>

<%

//파일 유효성 검사 추가된 소스
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
            alert("첨부파일을 최소 1개 이상 업로드해주세요.");
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
							<h2>우리동네 업체소식</h2>
						</div>
						<div class="text-right">
							<button onclick="location.href='list.jsp'" class="btn btn-secondary">목록</button>          
                		</div><br>

						<form action="writeOk.jsp?member_id=<%=member.getMemberId()%>" method="post" name="frm" enctype="multipart/form-data" id="frm" onsubmit="return validateForm();">
							<div class="input-group flex-nowrap">
								<span class="input-group-text" id="addon-wrapping" class="fs-4 fw-bold"
										style="font-weight: bold; font-size: 17px;">제목</span> 
								<input type="text" class="form-control" placeholder="소식 제목을 입력하세요."
									aria-label="Username" aria-describedby="addon-wrapping"
									name="title" required>
							</div>
							<br>

							<div>
								<span class="input-group-text justify-content-center" class="fs-4 fw-bold"
										style="font-weight: bold; font-size: 17px;">내용</span>
								<textarea id="summernote" class="form-control"
									aria-label="With textarea" placeholder="<%=member.getNicknm()%>님 상품/서비스 소개, 세로운 메뉴, 이벤트 등 다양한 소식을 알려보세요." rows="10"
									name="content" required></textarea>

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

						<!-- ----------------------------------------------------------------- -->
							<div class="card" style="width: 100%;">
								<div class="card-header">
									<i class="bi bi-camera-fill fs-3"></i> <span
										class="fs-4 fw-bold"
										style="font-weight: bold; font-size: 17px;">나의 가게를 소개할
										사진을 등록해주세요.</span>
								</div>
								<br>
								<!-- --------------------------------------첨부파일---------------------------- -->
								<ul class="uploadUl mb8"
									style="list-style-type: none; padding-left: 0;">

									<li><input type="file" name="file1" id="file"
										style="width: 80%; height: 30px;" /> <img class="btnP"
										src="<%=request.getContextPath() %>/images/plus.png"
										style="vertical-align: middle; width: 1em; height: 1em;" /> <img
										class="btnM"
										src="<%=request.getContextPath() %>/images/minus.png"
										style="vertical-align: middle; width: 1em; height: 1em;" /></li>

									<li><input type="file" name="file2" id="file"
										style="width: 80%; height: 30px;"> <img class="btnP"
										src="<%=request.getContextPath() %>/images/plus.png"
										style="vertical-align: middle; width: 1em; height: 1em;" /> <img
										class="btnM"
										src="<%=request.getContextPath() %>/images/minus.png"
										style="vertical-align: middle; width: 1em; height: 1em;" /></li>

									<li><input type="file" name="file3" id="file"
										style="width: 80%; height: 30px;" /> <img class="btnP"
										src="<%=request.getContextPath() %>/images/plus.png"
										style="vertical-align: middle; width: 1em; height: 1em;" /> <img
										class="btnM"
										src="<%=request.getContextPath() %>/images/minus.png"
										style="vertical-align: middle; width: 1em; height: 1em;" /></li>
								</ul>
								<!-- ---------- 첨부파일 추가 및 삭제---------------------- -->
							</div>

							<!-- ----------------------------------------------------------------- -->			
	
		 
		  <script>
		/*   첨부파일 유효성검사 */
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
		    
		                if(!validFileType(filename)){
		                    alert("허용되지 않는 확장자의 파일입니다.");
		                    $(this).val(''); // 파일 입력 초기화
		                    return false;
		                }else if(!validFileSize(file)){
		                    alert("파일 크기가 10MB를 초과합니다.");
		                    $(this).val(''); // 파일 입력 초기화
		                    return false;
		                }else if(!validFileNameSize(filename)){
		                    alert("파일명이 30자를 초과합니다.");
		                    $(this).val(''); // 파일 입력 초기화
		                    return false;
		                }
		                // 모든 검증을 통과하면, 해당 입력 필드에 파일명을 설정하거나 이미지를 미리 보기 등 추가적인 작업을 수행할 수 있습니다.
		            }
		        });
		    
		        // 파일 입력 추가/제거에 대한 기존 코드
		        $(document).on("click", ".btnP", function(){
		            var target = $(this);
					var fileNum = Number(target.parent().parent("ul").find("li:last-child").find("input").attr("name").substring(4))+1;
					$('<li><input type="file" name="file'+fileNum+'" id="file" style="width:80%; height:30px;"><img class="btnP" src="<%=request.getContextPath() %>/images/plus.png" style="vertical-align:middle; width:1em; height:1em;"/><img class="btnM" src="<%=request.getContextPath() %>/images/minus.png" style="vertical-align:middle; width:1em; height:1em;"/></li>').insertAfter(target.parent().parent("ul").find("li:last-child")); 
		        });
		        
		        $(document).on("click", ".btnM", function(){
		            var target = $(this);
					var liLen = $(this).parent().parent("ul").find("li").length;
					if(liLen!=1) target.parent().remove();
					else  alert("모두 지울 수 없습니다.");
		        });
		    });
		  
	</script>
		<!-- --------------------------------------첨부파일----------------------------------------->
							<hr>
		<!---------------------------------------- 업체주소 등록하기-------------------------------- -->

							<div class="card" style="width: 100%;">
								<div class="card-header">
									<i class="bi bi-camera-fill fs-3"></i> <span
										class="fs-4 fw-bold"
										style="font-weight: bold; font-size: 17px;">가게를 방문할 수
										있도록 위치를 등록해보세요</span>
								</div>
								<br>
								<div class="text-left" style="padding-left: 10px; padding-bottom: 20px;  padding-top: 10px;" >
								<br>
									<input type="text" id="sample3_postcode" placeholder="우편번호"
										name="post_code" required> <input type="button"
										onclick="sample3_execDaumPostcode()" value="우편번호 찾기">
									<br> <input type="text" id="sample3_address"
										placeholder="주소" name="addr" required> <br> <input
										type="text" id="sample3_detailAddress" placeholder="상호명"
										name="addr_detail" required> <input type="text"
										id="sample3_extraAddress" placeholder="OO동" name="local_extra">
									<!-- 	<button onclick="saveAddressToServer()">저장</button> -->
									<div id="wrap"
										style="display: none; border: 1px solid; width: 500px; height: 300px; margin: 5px 0; position: relative">
										<img src="//t1.daumcdn.net/postcode/resource/images/close.png"
											id="btnFoldWrap"
											style="cursor: pointer; position: absolute; right: 0px; top: -1px; z-index: 1"
											onclick="foldDaumPostcode()" alt="접기 버튼">
									</div>
								</div>
							</div>







							<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
		// 우편번호 찾기 찾기 화면을 넣을 element
		var element_wrap = document.getElementById('wrap');

		function foldDaumPostcode() {
			// iframe을 넣은 element를 안보이게 한다.
			element_wrap.style.display = 'none';
		}

		function sample3_execDaumPostcode() {
			// 현재 scroll 위치를 저장해놓는다.
			var currentScroll = Math.max(document.body.scrollTop,
					document.documentElement.scrollTop);
			new daum.Postcode(
					{
						oncomplete : function(data) {
							// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

							// 각 주소의 노출 규칙에 따라 주소를 조합한다.
							// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
							var addr = ''; // 주소 변수
							var extraAddr = ''; // 참고항목 변수

							//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
							if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
								addr = data.roadAddress;
							} else { // 사용자가 지번 주소를 선택했을 경우(J)
								addr = data.jibunAddress;
							}

							// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
							if (data.userSelectedType === 'R') {
								// 법정동명이 있을 경우 추가한다. (법정리는 제외)
								// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
								if (data.bname !== ''
										&& /[동|로|가]$/g.test(data.bname)) {
									extraAddr += data.bname;
								}
								// 건물명이 있고, 공동주택일 경우 추가한다.
								if (data.buildingName !== ''
										&& data.apartment === 'Y') {
									extraAddr += (extraAddr !== '' ? ', '
											+ data.buildingName
											: data.buildingName);
								}
								// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
								if (extraAddr !== '') {
									extraAddr = extraAddr;
								}
								// 조합된 참고항목을 해당 필드에 넣는다.
								document.getElementById("sample3_extraAddress").value = extraAddr;

							} else {
								document.getElementById("sample3_extraAddress").value = '';
							}

							// 우편번호와 주소 정보를 해당 필드에 넣는다.
							document.getElementById('sample3_postcode').value = data.zonecode;
							document.getElementById("sample3_address").value = addr;
							// 커서를 상세주소 필드로 이동한다.
							document.getElementById("sample3_detailAddress")
									.focus();

							// iframe을 넣은 element를 안보이게 한다.
							// (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
							element_wrap.style.display = 'none';

							// 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
							document.body.scrollTop = currentScroll;
						},
						// 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
						onresize : function(size) {
							element_wrap.style.height = size.height + 'px';
						},
						width : '100%',
						height : '100%'
					}).embed(element_wrap);

			// iframe을 넣은 element를 보이게 한다.
			element_wrap.style.display = 'block';
		}

		function saveAddressToServer() {
			// 주소 정보를 가져옵니다.
			var postcode = document.getElementById('sample3_postcode').value;
			var address = document.getElementById('sample3_address').value;
			var detailAddress = document
					.getElementById('sample3_detailAddress').value;
			var extraAddress = document.getElementById('sample3_extraAddress').value;

			// 띄어쓰기를 제거한 참고항목(extraAddress)
			var extraAddressWithoutSpaces = extraAddress.replace(/\s/g, '');

			// 사용자가 띄어쓰기를 시도한 경우 알람창을 띄우고 처리 중단
			if (extraAddressWithoutSpaces.length !== extraAddress.length) {
				alert('참고항목에 띄어쓰기는 허용되지 않습니다.');
				return; // 처리 중단 역할
			}

			/* // 서버에 전송할 데이터를 만듭니다.
			var data = {
				postcode : postcode, 					 // 우편번호
				address : address,						 // 기본주소
				detailAddress : detailAddress, 			 // 상세주소
				extraAddress : extraAddressWithoutSpaces // 참고항목(동)
			// 띄어쓰기가 제거된 값을 전송
			};
 */
			/* // jQuery를 사용하여 AJAX 요청을 보냅니다.
			$.ajax({
				type : 'POST', // 또는 'GET'
				url : 'findAddressOk.jsp', // 실제 서버 엔드포인트로 대체해야 합니다.
				data : data,
				success : function(response) {
					alert('주소 정보가 성공적으로 저장되었습니다.');
				},
				error : function(error) {
					console.error('주소 정보 저장 중 오류 발생:', error);
					alert('주소 정보 저장 중 오류가 발생했습니다.');
				}
			}); */
		}
	</script>						
<!---------------------------------------- 업체주소 등록하기-------------------------------- -->
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