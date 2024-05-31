<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="local.vo.Member" %>
<%
	Member memberHeader = (Member)session.getAttribute("login");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
	<header class="header_section">
		<div class="container-fluid">
			<nav class="navbar navbar-expand-lg custom_nav-container ">
				<a class="navbar-brand" href="<%=request.getContextPath()%>/index.jsp"> <span> 동네 한 바퀴 <i class="bi bi-house-heart"></i>
				</span>
				</a>
				<button class="navbar-toggler" type="button" data-toggle="collapse"
					data-target="#navbarSupportedContent"
					aria-controls="navbarSupportedContent" aria-expanded="false"
					aria-label="Toggle navigation">
					<span class="s-1"> </span> <span class="s-2"> </span> <span
						class="s-3"> </span>
				</button>

				<div class="collapse navbar-collapse" id="navbarSupportedContent">
					<div
						class="d-flex ml-auto flex-column flex-lg-row align-items-center">
						<ul class="navbar-nav  ">
							
							<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/free_board/list.jsp">
									자유게시판 </a></li>
							
							<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/together_board/list.jsp">
									같이해요 </a></li>
							<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/qa_board/list.jsp">
									Q &amp; A </a></li>
							<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/company_board/list.jsp">
									동네업체 </a></li>
							
							<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/smalltown_board/list.jsp">
									나작동 </a></li>
							<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/notice_board/list.jsp">
									공지사항 </a></li>
							<%
								if(memberHeader == null){
							%>
							<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/login/joinTerms.jsp">
									회원가입 </a></li>					 		
							<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/login/login.jsp">
									로그인 </a></li>
									
							<%
								}else{
							%>
							
							<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/my_page/myPageList.jsp?
							memberId=<%=memberHeader.getMemberId()%>">
									<%=memberHeader.getNicknm() %></a></li>
							<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/login/logOut.jsp">
									로그아웃 </a></li>
									
							<%
								}
							%>
							
							<%			
							if((memberHeader != null) && (memberHeader.getCodeId() == 'A')){
              				%>
							<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/manager/memberControl.jsp">
									관리자 </a></li>
									<%
										}
									%>
									
									
									
									
						</ul>
					</div>
				</div>
			</nav>
		</div>
	</header>
</body>
</html>