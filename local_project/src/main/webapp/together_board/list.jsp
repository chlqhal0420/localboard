<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="local.vo.*"%>
<%@ page import="java.sql.*"%>
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

	String totalSql = "SELECT count(*) as cnt " +
            "FROM board b " +
            "INNER JOIN member m ON b.created_by = m.member_id " +
            "WHERE b.delyn = 'N' AND b.type = 'T'";

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
	pagingVO = new PagingVO(nowPage, totalCnt, 10);

	rs = null;
	String sql = "SELECT board_id, title, m.nicknm, b.created_at, b.hit, m.addr_extra " +
            "FROM board b " +
            "INNER JOIN member m ON b.created_by = m.member_id " +
            "WHERE b.delyn = 'N' AND b.type = 'T'";

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
</head>

<body class="sub_page">

	<div class="hero_area">
		<!-- header section strats -->
		<%@ include file="/include/header.jsp"%>
		<!-- end header section -->
	</div>



	<!-- list section -->
	<section class="about_section layout_padding">
		<div class="container">
    <div class="row">
        <div class="col-md-12">
            <div class="heading_container">
                <h2>같이해요 게시판</h2>
            </div>
            <p>동호회, 봉사활동 등 같이 할 이웃들을 모집하는 게시판입니다.</p>

            <!-- Centered Search Form -->
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


            <div class="text-right">
                <button onclick="goToPage()" type="button" class="btn btn-info">글쓰기</button>
            </div><br>

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

            <!-- Table Section -->
            <div>
                <table class="table table-hover table-striped">
                    <thead class="table-info">
                        <tr>
                            <th scope="col">NO</th>
                            <th scope="col">지역</th>
                            <th scope="col">제목</th>
                            <th scope="col">작성일</th>
                            <th scope="col">작성자</th>
                            <th scope="col">조회수</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% while (rs.next()) { 
                            int boardId = rs.getInt("board_id");
                            String title = rs.getString("title");
                            String createdAt = rs.getString("created_at");
                            String nicknm = rs.getString("nicknm");
                            int hit = rs.getInt("hit");
                            String localExtra= rs.getString("addr_extra");
                        %>
                            <tr>
                                <th scope="row"><%=boardId%></th>
                                <td><%=localExtra%></td>
                                <td>
                                    <div class="row">
                                        <div class="col-8 text-truncate">
                                            <a href="view.jsp?board_id=<%=boardId%>"><%=title%></a>
                                        </div>
                                    </div>
                                </td>
                                <td><%=createdAt%></td>
                                <td><%=nicknm%></td>
                                <td>
                                    <div class="badge bg-warning"><%=hit%></div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>




		<!----------------------------------- 페이징 영역 -------------------------------------------------------------------------------->
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
 %> <a class="page-link"
							href="list.jsp?nowPage=<%=i%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>"><%=i%></a>
							<%
							} else {
							%> <a class="page-link" href="list.jsp?nowPage=<%=i%>"><%=i%></a>
							<%
							}
							%> <%
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
			</div>
		</div>

	</section>
	<!-- end list section -->


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