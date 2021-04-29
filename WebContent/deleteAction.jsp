<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.Bbs" %><!-- bbs 데이터베이스 객체를 다룰 수 있는 -->
<%@ page import="bbs.BbsDAO" %><!-- bbs 데이터베이스 객체를 다룰 수 있는 -->
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
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
	
	if(userID == null){//로그인이 안된사람들
	    PrintWriter script = response.getWriter();
	    script.println("<script>");
	    script.println("alert('로그인을 하세요') ");//글쓰기는 로그인이 된 상태에서만 가능 
	    script.println("location.href = 'login.jsp' "); 
	    script.println("</script>"); 
	}
	int bbsID = 0;//현재 수정하고자 하는 ID값이 들어오지 않았다면
	if(request.getParameter("bbsID") != null){//매개변수로 넘어온 bbsID가 존재한다면,request.getParameter("bbsID") =! null
		bbsID = Integer.parseInt(request.getParameter("bbsID"));//게시판 제목 눌러서 들어가면 url에 " bbsID=숫자 " 로 넘어옴.
	}
	if(bbsID == 0){//번호가 반드시 존재해야 글을 볼 수 있음.
	    PrintWriter script = response.getWriter();
	    script.println("<script>"); 
	    script.println("alert('유효하지 않은 글입니다.') "); 
	    script.println("location.href ='bbs.jsp' ");
	    script.println("</script>"); 
	}
	//현재 작성하는 글이 작성하는 본인인지 확인하는 작업에서 session 관리가 필요
	Bbs bbs = new BbsDAO().getBbs(bbsID);//넘어온 bbsID값을 가지고 해당 글을 가지고 온 다음에
	if(!userID.equals(bbs.getUserID())){//userID(세션에 있는 값)과 getUserID(이 글을 작성한 값)을 서로 비교해서 동일하지 않을 경우(동일한경우 문제 없음)
	    PrintWriter script = response.getWriter();
	    script.println("<script>"); 
	    script.println("alert('권한이 없습니다.') "); 
	    script.println("location.href ='bbs.jsp' ");
	    script.println("</script>"); 

	} else{//성공적으로 권한이 있는 사람이라면
			BbsDAO bbsDAO = new BbsDAO();//데이터베이스에 접근할 수 있는 객체
			int result = bbsDAO.delete(bbsID);//write 함수를 실행해서 실제로 게시글을 작성할 수 있도록 함.,각각의 매개변수 넣어줌

			if(result == -1){ //데이터베이스 오류 발생한 경우
			    PrintWriter script = response.getWriter();
			    script.println("<script>"); 
			    script.println("alert('글삭제에 실패했습니다.') "); //데이터베이스 오류시 글쓰기 실패
			    script.println("history.back() "); 
			    script.println("</script>");              
			 }

			 else {
			    PrintWriter script = response.getWriter();
			    script.println("<script>"); 
			    script.println("location.href = 'bbs.jsp'"); 
			    script.println("</script>");                 
			  }
		}
	

%>

</body>
</html>