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
                    <a class="dropdown-item" href="#">자유 게시판</a>
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
                </div>
            </li>
        </ul>

        <!-- 더보기 드롭 다운 -->
        <ul class="navbar-nav">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="MoreDropdwon" role="button" data-toggle="dropdown"
                   aria-haspopup="true" aria-expanded="false">더보기</a>
                <div class="dropdown-menu dropdown-menu-right">
                    <a class="dropdown-item" href="/MainPage/login.jsp">로그인</a>
                    <a class="dropdown-item" href="/MainPage/join.jsp">회원가입</a>

                </div>
            </li>
        </ul>
    </div>
</nav>
<hr>
<!-- 회원가입 화면 생성 -->
<section class="container">
    <div class="jumbotron";>
        <div class="container">
            <!-- 폼 생성 -->
            <form method="post" action="/Action/JoinAction.jsp">
                <h3 style="text-align: center">회원가입</h3>
                <div class="form-group">
                    <input type="text" class="form-control" placeholder="학번" name="studentNumber" maxlength="20">
                </div>
                <div class="form-group">
                    <input type="password" class="form-control" placeholder="비밀번호" name="studentPassword" maxlength="20">
                </div>
                <div class="form-group">
                    <input type="text" class="form-control" placeholder="이름" name="studentName" maxlength="20">
                </div>
                <div class="form-group"  style="text-align: center;">
                    <div class="btn-group" data-toggle="buttons">
                        <label class="btn btn-primary active">
                            <input type="radio" name="isCaptain" autocomplete="off" value="0" checked="checked">학부생
                        </label>
                        <label class="btn btn-primary">
                            <input type="radio" name="isCaptain" autocomplete="off" value="1">동아리장
                        </label>
                    </div>
                </div>
                <input type="submit" class="btn btn-primary form-control" value="회원가입">
            </form>
        </div>
    </div>
</section>
<footer>
    <hr>
    <div align="right"><p>dongdong!&nbsp;&nbsp;</p></div>
</footer>
</body>
</html>
