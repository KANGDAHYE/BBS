<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>

<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		if(userID == null){
			PrintWriter script = response.getWriter();
		    script.println("<script>"); 
		    script.println("alert('로그인을 하세요.') "); 
		    script.println("location.href ='login.jsp' ");
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

		}
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target ="#bs-example-navbar-collapse-1"
				aria-expanded="false"> 
 				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span> 
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav"> 
				<li><a href="main.jsp">메인</a></li>
				<li class="active"><a href="bbs.jsp">게시판</a></li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" 
						data-toggle="dropdown" role="button" aria-haspopup="true" 
						aria-expanded="flase"> 회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="LogoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>
	<div class="container">
		<div class="row">
			<form method="post" action="updateAction.jsp?bbsID=<%= bbsID %>"><!-- bbsID를 보내줄 수 있도록 함. -->
					<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd;'">
						<thead>
							<tr>
								<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50" value="<%= bbs.getBbsTitle()%>"></td><!-- 자신이 이전에 작성했던 글에 대한 정보를 볼 필요가 있음. -->
							</tr>
							<tr>
								<td><textarea class="form-control" placeholder="글내용" name="bbsContent" maxlength="2048" style="height: 350px;"><%= bbs.getBbsContent() %></textarea></td>
							</tr>
						</tbody>
					</table>
					<input type="submit" class="btn btn-primary pull-right" value="글수정"><!-- 글수정버튼 눌러서 updateAction.jsp로 각각의 내용들을 매개 변수로서 보낼 수 있게 됨. -->
			</form>
		</div>
	</div>

</body>
</html>