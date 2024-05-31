<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="local.vo.Member.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<%@ page import="java.math.BigInteger"%>
<%@ page import="java.security.SecureRandom"%>
<%@ page import="java.util.Base64"%>
<%
Member member = (Member) session.getAttribute("login");

String mnoParam = request.getParameter("mno");

int memberId = 0;

if (mnoParam != null && !mnoParam.equals("")) {
	memberId = Integer.parseInt(mnoParam);
}

Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;
String url = "jdbc:mysql://localhost:3306/localboard";
String user = "cteam";
String pass = "1234";

int mno = 0;
String email = "";
String password = "";
String nicknm = "";
String phone = "";
String createdAt = "";

try {

	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(url, user, pass);

	String sql = "SELECT * FROM member WHERE member_id = ?";
	psmt = conn.prepareStatement(sql);

	psmt.setInt(1, memberId);

	rs = psmt.executeQuery();

	if (rs.next()) {
		mno = rs.getInt("member_id");
		email = rs.getString("email");
		password = rs.getString("password");
		nicknm = rs.getString("nicknm");
		phone = rs.getString("phone");
		createdAt = rs.getString("created_at");
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

<title>회원정보수정</title>

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
<script src="<%=request.getContextPath()%>/js/jquery-3.4.1.min.js"></script>
<script>
	  	let checkNickRs = false; 
		let checkNickFlag = false;
	  	
	  	
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
	  	
		
		
		function validation(){
			if(checkPass(document.frm.password) & checkNickRs & checkNickFlag
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
</head>
<body class="sub_page">
	<div class="hero_area">
		<!-- header section strats -->
		<%@ include file="/include/header.jsp"%>
		<!-- end header section -->
	</div>

	<!-- member modify section -->

	<section class="about_section layout_padding">		
		<div class="col-md-4 mx-auto">
			
			<h2 class="text-center">
				회원정보 수정
			</h2>			
			<hr>
			<br>
			<br>

			 <!-- 수정 시작-->
                <form name="frm" action="mmodifyOk.jsp" method="post" onsubmit="return validation();">
    				<input type="hidden" name="memberId" value="<%=memberId%>">

						<div class="container text-left">
						 <div class="row-cols-md-4">
						  
						  	<div class="col text-center">
						      <h5><b>이메일</b></h5>
						      <%=member.getEmail() %>
						    </div>
						  </div>
						</div>
						<br>
						
						<table class="table">
						       <thead>
						           <tr>
						               <th>비밀번호</th>
						           </tr>
						       </thead>
						       <tbody>
						           <tr>
						               <td>
						               	<div class="form-group">
						               	<input type="password" id="password" name="password" class="form-control" placeholder="password"
											aria-label="Username" aria-describedby="addon-wrapping" required onblur="checkPass(this)">
						               	</div>
						               	<div class="checkRs"></div>
						               </td>
						           </tr>
						       </tbody>
						    </table>
						    <table class="table">
						       <thead>
						           <tr>
						               <th>연락처</th>
						           </tr>
						       </thead>
						       <tbody>
						           <tr>
						               <td>
						               	 <div class="form-group">
						               	 <input type="text" id="phone" name="phone" class="form-control" placeholder="010-1111-1111"
											aria-label="Username" aria-describedby="addon-wrapping" required onblur="checkPhone(this)">
						               	 </div>
						               	 <div class="checkRs"></div>
						               </td>
						           </tr>
						       </tbody>
						    </table>
						    <table class="table">
						       <thead>
						           <tr>
						               <th>닉네임</th>
						           </tr>
						       </thead>
						       <tbody>
						           <tr>
						               <td>
						               	 <div class="form-group">
						               		<input type="text" id="nicknm" name="nicknm" class="form-control" placeholder="nickname"
												aria-label="Username" aria-describedby="addon-wrapping" required onblur="checkNick(this)">
											<button type="button" class="btn btn-primary onclick=" onclick="checkNickFn(this)">중복확인</button>
						               	 </div>
						               	 <div class="checkRs"></div>
						               </td>
						           </tr>
						       </tbody>
						    </table>
						    <div class="text-center">
						    
						    <div class="btn-group">
						        <button class="btn btn-primary" type="submit">저장</button>
						        <button type="button" onclick="location.href='myPageList.jsp?memberId=<%=member.getMemberId() %>'" class="btn btn-success">뒤로가기</button>
						    </div>
						    </div>
				 </form>
						                
				 <!-- 글쓰기 종료-->
		</div>
		
	</section>

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