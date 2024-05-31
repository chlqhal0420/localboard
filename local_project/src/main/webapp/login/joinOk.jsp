<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import= "java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
<%@page import="java.sql.*"%>
<%@ page import="java.util.Base64" %>

<%
	request.setCharacterEncoding("UTF-8");
	String passwordre = request.getParameter("passwordre");
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	String nicknm = request.getParameter("nicknm");
	String phone = request.getParameter("phone");
	String extraAddress = request.getParameter("extraAddress");
	String postcode = request.getParameter("postcode");
	String address = request.getParameter("address");
	String detailAddress = request.getParameter("detailAddress");
	String codeId = request.getParameter("selectType"); // 라디오 버튼 값
	System.out.println(codeId);
	String businessNumber = request.getParameter("businessRegistrationNumber");

%>
<jsp:useBean id="member" class="local.vo.Member" /> <!-- Member member = new Member(); -->
<jsp:setProperty name="member" property="*" />
<%	
	if(isValidInput(email, password, passwordre, nicknm, phone, extraAddress, postcode, address)) {
	
		Connection conn = null;
		PreparedStatement psmt= null;
		String url = "jdbc:mysql://localhost:3306/localboard";
		String user = "cteam";
		String pass = "1234";
		int insertRow =0;
		try{
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(url,user,pass);
			System.out.println("연결성공!");
			String salt = request.getParameter("salt");
			System.out.println(salt);
			
			 // 비밀번호를 SHA-256으로 암호화
	        String hashedPassword = hashPassword(member.getPassword(), salt);
	        System.out.println(hashedPassword);
	        String sql = "INSERT INTO member(email, password, nicknm, phone, addr_extra, addr_post_code, addr_basic, addr_detail, created_at, salt, code_id, business_number)"
					   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, now(), ?, ?, ?)";
			
			psmt = conn.prepareStatement(sql);
		    psmt.setString(1, email);
			psmt.setString(2, hashedPassword);
			psmt.setString(3, nicknm);
			psmt.setString(4, phone);
			psmt.setString(5, extraAddress);  // addr_extra
			psmt.setString(6, postcode);	  // addr_post_code
			psmt.setString(7, address);		  // addr_basic
			psmt.setString(8, detailAddress); //addr_detail
			psmt.setString(9, salt); // 저장된 salt 값 추가
			psmt.setString(10, codeId);       // 회원 유형 코드 추가
		    psmt.setString(11, businessNumber); // 사업자 회원일 경우 사업자등록번호 추가
			
			insertRow = psmt.executeUpdate();
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(conn != null) conn.close();
			if(psmt != null) psmt.close();
		}
		
		if(insertRow>0){
		%>
			<script>
				alert("회원가입되었습니다.로그인을 시도하세요.");
				location.href="<%=request.getContextPath()%>/index.jsp";
			</script>
			
		<%	
		}else{
			%>
			<script>
				alert("회원가입에 실패했습니다.다시 시도하세요.");
				location.href="join.jsp";
			</script>
			
			<%
		}
	}else{
		 // 유효성 검사에 실패한 경우 오류 메시지를 join.jsp 페이지로 전달
        response.sendRedirect("join.jsp?error=invalidInput");
	}
	
%>

<%!
	// 추가적인 유효성 검사 메서드
	// 이메일 유효성 검사
	private boolean isValidEmail(String email) {
	    // 여기에 이메일 유효성 검사 로직 추가
	    // 예: 정규 표현식을 사용한 간단한 예제
	    // 여러분의 실제 요구사항에 맞게 수정이 필요할 수 있습니다.
	    String regex = "^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$";
	    return email.matches(regex);
	}
	
	// 비밀번호 유효성 검사
	private boolean isValidPassword(String password) {
	    // 여기에 비밀번호 유효성 검사 로직 추가
	    // 예: 최소 길이, 특수문자 포함 여부 등을 확인하는 로직
	    // 여러분의 실제 요구사항에 맞게 수정이 필요할 수 있습니다.
	    return password.length() >= 6 && password.matches(".*[!@#$%^*+=-].*");
	}
	
	// 입력값의 유효성 검사
	private boolean isValidInput(String email, String password, String passwordre,
	        String nicknm, String phone, String extraAddress,
	        String postcode, String address) {
	    return isValidEmail(email) &&
	            isValidPassword(password) &&
	            password.equals(passwordre) &&
	            // 여기에 나머지 입력값의 유효성 검사 로직을 추가
	            // 필요에 따라 다양한 검사를 수행할 수 있습니다.
	            // 예: 닉네임, 전화번호 등의 형식 검사 등
	            !nicknm.trim().isEmpty() &&
	            !phone.trim().isEmpty() &&
	            !extraAddress.trim().isEmpty() &&
	            !postcode.trim().isEmpty() &&
	            !address.trim().isEmpty()
	            ;
	}
	
	private String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] saltBytes = hexStringToByteArray(salt);

            // Add salt to the password
            String passwordWithSalt = password + byteArrayToHexString(saltBytes);

            byte[] hashedBytes = md.digest(passwordWithSalt.getBytes());

            return byteArrayToHexString(hashedBytes);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

    private byte[] hexStringToByteArray(String s) {
        int len = s.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
                                 + Character.digit(s.charAt(i+1), 16));
        }
        return data;
    }

    private String byteArrayToHexString(byte[] bytes) {
        StringBuilder result = new StringBuilder();
        for (byte b : bytes) {
            result.append(String.format("%02x", b));
        }
        return result.toString();
    }
%>