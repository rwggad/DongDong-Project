<%--
  Created by IntelliJ IDEA.
  User: rwgga
  Date: 2018-10-20
  Time: 오후 11:29
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="list.clubusers" %>
<%@ page import="list.clublistDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="user.UserDAO" %>
<%@ page import="management.managementDAO" %>
<%@ page import="board.Board" %>
<%@ page import="list.clubcalendar" %>
<%@ page import="board.comment" %>
<%@ page import="user.User" %>
<%@ page import="list.clublist" %>
<%@ page import="user.waitUser" %>
<!DOCTYPE html>
<html>
<head>
    <title>DONG_DONG</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width" , initial-scale="1">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
    <link href="https://fonts.googleapis.com/css?family=Cute+Font|Gaegu:300,400,700|Gamja+Flower|Gugi|Jua|Sunflower:300,500,700&amp;subset=korean" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
    <style type="text/css">
        *{
            font-family: 'Jua', sans-serif;
        }
    </style>
</head>
<!-- 시작 -->
<body class="bg-secondary">
<%
    int isCaptain = -1; // 현재 접속한 회원이 동아리장 인지?
    if (session.getAttribute("isCaptain") != null) {
        isCaptain = (Integer) session.getAttribute("isCaptain");
    }
    String studentNumber = null; // 현재 접속된 회원이 있는지 ?
    if (session.getAttribute("studentNumber") != null) {
        studentNumber = (String) session.getAttribute("studentNumber");
    }
    int boardKind = -10;
    if (request.getParameter("boardKind") != null) {
        boardKind = Integer.parseInt(request.getParameter("boardKind"));
    }
    ArrayList<clubusers> members = new ArrayList<>();
    members = new clublistDAO().getMyList(studentNumber, boardKind);
    String studentName = new UserDAO().userName(studentNumber); // 학번으로 이름 따오기
    clublist club = new clublist();
    club = new clublistDAO().getClubInfo(boardKind);

    if (boardKind == -10) { // boardKind 가 넘어오지않으면 error
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('BK == -2 ERROR')");
        script.println("location.href = '/MainPage/main.jsp' ");
        script.println("</script>");
    }
    if (studentNumber == null) { // 로그인을 안했다면
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인 하세요.')");
        script.println("location.href = '/MainPage/login.jsp'");
        script.println("</script>");
    }
    if (members.size() == 0) { // 해달 동아리의 멤버가 아니라면
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.(해당 동아리 회원이 아닙니다.)')");
        script.println("location.href = '/MainPage/findClub.jsp?clubKind=" + 0 + "&CurClubKind=" + "전체" + "'");
        script.println("</script>");
    }else if(members.get(0).getIsStaff() != 1){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.(해당 동아리 관리자가 아닙니다.)')");
        script.println("location.href = '/clubPage/club.jsp?boardKind=" + boardKind + "'");
        script.println("</script>");
    }
%>
<!-- 네비게이션 바 시작 -->
<nav class="navbar navbar-expand-sm navbar-dark bg-success sticky-top">
    <!-- 홈 버튼 -->
    <a class="navbar-brand" href="/MainPage/main.jsp">DD</a>
    <!-- 우측 버튼 지정 -->
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#myNav">
        <span class="navbar-toggler-icon"></span>
    </button>
    <!-- 네비게이션바 내용 설정 -->
    <div class="collapse navbar-collapse" id="myNav">
        <ul class="navbar-nav mr-auto">
            <!-- 바로 가기 버튼 -->
            <li class="nav-item active">
                <a class="nav-link"
                   href="/clubPage/club.jsp?&boardKind=<%=members.get(0).getBoardKind()%>"><%=club.getClubName()%>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/clubPage/clubCalendar.jsp?boardKind=<%=boardKind%>">일정</a>
            </li>
        </ul>
        <ul class="navbar-nav">
            <!-- 멤버수 -->
            <li class="nav-item active disabled">
                <a class="nav-link"><%="멤버수 : " + club.getClubUserCnt()%></a>
            </li>
            <!--드롭 다운 -->
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="myNavDropdwon" role="button" data-toggle="dropdown"
                   aria-haspopup="true" aria-expanded="false">더보기</a>
                <div class="dropdown-menu dropdown-menu-right">
                    <a class="dropdown-item disabled"><span class="btn btn-outline-success"><%=studentName + "님"%></span></a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="/Action/LogoutAction.jsp">로그아웃</a>
                    <%if(members.get(0).getIsStaff() == 1){%>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="/clubPage/managementClub.jsp?boardKind=<%=boardKind%>">동아리 관리</a>
                    <%}else{%>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item disabled" onclick="if(!confirm('정말로 탈퇴하시겠습니까?')){return false}"
                       href="/Action/clubUserDropAction.jsp?boardKind=<%=boardKind%>&outStudentNumber=<%=studentNumber%>&option=<%=-9999%>">
                        <span class="btn btn-outline-danger">동아리 탈퇴하기</span></a>
                    <%}%>
                </div>
            </li>
        </ul>
    </div>
