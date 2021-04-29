<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">

<title>JSP 게시판 웹 사이트</title>
</head>
<body>
<%
    //현재 이 페이지에 접속한 회원이 세션을 뺴앗기도록 만들어서 로그아웃 시켜줌. 
	session.invalidate();
%>
<script type="text/javascript">
	location.href = 'main.jsp';
</script>

</body>
</html>