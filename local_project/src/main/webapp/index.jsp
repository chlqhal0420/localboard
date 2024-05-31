<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<!--  <meta name="keywords" content="" />
  <meta name="description" content="" />
  <meta name="author" content="" /> -->

<title>동네커뮤니티</title>

<!-- slider stylesheet -->
<link rel="stylesheet" type="text/css"
	href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.1.3/assets/owl.carousel.min.css" />

<!-- bootstrap core css -->
<link rel="stylesheet" type="text/css" href="css/bootstrap.css" />

<!-- fonts style -->
<link
	href="https://fonts.googleapis.com/css?family=Poppins:400,600,700&display=swap"
	rel="stylesheet">
<!-- Custom styles for this template -->
<link href="css/style.css" rel="stylesheet" />
<!-- responsive style -->
<link href="css/responsive.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>


</style>
</head>

<body>

	<div class="hero_area">

		<!-- header section strats -->
		<%@ include file="include/header.jsp"%>
		<!-- end header section -->

		<!-- slider section -->
		<section class=" slider_section ">
			<div class="container">
				<div class="row">
					<div class="col-md-6 ">
						<div class="detail_box">
							<h1>
								동네 한 바퀴 커뮤니티를 <br> 소개합니다! <i class="bi bi-emoji-smile"></i>
							</h1>
							<hr><br>
							<h5>여기는 우리동네, 함께 만들어가는 소통의 공간! </h5><br>
							<h5>함께 나누고 소통하며, 작은 것부터 큰 이야기까지 새로운 인연과 소식을 접해보세요.</h5><br>
							<h5>동네 한 바퀴, 당신의 이야기가 우리의 이야기입니다. <i class="bi bi-chat-heart"></i></h5>
							
							
						</div>
					</div>
					
					<div class="col-lg-5 col-md-6 offset-lg-1">
						<div class="img_content">
							<div class="img_container">
								<div id="carouselExampleControls" class="carousel slide"
									data-ride="carousel">
									<div class="carousel-inner">
										<div class="carousel-item active">
											<div class="img-box">
												<img src="images/local.jpg" alt="">
											</div>
										</div>
										<div class="carousel-item">
											<div class="img-box">
												<img src="images/houses.jpg" alt="">
											</div>
										</div>
										<div class="carousel-item">
											<div class="img-box">
												<img src="images/street.jpg" alt="">
											</div>
										</div>
									</div>
								</div>
							</div>
							<a class="carousel-control-prev" href="#carouselExampleControls"
								role="button" data-slide="prev"> <span class="sr-only">Previous</span>
							</a> <a class="carousel-control-next" href="#carouselExampleControls"
								role="button" data-slide="next"> <span class="sr-only">Next</span>
							</a>
						</div>
					</div>
					
					
				</div>
			</div>
		</section>
		<!-- end slider section -->
	</div>



	<!-- info section -->
	<%@ include file="include/info.jsp"%>
	<!-- end info section -->

	<!-- footer section -->
	<%@ include file="include/footer.jsp"%>
	<!-- footer section -->


	<script src="js/jquery-3.4.1.min.js"></script>
	<script src="js/bootstrap.js"></script>

</body>
</html>