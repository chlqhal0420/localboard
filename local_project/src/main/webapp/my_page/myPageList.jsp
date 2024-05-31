<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="local.vo.Member" %> 
<%
	
	Member member = (Member)session.getAttribute("login");

	String mnoParam = request.getParameter("memberId");

	int memberId=0;

	if(mnoParam != null && !mnoParam.equals("")){
		memberId = Integer.parseInt(mnoParam);
	}
	
	Connection conn = null;
	PreparedStatement psmt= null;
	ResultSet rs = null;
	String url = "jdbc:mysql://localhost:3306/localboard";
	String user = "cteam";
	String pass = "1234";
	
	String email = "";
	String password = "";
	String nicknm = "";
	String phone = "";
	String createdAt = "";
	
	
	try{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "SELECT email, nicknm,password, phone, created_at FROM member WHERE member_id = ?";
		psmt = conn.prepareStatement(sql);
		
		psmt.setInt(1,memberId);
		
		rs = psmt.executeQuery();
		
		if(rs.next()){
			email = rs.getString("email");
			password = rs.getString("password");
			nicknm = rs.getString("nicknm");
			phone = rs.getString("phone");
			createdAt = rs.getString("created_at");
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
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

  <title>마이페이지</title>

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
    <style>
      
        .about_section {
            padding: 50px 0;
        }

        .col-md-6 {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            background-color: lightyellow;
        }

        .profile-img {
            border-radius: 50%;
            width: 140px;
            height: 140px;
        }

       
    </style>
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
        <div class="row justify-content-center">
            <div class="col-md-6">              
                    <h2 class="mb-4 text-center"><b>마이페이지</b></h2>
                    <div class="row">
                        <div class="col-md-4">
                            <ul class="navbar-nav">
                                <!-- 로그인시 나오도록 -->
                                <li class="nav-item">
                                    <img src="<%=request.getContextPath() %>/images/cafe9.jpg" class="profile-img"/>
                                </li>
                            </ul>
                        </div>
                        <div class="col-md-8">
                            <table class="table">
                                <tr>
                                    <th scope="col">닉네임</th>
                                    <td><b><%=nicknm %></b></td>
                                </tr>
                                <tr>
                                    <th scope="col">이메일</th>
                                    <td><b><%=email %></b></td>
                                </tr>
                                <tr>
                                    <th scope="col">연락처</th>
                                    <td><b><%=phone %></b></td>
                                </tr>
                                <tr>
                                    <th scope="col">가입일</th>
                                    <td><b><%=createdAt %></b></td>
                                </tr>
                            </table>
                        </div>
                    </div><br>
                    <div class="d-grid gap-2 d-md-block text-center">
                        <button type="button" class="btn btn-primary" onclick="location.href='mmodify.jsp?mno=<%=member.getMemberId()%>'">회원정보수정</button>
                        <button type="button" class="btn btn-danger" onclick="document.frm.submit();">탈퇴</button>
						
                        <form name="frm" action="mdelete.jsp" method="post">
                            <input type="hidden" name="memberId" value="<%= memberId%>">
                        </form><br>
                        
                        <button type="button" class="btn btn-info" onclick="location.href='myWrite.jsp?memberId=<%=member.getMemberId()%>'">내가 쓴 글 보기</button>
                    
                        <button type="button" class="btn btn-info" onclick="location.href='myLike.jsp?memberId=<%=member.getMemberId()%>'">좋아요 한 글 보기</button>
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