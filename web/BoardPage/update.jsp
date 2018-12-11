<%--
  Created by IntelliJ IDEA.
  User: rwgga
  Date: 2018-10-20
  Time: 오후 11:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.Board" %>
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
    String studentNumber = null; // 현재 접속된 회원이 있는지 ?
    if (session.getAttribute("studentNumber") != null) {
        studentNumber = (String) session.getAttribute("studentNumber");
    }
    int boardID = 0; // 현재 수정 하려는 게시물 id 받아오기
    if (request.getParameter("boardID") != null) {
        boardID = Integer.parseInt(request.getParameter("boardID"));
    }
    int boardKind = -10;
    if (request.getParameter("boardKind") != null) {
        boardKind = Integer.parseInt(request.getParameter("boardKind"));
    }

    Board bbs = new BoardDAO().getBbs(boardID);
    String studentName = new UserDAO().userName(studentNumber); // 학번으로 이름 따오기

    if (studentNumber == null) { // 로그인을 안했으면 게시판에 접근 할 수 없다.
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인 하세요.')");
        script.println("location.href = '/MainPage/login.jsp' ");
        script.println("</script>");
    }
    if (boardID == 0) { // 없는 게시물 id는 접근 불가
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 게시글 입니다.')");
        if (boardKind == -1) {
            script.println("location.href = '/BoardPage/noticeBoard.jsp?boardKind=" + boardKind + "'");
        } else {
            script.println("location.href = '/BoardPage/clubBoard.jsp?boardKind=" + boardKind + "'");
        }
        script.println("</script>");
    }
    if ((!studentNumber.equals(bbs.getBoardWriter())) || (studentNumber == null)) { // 이 게시물을 작성한 회원이 아니면 수정 기능에 들어 갈 수 없음
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.')");
        if (boardKind == -1) {
            script.println("location.href = '/BoardPage/noticeBoard.jsp?boardKind=" + boardKind + "'");
        } else {
            script.println("location.href = '/BoardPage/clubBoard.jsp?boardKind=" + boardKind + "'");
        }
        script.println("</script>");
    }
%>
<hr>
<!-- 게시판 시작 -->
<section class="container">
    <div class="jumbotron bg-light">
        <div class="container">
            <form method="post"
                  action="/Action/boardUpdateAction.jsp?boardID=<%=boardID%>&boardKind=<%=bbs.getBoardKind()%>">
                <table class="table table-striped" style="text-align: center;">
                    <thead class="table-primary"> <!-- 테이블 헤더 ( 최상단 ) -->
                    <tr> <!-- 테이블 하나의 행 -->
                        <th colspan="2">게시물 수정</th>
                    </tr>
                    </thead>
                    <tbody class="table-light"> <!-- 테이블 바디 -->
                    <tr>
                        <!-- 글 제목 입력 -->
                        <td><input type="text" class="form-control" placeholder="글 제목" name="boardTitle"
                                   maxlength="50"
                                   value="<%=bbs.getBoardTitle()%>"></td>
                    </tr>
                    <tr>
                        <!-- 글 입력 -->
                        <td><textarea class="form-control" placeholder="글 내용" name="boardContent" maxlength="2048"
                                      style="height: 350px;"><%=bbs.getBoardContent()%></textarea></td>
                    </tr>
                    </tbody>
                </table>
                <div align="right">
                    <input type="submit" class="btn btn-primary" value="수정">
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
