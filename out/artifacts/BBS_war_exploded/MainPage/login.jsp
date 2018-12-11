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
            font-family: 'Sunflower', sans-serif;
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
    <div align="right" class="collapse navbar-collapse" id="myNav">
        <!-- 바로 가기 버튼 -->
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link" href="/MainPage/join.jsp">회원가입</a>
            </li>
            <li class="nav-item active">
                <a class="nav-link" href="/MainPage/login.jsp">로그인</a>
            </li>
        </ul>
    </div>
</nav>
<hr>
<!-- 로그인 화면 생성 -->
<section class="container" >
    <div class="jumbotron">
        <table class="table">
            <tr>
                <td width="50%">
                    <img src="/images/image.png" style="margin-left: 70px; margin-top: 20px">
                </td>
                <!-- 로그인 폼-->
                <td width="50%">
                    <div class="jumbotron">
                        <div class="container" style="text-align: center">
                            <h1 style="text-align: left">인싸가 되고 싶어?!<br>그럼 동동으로와 ~</h1>
                            <br>
                            <h6 style="text-align: left"> 동아리 모임은 동동과 함께 하세요! </h6>
                        </div>
                        <hr>
                        <div class="container">
                            <br>
                            <!-- 로그인 폼 생성 -->
                            <form method="post" action="/Action/loginAction.jsp">
                                <h3 style="text-align: center">로그인</h3>
                                <div>
                                    <div class="form-group">
                                        <input type="text" class="form-control" placeholder="학번" name="studentNumber" maxlength="20" style="text-align: center;">
                                    </div>
                                    <div class="form-group">
                                        <input type="password" class="form-control" placeholder="비밀번호" name="studentPassword" maxlength="20" style="text-align: center;">
                                    </div>
                                    <input type="submit" class="btn btn-primary form-control" value="로그인">
                                </div>
                            </form>
                            <br>
                        </div>
                        <hr>
                    </div>
                </td>
            </tr>

        </table>
    </div>
</section>
<footer>
    <hr>
    <div align="right"><p>dongdong!&nbsp;&nbsp;</p></div>
</footer>
</body>
</html>
