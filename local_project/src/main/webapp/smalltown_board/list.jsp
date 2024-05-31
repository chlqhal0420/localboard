<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="local.vo.*"%>
<%@ page import="java.sql.*"%>
<%@ page errorPage="errorPage.jsp" %>
<%
Member member = (Member) session.getAttribute("login");

request.setCharacterEncoding("UTF-8");

String searchType = request.getParameter("searchType");
String searchValue = request.getParameter("searchValue");

String nowPageParam = request.getParameter("nowPage");

int nowPage = 1;
if (nowPageParam != null && !nowPageParam.equals("")) {
	nowPage = Integer.parseInt(nowPageParam);
}

Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;
String url = "jdbc:mysql://localhost:3306/localboard";
String user = "cteam";
String pass = "1234";

PagingVO pagingVO = null;

try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(url, user, pass);

	String totalSql = "SELECT count(*) as cnt " + "  FROM board b      " + " INNER JOIN member m"
	+ " ON b.created_by = m.member_id   " + " WHERE b.delyn = 'N' AND b.type = 'S'"; // F : 자유게시판 

	if (searchType != null) {
		if (searchType.equals("title")) {
	totalSql += " AND title LIKE CONCAT('%',?,'%') ";
		} else if (searchType.equals("nicknm")) {
	totalSql += " AND m.nicknm LIKE CONCAT('%',?,'%')";
		}
	}

	psmt = conn.prepareStatement(totalSql);
	if (searchType != null && (searchType.equals("title") || searchType.equals("nicknm"))) {
		psmt.setString(1, searchValue);
	}
	rs = psmt.executeQuery();

	int totalCnt = 0;

	if (rs.next()) {
		totalCnt = rs.getInt("cnt");
	}
	

	if (rs != null)
		rs.close();
	if (psmt != null)
		psmt.close();

	//paging 객체 생성
	pagingVO = new PagingVO(nowPage, totalCnt, 8);

	rs = null;
	/* String sql = "SELECT board_id, title, m.nicknm, b.created_at, b.hit, m.addr_extra " + "  FROM board b      "
	+ " INNER JOIN member m" + " ON b.created_by = m.member_id   " + " WHERE b.delyn = 'N' AND b.type = 'S'"; // F : 자유게시판  */
	
	String sql= " SELECT b.board_id, b.title, m.nicknm, b.created_at, b.hit, m.addr_extra, "
		    	+" COALESCE(bl.total_count, 0) AS like_count, "
		    	+" COALESCE(c.comment_count, 0) AS comment_count, "
		    	+" bfd.file_real_nm,bfd.file_thumbnail_nm "
				+" FROM board b INNER JOIN member m ON b.created_by = m.member_id "
				+" LEFT JOIN (SELECT board_id, SUM(count) AS total_count FROM board_like GROUP BY board_id) bl ON b.board_id = bl.board_id "
				+" LEFT JOIN (SELECT board_id, COUNT(*) AS comment_count FROM comment WHERE delyn = 'N' GROUP BY board_id) c ON b.board_id = c.board_id "
				+" LEFT JOIN board_file_detail bfd ON b.file_id = bfd.file_id "
				+" WHERE b.delyn = 'N' AND b.type = 'S'";

	if (searchType != null) {
		if (searchType.equals("title")) {
	sql += " AND title LIKE CONCAT('%',?,'%') ";
		} else if (searchType.equals("nicknm")) {
	sql += " AND m.nicknm LIKE CONCAT('%',?,'%')";
		}
	}
	sql += " ORDER BY board_id desc ";
	sql += " limit ?, ?";

	psmt = conn.prepareStatement(sql);

	if (searchType != null && (searchType.equals("title") || searchType.equals("nicknm"))) {
		psmt.setString(1, searchValue);
		psmt.setInt(2, pagingVO.getStart() - 1);
		psmt.setInt(3, pagingVO.getPerPage());
	} else {
		psmt.setInt(1, pagingVO.getStart() - 1);
		psmt.setInt(2, pagingVO.getPerPage());
	}

	rs = psmt.executeQuery();
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

<!-- 아이콘 CDN -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.0/css/all.min.css"
	rel="stylesheet">
<style>
.rounded-circle {
	border-radius: 50% !important;
}

.ms-3 {
	margin-left: 1rem !important;
}
</style>
</head>

