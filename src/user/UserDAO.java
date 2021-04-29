package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	//실제 MySQL에 접속하게 해주는 부분
	public UserDAO() {
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
	
	public int login(String userID, String userPassword) {
		String SQL = "SELECT userPassword FROM user WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();// 결과가 존재한다면 실행
			
			if (rs.next()) {
				if(rs.getString(1).equals(userPassword)) {
					return 1; //로그인 성공
				}else {
					return 0; // 패스워드 불일치
				}
			}
			return -1;// 아이디가 없음
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -2; // 데이터베이스 오류를 의미
	}
	
	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES(?,?,?,?,?)";
		try {
			pstmt = conn.prepareStatement(SQL); //PreparedStatement 문구는 위에 명시한 sql문장을 넣는 방식, pstmt에 인스턴스를 넣어줌.
			pstmt.setString(1, user.getUserID());//각각?에 해당하는 내용이 뭐가 들어갈지. 
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName()); 
			pstmt.setString(4, user.getUserGender()); 
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate();//해당 pstmt를 실행한 뒤 결과를 넣을 수 있다. 
			                             //insert 문장의 경우는 반드시 0이상의 숫자가 반환되기 때문에 -1이 아닌경우는 성공적으로 회원가입이 이루어 진다.
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;// 예외가 발생했을때, 해당 아이디가 이미 존재하는 경우
		          //userID(pk)이기 때문
	}
	
}
