<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="local.vo.*"%>
<%@ page import="java.sql.*"%>
<%@ page errorPage="errorPage.jsp" %>
<%

Member member = (Member) session.getAttribute("login"); 

request.setCharacterEncoding("UTF-8");

/* 검색기능 */

String searchType = request.getParameter("searchType");
String searchValue = request.getParameter("searchValue");

/* 페이징 */
String nowPageParam = request.getParameter("nowPage");

int nowPage = 1;
if (nowPageParam != null && !nowPageParam.equals("")) {
	nowPage = Integer.parseInt(nowPageParam);
}
PagingVO pagingVO = null;


Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;
String url = "jdbc:mysql://localhost:3306/localboard";
String user = "cteam";
String pass = "1234";

try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(url, user, pass);
	
	
	String totalSql = "SELECT count(*) as cnt " + "  FROM local_board lb      " + " INNER JOIN member m"
			+ " ON lb.created_by = m.member_id   " + " WHERE lb.delyn = 'N'";

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
			

			if (rs != null) rs.close();
			if (psmt != null) psmt.close();

			//paging 객체 생성
			pagingVO = new PagingVO(nowPage, totalCnt, 8);
	
			rs = null;
	

	//---------------------- 동네업체 게시판 목록 데이터 가져오기 ---------------------------------------------
 		
	 /*	file_id로 그룹을 만들고, 그중에 file_ord가 가장 큰 값을 가져오는 쿼리문 */
	 /* String sql = " SELECT lb.lb_id, lb.title, lb.local_id, m.nicknm, lb.created_at, lb.hit, lb.content, bf.file_id, max_fd.file_thumbnail_nm, max_fd.file_real_nm, max_fd.file_origin_nm " 
			 +" FROM  local_board lb " 
			 +" INNER JOIN  member m ON lb.created_by = m.member_id "
			 +" INNER JOIN  board_file bf ON bf.file_id = lb.file_id "
			 +" INNER JOIN (  SELECT   fd.file_id,    fd.file_thumbnail_nm,  fd.file_real_nm,  fd.file_origin_nm,  fd.file_ord "
			 +" FROM  board_file_detail fd INNER JOIN ( SELECT file_id, MAX(file_ord) AS max_file_ord "
			        +" FROM board_file_detail GROUP BY file_id ) AS temp_fd ON fd.file_id = temp_fd.file_id AND fd.file_ord = temp_fd.max_file_ord )"
			+" AS max_fd ON bf.file_id = max_fd.file_id WHERE  lb.delyn = 'N'";  */
	
			String sql =  " SELECT lb.lb_id, lb.title, lb.local_id,  m.nicknm, lb.created_at, lb.hit, lb.content, "
				 	 +" 	bf.file_id, max_fd.file_thumbnail_nm,  max_fd.file_real_nm, max_fd.file_origin_nm, "
				   	+ "    	COALESCE(ll.total_likes, 0) AS total_likes, "
				    + "   	COALESCE(r.total_reviews, 0) AS total_reviews " 
				    + " 	FROM local_board lb  "
				    + " 	INNER JOIN member m ON lb.created_by = m.member_id "
				    + " 	INNER JOIN board_file bf ON bf.file_id = lb.file_id "
				    + " 	INNER JOIN (SELECT  fd.file_id, fd.file_thumbnail_nm, fd.file_real_nm, fd.file_origin_nm, fd.file_ord "
				    + "   	FROM board_file_detail fd "
				    +"  	INNER JOIN ( SELECT file_id, MAX(file_ord) AS max_file_ord FROM board_file_detail "
				    +"      GROUP BY file_id ) temp_fd ON fd.file_id = temp_fd.file_id AND fd.file_ord = temp_fd.max_file_ord ) "
				    +"  	max_fd ON bf.file_id = max_fd.file_id "
				    +" 		LEFT JOIN (SELECT lb_id, SUM(count) AS total_likes "
				    +"    	FROM local_like GROUP BY lb_id) ll ON lb.lb_id = ll.lb_id "
				    +" 		LEFT JOIN (SELECT lb_id, COUNT(review_id) AS total_reviews "
				    +"   	FROM review WHERE delyn = 'N' "
				    +"  	GROUP BY  lb_id) r ON lb.lb_id = r.lb_id WHERE  lb.delyn = 'N'";
	
