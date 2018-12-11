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

    int boardKind = -10;
    if (request.getParameter("boardKind") != null) {
        boardKind = Integer.parseInt(request.getParameter("boardKind"));
    }

    String studentName = new UserDAO().userName(studentNumber); // 학번으로 이름 따오기

    if (boardKind == -10) { // boardKind 가 넘어오지않으면 error
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('BK == -10 ERROR')");
        script.println("location.href = '/MainPage/main.jsp' ");
        script.println("</script>");
    }
    if (studentNumber == null) { // 로그인을 안했다면 작성 불가
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인 하세요.')");
        script.println("location.href = '/MainPage/login.jsp' ");
        script.println("</script>");
    }
    if(((isCaptain == 0 && boardKind == -1))){ // 홍보 게시판을 경우는 동아리장만 게시 가능
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.(동아리장만 게시 가능)')");
        script.println("location.href = '/MainPage/noticeBoard.jsp' ");
        script.println("</script>");
    }
%>
<hr>
<!-- 게시판 시작 -->
<section class="container">
    <div class="jumbotron bg-light">
        <div class="container">
            <form method="post" action="/Action/boardWriteAction.jsp?boardKind=<%=boardKind%>">
                <!-- 사용자가 작성한 양식을 writeAction.jsp로 post 한다.-->
                <table class="table table-striped table-hover table-bordered" style="text-align: center;">
                    <thead class="table-primary"> <!-- 테이블 헤더 ( 최상단 ) -->
                    <tr> <!-- 테이블 하나의 행 -->
                        <th colspan="2" style="text-align: center;">글쓰기</th>
                    </tr>
                    </thead>
                    <tbody> <!-- 테이블 바디 -->
                    <tr>
                        <td><input type="text" class="form-control" placeholder="글 제목" name="boardTitle" maxlength="50">
                        </td>
                        <!-- 글 제목 입력 -->
                    </tr>
                    <tr>
                        <td><textarea class="form-control" placeholder="글 내용" name="boardContent" maxlength="2048"
                                      style="height: 350px;"></textarea></td> <!-- 글 입력 -->
                    </tr>
                    </tbody>
                </table>
                <div align="right">
                    <input type="submit" class="btn btn-primary" value="글쓰기">
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
