<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %> <!-- 게시판의 목록을 출력하기 위해 필요 -->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" charset="UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<style type="text/css">
	a {
		color: #000000;
		text-decoration: none;
	}
	a:hover{
		color: #107836;
		text-decoration: none;
	}
</style>

<title>JSP 게시판 웹 사이트</title>
</head>
<body>
	<%
		
		String userID = null;
		if(session.getAttribute("userID") != null){//request.getParameter("name값")
			userID = (String)session.getAttribute("userID");
		}
		
		int pageNumber = 1;//현재 게시판이 몇 번째 페이지 인지 알려주기 위함, 1은 기본 페이지를 의미함.
		if(request.getParameter("pageNumber") != null){// 파라미터로 pageNumber가 넘어왔다면 해당 파라미터 값을 넣어줄 수 있도록 함. 
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));//파라미터는 정수형으로 바꿔주는 parseInt 함수 사용.
			
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
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<%
					    //게시글을 뽑아올 수 있도록 인스턴스 만듦
						BbsDAO bbsDAO = new BbsDAO();
						ArrayList<Bbs> list = bbsDAO.getList(pageNumber);//현재 페이지에서 가져온 리스트, 게시글 목록
						//가져온 목록을 하나씩 출력
						for(int i = 0; i < list.size(); i++){
					%>
							<!-- 현재 게시글에 대한 정보를 가져올 수 있게 함. -->
							<tr>
								<td><%= list.get(i).getBbsID() %></td>
								<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt").replaceAll("\n","<br>") %></a></td> <!-- 해당 게시글 눌렀을때 이동, 해당 게시글 번호를 매개변수로 jsp페이지로 보냄.   -->
								<td><%= list.get(i).getUserID() %></td>
								<td><%= list.get(i).getBbsDate().substring(0, 11)+list.get(i).getBbsDate().substring(11, 13)+"시" + list.get(i).getBbsDate().substring(14, 16)+"분" %></td><!-- 날짜형태 바꾸기 -->
							</tr>
					<%
						} 
					%>
				</tbody>
			</table>
			<% 
				if(pageNumber != 1){//1페이지가 아니라면 2페이지 이상이기 때문에
				
			%>
					<a href="bbs.jsp?pageNumber=<%=pageNumber -1%>" class="btn btn-success btn-arrow-left">이전</a><!-- 이전페이지로 돌아갈 수 있는게 필요 -->
			<% 
				}if(bbsDAO.nextPage(pageNumber+1)){//만들어놨던 함수 이용, 다음페이지가 존재한다면,pageNumber는 현재페이지
					
			%>
					<a href="bbs.jsp?pageNumber=<%=pageNumber +1%>" class="btn btn-success btn-arrow-right">다음</a><!-- 다음페이지로 이동할 수 있는게 필요 -->
			<% 
				}
			%>
			
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>

</body>
</html>