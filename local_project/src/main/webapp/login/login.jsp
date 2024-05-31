<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.util.Base64" %>

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
</head>

<body class="sub_page">

	<div class="hero_area">
		<!-- header section strats -->
		<%@ include file="/include/header.jsp"%>
		<!-- end header section -->
	</div>

	<!-- login section -->
	<section class="about_section layout_padding">
		<div class="container">
			<div class="row justify-content-center">
				<!-- 중앙 정렬 클래스 추가 -->
				<div class="col-md-6">
					
						<div class="heading_container">
							<h2>로그인</h2>
						</div>
						<div>동네 한 바퀴에 오신 것을 환영합니다!</div>						
						<hr><br>
						<form action="loginOk.jsp" method="post">
							<div class="input-group flex-nowrap">
								<span class="input-group-text" id="addon-wrapping">Email</span> <input
									type="email" id="email" name="email" class="form-control" placeholder="email"
									aria-label="Username" aria-describedby="addon-wrapping">
							</div>
							<br><br>
							<div class="input-group flex-nowrap">
								<span class="input-group-text" id="addon-wrapping">비밀번호</span> <input
									type="password" id="password" name="password" class="form-control" placeholder="password"
									aria-label="Username" aria-describedby="addon-wrapping">
							</div>
							<br><br>
							<div class="text-center">						
							<button type="submit" class="btn btn-primary">로그인</button>
							</div>
						</form>
						<a href="forgotPassword.jsp">비밀번호를 잊어버렸습니다.</a>
					</div>
				</div>
			</div>
		
	</section>
	
	
	
	

	<!-- end  login section -->


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