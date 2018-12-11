<%--
  Created by IntelliJ IDEA.
  User: rwgga
  Date: 2018-10-20
  Time: 오후 11:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>DONG_DONG</title>
</head>

<!-- 홈페이지가 켜지면   index. jsp 부터 켜진다. -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/bootstrap-grid.min.css">
<link rel="stylesheet" href="css/bootstrap-reboot.min.css">
<link rel="stylesheet" href="css/custom.css">
<!-- 시작 -->
<body>
<!-- 네비게이션 바 시작 -->
<%--
<nav class="navbar navbar-expand-sm navbar-dark bg-primary">
    <!-- 홈 버튼 -->
    <a class="navbar-brand" href="main.jsp">DongDong</a>
    <!-- 우측 버튼 지정 -->
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#myNav">
        <span class="navbar-toggler-icon"></span>
    </button>
    <!-- 네비게이션바 내용 설정 -->
    <div class="collapse navbar-collapse" id="myNav">
        <ul class="navbar-nav mr-auto">
            <!-- 바로 가기 버튼 -->
            <li class="nav-item active">
                <a class="nav-link" href="main.jsp">메인</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="noticeBoard.jsp">홍보 게시판</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="findClub.jsp?clubKind=<%=0%>&CurClubKind=<%="분류1"%>">동아리 찾기</a>
            </li>
        </ul>
        <ul class="navbar-nav">
            <!--드롭 다운 -->
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="myNavDropdwon" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">더보기</a>
                <div class="dropdown-menu dropdown-menu-right">
                    <a class="dropdown-item" href="login.jsp">로그인</a>
                    <a class="dropdown-item" href="join.jsp">회원가입</a>

                    <a class="dropdown-item" href="LogoutAction.jsp">로그아웃</a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="createClub.jsp">동아리 개설하기</a>
                </div>
            </li>
        </ul>
    </div>
</nav>
--%>

<script>
    location.href = 'MainPage/login.jsp';
</script>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
</body>
</html>
