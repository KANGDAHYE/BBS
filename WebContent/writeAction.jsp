<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.Bbs" %><!-- bbs 데이터베이스 객체를 다룰 수 있는 -->
<%@ page import="bbs.BbsDAO" %><!-- bbs 데이터베이스 객체를 다룰 수 있는 -->
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page"/><!-- 하나의 게시글 정보를 담을 수 있게 함 -->
<jsp:setProperty property="bbsTitle" name="bbs"/> <!-- 하나의 게시글 인스턴스를 만들어줄 수 있도록 함-->
<jsp:setProperty property="bbsContent" name="bbs"/> 
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
	}else{//로그인이 되어있는 사람들
		if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null){//글제목, 내용 입력 x
				    PrintWriter script = response.getWriter();
				    script.println("<script>"); 
				    script.println("alert('입력이 안 된 사항이 있습니다.') "); 
				    script.println("history.back() ");
				    script.println("</script>"); 
				    
				}else{// 제목, 내용 있다면 실제로 데이터베이스 등록을 해줌
					BbsDAO bbsDAO = new BbsDAO();//데이터베이스에 접근할 수 있는 객체
					int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());//write 함수를 실행해서 실제로 게시글을 작성할 수 있도록 함.,각각의 매개변수 넣어줌

					if(result == -1){ //데이터베이스 오류 발생한 경우
					    PrintWriter script = response.getWriter();
					    script.println("<script>"); 
					    script.println("alert('글쓰기에 실패했습니다.') "); //데이터베이스 오류시 글쓰기 실패
					    script.println("history.back() "); 
					    script.println("</script>");              
					 }

					 else { //글쓰기 성공
					    PrintWriter script = response.getWriter();
					    script.println("<script>"); 
					    script.println("location.href = 'bbs.jsp'"); 
					    script.println("</script>");                 
					   }
			}
	}

%>

</body>
</html>