package user;

import board.Board;

import javax.annotation.processing.SupportedSourceVersion;
import javax.swing.plaf.basic.BasicInternalFrameTitlePane;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class UserDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    // 디비 접속
    public UserDAO(){
        try{
            String dbURL = "jdbc:mysql://localhost:3306/dongdong";
            String dbID = "root";
            String dbPassword = "root";
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        }catch (Exception e){
            System.out.println(e.toString());
        }
    }
    // userID로 넘어온 ID값이 db에 존재 하는지 확인하고 존재한다면 그 아이디의 password 값으 무엇인지?
    public int login(User user){
        String SQL = "SELECT studentPassword from user where studentNumber = ?"; // 여기에 있는 ? 에 대한 내용을
        try{
            pstmt = conn.prepareStatement(SQL); // 여기서 연결하고
            pstmt.setString(1, user.getStudentNumber()); // 그 물음표에 대한 값으로 user ID를 넣어준다.
            rs = pstmt.executeQuery();
            if(rs.next()){ // 결과가 존재한다면 ( ID가 있다면 )
                if(rs.getString(1).equals(user.getStudentPassword())) // 해당 아이디에 대한 password값과 같다면
                    return 1; // 로그인 성공
                else
                    return 0; // 로그인 실패 ( 비밀번호 불일치 )
            }else{
                return -1; // 로그인 실패 ( 아이디가 존재 하지 않음 )
            }

        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -2; // db error
    }
    // 회원가입
    public int join(User user){
        String SQL = "INSERT INTO USER VALUES(?, ?, ?, ?)";
        try{
            pstmt = conn.prepareStatement(SQL); // 여기서 연결하고
            pstmt.setString(1, user.getStudentNumber()); // 그 물음표에 대한 값으로 user ID를 넣어준다.
            pstmt.setString(2, user.getStudentPassword()); // 그 물음표에 대한 값으로 user Password 넣어준다.
            pstmt.setString(3, user.getStudentName()); // 그 물음표에 대한 값으로 user Name 를 넣어준다.
            pstmt.setInt(4, user.getIsCaptain());
            return pstmt.executeUpdate(); // INSERT문을 실행후 성공하면 무조건 0 이상의 숫자가 반환이 된다.
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1; // db error
    }
    // 학부생, 동아리장 파악
    public int isCaptain(String studentNumber){
        String SQL = "SELECT isCaptain FROM user where studentNumber = ?";
        try{
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentNumber);
            rs =  pstmt.executeQuery();
            if(rs.next()){
                return rs.getInt(1);
            }else{
                return -1;
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -2; // db error
    }
    // 학번으로 이름 따오기
    public String userName(String studentNumber){
        String SQL = "SELECT studentName FROM user where studentNumber = ?";
        try{
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentNumber);
            rs =  pstmt.executeQuery();
            if(rs.next()){
                return rs.getString(1);
            }else{
                return null;
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return null; // db error
    }

}
