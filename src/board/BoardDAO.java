package board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BoardDAO {
    private Connection conn;
    private ResultSet rs;
    // DataBase Connect
    public BoardDAO(){
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
    // 현재 시간을 가져오는 함수
    public String getDate(){
        String SQL = "SELECT NOW()"; // 현재 시간을 가져오는 mysql 문장
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getString(1);
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return ""; // database error;
    }
    // 게시글 또는 댓글에 마지막으로 쓰인 글의 번호를 들고와서 + 1 해주는 함수
    public int getNext(String SQL){
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getInt(1) + 1;
            }
            return 1; //첫번째 계시물인 경우
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1; // database error;
    }
    // 게시글을 작성
    public int write(int boardKind, String studentNumber, String boardTitle, String boardContent){
        String SQL = "INSERT INTO board VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
        try {

            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext("SELECT boardID FROM board order BY boardID DESC"));
            pstmt.setInt(2, boardKind);
            pstmt.setString(3, boardTitle);
            pstmt.setString(4, studentNumber);
            pstmt.setString(5, boardContent);
            pstmt.setString(6, getDate());
            pstmt.setInt(7, 0);
            pstmt.setInt(8, 1); // isDelete 0 이면 삭제된 게시글
            return pstmt.executeUpdate(); // 성공적으로 수행된 경우 0 이상으 숫자가 나옴
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1; // database error;
    }
    // 게시글 목록 가져오기
    public ArrayList<Board> getBList(int boardKind){
        // bbsID 가 ? 보다 작고 bbsAV == 1( 삭제가 안된 게시물) 을 10개 까지 가져온다
        String SQL = "SELECT * FROM board WHERE boardKind = ? AND isDelete = 1 ORDER BY boardID DESC";
        ArrayList<Board> List = new ArrayList<>();
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardKind);
            rs = pstmt.executeQuery();
            while(rs.next()){
                Board bbs = new Board();
                bbs.setBoardID(rs.getInt(1));
                bbs.setBoardKind(rs.getInt(2));
                bbs.setBoardTitle(rs.getString(3));
                bbs.setBoardWriter(rs.getString(4));
                bbs.setBoardContent(rs.getString(5));
                bbs.setBoardDate(rs.getString(6));
                bbs.setBoardCount(rs.getInt(7));
                bbs.setIsDelete(rs.getInt(8));
                List.add(bbs);
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return List;
    }
    // 게시물 ID에 맞는 게시물 가져오기
    public Board getBbs(int boardID){
        String SQL = "SELECT * FROM board WHERE boardID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1,boardID);
            rs = pstmt.executeQuery();
            if(rs.next()) {
                Board bbs = new Board();
                bbs.setBoardID(rs.getInt(1));
                bbs.setBoardKind(rs.getInt(2));
                bbs.setBoardTitle(rs.getString(3));
                bbs.setBoardWriter(rs.getString(4));
                bbs.setBoardContent(rs.getString(5));
                bbs.setBoardDate(rs.getString(6));
                bbs.setBoardCount(rs.getInt(7));
                bbs.setIsDelete(rs.getInt(8));
                return bbs;
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return null; // 게시물 내용이 없음
    }
    // 게시물 수정
    public int update(int boardID, String boardTitle, String boardContent){
        String SQL = "UPDATE board SET boardTitle = ? , boardContent = ? WHERE boardID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1,boardTitle);
            pstmt.setString(2, boardContent);
            pstmt.setInt(3, boardID);
            return pstmt.executeUpdate(); // 성공적으로 수행된 경우 0 이상으 숫자가 나옴
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1; // database error;
    }
    // 게시물 삭제
    public int delete(int boardID){
        String SQL = "UPDATE board SET isDelete = 0 WHERE boardID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardID);
            return pstmt.executeUpdate(); // 성공적으로 수행된 경우 0 이상으 숫자가 나옴
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1; // database error;
    }
    // 조회수 가져오기
    public int getCount(int boardID){
        String SQL = "SELECT boardCount FROM board WHERE boardID = ?";
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1,boardID);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getInt(1) + 1;
            }
            return -1;
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -2;
    }
    // 조회수 설정하기
    public int setCount(int boardID){
        String SQL ="UPDATE board SET boardCount = ? WHERE boardID = ?";
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getCount(boardID));
            pstmt.setInt(2,boardID);
            return pstmt.executeUpdate(); // 성공적으로 수행된 경우 0 이상으 숫자가 나옴
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1; // db error
    }


    // 댓글 작성
    public int commentWrite(int boardID, int boardKind, String studentNumber, String commentContent) {
        String SQL = "INSERT INTO comment VALUES(?,?, ?, ?,?,?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext("SELECT commentID FROM comment order BY commentID DESC"));
            pstmt.setInt(2,boardID);
            pstmt.setString(3,studentNumber);
            pstmt.setString(4,commentContent);
            pstmt.setString(5,getDate());
            pstmt.setInt(6,1);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return -1;
    }
    // 게시판작성된 댓글 목록 가져오기
    public ArrayList<comment>getCList(int boardID){
        String SQL = "SELECT * FROM comment WHERE boardID = ? AND isDelete = 1 ORDER BY commentID DESC";
        ArrayList<comment>List = new ArrayList<>();
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardID);
            rs = pstmt.executeQuery();
            while(rs.next()){
                comment comment = new comment();
                comment.setCommentID(rs.getInt(1));
                comment.setBoardID(rs.getInt(2));
                comment.setCommentWriter(rs.getString(3));
                comment.setCommentContent(rs.getString(4));
                comment.setCommentDate(rs.getString(5));
                comment.setIsDelete(rs.getInt(6));
                List.add(comment);
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return List;
    }
    // 댓글 ID에 맞은 댓글 가져오기
    public comment getComment(int commentID){
        String SQL = "SELECT * FROM comment WHERE commentID = ?";
        comment comment = new comment();
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, commentID) ;
            rs = pstmt.executeQuery();
            if(rs.next()){
                comment.setCommentID(rs.getInt(1));
                comment.setBoardID(rs.getInt(2));
                comment.setCommentWriter(rs.getString(3));
                comment.setCommentContent(rs.getString(4));
                comment.setCommentDate(rs.getString(5));
                comment.setIsDelete(rs.getInt(6));
                return comment;
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return null;
    }
    // 댓글 삭제
    public int commentDelete(int commentID) {
        String SQL = "UPDATE comment SET isDelete = 0 WHERE commentID = ?";
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, commentID);
            return pstmt.executeUpdate();
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1;
    }
}