/* 테이블 inner join 해서 모든 것을 가져오는 쿼리문 			
	String sql= " select * from local_board lb inner join member m on lb.created_by = m.member_id JOIN board_file bf on lb.file_id = bf.file_id JOIN board_file_detail bfd on bfd.file_id = bf.file_id ";		
 */	
	 if (searchType != null) {
			if (searchType.equals("title")) {
		sql += " AND title LIKE CONCAT('%',?,'%') ";
			} else if (searchType.equals("nicknm")) {
		sql += " AND m.nicknm LIKE CONCAT('%',?,'%')";
			}
		}
		sql += " ORDER BY lb_id desc ";
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
	//---------------------- 동네업체 게시판 목록 데이터 가져오기 ---------------------------------------------
	
	//-----------------------좋아요 카운트 수 가져오기------------------------------------------------------
	

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
				<h2>우리동네 업체소식</h2>
			</div>
			<p>나의 가게를 홍보해보세요</p>
			
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
			<%
				if((member!=null)&&(member.getCodeId() == 'C')){
			%>
			<div class="text-right">
				<button onclick="location.href='write.jsp'" type="button"
					class="btn btn-info">글쓰기</button>
			</div>
			<%
				}
			%>
			
			<br>
			<div class="row">
				<%
					while (rs.next()) {
						int lb_id = rs.getInt("lb_id");
						String local_id = rs.getString("local_id");
						String title = rs.getString("title");
						String created_at = rs.getString("created_at");
						String nicknm = rs.getString("nicknm");
						int hit = rs.getInt("hit");
						String content=rs.getString("content");
						String file_real_nm= rs.getString("file_real_nm");
						String file_thumbnail_nm=rs.getString("file_thumbnail_nm");
						int totalLikes =rs.getInt("total_likes");
						int totalRivews=rs.getInt("total_reviews");
				%>


				<!-- --------------------------------게시글 출력부분(시작)--------------------------------------- -->
				<div class="col-md-3 mt-2 mb-2">
					<div class="card" style="width: 18rem; height: 350px;">

						<div
							style="position: absolute; top: 0; left: 0; background-color: rgba(0, 0, 0, 0.5); color: white; padding: 5px; z-index: 1;">
							<small><%=lb_id%></small>
						</div>

						<img src="<%=request.getContextPath()%><%= file_thumbnail_nm %>/<%= file_real_nm %>" class="card-img-top" alt="..." height="200">

						<div class="card-body">
							<h5 class="card-title d-inline-block text-truncate"
								style="max-width: 250px;">
								<a href="view.jsp?board_id=<%=lb_id%>"><%=title%></a>
							</h5>
					<%--  	<h5 class="card-text d-inline-block text-truncate"
								style="max-width: 250px; max-height: 100px"><%=content %></h5>   --%>

							<div
								class="d-flex justify-content-between border-top border-secondary p-4">
								<div class="d-flex align-items-center">
									<!-- 썸네일이미지 -->
								<!-- 	<img class="rounded-circle me-2"
										src="https://search.pstatic.net/sunny/?src=https%3A%2F%2Fpng.pngtree.com%2Fpng-vector%2F20231113%2Fourlarge%2Fpngtree-a-red-apple-png-image_10577760.png&type=a340"
										width="30" height="30" alt="썸네일이미지">  -->
										<small class="text-uppercase"><%=nicknm%></small>
								</div>
								<div class="d-flex align-items-center">
									<small class="ms-3"><i
										class="fa fa-heart text-secondary me-2"></i>&nbsp<%=totalLikes%>&nbsp</small> <small
										class="ms-3"><i class="fa fa-eye text-secondary me-2"></i>
										<%=hit%> </small> <small class="ms-3"><i
										class="fa fa-comment text-secondary me-2"></i>&nbsp<%=totalRivews%>&nbsp</small>

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
if (conn != null) conn.close();
if (psmt != null) psmt.close();
if (rs != null) rs.close();
}
%>