</nav>
<hr>
<section class="container">
    <div class="jumbotron bg-light">
        <div class="container">
            <h1>내 동아리 관리</h1>
            <br>
            <div class="progress">
                <div class="progress-bar bg-success" style="width: 100%"></div>
            </div>
            <br>
            <!-- 관리 -->
            <% managementDAO mmDAO = new managementDAO();%>
            <div class="container">
                <div id="accordion">
                    <!-- 가입 신청 관리 -->
                    <div class="card">
                        <div class="card-header">
                            <a class="card-link" data-toggle="collapse" data-parent="#accordion" href="#collapseZero">가입 신청 관리</a>
                        </div>
                        <div id="collapseZero" class="collapse">
                            <div class="card-body">
                                <table class="table table-light table-bordered">
                                    <%
                                        ArrayList<waitUser> waitUsers = new clublistDAO().getWaitUser(boardKind);
                                        if (waitUsers.size() == 0) { %>
                                    <p>신청중인 회원이 없습니다.</p>
                                    <% } %>
                                    <thead class="table-sm">
                                    <tr>
                                        <td>학번</td>
                                        <td>이름</td>
                                        <td>신청 내용</td>
                                        <td></td>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (int i = 0; i < waitUsers.size(); i++) {%>
                                    <tr>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=waitUsers.get(i).getStudentNumber()%>
                                            </a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=new UserDAO().userName(waitUsers.get(i).getStudentNumber())%>
                                            </a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=waitUsers.get(i).getWaitContent()%>
                                            </a>
                                        </td>
                                        <td align="right">
                                            <a onclick="if(!confirm('가입 신청을 승인 하시겠습니까?')){return false}"
                                               href="/Action/waitUserControl.jsp?otherStudentNumber=<%=waitUsers.get(i).getStudentNumber()%>&boardKind=<%=waitUsers.get(i).getBoardKind()%>&option=<%=1%>" class="btn btn-primary btn-sm">승인</a>
                                            <a onclick="if(!confirm('가입 신청을 거절 하시겠습니까?')){return false}"
                                               href="/Action/waitUserControl.jsp?otherStudentNumber=<%=waitUsers.get(i).getStudentNumber()%>&boardKind=<%=waitUsers.get(i).getBoardKind()%>&option=<%=0%>"  class="btn btn-danger btn-sm">거절</a>
                                        </td>
                                    </tr>
                                    </tbody>
                                    <%
                                        }
                                    %>
                                </table
                            </div>
                        </div>
                    </div>
                    <br>
                    <!-- 회원관리 -->
                    <div class="card">
                        <div class="card-header">
                            <a class="card-link" data-toggle="collapse" data-parent="#accordion" href="#collapseOne">회원관리</a>
                        </div>
                        <div id="collapseOne" class="collapse">
                            <div class="card-body">
                                <table class="table table-light table-bordered">
                                    <%
                                        ArrayList<User> users = mmDAO.getUserList(boardKind);
                                        if (users.size() == 0) { %>
                                    <p>가입한 회원이 없습니다.</p>
                                    <% } %>
                                    <thead class="table-sm">
                                    <tr>
                                        <td>학번</td>
                                        <td>이름</td>
                                        <td></td>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (int i = 0; i < users.size(); i++) {%>
                                    <tr>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=users.get(i).getStudentNumber()%>
                                            </a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=new UserDAO().userName(users.get(i).getStudentNumber())%>
                                            </a>
                                        </td>
                                        <td align="right">
                                            <a onclick="if(!confirm('정말로 추방하시겠습니까?')){return false}"
                                               href="/Action/clubUserDropAction.jsp?boardKind=<%=boardKind%>&outStudentNumber=<%=users.get(i).getStudentNumber()%>&option=<%=0%>"
                                               class="btn btn-danger btn-sm">추방</a> <!--삭제-->
                                        </td>
                                    </tr>
                                    </tbody>
                                    <%
                                        }
                                    %>
                                </table
                            </div>
                        </div>
                    </div>
                    <br>
                    <!-- 게시글 관리 -->
                    <div class="card">
                        <div class="card-header">
                            <a class="card-link" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">게시글
                                관리</a>
                        </div>
                        <div id="collapseTwo" class="collapse">
                            <div class="card-body">
                                <table class="table table-light table-bordered">
                                    <%
                                        ArrayList<Board> boards = mmDAO.getBoardList(boardKind);
                                        if (boards.size() == 0) { %>
                                    <p>작성된 게시물이 없습니다.</p>
                                    <% } %>
                                    <thead class="table-sm">
                                    <tr>
                                        <td>id</td>
                                        <td>제목</td>
                                        <td>작성자</td>
                                        <td></td>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (int i = 0; i < boards.size(); i++) {%>
                                    <tr>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=boards.get(i).getBoardID()%>
                                            </a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"
                                               href="/BoardPage/view.jsp?boardID=<%=boards.get(i).getBoardID()%>&boardKind=<%=boardKind%>"><%=boards.get(i).getBoardTitle()%>
                                            </a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=new UserDAO().userName(boards.get(i).getBoardWriter()) + "(" + boards.get(i).getBoardWriter() + ")" %>
                                            </a>
                                        </td>
                                        <td align="right">
                                            <a onclick="if(!confirm('정말로 삭제하시겠습니까?')){return false}"
                                               href="/Action/boardDropAction.jsp?boardID=<%=boards.get(i).getBoardID()%>&boardKind=<%=boardKind%>"
                                               class="btn btn-danger btn-sm">삭제</a> <!--삭제-->
                                        </td>
                                    </tr>
                                    </tbody>
                                    <%
                                        }
                                    %>
                                </table>
                            </div>
                        </div>
                    </div>
                    <br>
                    <!-- 일정 관리 -->
                    <div class="card">
                        <div class="card-header">
                            <a class="card-link" data-toggle="collapse" data-parent="#accordion" href="#collapseThree">일정
                                관리</a>
                        </div>
                        <div id="collapseThree" class="collapse">
                            <div class="card-body">
                                <table class="table table-light table-bordered">
                                    <%
                                        ArrayList<clubcalendar> clubcalendars = mmDAO.getCalList(boardKind);
                                        if (clubcalendars.size() == 0) { %>
                                    <p>등록된 일정이 없습니다.</p>
                                    <% } %>
                                    <thead class="table-sm">
                                    <tr>
                                        <td>id</td>
                                        <td>날짜</td>
                                        <td>일정 내용</td>
                                        <td></td>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (int i = 0; i < clubcalendars.size(); i++) {%>
                                    <tr>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=clubcalendars.get(i).getCalID()%>
                                            </a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=clubcalendars.get(i).getCalDate()%>
                                            </a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=clubcalendars.get(i).getCalContent()%>
                                            </a>
                                        </td>
                                        <td align="right">
                                            <a onclick="if(!confirm('정말로 삭제하시겠습니까?')){return false}"
                                               href="/Action/clubCalendarDropAction.jsp?calID=<%=clubcalendars.get(i).getCalID()%>&boardKind=<%=boardKind%>"
                                               class="btn btn-danger btn-sm">삭제</a> <!--삭제-->
                                        </td>
                                    </tr>
                                    </tbody>
                                    <%
                                        }
                                    %>
                                </table>
                            </div>
                        </div>
                    </div>
                    <br>
                </div>
            </div>
            <br>
            <!-- 동아리 폐쇄 -->
            <div align="center">
                <a onclick="if(!confirm('정보를 다시 되 돌릴수 없습니다. 정말로 폐쇄하시겠습니까??')){return false}"
                   href="/Action/clubDropAction.jsp?boardKind=<%=boardKind%>&option=<%=0%>"
                   class="btn btn-danger btn-lg">동아리 폐쇄</a> <!--삭제-->
            </div>
        </div>
    </div>
</section>
<footer>
    <hr>
    <div align="right"><p>dongdong!&nbsp;&nbsp;</p></div>
</footer>
</body>
</html>
