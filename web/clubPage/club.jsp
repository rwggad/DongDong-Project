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
<%@ page import="board.BoardDAO" %>
<%@ page import="board.Board" %>
<%@ page import="list.clublist" %>
<!DOCTYPE html>
<html>
<head>
    <title>DONG_DONG</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width" , initial-scale="1">
    <link rel="stylesheet" href="/css/text_custom.css?ver=1">
    <link rel="stylesheet" href="/css/bootstrap.css">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
    <link href="https://fonts.googleapis.com/css?family=Cute+Font|Gaegu:300,400,700|Gamja+Flower|Gugi|Jua|Sunflower:300,500,700&amp;subset=korean" rel="stylesheet">
    <%--<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">--%>
    <script>
        function show() {
            $("#writeViewModal").modal('show');
        }
        function submit(boardTitle, boardContent) {
            if(boardTitle == ''){
                alert("제목을 입력하세요!");
            }else if(boardContent ==''){
                alert("내용을 입력하세요!");
            }else{
                $("#writeViewModal").modal('');
            }
        }
    </script>
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
    int boardKind = -2;
    if (request.getParameter("boardKind") != null) {
        boardKind = Integer.parseInt(request.getParameter("boardKind"));
    }
    ArrayList<clubusers> members = new ArrayList<>();
    members = new clublistDAO().getMyList(studentNumber, boardKind);
    String studentName = new UserDAO().userName(studentNumber); // 학번으로 이름 따오기
    clublist club = new clublist();
    club = new clublistDAO().getClubInfo(boardKind);

    if (boardKind == -2) { // boardKind 가 넘어오지않으면 error
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
        script.println("location.href = '/MainPage/login.jsp' ");
        script.println("</script>");
    }
    if(members.size() == 0){ // 해달 동아리의 멤버가 아니라면
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.(해당 동아리 회원이 아닙니다.)')");
        script.println("location.href = '/MainPage/findClub.jsp?clubKind=" + 0 + "&CurClubKind=" + "전체" + "'");
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
    <!-- 상단 글 작성 -->
    <div class="jumbotron bg-light" style="width: 600px; margin-left: auto; margin-right: auto;">
        <div class="container">
            <div style="display: inline-block;">
                <h1><%=club.getClubName()%></h1>
            </div>
            <div style="display: inline-block; float: right; margin-top: 10px">
                <!-- 만약 동아리장이라면 개설하기 버튼 추가 -->
                <% if (isCaptain >= 1) { %>
                <button class="btn btn-outline-success" data-toggle="modal" onclick="show()">글쓰기</button>
                <% } %>
            </div>
            <hr>
        </div>

        <!-- 모달 팝업 -->
        <div class="modal fade" id="writeViewModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <span class="t_left_m">글 작성 </span>
                    </div>
                    <form method="post" action="/Action/boardWriteAction.jsp?boardKind=<%=boardKind%>">
                        <div class="modal-body" style="margin: auto">
                            <!-- 글 제목 -->
                            <div>
                                <input type="text" class="form-control" placeholder="글 제목" name="boardTitle"
                                       maxlength="50">
                            </div>
                            <br>
                            <!-- 글 내용 -->
                            <div>
                                    <textarea class="form-control" placeholder="글 내용" name="boardContent"
                                              maxlength="2048" style="height: 200px;"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <input type="submit" class="btn btn-primary" value="글쓰기">
                            <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!-- 뉴스 피드 자리 -->
    <%
        BoardDAO bbsDAO = new BoardDAO();
        ArrayList<Board> boards = bbsDAO.getBList(boardKind);
        if(boards.size() == 0){ %>
    <div class="jumbotron bg-light" style="width: 600px; margin-left: auto; margin-right: auto; margin-bottom: 10px">
        <p style="margin: auto; vertical-align: middle; text-align: center">
            그룹 게시판
            <br>
            첫 게시글을 작성해보세요.
            <br>
            나와 멤버가 쓴 글이 여기에 표시됩니다.
        </p>
    </div>
    <% }
        for (int i = 0; i < boards.size(); i++) {
    %>
    <div class="jumbotron bg-light" style="width: 600px; margin-left: auto; margin-right: auto; margin-bottom: 15px"
        onclick="location.href='/BoardPage/view.jsp?boardID=<%=boards.get(i).getBoardID()%>&boardKind=<%=boardKind%>'">
        <!-- 제목 -->
        <div class="t_left_m" style="font-size: 25px">
            <%= boards.get(i).getBoardTitle() %>
        </div>
        <hr>
        <!-- 작성자, 작성일자 -->
        <div style="">
            <div class="t_left_m">
                <%= new UserDAO().userName(boards.get(i).getBoardWriter()) + "(" + boards.get(i).getBoardWriter() + ")"%>
            </div>
            <div class="t_left_m" style="font-size: xx-small">
                <%= boards.get(i).getBoardDate().substring(0, 11)%>
            </div>
        </div>
        <br>
        <!-- 글 내용 -->
        <div class="t_left_m" style="margin-left: 30px ">
            <%=boards.get(i).getBoardContent()%>
        </div>
        <hr>
        <!-- 글 댓글 수 -->
        <div class="t_right_m">
            <%="댓글 : " + new BoardDAO().getCList(boards.get(i).getBoardID()).size()%>
        </div>
    </div>
    <% }%>
</section>
<footer>
    <hr>
    <div align="right"><p>dongdong!&nbsp;&nbsp;</p></div>
</footer>
</body>
</html>
