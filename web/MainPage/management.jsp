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
    int isCaptain = -1; // 현재 접속한 회원이 어드민인지?
    if (session.getAttribute("isCaptain") != null) {
        isCaptain = (Integer) session.getAttribute("isCaptain");
    }
    String studentNumber = null; // 현재 접속된 회원이 있는지 ?
    if (session.getAttribute("studentNumber") != null) {
        studentNumber = (String) session.getAttribute("studentNumber");
    }

    String studentName = new UserDAO().userName(studentNumber); // 학번으로 이름 따오기

    if (studentNumber == null) { // 로그인을 안했다면
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인 하세요.')");
        script.println("location.href = '/MainPage/login.jsp'");
        script.println("</script>");
    }
    if(isCaptain != 9999){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.(관리자가 아닙니다.)')");
        script.println("location.href = '/MainPage/main.jsp");
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
                    <a class="dropdown-item disabled"><span
                            class="btn btn-outline-success"><%=studentName + "님"%></span></a>
                    <div class="dropdown-divider"></div>
                    <%if (isCaptain >= 1) {%>
                    <a class="dropdown-item" href="/clubPage/createClub.jsp">동아리 개설하기</a>
                    <%}%>
                    <a class="dropdown-item" href="/MainPage/myClub.jsp">내 동아리</a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="/Action/LogoutAction.jsp">로그아웃</a>
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
<br>
<section class="container">
    <div class="jumbotron bg-light">
        <div class="container">
            <h1>내 동아리 관리</h1>
            <br>
            <div class="progress">
                <div class="progress-bar bg-primary" style="width: 100%"></div>
            </div>
            <br>
            <!-- 관리 -->
            <%
                managementDAO mmDAO = new managementDAO();
            %>
            <div class="container">
                <div id="accordion">
                    <!-- 회원관리 -->
                    <div class="card">
                        <div class="card-header">
                            <a class="card-link" data-toggle="collapse" data-parent="#accordion" href="#collapseOne">회원관리</a>
                        </div>
                        <div id="collapseOne" class="collapse">
                            <div class="card-body">
                                <table class="table table-light table-bordered">
                                    <%
                                        ArrayList<User> users = mmDAO.getUserList(-9999);
                                        if (users.size() == 0) { %>
                                    <p>가입한 회원이 없습니다.</p>
                                    <% } %>
                                    <thead class="table-sm">
                                    <tr>
                                        <td>학번</td>
                                        <td>이름</td>
                                        <td>분류</td>
                                        <td></td>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (int i = 0; i < users.size(); i++) {%>
                                    <tr>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=users.get(i).getStudentNumber()%></a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=users.get(i).getStudentName()%></a>
                                        </td>
                                        <td>
                                            <% if(users.get(i).getIsCaptain() == 0) { %> <!-- 삭제된 게시물 -->
                                            <a class="btn btn-outline-secondary btn-sm">학부생</a>
                                            <%} else { %>
                                            <a class="btn btn-outline-info btn-sm">동아리 장</a>
                                            <% } %>
                                        </td>
                                        <td align="right">
                                            <a onclick="if(!confirm('정말로 추방하시겠습니까?')){return false}"
                                               href="/Action/userDropAction.jsp?outStudentNumber=<%=users.get(i).getStudentNumber()%>&option=<%=0%>"
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
                            <a class="card-link" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">게시글 관리</a>
                        </div>
                        <div id="collapseTwo" class="collapse">
                            <div class="card-body">
                                <table class="table table-light table-bordered">
                                    <%
                                        ArrayList<Board> boards = mmDAO.getBoardList(-9999);
                                        if (boards.size() == 0) { %>
                                    <p>작성된 게시물이 없습니다.</p>
                                    <% } %>
                                    <thead class="table-sm">
                                    <tr>
                                        <td>id</td>
                                        <td>제목</td>
                                        <td>작성자</td>
                                        <td>삭제여부</td>
                                        <td></td>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (int i = 0; i < boards.size(); i++) {%>
                                    <tr>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=boards.get(i).getBoardID()%></a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm" href="#"><%=boards.get(i).getBoardTitle()%></a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=new UserDAO().userName(boards.get(i).getBoardWriter()) + "(" + boards.get(i).getBoardWriter() + ")" %></a>
                                        </td>
                                        <td>
                                            <% if(boards.get(i).getIsDelete() == 0) { %> <!-- 삭제된 게시물 -->
                                            <a class="btn btn-outline-danger btn-sm"><%=boards.get(i).getIsDelete()%></a>
                                            <%} else { %>
                                            <a class="btn btn-outline-secondary btn-sm"><%=boards.get(i).getIsDelete()%></a>
                                            <% } %>
                                        </td>
                                        <td align="right">
                                            <a onclick="if(!confirm('정말로 삭제하시겠습니까?')){return false}"
                                               href="/Action/boardDropAction.jsp?boardID=<%=boards.get(i).getBoardID()%>&boardKind=<%=-9999%>"
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
                    <!-- 댓글 관리 -->
                    <div class="card">
                        <div class="card-header">
                            <a class="card-link" data-toggle="collapse" data-parent="#accordion" href="#collapseThree">댓글 관리</a>
                        </div>
                        <div id="collapseThree" class="collapse">
                            <div class="card-body">
                                <table class="table table-light table-bordered">
                                    <%
                                        ArrayList<comment> comments = mmDAO.getCommentList(-9999);
                                        if (comments.size() == 0) { %>
                                    <p>작성된 게시물이 없습니다.</p>
                                    <% } %>
                                    <thead class="table-sm">
                                    <tr>
                                        <td>id</td>
                                        <td>댓글 내용</td>
                                        <td>작성자</td>
                                        <td>삭제여부</td>
                                        <td></td>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (int i = 0; i < comments.size(); i++) {%>
                                    <tr>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=comments.get(i).getCommentID()%></a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm" href="#"><%=comments.get(i).getCommentContent()%></a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=new UserDAO().userName(comments.get(i).getCommentWriter()) + "(" + comments.get(i).getCommentWriter() + ")" %></a>
                                        </td>
                                        <td>
                                            <% if(comments.get(i).getIsDelete() == 0) { %> <!-- 삭제된 게시물 -->
                                            <a class="btn btn-outline-danger btn-sm"><%=comments.get(i).getIsDelete()%></a>
                                            <%} else { %>
                                            <a class="btn btn-outline-secondary btn-sm"><%=comments.get(i).getIsDelete()%></a>
                                            <% } %>
                                        </td>
                                        <td align="right">
                                            <a onclick="if(!confirm('정말로 삭제하시겠습니까?')){return false}"
                                               href="/Action/commentDropAction.jsp?commentID=<%=comments.get(i).getCommentID()%>&boardKind=<%=-9999%>"
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
                    <!-- 동아리 관리-->
                    <div class="card">
                        <div class="card-header">
                            <a class="card-link" data-toggle="collapse" data-parent="#accordion" href="#collapseFour">동아리 관리</a>
                        </div>
                        <div id="collapseFour" class="collapse">
                            <div class="card-body">
                                <table class="table table-light table-bordered">
                                    <%
                                        ArrayList<clublist> clublists = new clublistDAO().getList(0);
                                        if (clublists.size() == 0) { %>
                                    <p>개설된 동아리가 없습니다.</p>
                                    <% } %>
                                    <thead class="table-sm">
                                    <tr>
                                        <td>id</td>
                                        <td>동아리명</td>
                                        <td>동아리장</td>
                                        <td></td>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (int i = 0; i < clublists.size(); i++) {%>
                                    <tr>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=clublists.get(i).getBoardKind()%></a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm" href="#"><%=clublists.get(i).getClubName()%></a>
                                        </td>
                                        <td>
                                            <a class="btn btn-outline-secondary btn-sm"><%=new UserDAO().userName(clublists.get(i).getClubCaptain()) + "(" + clublists.get(i).getClubCaptain() + ")" %></a>
                                        </td>
                                        <td align="right">
                                            <a onclick="if(!confirm('정말로 삭제하시겠습니까?')){return false}"
                                               href="/Action/clubDropAction.jsp?boardKind=<%=clublists.get(i).getBoardKind()%>&option=<%=-1%>"
                                               class="btn btn-danger btn-sm">폐쇄</a> <!--삭제-->
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
        </div>
    </div>
</section>
<footer>
    <hr>
    <div align="right"><p>dongdong!&nbsp;&nbsp;</p></div>
</footer>
</body>
</html>
