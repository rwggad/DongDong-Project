<%--
  Created by IntelliJ IDEA.
  User: rwgga
  Date: 2018-10-20
  Time: 오후 11:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.Board" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="user.UserDAO" %>
<%@ page import="board.comment" %>
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

    String studentName = new UserDAO().userName(studentNumber); // 학번으로 이름 따오기

    if (studentNumber == null) { // 로그인을 안했으면 게시판에 접근 할 수 없다.
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인 하세요.')");
        script.println("location.href = '/MainPage/login.jsp' ");
        script.println("</script>");
    }

%>

<!-- 네비게이션 바 시작 -->
<nav class="navbar navbar-expand-sm navbar-dark bg-primary sticky-top">
    <!-- 홈 버튼 -->
    <a class="navbar-brand" href="/MainPage/main.jsp">DD</a>
    <!-- 우측 버튼 지정 -->
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#myNav">
        <span class="navbar-toggler-icon"></span>
    </button>
    <!-- 네비게이션바 내용 설정 -->
    <div class="collapse navbar-collapse" id="myNav">
        <!-- 바로 가기 버튼 -->
        <ul class="navbar-nav">
            <%--<li class="nav-item active">
                <a class="nav-link" href="/MainPage/main.jsp">메인</a>
            </li>--%>
        </ul>

        <!-- 커뮤니티 드롭 다운 -->
        <ul class="navbar-nav">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="communityDropdown" role="button" data-toggle="dropdown"
                   aria-haspopup="true" aria-expanded="false">게시판</a>
                <div class="dropdown-menu dropdown">
                    <a class="dropdown-item" href="#">공지사항</a>
                    <a class="dropdown-item" href="/BoardPage/noticeBoard.jsp">홍보 게시판</a>
                </div>
            </li>
        </ul>

        <!-- 동아리 보기 드롭다운 -->
        <ul class="navbar-nav mr-auto">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="ClubDropdown" role="button" data-toggle="dropdown"
                   aria-haspopup="true" aria-expanded="false">동아리</a>
                <div class="dropdown-menu dropdown">
                    <a class="dropdown-item" href="/MainPage/findClub.jsp?clubKind=<%=0%>&CurClubKind=<%="전체"%>">동아리 찾기</a>
                    <%if (studentNumber != null) {%>
                    <a class="dropdown-item" href="/MainPage/myClub.jsp">내 동아리</a>
                    <%}%>
                </div>
            </li>
        </ul>

        <!-- 더보기 드롭 다운 -->
        <ul class="navbar-nav">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="MoreDropdwon" role="button" data-toggle="dropdown"
                   aria-haspopup="true" aria-expanded="false">더보기</a>
                <div class="dropdown-menu dropdown-menu-right">
                    <%if (studentNumber == null) {%>
                    <a class="dropdown-item" href="/MainPage/login.jsp">로그인</a>
                    <a class="dropdown-item" href="/MainPage/join.jsp">회원가입</a>
                    <%} else {%>
                    <a class="dropdown-item disabled"><span class="btn btn-outline-success"><%=studentName + "님"%></span></a>
                    <div class="dropdown-divider"></div>
                    <%if (isCaptain >= 1) {%>
                    <a class="dropdown-item" href="/clubPage/createClub.jsp">동아리 개설하기</a>
                    <%}%>
                    <a class="dropdown-item" href="/MainPage/myClub.jsp">내 동아리</a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="/Action/LogoutAction.jsp">로그아웃</a>
                    <%}%>
                    <%if (isCaptain == 9999) {%>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="/MainPage/management.jsp">홈페이지 관리</a>
                    <%}else{%>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item disabled" onclick="if(!confirm('정말로 탈퇴하시겠습니까?')){return false}"
                       href="/Action/userDropAction.jsp?outStudentNumber=<%=studentNumber%>&option=<%=-9999%>">
                        <span class="btn btn-outline-danger">동동 탈퇴하기</span></a>
                    <%}%>
                </div>
            </li>
        </ul>
    </div>
</nav>
<hr>
<!-- 게시판 시작 -->
<section class="container">
    <div class="jumbotron bg-light" style="width: 850px; margin-left: auto; margin-right: auto;">
        <div class="container">
            <h1>홍보 게시판</h1>
            <br>
            <div class="progress">
                <div class="progress-bar" style="width: 100%"></div>
            </div>
        </div>
        <br>
        <div class="container">
            <table class="table table-hover table-bordered" style="text-align: center; width: 100%;">
                <colgroup>
                    <col width="7%"/>
                    <col width="51%"/>
                    <col width="20%"/>
                    <col width="15%"/>
                    <col width="7%"/>
                </colgroup>
                <thead class="table-primary table-sm">  <!-- 테이블 헤더 ( 최상단 ) -->
                <tr> <!-- 테이블 하나의 행 -->
                    <th style="text-align: center;">번호</th>
                    <th style="text-align: center; width: 50%">제목</th>
                    <th style="text-align: center;">작성자</th>
                    <th style="text-align: center;">날짜</th>
                    <th style="text-align: center;">조회수</th>
                </tr>
                </thead>
                <tbody class="bg-light table-sm"> <!-- 테이블 바디 (글의 제목) -->
                <%
                    ArrayList<Board> boards = new BoardDAO().getBList(-1);
                    if (boards.size() == 0) { // List size가 0 이면 게시물이 없음
                %>
                <tr>
                    <td colspan="5" align="center">작성된 게시물이 없습니다.</td>
                </tr>
                <% }
                    for (int i = 0; i < boards.size(); i++) { %>
                <tr>
                    <td>
                        <%= boards.get(i).getBoardID() %>
              </td>
                    <td> <!-- 게시물 제목 -->
                        <a href="/BoardPage/view.jsp?boardID=<%=boards.get(i).getBoardID()%>&boardKind=<%=-1%>">
                            <%= boards.get(i).getBoardTitle()%>
                        </a>
                        <%if (boards.get(i).getBoardCount() < 10) { %> <!--조회수 10 미만은 new로 표기-->
                        <span class="badge badge-primary"> NEW</span>
                        <%}%>
                    </td>
                    <!-- 게시물 작성자 -->
                    <td><%= new UserDAO().userName(boards.get(i).getBoardWriter()) + "(" + boards.get(i).getBoardWriter() + ")"  %>
                    </td>
                    <!-- 게시물 일자 -->
                    <td><%= boards.get(i).getBoardDate().substring(0, 11)%>
                    </td>
                    <!-- 게시물 조회수 -->
                    <td><%=boards.get(i).getBoardCount() %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <%
                if (isCaptain >= 1) {
            %>
            <div align="right">
                <a href="/BoardPage/write.jsp?boardKind=<%=-1%>" class="btn btn-primary">글쓰기</a>
            </div>
            <%
                }
            %>
        </div>
    </div>
</section>
<footer>
    <hr>
    <div align="right"><p>dongdong!&nbsp;&nbsp;</p></div>
</footer>
</body>
</html>
