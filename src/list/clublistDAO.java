package list;

import user.UserDAO;
import user.waitUser;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class clublistDAO {
    private Connection conn;
    private ResultSet rs;
    // DataBase Connect
    public clublistDAO(){
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

    // 다음 ID 들고오기
    public int getNext(String SQL){
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getInt(1) + 1;
            }else{
                return 1;
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1;
    }
    // boardKind 들고오기
    public int getBoardKind(){
        while(true){
            double randomValue = Math.random();
            int intValue = (int)(randomValue * 1000) + 1;
            try{
                PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM clubList WHERE boardKind = ?");
                pstmt.setInt(1, intValue);
                rs = pstmt.executeQuery();
                if(!rs.next()) {
                    /**
                     * 중복되는 kind값이 아닐 때*/
                    return intValue;
                }
            }catch (Exception e){
                System.out.println(e.toString());
            }
        }
    }

    // 이미 회원인지
    public boolean isClubUser(int boardKind, String studentNumber){
        try{
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM clubusers WHERE studentNumber = ?  AND boardKind = ?");
            pstmt.setString(1, studentNumber);
            pstmt.setInt(2, boardKind);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return true;
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return false;
    }
    // 회원 추가
    public int joinClub(int boardKind_id, String clubName, String studentNumber, int isStaff){
        try {
            /**
             * 동아리 회원 탈퇴시 해당 동아리의 유저수 1씩 증가*/
            PreparedStatement pstmt2 = conn.prepareStatement("UPDATE clubList set clubUserCnt = clubUserCnt + 1 WHERE boardKind = ?");
            pstmt2.setInt(1,boardKind_id);
            pstmt2.executeUpdate();
            /**
             * DB에 추가 해줌*/
            PreparedStatement pstmt1= conn.prepareStatement("INSERT INTO clubUsers VALUES(?, ?, ?, ?, ?)");
            pstmt1.setInt(1, getNext("SELECT infoID FROM clubUsers order BY infoID DESC"));
            pstmt1.setInt(2, boardKind_id);
            pstmt1.setString(3, clubName);
            pstmt1.setString(4, studentNumber);
            pstmt1.setInt(5, isStaff);
            return pstmt1.executeUpdate();
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1; // db error
    }
    // 다음 id를 받아온후 db 인설트
    public int createClub(clublist list, String studentNumber){
        int boardKind_id = getBoardKind();
        String SQL = "INSERT INTO clubList VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            /**
             * 동아리 장 정보를 clubusers에 추가*/
            joinClub(boardKind_id, list.getClubName(), studentNumber, 1);
            /**
             * clublist에 추가*/
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardKind_id);
            pstmt.setString(2, studentNumber);
            pstmt.setString(3, list.getClubName());
            pstmt.setString(4, list.getClubContent());
            pstmt.setString(5, list.getClubLocation());
            pstmt.setString(6, list.getClubPhoneNumber());
            pstmt.setInt(7, 0);
            pstmt.setInt(8, list.getClubKind());
            return pstmt.executeUpdate(); // 성공적으로 수행된 경우 0 이상으 숫자가 나옴
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1; // database error;
    }

    // 대기 목록삭제
    public int deleteWait(String studentNumber){
        try{
            PreparedStatement pstmt = conn.prepareStatement("DELETE FROM waitusers WHERE studentNumber = ?");
            pstmt.setString(1,studentNumber);
            return pstmt.executeUpdate();
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1;
    }
    // 대기 목록 추가
    public int InsertWait(int boardKind, String sutdentNumber, String waitContent){
        try {
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO waitusers VALUES(?, ?, ?, ?)");
            pstmt.setInt(1, getNext("SELECT infoID FROM waitusers order BY infoID DESC "));
            pstmt.setInt(2, boardKind);
            pstmt.setString(3, waitContent);
            pstmt.setString(4, sutdentNumber);
            return pstmt.executeUpdate();
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1;
    }
    // 대기 목록에 있는지 확인
    public boolean isWait(String studentNumber, int boardKind){
        try{
            PreparedStatement pstmt = conn.prepareStatement("SELECT studentNumber FROM waitusers WHERE studentNumber = ? ABD boardKind = ?");
            pstmt.setString(1, studentNumber);
            pstmt.setInt(2, boardKind);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return true;
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return false;
    }
    // 대기 목록 가져오기
    public ArrayList<waitUser> getWaitUser(int boardKind){
        ArrayList<waitUser> waitList = new ArrayList<>();
        String SQL = "SELECT * FROM waitusers WHERE boardKind = ?";
        try{
            PreparedStatement sptmt = conn.prepareStatement(SQL);
            sptmt.setInt(1, boardKind);
            rs = sptmt.executeQuery();
            while(rs.next()){
                waitUser list = new waitUser();
                list.setInfoID(rs.getInt(1));
                list.setBoardKind(rs.getInt(2));
                list.setWaitContent(rs.getString(3));
                list.setStudentNumber(rs.getString(4));
                waitList.add(list);
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return waitList;
    }

    // 현재 kind(분류)에 맞는 동아리 가져오기
    public ArrayList<clublist> getList(int clubKind){
        String SQL = null;
        if(clubKind == 0){
            SQL = "SELECT * FROM clubList";
        }else{
            SQL = "SELECT * FROM clubList where clubKind = ?";
        }
        ArrayList<clublist> List = new ArrayList<>();
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            if(clubKind != 0)
                pstmt.setInt(1, clubKind);
            rs = pstmt.executeQuery();
            while(rs.next()){
                clublist dlist = new clublist();
                dlist.setBoardKind(rs.getInt(1));
                dlist.setClubCaptain(rs.getString(2));
                dlist.setClubName(rs.getString(3));
                dlist.setClubContent(rs.getString(4));
                dlist.setClubLocation(rs.getString(5));
                dlist.setClubPhoneNumber(rs.getString(6));
                dlist.setClubUserCnt(rs.getInt(7));
                dlist.setClubKind(rs.getInt(8));
                List.add(dlist);
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return List;
    }
    // 내 동아리 list 들고오기
    public ArrayList<clubusers> getMyList(String studentNumber, int boardKind){
        String SQL = null;
        if(boardKind == -1){
            SQL = "SELECT * FROM clubUsers where studentNumber = ?";
        }else{
            SQL = "SELECT * FROM clubUsers where studentNumber = ? AND boardKind = ?";
        }
        ArrayList<clubusers> List = new ArrayList<>();
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentNumber);
            if(boardKind != - 1) pstmt.setInt(2, boardKind);
            rs = pstmt.executeQuery();

            while(rs.next()){
                clubusers member = new clubusers();
                member.setInfoID(rs.getInt(1));
                member.setBoardKind(rs.getInt(2));
                member.setClubName(rs.getString(3));
                member.setStudentNumber(rs.getString(4));
                member.setIsStaff(rs.getInt(5));
                List.add(member);
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return List;
    }
    // id값에 해당되는 동아리 정보 가져오기
    public clublist getClubInfo(int boardKind){
        String SQL="SELECT * FROM clublist WHERE boardKind = ?";
        clublist clubInfo = new clublist();
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardKind);
            rs = pstmt.executeQuery();
            if(rs.next()){
                clubInfo.setBoardKind(rs.getInt(1));
                clubInfo.setClubLocation(rs.getString(2));
                clubInfo.setClubName(rs.getString(3));
                clubInfo.setClubContent(rs.getString(4));
                clubInfo.setClubLocation(rs.getString(5));
                clubInfo.setClubPhoneNumber(rs.getString(6));
                clubInfo.setClubUserCnt(rs.getInt(7));
                clubInfo.setClubKind(rs.getInt(8));
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return clubInfo;
    }

    // 캘린더 일정 추가
    public int insertCal(int boardKind, String calDate, String calContent){
        String SQL = "INSERT INTO clubCalendar VALUES(?,?,?,?)";
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext("SELECT calID FROM clubCalendar order BY calID DESC"));
            pstmt.setInt(2, boardKind);
            pstmt.setString(3, calDate);
            pstmt.setString(4,calContent);
            return pstmt.executeUpdate();
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return -1;
    }
    // 캘린더 일정 가져오기
    public ArrayList<clubcalendar> getCalList(String calDate, int boardKind){
        String SQL = "SELECT * FROM clubCalendar WHERE calDate = ? AND boardKind = ? ORDER BY calID DESC";
        ArrayList<clubcalendar> List = new ArrayList<>();
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, calDate);
            pstmt.setInt(2, boardKind);
            rs = pstmt.executeQuery();
            while(rs.next()){
                clubcalendar clubcalendar = new clubcalendar();
                clubcalendar.setCalID(rs.getInt(1));
                clubcalendar.setBoardKind(rs.getInt(2));
                clubcalendar.setCalDate(rs.getString(3));
                clubcalendar.setCalContent(rs.getString(4));
                List.add(clubcalendar);
            }
        }catch (Exception e){
            System.out.println(e.toString());
        }
        return List;
    }
 }
