package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	private Connection conn;
	private ResultSet rs;
	
	//실제 MySQL에 접속하게 해주는 부분
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";//"jdbc:mysql://localhost:3306";//"jdbc:mysql://localhost:3306/데이터명?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC"; 
			String dbID = "root";
			String dbPassword = "1234";
			Class.forName("com.mysql.cj.jdbc.Driver");//com.mysql.jdbc.Driver 더이상 사용 안함.//com.mysql.cj.jdbc.Driver
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	
	//현재시간을 가져온 함수, 글작성시 서버의 시간을 넣어주는 역할
	public String getDate() {
		//BbsDAO 클래스는 여러개의 함수가 사용되기 때문에 각각 함수끼리 데이터베이스 접근에
		//마찰이 일어나지 않도록 pstmt를 안쪽에 넣어줌.
		String SQL = "SELECT NOW()";//현재 시간 가져오는 MySQL 함수
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);//현재 연결되어 있는 conn 객체를 통해서 SQL 문장을 실행 준비 단계로 만들어줌.
			rs = pstmt.executeQuery();//실제로 실행했을 때 나오는 결과를 가져올 수 있도록 함.
			if(rs.next()) {//결과가 있는경우
				return rs.getString(1);//현재 그날짜 그대로 반환
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";//빈 문자열 반환으로 데이터 베이스 오류 알려줌
	}
	
	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";//게시글 id를 가져옴, 1번부터 하나씩 늘어나야 되기 때문에 마지막에 쓰인 글을 가져와서 
		                                                         //그 번호에 +1한 값이 다음 글의 번호가 됨. 내림차순으로 가장 마지막에 쓰인 번호 가져옴.
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);//현재 연결되어 있는 conn 객체를 통해서 SQL 문장을 실행 준비 단계로 만들어줌.
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1)+1;//그 다음 게시글의 번호
			}
			return 1;// 현재 쓰여있는 게시물이 없는 경우(첫번째 게시물)
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류(게시글 번호에 적절하지 않은 -숫자)
	}
	
	//하나의 게시물을 실제로 데이터베이스에 삽입하는 write 함수
	
	public int write(String bbsTitle, String userID, String bbsContent) {//현재시간을 가져온 함수, 글작성시 서버의 시간을 넣어주는 역할
		String SQL = "INSERT INTO BBS VALUES(?,?,?,?,?,?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());// 다음번에 사용될 게시글 번호
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);//Available 처음에 글을 작성했을 때 글이 보여지고, 삭제가 안됐기 때문에 1을 넣어줌
			//rs = pstmt.executeQuery();INSERT문은 executeUpdate()로 업데이트 작동하기 때문에 executeQuery() 필요없음
			return pstmt.executeUpdate();//성공적으로 수행했다면 0이상의 결과 반환,
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류(게시글 번호에 적절하지 않은 -숫자)
	}

	
	//게시판은 1페이지 2페이지 이런식으로 페이지를 넘겨 가면서 글들을 읽을 수 있도록 되어있음.
	//페이지에 총10개의 게시글을 가져올 수 있도록 함.
	public ArrayList<Bbs> getList(int pageNumber){//특정한 리스트를 담아서 알아낼 수 있도록함.

		// 삭제되지 않아 bbsAvilable=1인 글들만 가져올 수 있게 만듦.
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		ArrayList<Bbs> list = new ArrayList<Bbs>();//bbs라는 클래스에서 나온 인스턴스를 보관할 수 있는 리스트
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);//현재 연결되어 있는 conn 객체를 통해서 SQL 문장을 실행 준비 단계로 만들어줌.
			pstmt.setInt(1, getNext()-(pageNumber -1)*10);//getNext는 다음으로 작성될 글 번호(5페이지가 있으면 6), pageNumber는 5개밖에 없으니까 1페이지가 됨. 
														  //결과적으로 계산했을때 6이라는 값이 담김.6보다 작은 것만 가져오기 때문에 1부터 5까지 모든 글자가 나옴
			rs = pstmt.executeQuery();
			while(rs.next()) {
				Bbs bbs = new Bbs();// bbs 인스턴스 만들어서
				bbs.setBbsID(rs.getInt(1));//bbs에 담긴 모든 속성을 뺴옴(select*), 각각 다 넣어주면 작동하게 됨.
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));//결과로 나온 모든 게시글 목록을 다 담아서
				list.add(bbs);//list에 담아서 반환
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;//결과적으로 10개 뽑아온 게시글 리스트를 출력할 수 있도록 함.
		
	}
	
	//페이지가 10개 단위로 끝긴다면 게시글이 10개일때는 다음 버튼이 없어야함.
	//특정한 페이지가 존재하는지 nextPage함수를 이용해 물어봄.
	//페이징 처리
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM bbs WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pageNumber -1)*10);
			rs = pstmt.executeQuery();
			if(rs.next()) {//결과가 하나라도 존재한다면
				return true;// 다음 페이지로 넘어감
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;//다음 결과가 없다면
	}
	
	//하나의 글 내용을 불러오는 함수
	public Bbs getBbs(int bbsID) {//4. getBbs 이 함수를 불러낸 대상한테(반환해줌)
		String SQL = "SELECT * FROM BBS WHERE bbsID = ? ";//bbsID가 특정한 숫자인 경우 어떤행위를 실행
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);//bbsID가 어떤 값을 넣어서 그 숫자에 해당하는 게시글을 가져옴.
			rs = pstmt.executeQuery();
			if(rs.next()) {//결과가 하나라도 존재한다면
				Bbs bbs = new Bbs();//2. bbs 인스턴스 넣어서
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));//1. 결과로 나온 변수 6개를 받은 다음에
				return bbs;//3. 이걸 그대로 반환해줌.
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;//해당 글이 존재하지 않는다면 null 반환
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent) {//특정한 번호에 매개변수로 들어온 제목, 내용으로 바꿔치기
		String SQL = "UPDATE BBS SET bbsTitle= ?, bbsContent = ? WHERE bbsID = ?";//특정ID에 해당하는 제목 내용 바꿔줌.
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();//성공적으로 수행했다면 0이상의 결과 반환,
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류(게시글 번호에 적절하지 않은 -숫자)
	}
	
	public int delete(int bbsID) {//어떠한 글인지 알 수 있게 bbsID 받아옴
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";//글을 삭제하더라도 글의 정보가 남아있을 수 있도록 bbsAvailable = 0 으로 바꿈으로 delete 함수 구현
		try {	
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);//성공적으로 bbsID값을 들어갈 수 있게 해서 bbsAvailable 값을 0으로 바꿈으로서 삭제처리함.
			return pstmt.executeUpdate();//성공일 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;//성공적일 경우 0 이상 반환 오류일때 -값 반환
		
	}

}
