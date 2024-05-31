<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="local.vo.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%

request.setCharacterEncoding("UTF-8");

Connection conn = null;
PreparedStatement psmt = null;
ResultSet rs = null;
String url = "jdbc:mysql://localhost:3306/localboard";
String user = "cteam";
String pass = "1234";

List<Member> mlist = new ArrayList<Member>();
int reportCount = 0;
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, user, pass);

    String sql = "SELECT member_id, email, nicknm, phone, status, created_at, stop_reason, stop_start_date, stop_end_date, report_count "
               + "FROM member WHERE status <> 'quit' ORDER BY created_at DESC "; // quit 값을 제외하고 최신순 결과를 조회
              
    psmt = conn.prepareStatement(sql);
    rs = psmt.executeQuery();

    while (rs.next()) {
        Member member = new Member();
        member.setMemberId(rs.getInt("member_id"));
        member.setEmail(rs.getString("email"));
        member.setNicknm(rs.getString("nicknm"));
        member.setPhone(rs.getString("phone"));
        member.setStatus(rs.getString("status"));
        member.setCreatedAt(rs.getString("created_at"));
        member.setStopReason(rs.getString("stop_reason"));
        member.setStopStartDate(rs.getString("stop_start_date"));
        member.setStopEndDate(rs.getString("stop_end_date"));
        member.setReportCount(rs.getInt("report_count"));  //신고된 횟수

        mlist.add(member);
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
                    <h3>회원 관리</h3>
                </div>
                <br>
                <!-- 테이블 섹션 -->
                <div>
                    <table class="table table-hover table-striped fluid">
                        <thead class="table-warning">
                            <tr>
                                <th class="col-1">ID</th>
                                <th class="col-2">이메일</th>
                                <th class="col-1">닉네임</th>
                                <th class="col-2">전화번호</th>
                                <th class="col-1">가입일시</th>
                                <th class="col-2">회원상태</th>
                                <th class="col-2">정지사유</th>
                                <th class="col-1">정지시작일</th>
                                <th class="col-1">정지종료일</th>
                                <th class="col-1">신고건</th>
                                <th class="col-2">처리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                           		for (Member member : mlist) {
                            %>
                            <tr>
                               	<td class="col-1"><%=member.getMemberId()%></td>
                                <td class="col-2"><%=member.getEmail()%></td>
                                <td class="col-1"><%=member.getNicknm()%></td>
                                <td class="col-2"><%=member.getPhone()%></td>
                                <td class="col-1"><%=member.getCreatedAt()%></td>
                                <td class="col-2"><%=member.getStatus()%></td>
                                <td class="col-2"><%=member.getStopReason()%></td>
                                <td class="col-1"><%=member.getStopStartDate()%></td>
                                <td class="col-1"><%=member.getStopEndDate()%></td>                           
                                <td class="col-1"><%=member.getReportCount()%></td>
                                <td class="col-2">
                                    <!-- 모달을 트리거하는 버튼 -->
                                    <button type="button" class="btn btn-danger" data-toggle="modal" data-target="#myModal_<%=member.getMemberId()%>">수정</button>
                                    <button type="button" class="btn btn-success" onclick="quitFn(<%=member.getMemberId()%>)">탈퇴</button>
                                </td>
                            </tr>
                            <!-- 모달 -->
                            <div class="modal fade" id="myModal_<%=member.getMemberId()%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="exampleModalLabel">처리 수정</h5>
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                        <div class="modal-body">
                                            <!-- Ajax를 사용해 stopReason 업데이트하는 폼 -->
                                            <form id="updateForm_<%=member.getMemberId()%>">                                        
                                                <div class="form-group">
													<label for="status">회원 상태:</label> 
														<select
															class="form-control" id="status_<%=member.getMemberId()%>" name="status">
													<option>active</option>
													<option>stop</option>																									
														</select>
												</div>
                                                <div class="form-group">
                                                    <label for="stopReason">정지 사유:</label>
                                                    <input type="text" class="form-control" id="stopReason_<%=member.getMemberId()%>" value="<%=member.getStopReason()%>" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="stopReason">정지시작일:</label>
                                                    <input type="text" class="form-control" id="stopStartDate_<%=member.getMemberId()%>" value="<%=member.getStopStartDate()%>" required>
                                                </div>
                                                <div class="form-group">
                                                    <label for="stopReason">정지종료일:</label>
                                                    <input type="text" class="form-control" id="stopEndDate_<%=member.getMemberId()%>" value="<%=member.getStopEndDate()%>" required>
                                                </div>                                               
                                                <div class="text-center">                                             
                                                <button type="button" class="btn btn-primary" onclick="updateStopReason(<%=member.getMemberId()%>)">저장</button>
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

<!--------------------------------------------- 회원 정지 처리 영역 ------------------------------------------------------>
<script>
    function updateStopReason(memberId) {
        var newStatus = $("#status_" + memberId).val();
        var newStopReason = $("#stopReason_" + memberId).val();
        var newStopStartDate = $("#stopStartDate_" + memberId).val();
        var newStopEndDate = $("#stopEndDate_" + memberId).val();
        
        
        $.ajax({
            type: "POST",
            url: "updateStop.jsp", // 업데이트를 처리할 서블릿 또는 서버 측 스크립트 지정
            data: { member_id: memberId, 
            		stop_reason: newStopReason, 
            		status: newStatus, 
            		stop_start_date: newStopStartDate, 
            		stop_end_date: newStopEndDate },
            		
            success: function(response) {
                // 성공 처리, 예를 들어 모달 닫기 또는 UI 업데이트
            	   // 서버에서 받은 응답 데이터                              	 
            	   location.reload();

                // 모달 닫기
                $("#myModal_" + memberId).modal('hide');
            },
            error: function(error) {
                // 오류 처리, 예를 들어 오류 메시지 표시
                console.error("정지 사유 업데이트 오류:", error);
            }
        });
    }
    
</script>

<script>
    //------------------------------------ 회원 탈퇴 영역 -----------------------------------------
    function quitFn(memberId) {
    	// 탈퇴 확인 창 띄우기
    	var confirmation = confirm("이 회원을 탈퇴시키시나요?");
    	
    	if(confirmation){
    	$.ajax({
            type: "POST",
            url: "updateQuit.jsp", // 업데이트를 처리할 서블릿 또는 서버 측 스크립트 지정
            data: { member_id: memberId },
            		
            success: function(response) {
                // 성공 처리, 예를 들어 모달 닫기 또는 UI 업데이트                               	 
            	   location.reload();
               alert("탈퇴가 정상적으로 처리되었습니다.");
            },
            error: function(error) {
                // 오류 처리, 예를 들어 오류 메시지 표시
            	 alert("탈퇴가 처리되지 않았습니다.");
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