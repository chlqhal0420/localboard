<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="local.vo.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>

<%
request.setCharacterEncoding("UTF-8");

Member member = (Member) session.getAttribute("login");

Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;
String url = "jdbc:mysql://localhost:3306/localboard";
String user = "cteam";
String pass = "1234";

List<ReviewReport> rrlist = new ArrayList<ReviewReport>();

// 추가된 부분: 변수 초기화


int reportCount = 0;
try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	conn = DriverManager.getConnection(url, user, pass);

	String sql = "SELECT rr.review_report_id, rr.created_at, rr.reason, rr.status, r.content, lb.title, r.review_id, r.created_by, lb.lb_id "
			+" FROM review_report rr "
			+" JOIN review r ON rr.review_id = r.review_id "
			+" JOIN local_board lb ON r.lb_id = lb.lb_id "
			+" ORDER BY rr.created_at DESC ";
	psmt = conn.prepareStatement(sql);
	rs = psmt.executeQuery();

	while (rs.next()) {
		ReviewReport reviewreport = new ReviewReport();
		reviewreport.setReviewReportId(rs.getInt("review_report_id"));
		reviewreport.setCreatedBy(rs.getInt("created_by")); // 신고된사람ID
		reviewreport.setCreatedAt(rs.getString("created_at"));
		reviewreport.setReason(rs.getString("reason"));
		reviewreport.setStatus(rs.getString("status"));
		reviewreport.setContent(rs.getString("content"));
		reviewreport.setTitle(rs.getString("title"));
		reviewreport.setReviewId(rs.getInt("review_id"));
		reviewreport.setLbId(rs.getInt("lb_id"));
		rrlist.add(reviewreport);
	}

} catch (Exception e) {
	e.printStackTrace();
} finally {
	try {
		if (conn != null)
	conn.close();
		if (psmt != null)
	psmt.close();
		if (rs != null)
	rs.close();
	} catch (SQLException e) {
		e.printStackTrace();
	}
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

	<!-- about section -->
	<section class="about_section layout_padding">
		<div class="container">
			<div class="row">
				<div class="col-lg-12">
					<%@ include file="header.jsp"%>
					<div class="heading_container">
						<h3>동네업체 후기 신고</h3>
					</div>
					<br>
					<!-- Table Section -->
					<div>
						<table class="table table-hover table-striped fluid">
							<thead class="table-warning">
								<tr>
									<th scope="col">NO</th>
									<th scope="col">게시글번호</th>
									<th scope="col">후기내용</th>
									<th scope="col">신고된사람ID</th>
									<th scope="col">신고일시</th>
									<th scope="col">신고사유</th>
									<th scope="col">상태</th>
									<th scope="col">처리</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (ReviewReport reviewreport : rrlist) {
								%>
								<tr>
									<td><%=reviewreport.getReviewReportId()%></td>
									<!-- 수정된 부분: title 및 content 변수 사용 -->
									<td><%=reviewreport.getLbId()%></td>
																		
									<td>
										<div class="row">
											<div class="col-10 text-truncate">
												<%=reviewreport.getContent()%>
											</div>
										</div>
									</td>
																		
									<td><%=reviewreport.getCreatedBy()%></td> <!-- 신고된 사람ID -->
									<td><%=reviewreport.getCreatedAt()%></td>
									<td><%=reviewreport.getReason()%></td>
									<td>
										<%=reviewreport.getStatus()%>
										<button type="button" class="btn btn-success" data-toggle="modal" data-target="#myModal_<%=reviewreport.getReviewReportId()%>">수정</button>	
									</td>
									
									<td>       										
										<button type="button" class="btn btn-danger" onclick="quitFn(<%=reviewreport.getReviewId()%>)">삭제</button>	
									</td>
								</tr>
								<!-- 모달 -->
								<div class="modal fade" id="myModal_<%=reviewreport.getReviewReportId()%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
									<div class="modal-dialog modal-dialog-centered" role="document">
										<div class="modal-content">
											<div class="modal-header">
												<h5 class="modal-title" id="exampleModalLabel">댓글 상태
													수정</h5>
												<button type="button" class="close" data-dismiss="modal"
													aria-label="Close">
													<span aria-hidden="true">&times;</span>
												</button>
											</div>
											<div class="modal-body">
												<!-- Ajax를 사용해 stopReason 업데이트하는 폼 -->
												<form
													id="updateForm_<%=reviewreport.getReviewReportId()%>">
													<div class="form-group">
														<label for="status">선 택 :</label> <select
															class="form-control"
															id="status_<%=reviewreport.getReviewReportId()%>"
															name="status">
															<option>예정</option>
															<option>경고</option>															
															<option>완료</option>
														</select>
													</div>
													<div class="text-center">
														<button type="button" class="btn btn-primary"
															onclick="updateReviewReport(<%=reviewreport.getReviewReportId()%>)">저장</button>
													</div>
												</form>
											</div>
										</div>
									</div>
								</div>
								<%
								}
								%>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</section>
	
	<!--------------------------------------------- 후기 경고 처리 영역 ------------------------------------------------------>
	<script>
    function updateReviewReport(reviewReportId) {
        var newStatus = $("#status_" + reviewReportId).val();
        
        
        $.ajax({
            type: "POST",
            url: "updateReviewReport.jsp", // 업데이트를 처리할 서블릿 또는 서버 측 스크립트 지정
            data: { review_report_id: reviewReportId,
            	    status: newStatus},
            		
            success: function(response) {
                // 성공 처리, 예를 들어 모달 닫기 또는 UI 업데이트
            	   // 서버에서 받은 응답 데이터                              	 
            	   location.reload();

                // 모달 닫기
                $("#myModal_" + reviewReportId).modal('hide');
            },
            error: function(error) {
                // 오류 처리, 예를 들어 오류 메시지 표시
                console.error("정지 사유 업데이트 오류:", error);
            }
        });
    }
    
</script>

	<script>
    //------------------------------------ 신고 후기 삭제 영역 -----------------------------------------
    function quitFn(reviewId) {
    	// 탈퇴 확인 창 띄우기
    	var confirmation = confirm("이 신고댓글을 삭제시키시나요?");
    	
    	if(confirmation){
    	$.ajax({
            type: "POST",
            url: "delReviewReport.jsp", // 업데이트를 처리할 서블릿 또는 서버 측 스크립트 지정
            data: { review_id: reviewId },
            		
            success: function(response) {
                // 성공 처리, 예를 들어 모달 닫기 또는 UI 업데이트                               	 
            	  
               alert("신고 댓글 삭제가 처리되었습니다.");
            },
            error: function(error) {
                // 오류 처리, 예를 들어 오류 메시지 표시
            	 alert("신고 댓글 삭제가 처리되지 않았습니다.");
            }
        });
    	}
    }

</script>
	
	
	
	<!-- end about section -->

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
