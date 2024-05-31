<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

   <title>동네한바퀴 회원가입 약관동의</title>

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
  <style type="text/css">
  	.terms_item{
  		padding: 0px;
  		margin: 0px;
  		display: none; /* 초기에는 숨김 상태 */
  	.terms_view
  	}
  	.check_terms a{
  		margin: 0!important;
  		display: none; /* 초기에는 숨김 상태 */
  	}
  </style>
  <script type="text/javascript">
  	
  	function openTerms1() {
	   window.open("./terms/serviceTerms.jsp", "약관동의", "width=600, height=800, toolbar=no, menubar=no, scrollbars=no, resizable=yes")
	}
  	
  	function openTerms2() {
 	   window.open("./terms/privacyInfoAgree.jsp", "약관동의", "width=600, height=800, toolbar=no, menubar=no, scrollbars=no, resizable=yes")
 	}
  	
  	// 모든 약관에 동의 체크박스 선택 시, 필수 약관들을 모두 선택하도록 하는 함수
    function checkAllTerms() {
      var checkAll = document.getElementById("checkAll");
      var termsServiceCheckboxes = document.getElementsByName("termsService");
      var termsItems = document.getElementsByClassName("terms_item");

      for (var i = 0; i < termsServiceCheckboxes.length; i++) {
        termsServiceCheckboxes[i].checked = checkAll.checked;
        // 체크박스가 체크되면 해당 약관 아이템을 나타나게 함
        termsItems[i].style.display = checkAll.checked ? "block" : "none";
      }
    }
  	
    // 폼 제출 시 약관 동의 확인
    function validateTermsAgreement() {
      var termsServiceCheckboxes = document.getElementsByName("termsService");
      var isAllChecked = true;

      for (var i = 0; i < termsServiceCheckboxes.length; i++) {
        if (!termsServiceCheckboxes[i].checked) {
          isAllChecked = false;
          break;
        }
      }

      if (!isAllChecked) {
        alert('필수 항목에 모두 동의하여야 합니다');
        return false; // 폼 제출을 중단
      }

      return true; // 폼 제출을 진행
    }
  	
  </script>
  
</head>
<body class="sub_page">
  <div class="hero_area">
	<!-- header section strats -->
	<%@ include file="/include/header.jsp"%>
	<!-- end header section -->
  </div>
  
  
  <section class="about_section layout_padding">
    
        <div class="row justify-content-center">
            <div class="col-md-3 mx-auto text-center">
                <div class="text-center">
                    <h2>회원가입 약관동의</h2>
                </div>
                <hr>
                <br><br>
                <div class="text-left">
                <p>회원가입을 위해 약관에 동의해주세요</p>
                <form action="join.jsp" method="post" id="form__wrap" onsubmit="return validateTermsAgreement();">
                    <div class="checkAll">
                        <input type="checkbox" id="checkAll" name="checkAll" onclick="checkAllTerms()">
                        <label for="checkAll">필수 약관에 전부 동의합니다.</label>
                    </div>
                    <ul class="terms_list">
                        <li class="terms_item">
                            <div class="check_terms">
                                <input type="checkbox" id="termsService" name="termsService">
                                <label for="termsService">[필수] 만 14세 이상입니다.</label>
                            </div>
                        </li>
                        <li class="terms_item">
                            <div class="check_terms">
                                <input type="checkbox" id="termsService" name="termsService">
                                <label for="termsService">[필수] 동네 한 바퀴 서비스 이용약관 동의</label>
                                <a class="termsview" onclick="openTerms1()" style="background-color: transparent; color: purple;">보기></a>
                            </div>
                        </li>
                        <li class="terms_item">
                            <div class="check_terms">
                                <input type="checkbox" id="termsService" name="termsService">
                                <label for="termsService">[필수] 개인정보 수집 및 이용 동의</label>
                                <a class="termsview" onclick="openTerms2()" style="background-color: transparent; color: purple;">보기></a>
                            </div>
                        </li>
                    </ul>
                    <div class="nonEssential">
                        <input type="checkbox" id="nonEssential" name="checkAll">
                        <label for="nonEssential">[선택] 마케팅 정보 수신에 대해 동의합니다.</label>
                    </div>
                    <br>
                    <div class="text-center">                   
                    <button type="submit" class="btn btn-primary">회원가입하러가기</button>
                    </div>
                </form>
                
                </div>
            </div>
        </div>
    
</section>

  
  
  <!-- info section -->
  <%@ include file="/include/info.jsp"%>
  <!-- end info section -->

  <!-- footer section -->
  <%@ include file="/include/footer.jsp"%>
  <!-- footer section -->


  <script src="/js/jquery-3.4.1.min.js"></script>
  <script src="/js/bootstrap.js"></script>
</body>
</html>