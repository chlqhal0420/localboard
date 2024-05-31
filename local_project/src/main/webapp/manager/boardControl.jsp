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

List<BoardReport> brlist = new ArrayList<BoardReport>();

int reportCount = 0;
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, user, pass);

    int test = member.getMemberId();


    String sql = "SELECT board_report_id, board_id, created_by, created_at, reason, status, board_code, modified_by "
               + "FROM board_report ORDER BY created_at DESC ";
              
    psmt = conn.prepareStatement(sql);
    rs = psmt.executeQuery();

    while (rs.next()) {
    	BoardReport boardreport = new BoardReport();
    	boardreport.setBoardReportId(rs.getInt("board_report_id"));
    	boardreport.setBoardId(rs.getInt("board_id"));
    	boardreport.setCreatedBy(rs.getInt("created_by"));
    	boardreport.setCreatedAt(rs.getString("created_at"));
    	boardreport.setReason(rs.getString("reason"));
    	boardreport.setStatus(rs.getString("status"));
    	boardreport.setBoardCode(rs.getString("board_code").charAt(0));
    	boardreport.setModifiedBy(rs.getInt("modified_by"));
      	

    	brlist.add(boardreport);
    }
  

} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (conn != null) conn.close();
    if (psmt != null) psmt.close();
    if (rs != null) rs.close();
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
					<%@ include file="/manager/header.jsp"%>
					<div class="heading_container">
						<h3>게시글 신고</h3>
					</div>
						<br>
						<P>F: 자유게시판 &nbsp;|&nbsp; T: 같이해요 &nbsp;|&nbsp; Q: Q&amp;A  &nbsp;|&nbsp; C: 동네업체 &nbsp;|&nbsp; S: 나작동 </P>
					<br>
					<!-- Table Section -->
					<div>
						<table class="table table-hover table-striped fluid">
							<thead class="table-warning">
								<tr>
									<th scope="col">NO</th>
									<th scope="col">신고한사람ID</th>
									<th scope="col">신고된사람ID</th>
									<th scope="col">일시</th>
									<th scope="col">코드</th>
									<th scope="col">번호</th>
									<th scope="col">신고사유</th>
									<th scope="col">게시글상태</th>																										
									<th scope="col">처리</th>																										
								</tr>
							</thead>
							<tbody>
							<%
								for (BoardReport boardreport : brlist) {
							%>
								<tr>
									<td><%= boardreport.getBoardReportId()%></td>
									<td><%= boardreport.getCreatedBy()%></td>
									<td><%= boardreport.getModifiedBy()%></td> <!-- 신고된 회원 -->
									<td><%= boardreport.getCreatedAt()%></td>
									<td><%= boardreport.getBoardCode()%></td>
									<td><%= boardreport.getBoardId()%></td>
									<td><%= boardreport.getReason()%></td>
									<td>							
									<%= boardreport.getStatus()%>&nbsp;
                                    <button type="button" class="btn btn-success" data-toggle="modal" data-target="#myModal_<%=boardreport.getBoardReportId()%>">수정</button>								
									</td>									
									<td>		
                            
                                    <button type="button" class="btn btn-danger" onclick="quitFn(<%=boardreport.getBoardId()%>)">삭제</button>								
									</td>									
								</tr>
								 <!-- 모달 -->
                            <div class="modal fade" id="myModal_<%=boardreport.getBoardReportId()%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="exampleModalLabel">게시글 상태 수정</h5>
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                        <div class="modal-body">
                                            <!-- Ajax를 사용해 stopReason 업데이트하는 폼 -->
                                            <form id="updateForm_<%=boardreport.getBoardReportId()%>">                                        
                                                <div class="form-group">
													<label for="status">선 택 :</label> 
														<select
															class="form-control" id="status_<%= boardreport.getBoardReportId()%>" name="status">
																<option>예정</option>
																<option>경고</option>																				
																<option>완료</option>							
														</select>
												</div>
                                                <div class="text-center">                                             
                                                <button type="button" class="btn btn-primary" onclick="updateBoardReport(<%=boardreport.getBoardReportId()%>)">저장</button>
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
	
	
	<!--------------------------------------------- 신고 게시글 경고 처리 영역 ------------------------------------------------------>
<script>
    function updateBoardReport(boardReportId) {
        var newStatus = $("#status_" + boardReportId).val();
        
        
        $.ajax({
            type: "POST",
            url: "updateBoardReport.jsp", // 업데이트를 처리할 서블릿 또는 서버 측 스크립트 지정
            data: { board_report_id: boardReportId,
            	    status: newStatus},
            		
            success: function(response) {
                // 성공 처리, 예를 들어 모달 닫기 또는 UI 업데이트
            	   // 서버에서 받은 응답 데이터                              	 
            	   location.reload();

                // 모달 닫기
                $("#myModal_" + boardReportId).modal('hide');
            },
            error: function(error) {
                // 오류 처리, 예를 들어 오류 메시지 표시
                console.error("정지 사유 업데이트 오류:", error);
            }
        });
    }
    
</script>

<script>
    //------------------------------------ 신고 게시글 삭제 영역 -----------------------------------------
    function quitFn(boardId) {
    	// 탈퇴 확인 창 띄우기
    	var confirmation = confirm("이 게시글을 삭제시키시나요?");
    	
    	if(confirmation){
    	$.ajax({
            type: "POST",
            url: "delBoardReport.jsp", // 업데이트를 처리할 서블릿 또는 서버 측 스크립트 지정
            data: { board_id: boardId },
            		
            success: function(response) {
                // 성공 처리, 예를 들어 모달 닫기 또는 UI 업데이트                               	 
            	  
               alert("신고 게시글 삭제가 처리되었습니다.");
            },
            error: function(error) {
                // 오류 처리, 예를 들어 오류 메시지 표시
            	 alert("신고 게시글 삭제가 처리되지 않았습니다.");
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