<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %><!-- 실제 데이터베이스 사용할 수 있도록 bbs 클래스를 가져옴. -->
<%@ page import="bbs.BbsDAO" %><!-- 데이터베이스 접근 객체 또한 가져옴.  -->
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
		//매개변수 및 기본세팅
		//게시판에서 어떤 글을 눌러서 들어갔을때 bbsID가 정상적으로 넘어왔다면
		//view 페이지는 그걸 이용해서 bbsID에 담은 다음에 처리할 수 있도록 함.
		int bbsID = 0;
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
		//해당 글 내용가져오기, 유효한 글이라면 구체적 정보를 bbs라는 인스턴스에 담음.
		Bbs bbs = new BbsDAO().getBbs(bbsID);
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
			<%
			    //로그인 안되어있을때
				if(userID == null){
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" 
						data-toggle="dropdown" role="button" aria-haspopup="true" 
						aria-expanded="flase"> 접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
				//로그인 되어있을때.
				}else{
			%>
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
			<%
				}
			%>
		</div>
	</nav>
	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd;'">
				<thead>
					<tr>
						<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td style="width: 20%">글 제목</td>
						<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt").replaceAll("\n","<br>") %></td><!-- 글 제목 담음. -->
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%= bbs.getUserID() %></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="2"><%= bbs.getBbsDate().substring(0, 11)+bbs.getBbsDate().substring(11, 13)+"시" + bbs.getBbsDate().substring(14, 16)+"분" %></td>
					</tr>
					<tr>
						<td>내용</td>
						<td colspan="2" style="min-height: 200px; text-align: left;"><%= bbs.getBbsContent()
						.replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt").replaceAll("\n","<br>") %></td>
						<!-- 공백처리 : &nbsp로 바꿔서 출력, 모든 기호 html 안에서 사용되는 특수 기호로 바꾸기 -->
					</tr>
				</tbody>
			</table>
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
			<!-- 해당글 작성자라면 수정 삭제 -->
			<%
				if(userID != null && userID.equals(bbs.getUserID())){//현재 사용자가 해당글의 작성자와 동일하다면
			%>
				<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a><!-- bbsID를 가져갈 수 있도록 해서 매개변수로서 가져갈 수 있게 만들어줌. -->
				<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a><!-- 바로 삭제 진행하는 Action 페이지로 이동. -->
			<% 
				}
			%>
			<input type="submit" class="btn btn-primary pull-right" value="글쓰기">
		</div>
	</div>

</body>
</html>