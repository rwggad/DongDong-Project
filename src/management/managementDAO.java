package management;

import board.Board;
import board.comment;
import list.clubcalendar;
import user.User;
import user.waitUser;

import javax.swing.plaf.basic.BasicInternalFrameTitlePane;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class managementDAO {
    private Connection conn;
    private ResultSet rs;

    // DataBase Connect
    public managementDAO() {
        try {
            String dbURL = "jdbc:mysql://localhost:3306/dongdong";
            String dbID = "root";
            String dbPassword = "root";
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    // 회원 목록 들고오기
    public ArrayList<User> getUserList(int boardKind) {
        String SQL = null;
        ArrayList<User> List = new ArrayList<>();
        if (boardKind >= 0) { // 동아리 멤버만
            SQL = "SELECT * FROM clubusers WHERE boardKind = ? AND isStaff = ?";
        } else { // 전체 회원 목록
            SQL = "SELECT * FROM user WHERE isCaptain != ?";
        }
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            if (boardKind >= 0) {
                pstmt.setInt(1, boardKind);
                pstmt.setInt(2, 0);
            }else{
                pstmt.setInt(1,9999);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                if (boardKind >= 0) {
                    user.setStudentNumber(rs.getString(4));
                    user.setStudentName(rs.getString(5));
                }else{
                    user.setStudentNumber(rs.getString(1));
                    //user.setStudentPassword(rs.getString(2));
                    user.setStudentName(rs.getString(3));
                    user.setIsCaptain(rs.getInt(4));
                }
                List.add(user);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return List;
    }

    // 게시물 목록 들고오기
    public ArrayList<Board> getBoardList(int boardKind) {
        String SQL = null;
        ArrayList<Board> List = new ArrayList<>();
        if (boardKind >= 0) { // 해당 동아리 게시물만 (삭제가 안된 게시물만 가져온다)
            SQL = "SELECT * FROM board WHERE boardKind = ? AND isDelete = ? ORDER BY boardID DESC";
        } else { // 전체 게시물 목록
            SQL = "SELECT * FROM board ORDER BY boardID DESC";
        }
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            if (boardKind >= 0) {
                pstmt.setInt(1, boardKind);
                pstmt.setInt(2, 1);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Board board = new Board();
                board.setBoardID(rs.getInt(1));
                board.setBoardKind(rs.getInt(2));
                board.setBoardTitle(rs.getString(3));
                board.setBoardWriter(rs.getString(4));
                board.setBoardContent(rs.getString(5));
                board.setBoardDate(rs.getString(6));
                board.setBoardCount(rs.getInt(7));
                board.setIsDelete(rs.getInt(8));
                List.add(board);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return List;
    }

    // 댓글 목록 들고오기
    public ArrayList<comment> getCommentList(int boardKind) {
        String SQL = null;
        ArrayList<comment> List = new ArrayList<>();
        if (boardKind >= 0) { // 해당 동아리 댓글만
            SQL = "SELECT * FROM comment WHERE boardKind = ? AND isDelete = ? ORDER BY commentID DESC";
        } else { // 전체 게시물 목록
            SQL = "SELECT * FROM comment ORDER BY commentID DESC";
        }
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            if (boardKind >= 0) {
                pstmt.setInt(1, boardKind);
                pstmt.setInt(2, 1);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                comment comment = new comment();
                comment.setCommentID(rs.getInt(1));
                comment.setBoardID(rs.getInt(2));
                comment.setCommentWriter(rs.getString(3));
                comment.setCommentContent(rs.getString(4));
                comment.setCommentDate(rs.getString(5));
                comment.setIsDelete(rs.getInt(6));
                List.add(comment);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return List;
    }

    // 일정 목록 들고오기
    public ArrayList<clubcalendar> getCalList(int boardKind) {
        String SQL = "SELECT * FROM clubcalendar WHERE boardKind = ? ORDER BY calID DESC";
        ArrayList<clubcalendar> List = new ArrayList<>();
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardKind);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                clubcalendar clubcalendar = new clubcalendar();
                clubcalendar.setCalID(rs.getInt(1));
                clubcalendar.setBoardKind(rs.getInt(2));
                clubcalendar.setCalDate(rs.getString(3));
                clubcalendar.setCalContent(rs.getString(4));
                List.add(clubcalendar);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return List;
    }

    // 회원 탈퇴
    public int userDrop(String studentNumber){
        /**
         * 이거 수정해야함*/
        String SQL = "DELETE FROM user WHERE studentNumber = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentNumber);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return -1;
    }

    // 동아리 회원 탈퇴시키기
    public int clubUserDrop(String studentNumber, int boardKind) {
        String SQL = null;
        if (boardKind >= 0) { // 동아리 회원 추방
            SQL = "DELETE FROM clubusers WHERE boardKind = ? AND studentNumber = ?";
        } else { // dong dong에서  추방
            SQL = "DELETE FROM user WHERE studentNuumber = ?";
        }
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            if (boardKind > 0) {
                pstmt.setInt(1, boardKind);
                pstmt.setString(2, studentNumber);
                /**
                 * 동아리 회원 탈퇴시 해당 동아리의 유저수 1씩 감소*/
                PreparedStatement pstmt2 = conn.prepareStatement("UPDATE clubList set clubUserCnt = clubUserCnt - 1 WHERE boardKind = ?");
                pstmt2.setInt(1,boardKind);
                pstmt2.executeUpdate();
            } else {
                pstmt.setString(1, studentNumber);
            }
            return pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return -1;
    }

    // 일정 삭제 시키기
    public int clubCalDrop(int calID) {
        String SQL = "DELETE FROM clubCalendar WHERE calID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, calID);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return -1;
    }

    // 게시물 삭제 시키기
    public int boardDrop(int boardID){
        String SQL = "DELETE FROM board WHERE boardID = ?";
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardID);
            return pstmt.executeUpdate();
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1;
    }

    // 댓글 삭제 시키기
    public int commentDrop(int commentID){
        String SQL = "DELETE FROM comment WHERE commentID = ?";
        try{
            PreparedStatement sptmt = conn.prepareStatement(SQL);
            sptmt.setInt(1, commentID);
            return sptmt.executeUpdate();
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1;
    }

    // 동아리 폐쇄
    public int clubDrop(int boardKind) {
        try {
            PreparedStatement pstmt;
            /**
             * 사용자 정보 삭제*/
            pstmt= conn.prepareStatement("DELETE FROM clubUsers WHERE boardKind = ?");
            pstmt.setInt(1,boardKind);
            pstmt.executeUpdate();
            /**
             * 동아리 정보 삭제*/
            pstmt= conn.prepareStatement("DELETE FROM clubList WHERE boardKind = ?");
            pstmt.setInt(1,boardKind);
            pstmt.executeUpdate();
            /**
             * 일정 정보 삭제*/
            pstmt= conn.prepareStatement("DELETE FROM clubCalendar WHERE boardKind = ?");
            pstmt.setInt(1,boardKind);
            pstmt.executeUpdate();

            /**
             * 게시물 삭제 id를 가져오고 그에 맞는 게시물 전부 삭제 */
            pstmt= conn.prepareStatement("SELECT boardID FROM board WHERE boardKind = ?");
            pstmt.setInt(1,boardKind);
            rs = pstmt.executeQuery();
            while(rs.next()){
                PreparedStatement pstmt2 = conn.prepareStatement("UPDATE board SET isDelete = 0 WHERE boardID = ?");
                pstmt2.setInt(1, rs.getInt(1));
                pstmt2.executeUpdate();

                PreparedStatement pstmt3 = conn.prepareStatement("UPDATE comment SET isDelete = 0 WHERE boardID = ?");
                pstmt3.setInt(1, rs.getInt(1));
                pstmt3.executeUpdate();
            }

            return 0;
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1;
    }


}
