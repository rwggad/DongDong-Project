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
<%@ page import="list.clubcalendar" %>
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
    <script>
        function show(date, content) {
            $("#viewTitle").html(date);
            $("#viewContent").html(content);
            $("#calViewModal").modal('show');
        }
        function plus_show() {
            $("#calPlusModal").modal('show');
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
    int boardKind = -10;
    if (request.getParameter("boardKind") != null) {
        boardKind = Integer.parseInt(request.getParameter("boardKind"));
    }
    ArrayList<clubusers> members = new ArrayList<>();
    members = new clublistDAO().getMyList(studentNumber, boardKind);
    String studentName = new UserDAO().userName(studentNumber); // 학번으로 이름 따오기
    clublist club = new clublist();
    club = new clublistDAO().getClubInfo(boardKind);

    if(boardKind == -10){ // boardKind 가 넘어오지않으면 error
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('BK == -10 ERROR')");
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

    // 달력 부분
    java.util.Calendar cal=java.util.Calendar.getInstance(); //Calendar객체 cal생성
    int currentYear=cal.get(java.util.Calendar.YEAR); //현재 날짜 기억
    int currentMonth=cal.get(java.util.Calendar.MONTH);
    int currentDate=cal.get(java.util.Calendar.DATE);

    int year = -1;
    if(request.getParameter("year") != null){
        year = Integer.parseInt(request.getParameter("year"));
    }else{
        year = currentYear;
    }

    int month = -1;
    if(request.getParameter("month") != null){
        month = Integer.parseInt(request.getParameter("month"));
    }else{
        month = currentMonth;
    }

    if(month<0) { month=11; year=year-1; } //1월부터 12월까지 범위 지정.
    if(month>11) { month=0; year=year+1; }
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
            <li class="nav-item">
                <a class="nav-link"
                   href="/clubPage/club.jsp?&boardKind=<%=members.get(0).getBoardKind()%>"><%=club.getClubName()%>
                </a>
            </li>
            <li class="nav-item active">
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
<!-- 달력 부 -->
<section class="container">
    <div class="jumbotron  bg-light" style="width: 700px; margin-left: auto; margin-right: auto">
        <div class="container">
            <h1>동아리 일정</h1>
            <br>
            <div class="progress">
                <div class="progress-bar bg-success" style="width: 100%"></div>
            </div>
        </div>
        <br>
        <div class="container">
            <!-- 달력 상단 -->
            <table class="table table-success">
                <tr>
                    <td align=left> <!-- 년 도-->
                        <a href="/clubPage/clubCalendar.jsp?boardKind=<%=boardKind%>&year=<%=(year-1)%>&month=<%=(month)%>" style="color: #404040;">◀</a>
                        <span><%=year + "년"%></span>
                        <a href="/clubPage/clubCalendar.jsp?boardKind=<%=boardKind%>&year=<%=(year+1)%>&month=<%=(month)%>" style="color: #404040;">▶</a>
                    </td>
                    <td align=center> <!-- 월 -->
                        <a href="/clubPage/clubCalendar.jsp?boardKind=<%=boardKind%>&year=<%=(year)%>&month=<%=(month - 1)%>" style="color: #404040;">◀</a>
                        <span><%=(month + 1) + "월"%></span>
                        <a href="/clubPage/clubCalendar.jsp?boardKind=<%=boardKind%>&year=<%=(year)%>&month=<%=(month + 1)%>" style="color: #404040;">▶</a>
                    </td>
                    <td align=right> <!-- 일 -->
                        <span><%=currentYear + "-" + (currentMonth + 1) + "-" + currentDate%></span>
                    </td>
                </tr>
            </table>
            <!-- 달력 부분 -->
            <table class="table table-light table-hover table-bordered">
                <thead class="table-secondary"style="text-align: center">
                <tr>
                    <td width="160">일</td> <!-- 일=1 -->
                    <td width="160">월</td> <!-- 월=2 -->
                    <td width="160">화</td> <!-- 화=3 -->
                    <td width="160">수</td> <!-- 수=4 -->
                    <td width="160">목</td> <!-- 목=5 -->
                    <td width="160">금</td> <!-- 금=6 -->
                    <td width="160">토</td> <!-- 토=7 -->
                </tr>
                </thead>
                <tbody align="center">
                <tr>
                    <%
                        cal.set(year, month, 1); //현재 날짜를 현재 월의 1일로 설정
                        int startDay = cal.get(java.util.Calendar.DAY_OF_WEEK); //현재날짜(1일)의 요일
                        int end = cal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH); //이 달의 끝나는 날
                        int br = 0; //7일마다 줄 바꾸기
                        for (int i = 0; i < (startDay - 1); i++) { //빈칸출력
                    %><td>&nbsp;</td> <%
                    br++;
                    if ((br % 7) == 0) {
                %><br><%
                        }
                    }
                    month++;
                    for (int i = 1; i <= end; i++) { //날짜출력
                        String monthStr ="";
                        if(month < 10)
                            monthStr += '0';
                        monthStr += month;
                        String dayStr = "";
                        if(i < 10)
                            dayStr += '0';
                        dayStr += i;
                        String selectDate = year + "-" + monthStr + "-" + dayStr;
                        String selectContents = "";
                        ArrayList<clubcalendar> ccs = new clublistDAO().getCalList(selectDate, boardKind);
                        if(ccs.size() == 0){
                            selectContents = "일정이 없습니다.";
                %>
                    <!-- 일정이 없을 경우 회색으로 출력 -->
                    <td><button class="btn btn-outline-secondary"  data-toggle="modal"
                                onclick="show('<%=selectDate%>','<%=selectContents%>')"><%=i%></button></td><%
                }else{
                    // 해달 날짜에 대한 일정들을 받아온다.
                    for (int j = 0; j < ccs.size(); j++) {
                        selectContents += "- " + ccs.get(j).getCalContent();
                        if(j + 1 < ccs.size())
                            selectContents += "<br>";
                    }
                %>
                    <!-- 일정이 없을 경우 초록색으로 출력 후 일정 갯수 출력 -->
                    <td><button class="btn btn-outline-success"  data-toggle="modal"
                                onclick="show('<%=selectDate%>','<%=selectContents%>')"><%=i%>&nbsp;<span class="badge badge-success"><%=ccs.size()%></span></button></td><%
                    }
                    br++;
                    if ((br % 7) == 0 && i != end) {
                %></tr><tr><%
                        }
                    }
                    while ((br++) % 7 != 0) //말일 이후 빈칸출력
                %><td>&nbsp;</td>
                </tr>
                </tbody>
            </table>
            <!-- 일정 추가 -->
            <%
                if (members.get(0).getIsStaff() == 1) {
            %>
            <div align="right">
                <a class="btn btn-danger" href="/clubPage/managementClub.jsp?boardKind=<%=boardKind%>">일정 삭제</a>
                <a class="btn btn-success" onclick="plus_show()">일정 추가</a>
            </div>
            <%
                }
            %>
            <!-- 일정 모달 팝업 -->
            <div class="modal fade" id ="calViewModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <!-- 모달 팝업 제목 -->
                            <h5 class="modal-title" id="viewTitle"></h5>
                            <!-- 오른쪽 상단 x -->
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <!-- 모달 내용 -->
                            <div style="text-align: center"><p id="viewContent"></p></div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
                        </div>
                    </div>
                </div>

            </div>
            <!-- 일정 추가 모달 팝업 -->
            <div class="modal fade" id ="calPlusModal" tabindex="-1" role="dialog">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <!-- 모달 팝업 제목 -->
                            <h5 class="modal-title">일정 추가</h5>
                            <!-- 오른쪽 상단 x -->
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>

                        <form method="post" action="/Action/clubCalendarPlusAction.jsp?boardKind=<%=boardKind%>">
                            <div class="modal-body">
                                <!-- 글 제목 -->
                                <div>
                                    <input class="form-control" name="calData" type="date">
                                </div>
                                <br>
                                <!-- 글 내용 -->
                                <div>
                                    <textarea class="form-control" placeholder="추가할 일정" name="calContent" maxlength="2048"
                                              style="height: 200px;"></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <input type="submit" class="btn btn-success" value="추가 하기">
                                <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
                            </div>
                        </form>
                    </div>
                </div>

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