<body class="sub_page">
	<div class="hero_area">
		<!-- 헤더 section strats -->
		<%@ include file="/include/header.jsp"%>
		<!-- end 헤더 section -->
	</div>

	<!-- about section -->
	<section class="about_section layout_padding">
		<div class="container">
			<div class="heading_container">
				<h2>내가 사는 작은 동네</h2>
			</div>
			<p>우리 동네의 명소와 내가 방문한 장소를 공유해보세요</p>
			
			  <!-- ----------------------검색창 ---------------------------->
            <div class="d-flex justify-content-center align-items-center my-3">
                <form name="frm" action="list.jsp" method="get" class="form-inline">
                    <select name="searchType" class="form-control mr-2">
                        <option value="title" <%if (searchType != null && searchType.equals("title")) out.print("selected");%>>제목</option>
                        <option value="nickname" <%if (searchType != null && searchType.equals("nickname")) out.print("selected");%>>작성자</option>
                    </select>
                    <input type="text" name="searchValue" value="<%if (searchValue != null) out.print(searchValue);%>" class="form-control mr-2">
                    <button type="submit" class="btn btn-primary">검색</button>
                </form>
            </div>
			<!-- ---------------------검색창(끝) ------------------------------>
			
			<div class="text-right">
				<button onclick="goToPage()" type="button"
					class="btn btn-info">글쓰기</button>
			</div>
			
			  <!-- 로그인한 사용자에게만 글쓰기 가능 -->
            <script>
            function goToPage(){
            	let loginMember = '<%=member%>'; 
            	if(loginMember != 'null'){
            		location.href='write.jsp';
            }else{
            	alert("로그인을 하신 후 이용해 주시기 바랍니다.");
            	location.href='<%=request.getContextPath()%>/login/login.jsp';
            	}
            }
            </script>        
			
			
			<br>
			<div class="row">
				<%
					while (rs.next()) {
						int boardId = rs.getInt("board_id");
						String title = rs.getString("title");
						String nicknm = rs.getString("nicknm");
						String created_at = rs.getString("created_at");
						int hit = rs.getInt("hit");
						String addrExtra = rs.getString("addr_extra");
						int likeCount=rs.getInt("like_count");
						int commentCount =rs.getInt("comment_count");
						String file_real_nm= rs.getString("file_real_nm");
						String file_thumbnail_nm=rs.getString("file_thumbnail_nm");
						
						
				%>


				<!-- --------------------------------게시글 출력부분(시작)--------------------------------------- -->
				<div class="col-md-3 mt-2 mb-2">
					<div class="card" style="width: 18rem; height: 350px;">

						<div
							style="position: absolute; top: 0; left: 0; background-color: rgba(0, 0, 0, 0.5); color: white; padding: 5px; z-index: 1;">
							<small><%=boardId%></small>
						</div>


						<img src="<%=request.getContextPath()%><%= file_thumbnail_nm %>/<%= file_real_nm %>" class="card-img-top" alt="..." height="200">

						<div class="card-body">
							<h5 class="card-title d-inline-block text-truncate"
								style="max-width: 250px;">
								<a href="view.jsp?board_id=<%=boardId%>"><%=title%></a>
							</h5>
					<%-- 		<h5 class="card-text d-inline-block text-truncate"
								style="max-width: 250px; max-height: 100px"><%=content %></h5> --%>

							<div
								class="d-flex justify-content-between border-top border-secondary p-4">
								<div class="d-flex align-items-center">
								<!-- 	<img class="rounded-circle me-2"
										src="https://search.pstatic.net/sunny/?src=https%3A%2F%2Fpng.pngtree.com%2Fpng-vector%2F20231113%2Fourlarge%2Fpngtree-a-red-apple-png-image_10577760.png&type=a340"
										width="30" height="30" alt=""> --> <small
										class="text-uppercase">&nbsp;<%=nicknm%>&nbsp;</small>
								</div>
								<div class="d-flex align-items-center">
									<small class="ms-3"><i
										class="fa fa-heart text-secondary me-2"></i>&nbsp;<%=likeCount%>&nbsp;</small> <small
										class="ms-3"><i class="fa fa-eye text-secondary me-2"></i>&nbsp;
										<%=hit%>&nbsp;</small><small class="ms-3"><i
										class="fa fa-comment text-secondary me-2"></i>&nbsp;<%=commentCount %>&nbsp;</small>

								</div>
							</div>
						</div>
						<!-- </a> -->
					</div>

				</div>
				<%
						}
					%>
				<!-- --------------------------게시글 출력부분(끝)-------------------------- -->
						
				
			</div>
			<!----------------------------------- 페이징 영역 -------------------------------------------------------------------------------->
		<br>
		<div class="container">
			<div class="row justify-content-center">
				<div class="paging">
					<ul class="pagination">
						<%
						if (pagingVO.getStartPage() > pagingVO.getCntPage()) {
						%>
						<li class="page-item"><a class="page-link"
							href="list.jsp?nowPage=<%=pagingVO.getStartPage() - 1%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>"
							aria-label="Previous"> <span aria-hidden="true">&laquo;</span>
						</a></li>
						<%
						}
						%>

						<%
						for (int i = pagingVO.getStartPage(); i <= pagingVO.getEndPage(); i++) {
						%>
						<li class="page-item <%=(nowPage == i) ? "active" : ""%>">
							<%
							if (nowPage == i) {
							%> <span class="page-link"><b><%=i%></b></span>
							<%
							} else {
							%> <%
							 if (searchType != null) {
							 %> <a class="page-link" href="list.jsp?nowPage=<%=i%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>"><%=i%></a>
							<%
							} else {
							%> <a class="page-link" href="list.jsp?nowPage=<%=i%>"><%=i%></a>
							<%
							}
							%> 
							<%
							 }
							 %>
						</li>
						<%
						}
						%>

						<%
						if (pagingVO.getEndPage() < pagingVO.getLastPage()) {
						%>
						<li class="page-item"><a class="page-link"
							href="list.jsp?nowPage=<%=pagingVO.getEndPage() + 1%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>"
							aria-label="Next"> <span aria-hidden="true">&raquo;</span>
						</a></li>
						<%
						}
						%>
					</ul>
				</div>
				<!-- 페이징 영역 끝 -->
		</div>
	</div>
	</div>
	</section>
	<!-- end about section -->


	<!-- 인포 section -->
	<%@ include file="/include/info.jsp"%>
	<!-- 인포 info section -->

	<!-- 푸터 section -->
	<%@ include file="/include/footer.jsp"%>
	<!-- 푸터 section -->


	<script src="<%=request.getContextPath() %>/js/jquery-3.4.1.min.js"></script>
	<script src="<%=request.getContextPath() %>/js/bootstrap.js"></script>

</body>
</html>

<%
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