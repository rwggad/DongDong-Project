<%--
  Created by IntelliJ IDEA.
  User: rwgga
  Date: 2018-10-20
  Time: 오후 11:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="list.clublistDAO" %>
<%@ page import="list.clubusers" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="user.UserDAO" %>
<%@ page import="list.clublist" %>
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

    if (studentNumber == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.')");
        script.println("location.href = 'login.jsp' ");
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
<!-- 동아리 목록 -->
<section class="container">
    <div class="jumbotron bg-light" style="width: 700px; margin-right: auto; margin-left: auto">
        <div class="container">
            <h1>내 동아리</h1>
            <hr>
        </div>
        <br>
        <div class="container">
            <!-- 내 동아리 목록 출력 -->
            <%
                // DB에서 내 동아리 목록 출력
                clublistDAO clublistDAO = new clublistDAO();
                ArrayList<clubusers> members = clublistDAO.getMyList(studentNumber, -1);
                if (members.size() == 0) {
            %>
            <!-- 동아리가 없을 때 -->
            <table class="table table-bordered btn btn-outline-secondary">
                <tbody>
                <tr>
                    <td>
                        <div>
                            가입한 동아리가 없습니다.
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
            <%
                }
                for (int i = 0; i < members.size(); i++) {
                    clublist club = new clublist();
                    club = new clublistDAO().getClubInfo(members.get(i).getBoardKind());
            %>
            <button class="btn btn-outline-secondary" style="display: block; margin: 0 auto; width: 100%;">
            <% if (members.get(i).getIsStaff() == 1) { %>
            <table class="table"
                   onclick="location='/clubPage/club.jsp?&boardKind=<%=members.get(i).getBoardKind()%>'">
            <% } else {%>
            <table class="table"
                   onclick="location='/clubPage/club.jsp?&boardKind=<%=members.get(i).getBoardKind()%>'">
                <% } %>
                <colgroup>
                    <col width="20%"/>
                    <col width="20%"/>
                    <col width="60%"/>
                </colgroup>
                <tbody>
                <tr>
                    <td style="vertical-align: middle; text-align: center;" rowspan="2">
                        <div style="vertical-align: middle">
                            <img src="/images/Camera_icon32.png" alt="이미지">
                        </div>
                    </td>
                    <td style="vertical-align: middle; text-align: center;" rowspan="2">
                        <div>
                            <% if (members.get(i).getIsStaff() == 1) { %><span
                                class="badge badge-info">&#9733;</span><%}%>&nbsp;<%=members.get(i).getClubName()%>
                        </div>
                    </td>
                    <td>
                        <div><%=club.getClubContent()%>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%="멤버 : " + club.getClubUserCnt()%>
                    </td>
                </tr>
                </tbody>
            </table>
            </button>
            <hr>
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
