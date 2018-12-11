<%--
  Created by IntelliJ IDEA.
  User: rwgga
  Date: 2018-10-20
  Time: 오후 11:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
<%@ page import="board.Board" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="board.BoardDAO" %>
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
    <script type="text/javascript">
        $(function() {
            var documentEl = $(document),
                fadeElem = $('.fade-scroll');
            documentEl.on('scroll', function() {
                var currScrollPos = documentEl.scrollTop();
                fadeElem.each(function() {
                    var $this = $(this),
                        elemOffsetTop = $this.offset().top;
                    if (currScrollPos > elemOffsetTop) $this.css('opacity', 1 - (currScrollPos-elemOffsetTop) / 400);
                });
            });
        });
    </script>
    <style type="text/css">
        *{
            font-family: 'Jua', sans-serif;
        }
        h1 {
            font-weight: 300;
            font-size: 4em;
            color: #fff;
            background-color: #093257;
            padding: 300px 0 50px 100px;
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

    if (studentNumber == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인 하세요.')");
        script.println("location.href = '/MainPage/login.jsp' ");
        script.println("</script>");
    }
%>
<!-- 네비게이션 바 시작 -->
<nav class="navbar navbar-expand navbar-dark bg-primary sticky-top">
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
                    <a class="dropdown-item" href="/MainPage/findClub.jsp?clubKind=<%=0%>&CurClubKind=<%="전체"%>">동아리
                        찾기</a>
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
                    <%} if(isCaptain != 9999 && studentNumber != null){%>
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
<!-- 메인페이지 시작 -->
<header class="fade-scroll" >
    <%--<!-- 크로쉘 이미지 -->
    <div id="myCarousel" class="carousel slide " data-ride="carousel">
        <!-- 크로쉘 하단 표시기 -->
        <ol class="carousel-indicators">
            <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
            <li data-target="#myCarousel" data-slide-to="1"></li>
        </ol>
        <!-- 크로쉘 내부 이미지 지정 -->
        <div class="carousel-inner" style="height:400px;" >
            <!-- https://picsum.photos/1920/1080/?blur -->
            <div class="carousel-item active">
                <img class="d-block w-100" src="/images/bumin1.jpg" alt="First slide">
                <div class="carousel-caption">
                    <h1>환영합니다!</h1>
                </div>
            </div>
            <div class="carousel-item">
                <img class="d-block w-100" src="/images/bumin2.jpg" alt="First slide">
            </div>
        </div>
        <!-- 크로쉘 양옆 표시기 -->
        <a class="carousel-control-prev" href="#myCarousel" role="button" data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control-next" href="#myCarousel" role="button" data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
        </a>
    </div>--%>
    <h1 class="fade-scroll">Dong Dong</h1>
    <br>
</header>
<!-- 하단 내용 -->
<section class="container">
    <div class="jumbotron bg-light">
        <!-- 홍보 게시판 preview -->
        <div class="container">
            <h3>홍보 게시판</h3>
            <hr size="3">
            <table class="table table-hover table-bordered" style="text-align: center;">
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
                    ArrayList<Board> List = new BoardDAO().getBList(-1);
                    if (List.size() == 0) { // List size가 0 이면 게시물이 없음
                %>
                <tr>
                    <td colspan="5" align="center">작성된 게시물이 없습니다.</td>
                </tr>
                <% }
                    int roop = List.size();
                    if(roop > 5) roop = 5;
                    for (int i = 0; i < roop; i++) { %>
                <tr>
                    <td><%= List.get(i).getBoardID() %>
                    </td>
                    <td>
                        <a href="/BoardPage/view.jsp?boardID=<%=List.get(i).getBoardID()%>&boardKind=<%=-1%>"><%= List.get(i).getBoardTitle() %>
                        </a>
                        <%if (List.get(i).getBoardCount() < 10) { %> <!--조회수 10 미만은 new로 표기-->
                        <span class="badge badge-primary"> NEW</span>
                        <%}%>
                    </td>
                    <td><%= new UserDAO().userName(List.get(i).getBoardWriter()) %>
                    </td>
                    <td><%= List.get(i).getBoardDate().substring(0, 11)%>
                    </td>
                    <td><%=List.get(i).getBoardCount() %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <br>
        <!-- 다른 게시판들 preview -->
        <div class="container">
            <h3>공지사항</h3>
            <hr size="3">
            <table class="table table-hover table-bordered" style="text-align: center;">
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
                <tr>
                    <td colspan="5" align="center">작성된 게시물이 없습니다.</td>
                </tr>
                </tbody>
            </table>
        </div>
        <%--<table class="table table-light">
            <tr>
                <td>

                </td>
                <td>

                </td>
            </tr>
        </table>--%>
        <br>
    </div>
</section>
<footer>
    <hr>
    <div align="right"><p>dongdong!&nbsp;&nbsp;</p></div>
</footer>
</body>
</html>
