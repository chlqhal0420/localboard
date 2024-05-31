<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
	<section class="info_section layout_padding">
		<div class="container">
			<div class="info_contact">
				<div class="row">
					<div class="col-md-4">
						<a href=""> <img
							src="<%=request.getContextPath()%>/images/location-white.png"
							alt=""> <span> Passages of Lorem Ipsum available </span>
						</a>
					</div>
					<div class="col-md-4">
						<a href=""> <img
							src="<%=request.getContextPath()%>/images/telephone-white.png"
							alt=""> <span> Call : +012334567890 </span>
						</a>
					</div>
					<div class="col-md-4">
						<a href=""> <img
							src="<%=request.getContextPath()%>/images/envelope-white.png"
							alt=""> <span> demo@gmail.com </span>
						</a>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-md-8 col-lg-9">
					<div class="info_form">
						<form action="">
							<input type="text" placeholder="Enter your email">
							<button>subscribe</button>
						</form>
					</div>
				</div>
				<div class="col-md-4 col-lg-3">
					<div class="info_social">
						<div>
							<a href=""> <img
								src="<%=request.getContextPath()%>/images/fb.png" alt="">
							</a>
						</div>
						<div>
							<a href=""> <img
								src="<%=request.getContextPath()%>/images/twitter.png" alt="">
							</a>
						</div>
						<div>
							<a href=""> <img
								src="<%=request.getContextPath()%>/images/linkedin.png" alt="">
							</a>
						</div>
						<div>
							<a href=""> <img
								src="<%=request.getContextPath()%>/images/instagram.png" alt="">
							</a>
						</div>
					</div>
				</div>
			</div>

		</div>
	</section>
</body>
</html>