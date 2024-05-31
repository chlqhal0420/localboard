<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.math.BigInteger" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.util.Base64" %>

<%!
//스크립트릿 내에 generateSalt 메서드 정의
String generateSalt() {
    SecureRandom random = new SecureRandom();
    byte[] saltBytes = new byte[16];
    random.nextBytes(saltBytes);
    return bytesToHex(saltBytes);
}

// 바이트 배열을 16진수 문자열로 변환하는 메서드
String bytesToHex(byte[] bytes) {
    StringBuilder result = new StringBuilder();
    for (byte b : bytes) {
        result.append(String.format("%02x", b));
    }
    return result.toString();
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
  <script>
  	let checkNickRs = false; 
	let checkNickFlag = false;
  
	function checkEmail(obj){
  		let regId = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
		let regRs = regId.test(obj.value)
		let checkRs = obj.parentElement.nextElementSibling;
		if(obj.value == ""){
			checkRs.innerHTML = '필수입력입니다.';
			checkRs.style.color = 'red';
			return false;
		}else if(!regRs){
			checkRs.innerHTML = '유효한 이메일 형식이 아닙니다.';
			checkRs.style.color = 'red';
			return false;
		}else{
			checkRs.innerHTML = '이메일 중복확인을 해주세요.';
			checkRs.style.color = 'red';
			checkNickRs = true;
			return true;
		}
  	}
  	
	function checkEmailFn(obj) {
  		// 이메일 중복확인 함수
  			
  			let email = document.frm.email.value;
  			let checkRs = obj.parentElement.nextElementSibling;
  			
  			if(!checkNickRs){
  				checkRs.innerHTML = '이메일을 입력하세요.';
  				checkRs.style.color = 'red';
  				checkNickFlag = false;
  				return false;
  			}else{
  				$.ajax({
  					url : "checkEmail.jsp",
  					type : "get",
  					data : {email : email},
  					success : function(data){
  						//0 :사용가능, 1:사용 불가능
  						let result = data.trim();
  						if(result == 0){
  							checkNickFlag = true;
  							checkRs.innerHTML = '사용 가능합니다.';
  							checkRs.style.color = 'green';
  						}else{
  							checkNickFlag = false;
  							checkRs.innerHTML = '이미 존재하는 이메일입니다.';
  							checkRs.style.color = 'red';
  						}
  					},error:function(){
  						console.log("error");
  						checkNickFlag = false;
  					}
  				});
  			}
  			
  			
  		}
  	
  	
  	
  	function checkPass(obj){
		let regId =  /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,15}$/;  /* /^[a-zA-Z0-9](?=,*[a-zA-Z])(?=,*[0-9])/g; */
		let regRs = regId.test(obj.value)
		let checkRs = obj.parentElement.nextElementSibling;
		if(obj.value == ""){
			checkRs.innerHTML = '필수입력입니다.';
			checkRs.style.color = 'red';
			return false;
		}else if(obj.value.length < 6){
			checkRs.innerHTML = '여섯 자리 이상 입력하세요.';
			checkRs.style.color = 'red';
			return false;
		}else if(!regRs){
			checkRs.innerHTML = '숫자, 영문, 특수문자 조합만 입력 가능합니다.';
			checkRs.style.color = 'red';
			return false;
		}else{
			checkRs.innerHTML = '사용가능합니다.';
			checkRs.style.color = 'green';
			return true;
		}
	}
  	
  	function checkPassRe(obj){
		let confirmPass = document.getElementById("password").value == obj.value;
		let checkRs = obj.parentElement.nextElementSibling;
		if(obj.value == ""){
			checkRs.innerHTML = '필수입력입니다.';
			checkRs.style.color = 'red';
			return false;
		}else if(!confirmPass){
			checkRs.innerHTML = '비밀번호가 일치하지 않습니다.';
			checkRs.style.color = 'red';
			return false;
		}else{
			checkRs.innerHTML = '사용가능합니다.';
			checkRs.style.color = 'green';
			return true;
		}
	}
  	
  	function checkName(obj){
		let regId = /[^가-힣]/g;
		let regRs = regId.test(obj.value)
		let checkRs = obj.parentElement.nextElementSibling;
		if(obj.value == ""){
			checkRs.innerHTML = '필수입력입니다.';
			checkRs.style.color = 'red';
			return false;
		}else{
			checkRs.innerHTML = '사용가능합니다.';
			checkRs.style.color = 'green';
			return true;
		}
	}
  	
  	function checkNick(obj){
		let checkRs = obj.parentElement.nextElementSibling;
		if(obj.value == ""){
			checkRs.innerHTML = '필수입력입니다.';
			checkRs.style.color = 'red';
			checkNickRs = false;
			return false;
		}else{
			checkRs.innerHTML = '닉네임 중복확인을 해주세요.';
			checkRs.style.color = 'red';
			checkNickRs = true;
			return true;
		}
	}
	

	function checkNickFn(obj){
		//닉네임 중복확인 함수
		
		let nickname = document.frm.nicknm.value;
		let checkRs = obj.parentElement.nextElementSibling;
		
		if(!checkNickRs){
			checkRs.innerHTML = '닉네임을 입력하세요.';
			checkRs.style.color = 'red';
			checkNickFlag = false;
			return false;
		}else{
			$.ajax({
				url : "checkNickname.jsp",
				type : "get",
				data : {nickname : nickname},
				success : function(data){
					//0 :사용가능, 1:사용 불가능
					let result = data.trim();
					if(result == 0){
						checkNickFlag = true;
						checkRs.innerHTML = '사용 가능합니다.';
						checkRs.style.color = 'green';
					}else{
						checkNickFlag = false;
						checkRs.innerHTML = '이미 존재하는 닉네임입니다.';
						checkRs.style.color = 'red';
					}
				},error:function(){
					console.log("error");
					checkNickFlag = false;
				}
			});
		}
			
	} 
  	
	function checkPhone(obj){
		let regId = /[^0-9]/g;
		let regRs = regId.test(obj.value)
		let checkRs = obj.parentElement.nextElementSibling;
		if(obj.value == ""){
			checkRs.innerHTML = '필수입력입니다.';
			checkRs.style.color = 'red';
			return false;
		}else if(obj.value.length < 13 || obj.value.length > 13){
			checkRs.innerHTML = '유효한 휴대폰번호가 아닙니다.';
			checkRs.style.color = 'red';
			return false;
		}else{
			checkRs.innerHTML = '사용가능합니다.';
			checkRs.style.color = 'green';
			return true;
		}
	}
	
	function validation(){
		if(checkPass(document.frm.password) & checkPassRe(document.frm.passwordre)
				& checkNickRs & checkNickFlag
				& checkEmail(document.frm.email) 
				& checkPhone(document.frm.phone)){
			return true;
		}else{
			alert("입력란을 모두 작성하세요.");
			return false;
		}
		
		
	}
	
	function resetFn(){
		checkNickFlag = false;
	}
  	
  	
  </script>
  <script>
	document.addEventListener("DOMContentLoaded", function() {
	    // 페이지 로딩이 완료된 후에 실행될 코드
	
	    // 라디오 버튼 요소를 가져옵니다.
	    var businessRadio = document.querySelector('input[name="selectType"][value="C"]');
	    var normalRadio = document.querySelector('input[name="selectType"][value="N"]');
	    // 사업자 등록번호 입력 창을 감싸는 div 요소를 가져옵니다.
	    var businessNumberGroup = document.getElementById('businessRegistrationNumberGroup');
	
	    // 라디오 버튼의 변경을 감지하는 이벤트 리스너를 추가합니다.
	    businessRadio.addEventListener('change', function() {
	        // 라디오 버튼이 체크된 상태인 경우
	        if (businessRadio.checked) {
	            // 사업자 등록번호 입력 창을 나타나게 합니다.
	            businessNumberGroup.style.display = 'block';
	        } else {
	            // 라디오 버튼이 체크되지 않은 경우
	            // 사업자 등록번호 입력 창을 숨깁니다.
	            businessNumberGroup.style.display = 'none';
	        }
    	});
	
	   // 일반회원 라디오 버튼의 변경을 감지하는 이벤트 리스너를 추가합니다.
	   normalRadio.addEventListener('change', function() {
	   // 일반회원 라디오 버튼이 체크된 경우
	   if (normalRadio.checked) {
	   // 사업자 등록번호 입력 창을 숨깁니다.
	   businessNumberGroup.style.display = 'none';
	   }
	 });
	    
    // 회원 가입 폼 제출 시 유효성 검사 함수를 호출합니다.
    document.forms["frm"].addEventListener('submit', function(event) {
        // 사업자 회원 라디오 버튼이 선택된 경우에만 유효성 검사 수행
        if (businessRadio.checked) {
            if (!validateBusinessRegistrationNumber()) {
                event.preventDefault(); // 폼 제출을 막습니다.
                alert("올바른 형식의 사업자 등록번호를 입력하세요.");
            }
        }
    });

    // 사업자 등록번호 유효성 검사 함수
    function validateBusinessRegistrationNumber() {
        var businessNumberInput = document.getElementById('businessRegistrationNumber');
        var businessNumberPattern = /^\d{3}-\d{2}-\d{5}$/;

        if (!businessNumberPattern.test(businessNumberInput.value)) {
            // 유효하지 않은 형식의 사업자 등록번호인 경우
            return false;
        }

        // 유효한 형식의 사업자 등록번호인 경우
        return true;
    }
});
</script>
</head>

