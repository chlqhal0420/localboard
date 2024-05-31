<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동네커뮤니티</title>
<!-- bootstrap core css -->
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/bootstrap.css" />
<style>
   
    body {
        display: flex;
        justify-content: center; 
        align-items: center; 
        min-height: 100vh; 
        margin: 0; 
    }
 
    .img-container {
        text-align: center; 
    }
</style>
</head>
<body>
<div class="img-container">
    <img src="<%=request.getContextPath()%>/images/error.png" class="d-block w-30" height="500" alt="에러이미지">
    <%= exception.getMessage() %>
</div>
</body>
</html>