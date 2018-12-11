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
<%@ page import="list.clublist" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="user.UserDAO" %>
<!DOCTYPE html>
<html>
<head>
    <title>DONG_DONG</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width" , initial-scale="1">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
    <script>
        function basic_modal_show(title, content, boardKind, location, phoneNumber) {
            $("#title").html(title);
            $("#content").html(content);
            $("#location").html(location);
            $("#phoneNumber").html(phoneNumber);
            $("#myModal1").modal('show');
            $("#joinBtn").click(function () {
                $("#myModal1").modal('hide');
                join_modal_show(boardKind);
            });
        }
        function join_modal_show(boardKind){
            $("#myModal2").modal('show');
            $("#submit").click(function () {
                var waitContent = $('#waitContent').val();
                if(waitContent == ""){
                    alert("신청 내용을 입력하세요!");
                }else{
                    location.href="/Action/clubJoinAction.jsp?boardKind=" + boardKind + "&waitContent=" +  waitContent;
                    $("#myModal2").modal('hide');
                }
            })
        }
    </script>
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

    // 현재 동아리 찾기 게시판의 분류를 확인하기
    int clubKind = -1;
    if (request.getParameter("clubKind") != null) {
        clubKind = Integer.parseInt(request.getParameter("clubKind"));
    }

    String CurClubKind = null;
    if (request.getParameter("CurClubKind") != null) {
        CurClubKind = request.getParameter("CurClubKind");
    }

    String studentName = new UserDAO().userName(studentNumber); // 학번으로 이름 따오기

    if (studentNumber == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.')");
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
    <div class="jumbotron bg-light" style="width: 700px; margin-right: auto; margin-left: auto" >
        <div class="container">
            <div style="display: inline-block;">
                <h1>동아리 찾기</h1>
            </div>
            <div style="display: inline-block; float: right; margin-top: 10px">
                <!-- 만약 동아리장이라면 개설하기 버튼 추가 -->
                <% if (isCaptain >= 1) { %>
                <a href="/clubPage/createClub.jsp" class="btn btn-primary pull-right">동아리 개설</a>

                <% } %>
            </div>
            <hr>
        </div>
        <br>
        <div class="container">
            <!-- 분류 네비 -->
            <nav class="navbar navbar-expand-sm navbar-dark bg-info">
                <!-- 버튼 지정 -->
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#myKindNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <!-- 네비게이션바 내용 설정 -->
                <div class="collapse navbar-collapse active justify-content-between" id="myKindNav">
                    <ul class="navbar-nav">
                        <!--드롭 다운 -->
                        <li class="nav-item dropdown active">
                            <a class="nav-link dropdown-toggle" href="#" id="myKindNavDropdwon" role="button"
                               data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><%=CurClubKind%>
                            </a>
                            <div class="dropdown-menu">
                                <a class="dropdown-item"
                                   href="/MainPage/findClub.jsp?clubKind=<%=0%>&CurClubKind=<%="전체"%>">전체</a>
                                <a class="dropdown-item"
                                   href="/MainPage/findClub.jsp?clubKind=<%=1%>&CurClubKind=<%="문예"%>">문예</a>
                                <a class="dropdown-item"
                                   href="/MainPage/findClub.jsp?clubKind=<%=2%>&CurClubKind=<%="봉사"%>">봉사</a>
                                <a class="dropdown-item"
                                   href="/MainPage/findClub.jsp?clubKind=<%=3%>&CurClubKind=<%="종교"%>">종교</a>
                                <a class="dropdown-item"
                                   href="/MainPage/findClub.jsp?clubKind=<%=4%>&CurClubKind=<%="체육"%>">체육</a>
                                <a class="dropdown-item"
                                   href="/MainPage/findClub.jsp?clubKind=<%=5%>&CurClubKind=<%="학술"%>">학술</a>
                                <a class="dropdown-item"
                                   href="/MainPage/findClub.jsp?clubKind=<%=6%>&CurClubKind=<%="기타"%>">기타</a>
                            </div>
                        </li>
                    </ul>
                </div>
            </nav>
            <br>

            <%
                // DB에서 동아리 목록 출력
                clublistDAO dlistDAO = new clublistDAO();
                ArrayList<clublist> dlists = dlistDAO.getList(clubKind);
                if (dlists.size() == 0) {
            %>
            <%
                }
                for (int i = 0; i < dlists.size(); i++) {
                    clublist club = new clublist();
                    club = new clublistDAO().getClubInfo(dlists.get(i).getBoardKind());
            %>
            <button class="btn btn-outline-secondary" style="display: block; margin: 0; width: 100%;"
                    onclick="basic_modal_show('<%=dlists.get(i).getClubName()%>', '<%=dlists.get(i).getClubContent()%>', '<%=dlists.get(i).getBoardKind()%>', '<%=dlists.get(i).getClubLocation()%>' , '<%=dlists.get(i).getClubPhoneNumber()%>')">
                <table class="table">
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
                                <%=dlists.get(i).getClubName()%>
                            </div>
                        </td>
                        <td>
                            <div><%=dlists.get(i).getClubContent()%>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <%="멤버 : " + dlists.get(i).getClubUserCnt()%>
                            <br>
                            <%="동아리 장 : " + new UserDAO().userName(dlists.get(i).getClubCaptain())%>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </button>
            <!-- 알림 모달 팝업 -->
            <div class="modal fade" id="myModal1" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <!-- 모달 팝업 제목 -->
                            <h5 class="modal-title" id="title"></h5>
                            <!-- 오른쪽 상단 x -->
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <!-- 모달 내용 -->
                            <div style="text-align: center">
                                <p id="content"></p>
                                <p id="location"></p>
                                <p id="phoneNumber"></p>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
                            <button type="button" class="btn btn-primary" id="joinBtn">가입 하기</button>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 가입 모달 팝업 -->
            <div class="modal fade" id="myModal2" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <span class="t_left_m">가입 신청서 </span>
                        </div>
                        <div class="modal-body"
                            <!-- 글 내용 -->
                            <div>
                                <textarea placeholder="소개 내용을 적어주세요" id="waitContent"
                                          maxlength="2048" style="height: 200px; width: 100%;"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <input type="submit" class="btn btn-primary" id="submit" value="신청하기">
                            <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
                        </div>
                    </div>
                </div>
            </div>
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