<body class="sub_page">

  <div class="hero_area">
    <!-- header section strats -->
    <%@ include file="/include/header.jsp" %>
    <!-- end header section -->
  </div>



  <!-- join section -->
	<section class="about_section layout_padding">
		<div class="container">
			<div class="row justify-content-center">
				<!-- 중앙 정렬 클래스 추가 -->
				<div class="col-md-6">
						<div class="heading_container">
							<h2>회원가입</h2>
						</div>					
						<p>동네 한 바퀴의 일원이 되신 것을 축하드립니다!</p>
						<hr><br>
						<!-- 회원가입 시작 -->
						<form name="frm" action ="joinOk.jsp" method="post" onsubmit="return validation();">
							<input type="hidden" name="salt" id="salt" value="<%= generateSalt() %>" />
							<div class="input-group flex-nowrap form-group">
								<input type="radio" id="selectType" name="selectType" value="C">사업자회원
								&nbsp;&nbsp;<input type="radio" id="selectType" name="selectType" value="N" checked>일반회원
							</div>
							<!-- 사업자 등록번호 입력 창 (기본적으로는 숨김) -->
							<div class="input-group flex-nowrap form-group" id="businessRegistrationNumberGroup" style="display:none;">
    							<span class="input-group-text text-left" id="addon-wrapping" style="width: auto; display: inline;">사업자 등록번호</span>
    							<input type="text" id="businessRegistrationNumber" name="businessRegistrationNumber" 
    								class="form-control" placeholder="123-45-67890" pattern="\d{3}-\d{2}-\d{5}"
    								title="올바른 형식의 사업자 등록번호를 입력하세요." aria-label="Business Registration Number" 
    								aria-describedby="addon-wrapping" style="width: auto;"/>
							</div>
							<div class="input-group flex-nowrap form-group">
								<span class="input-group-text" id="addon-wrapping">Email</span> 
								<label for="email"></label>
								<input type="email" id="email" name="email" class="form-control" placeholder="email"
									aria-label="Username" aria-describedby="addon-wrapping" required onblur="checkEmail(this)" >
								<button type="button" class="btn btn-primary onclick=" onclick="checkEmailFn(this)">중복확인</button>
							</div>
							<div class="checkRs"></div>
							<br>
							<div class="input-group flex-nowrap form-group">
								<span class="input-group-text" id="addon-wrapping">비밀번호</span> 
								<label for="password"></label>
								<input type="password" id="password" name="password" class="form-control" placeholder="password"
									aria-label="Username" aria-describedby="addon-wrapping" required onblur="checkPass(this)">
							</div>
							<div class="checkRs"></div>
							<br>
							<div class="input-group flex-nowrap form-group">
								<span class="input-group-text" id="addon-wrapping">비밀번호 재입력</span>
								<label for="password"></label> 
								<input type="password" id="passwordre" name="passwordre" class="form-control" placeholder="password"
									aria-label="Username" aria-describedby="addon-wrapping" required onblur="checkPassRe(this)">
							</div>
							<div class="checkRs"></div>
							<br>
							<div class="input-group flex-nowrap form-group">
								<span class="input-group-text" id="addon-wrapping">닉네임</span> 
								<label for="nicknm"></label>
								<input type="text" id="nicknm" name="nicknm" class="form-control" placeholder="nickname"
									aria-label="Username" aria-describedby="addon-wrapping" required onblur="checkNick(this)">
								<button type="button" class="btn btn-primary onclick=" onclick="checkNickFn(this)">중복확인</button>
							</div>
							<div class="checkRs"></div>
							<br>
							<div class="input-group flex-nowrap form-group">
								<span class="input-group-text" id="addon-wrapping">연락처</span> 
								<label for="phone"></label>
								<input type="text" id="phone" name="phone" class="form-control" placeholder="010-1111-1111"
									aria-label="Username" aria-describedby="addon-wrapping" required onblur="checkPhone(this)">
							</div>
							<div class="checkRs"></div>
							<br>
							<!----------------------------------------------- 다음 API 사용하여 지역 정보 받기 ----------------------------------------->
							<div class="text-center">
							<input type="text" id="sample3_postcode" name="postcode" placeholder="우편번호" style="width: 250px;" required>
                            <input type="button" onclick="sample3_execDaumPostcode()" value="우편번호 찾기"> 
                            <br>

                            <input type="text" id="sample3_address" name="address" placeholder="주소" style="width: 370px;" required> 
                            <br> 
                            <input type="text" id="sample3_detailAddress" name="detailAddress" placeholder="상세주소" style="width: 370px;">
                            <br> 
                            <input type="text" id="sample3_extraAddress" name="extraAddress" placeholder="OO동/OO면/OO읍 입력해주세요!" 
                            	   onblur="saveAddressToServer()" style="width: 370px;" required></div>


							<div id="wrap"
								style="display: none; border: 1px solid; width: 500px; height: 300px; margin: 5px 0; position: relative">
								<img src="//t1.daumcdn.net/postcode/resource/images/close.png"
									id="btnFoldWrap"
									style="cursor: pointer; position: absolute; right: 0px; top: -1px; z-index: 1"
									onclick="foldDaumPostcode()" alt="접기 버튼">
							</div>
							<!----------------------------------------------- 다음 API 사용하여 지역 정보 받기 ----------------------------------------->

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
								    var postcode = document.getElementById('sample3_postcode').value;
								    var address = document.getElementById('sample3_address').value;
								    var detailAddress = document.getElementById('sample3_detailAddress').value;
								    var extraAddress = document.getElementById('sample3_extraAddress').value;
						
								    
								    // extraAddress 값이 띄어쓰기가 되어 있는지 확인
								    var extraAddressWithoutSpaces = extraAddress.replace(/\s/g, '');
								    if (extraAddressWithoutSpaces.length !== extraAddress.length) {
								        alert('띄어쓰기는 허용되지 않습니다.');
								        return;
								    }
						
								   
						
								    // extraAddress 값이 비어있는지 확인
								    if (extraAddressWithoutSpaces === '') {
								        alert('현재 거주하고 계신 "OO동/OO면/OO읍"을 입력해주세요.');
								        return;
								    }
						
								    var data = {
								        postcode: postcode,
								        address: address,
								        detailAddress: detailAddress,
								        extraAddress: extraAddressWithoutSpaces
								    };
						
								}
						      </script>
							<div class="text-center">
								<br>
								<button type="submit" class="btn btn-primary">가입하기</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		
	</section>

	<!-- end  join section -->
  

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