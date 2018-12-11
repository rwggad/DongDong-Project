<%--
  Created by IntelliJ IDEA.
  User: rwgga
  Date: 2018-10-20
  Time: 오후 11:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.User" %>
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
    if (isCaptain == 0) { // 동아리 장이 아니면 개설 할 수 없음
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.(동아리장만 개설 가능)')");
        script.println("location.href = '/MainPage/findClub.jsp?clubKind=" + 0 + "&CurClubKind=" + "전체" + "'");
        script.println("</script>");
    }
%>
<hr>
<!-- 동아리 개설 화면 생성 -->
<section class="container">
    <div class="jumbotron bg-light" style="width: 700px; margin-right: auto; margin-left: auto">
        <div class="container">
            <!-- 동아리 개설 폼 생성 -->
            <form method="post" action="../Action/clubCreateAction.jsp">
                <h3 style="text-align: center">동아리 개설</h3>
                <br>
                <div align="center">
                    <span>동아리 간단정보</span>
                </div>
                <br>
                <div class="form-group" style="text-align: center;">
                    <span style="width: 170px; display:inline-block; margin-right: 20px">
                    <input type="text" class="form-control" placeholder="동아리 이름" name="clubName" maxlength="50" style="text-align: center; height: 60px;">
                    </span>
                    <span style="width: 170px; display:inline-block; margin-right: 20px">
                    <input type="text" class="form-control" placeholder="동아리 위치" name="clubLocation" maxlength="50" style="text-align: center; height: 60px;">
                    </span>
                    <span style="width: 170px; display:inline-block;">
                    <input type="text" class="form-control" placeholder="연락처" name="clubPhoneNumber" maxlength="50" style="text-align: center; height: 60px;">
                    </span>
                </div>
                <hr>
                <div align="center">
                    <span>간단한 소개</span>
                </div>
                <br>
                <div class="form-group" style="text-align:center;">
                     <textarea class="form-control" placeholder="소개" name="clubContent" maxlength="2048" style="height: 250px; text-align: center"></textarea>
                </div>
                <hr>
                <div align="center">
                    <span>분류 선택</span>
                </div>
                <br>
                <div class="form-group" style="text-align: center;">
                    <div class="btn-group" data-toggle="buttons">
                        <label class="btn btn-primary active">
                            <input type="radio" name="clubKind" autocomplete="off" value="1" checked="checked">문예
                        </label>
                        <label class="btn btn-primary">
                            <input type="radio" name="clubKind" autocomplete="off" value="2">봉사
                        </label>
                        <label class="btn btn-primary">
                            <input type="radio" name="clubKind" autocomplete="off" value="3">종교
                        </label>
                        <label class="btn btn-primary">
                            <input type="radio" name="clubKind" autocomplete="off" value="4">체육
                        </label>
                        <label class="btn btn-primary">
                            <input type="radio" name="clubKind" autocomplete="off" value="5">학술
                        </label>
                        <label class="btn btn-primary">
                            <input type="radio" name="clubKind" autocomplete="off" value="6">기타
                        </label>
                    </div>
                </div>
                <hr>
                <div align="right">
                    <input type="submit" class="btn btn-primary" value="동아리 개설">
                    <a class="btn btn-primary" href="javascript:history.back()">목록</a>
                </div>
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
