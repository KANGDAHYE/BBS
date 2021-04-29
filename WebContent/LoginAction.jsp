<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:setProperty property="userID" name="user"/> 
<jsp:setProperty property="userPassword" name="user"/> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">

<title>JSP 게시판 웹 사이트</title>
</head>
<body>
<%
    //로그인이된 user는 로그인과 회원가입 페이지에 들어갈 수 없도록 해야함
	String userID = null;
	if(session.getAttribute("userID") != null){
		userID = (String)session.getAttribute("userID");
	}
	
	if(userID != null){
	    PrintWriter script = response.getWriter();
	    script.println("<script>");
	    script.println("alert('이미 로그인이 되어있습니다.') "); 
	    script.println("location.href = 'main.jsp' "); 
	    script.println("</script>"); 
	}

	UserDAO userDAO = new UserDAO();
	int result = userDAO.login(user.getUserID(), user.getUserPassword());
	
	if(result == 1){ // 성공
		session.setAttribute("userID", user.getUserID());//userID라는 이름으로 session을 보여줌, 세션 값으로는 getUserID로 넣어줌.  
	    PrintWriter script = response.getWriter();
	    script.println("<script>"); //스크립트 문장을 유동적으로 실행할 수 있도록 함.
	    script.println("location.href = 'main.jsp' "); //로그인 성공했을때 이동하는 페이지
	    script.println("</script>");                 
	 }
	
	   if(result == 0){ //비밀번호가 틀릴때
	    PrintWriter script = response.getWriter();
	    script.println("<script>"); 
	    script.println("alert('비밀번호가 틀림니다') "); 
	    script.println("history.back() "); 
	    script.println("</script>");                 
	   }
	
	 
	   if(result == -1){ //아이디가 존재하지 않을때
	    PrintWriter script = response.getWriter();
	    script.println("<script>"); 
	    script.println("alert('아이디가 존재하지 않음.') "); 
	    script.println("history.back() ");
	    script.println("</script>");                 
	   }
	
	   if(result == -2){ //데이터베이스 오류
	    PrintWriter script = response.getWriter();
	    script.println("<script>"); 
	    script.println("alert('데이터베이스 오류 발생') "); 
	    script.println("history.back() "); 
	    script.println("</script>");                 
	   }

%>

</body>
</html>