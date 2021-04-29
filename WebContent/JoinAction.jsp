<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:setProperty property="userID" name="user"/> 
<jsp:setProperty property="userPassword" name="user"/> 
<jsp:setProperty property="userName" name="user"/> 
<jsp:setProperty property="userGender" name="user"/> 
<jsp:setProperty property="userEmail" name="user"/> 
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

	if(user.getUserID() == null || user.getUserPassword() == null 
	|| user.getUserName() == null || user.getUserGender() == null || user.getUserEmail() == null){
	    PrintWriter script = response.getWriter();
	    script.println("<script>"); 
	    script.println("alert('입력이 안 된 사항이 있습니다.') "); 
	    script.println("history.back() ");
	    script.println("</script>"); 
	}else{
		
		UserDAO userDAO = new UserDAO();//데이터베이스에 접근할 수 있는 객체
		int result = userDAO.join(user);//각각의 변수들을 입력받아서 만들어진 하나의 user라는
		                                //인스턴스가 join 함수를 수행하도록 매개변수로 들어감.

		if(result == -1){ //데이터베이스 오류 발생한 경우
		    PrintWriter script = response.getWriter();
		    script.println("<script>"); 
		    script.println("alert('이미 존재하는 아이디입니다.') "); 
		    script.println("history.back() "); 
		    script.println("</script>");              
		 }

		 else { //회원가입 성공
			session.setAttribute("userID", user.getUserID());//해당 사용자 세션부여한 다음 메인페이지로 이동.
		    PrintWriter script = response.getWriter();
		    script.println("<script>"); 
		    script.println("location.href = 'main.jsp'"); //바로 로그인 시켜서 메인페이지로 이동
		    script.println("</script>");                 
		   }
	}
%>

</body>
</html>