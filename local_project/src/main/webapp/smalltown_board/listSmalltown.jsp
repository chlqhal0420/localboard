<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page errorPage="errorPage.jsp" %>
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
</head>

<body class="sub_page">

	<div class="hero_area">
    <!-- header section strats -->
    <%@ include file="/include/header.jsp" %>
    <!-- end header section -->
	</div>


  <!-- about section -->
  <section class="about_section layout_padding">
    <div class="container">
      <div class="row">
        <div class="col-md-6">
          <div class="detail-box">
            <div class="heading_container">
              <h2>
               나작동
              </h2>
             <!--  <img src="/images/plug.png" alt=""> -->
            </div>
            <p>
              지역의 아름다운 풍경, 특별한 장소를 사진과 함께 공유
            </p>
          </div>
        </div>
      

      </div>
    </div>
  </section>
  <!-- end about section -->
  

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