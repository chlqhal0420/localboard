<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="local.vo.*"%>
<%@ page import="java.util.*"%>
<%@ page errorPage="errorPage.jsp" %>

<%

Member member = (Member) session.getAttribute("login");

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

LocalBoard board = new LocalBoard(); // 동네업체 게시판 결과를 담을 객체
List<BoardFileDetail> bflist = new ArrayList<BoardFileDetail>(); // 게시글 첨부파일 목록 변수

try {
   Class.forName("com.mysql.cj.jdbc.Driver");
   conn = DriverManager.getConnection(url, user, pass);

   //---------------------- 동네업체 게시판 목록 데이터 가져오기 ---------------------------------------------
   String sql =  " SELECT lb_id, content, title, created_at, hit , local_extra, post_code, addr, addr_detail " + "  FROM local_board "
		    + " WHERE lb_id = ? "; 
   
	
   psmt = conn.prepareStatement(sql);
   psmt.setInt(1, lbId);
   rs = psmt.executeQuery();

   if (rs.next()) {
      board.setLbId(rs.getInt("lb_id"));
      board.setContent(rs.getString("content"));
      board.setTitle(rs.getString("title"));
      board.setCreatedAt(rs.getString("created_at"));
      board.setHit(rs.getInt("hit"));
      board.setLocalExtra(rs.getString("local_extra"));
      board.setPostCode(rs.getString("post_code"));
      board.setAddr(rs.getString("addr"));
      board.setAddrDetail(rs.getString("addr_detail"));

   }
   //---------------------- 업체 게시판 목록 데이터 가져오기 ---------------------------------------------

   //---------------------- 첨부 파일 데이터 가져오기 ---------------------------------------------

   if (psmt != null)
      psmt.close();
   if (rs != null)
      rs.close();

   sql = "select * from board_file_detail bfd inner join local_board lb on bfd.file_id = lb.file_id where lb_id = ?";

   psmt = conn.prepareStatement(sql);
   psmt.setInt(1, lbId);

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
							<h2>우리동네 업체소식</h2>
						</div>
						<div class="text-right">
							<button onclick="location.href='list.jsp'" class="btn btn-secondary">목록</button>          
                		</div><br>

                <form name="frm" action="modifyOk.jsp" method="post" enctype="multipart/form-data" id="frm">
					<input type="hidden" name="lb_id" value="<%=board.getLbId()%>">
							
							<div class="input-group flex-nowrap">
								<span class="input-group-text" id="addon-wrapping">제목</span> 
								<input type="text" class="form-control" value="<%=board.getTitle()%>"
									aria-label="Username" aria-describedby="addon-wrapping"
									name="title" required>
							</div>
							<br>

							<div>
								<span class="input-group-text justify-content-center">내용</span>
								<textarea id="summernote" class="form-control"
									aria-label="With textarea" placeholder="내용을 입력하세요." rows="10"
									name="content"  ><%=board.getContent()%></textarea>

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
						<div class="card-body">
	<!-- --------------------------------------첨부파일---------------------------- -->
							
							
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
	<!-- --------------------------------------첨부파일---------------------------- -->
		</div>
		</div>

<!-- ----------------------------------------------------------------- -->			
						
							
		
<script>
//--------마이너스 버튼을 눌렀을때 첨부파일을 삭제하는 함수(ajax통신 이용)-------------------
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

<!---------------------------------------- 업체주소 등록하기-------------------------------- -->
			<div class="card" style="width: 100%;">
								<div class="card-header">
									<i class="bi bi-camera-fill fs-3"></i> <span
										class="fs-4 fw-bold"
										style="font-weight: bold; font-size: 17px;">가게를 방문할 수
										있도록 위치를 등록해보세요</span>
								</div>
								 <div class="card-body">
	<div class="text-left" style="padding-left: 10px; padding-bottom: 20px;">
		<input type="text" id="sample3_postcode" placeholder="우편번호" name="postCode" value="<%=board.getPostCode()%>" required >
		<input type="button" onclick="sample3_execDaumPostcode()"
			value="우편번호 찾기">
		<br>
		<input type="text" id="sample3_address" placeholder="주소" name="addr" value="<%=board.getAddr()%>" required>
		<br>
		<input type="text" id="sample3_detailAddress" placeholder="상세주소" name="addrDetail" value="<%=board.getAddrDetail()%>" required>
		<input type="text" id="sample3_extraAddress" placeholder="참고항목" name="localExtra" value="<%=board.getLocalExtra()%>">
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
	
	
