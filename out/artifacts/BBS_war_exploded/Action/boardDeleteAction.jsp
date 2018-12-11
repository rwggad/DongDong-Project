<%--
  Created by IntelliJ IDEA.
  User: rwgga
  Date: 2018-10-20
  Time: 오후 11:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="board.Board" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>DONG_DONG</title>
</head>
<body>
<%
    String studentNumber = null; // 현재 접속된 회원이 있는지 ?
    if (session.getAttribute("studentNumber") != null) {
        studentNumber = (String) session.getAttribute("studentNumber");
    }
    int boardID = 0; // 현재 삭제 하려는 게시물 id 받아오기
    if (request.getParameter("boardID") != null) {
        boardID = Integer.parseInt(request.getParameter("boardID"));
    }
    int boardKind = -10; // 현재 삭제 하려는 게시물의 kind 받아오기
    if (request.getParameter("boardKind") != null) {
        boardKind = Integer.parseInt(request.getParameter("boardKind"));
    }

    Board board = new BoardDAO().getBbs(boardID);

    if (boardID == 0) {  // boardID 가 0 이면 게시물 id를 받아오지 못한것
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 게시글 입니다.')");
        if (boardKind == -1) {
            script.println("location.href = '/BoardPage/noticeBoard.jsp?boardKind=" + boardKind + "'");
        } else {
            script.println("location.href = '/clubPage/club.jsp?boardKind=" + boardKind + "'");
        }
        script.println("</script>");
    } else if (boardKind == -10) { // boardKind 가 넘어오지않으면 error
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('BK == -10 ERROR')");
        if (boardKind == -1) {
            script.println("location.href = '/BoardPage/noticeBoard.jsp?boardKind=" + boardKind + "'");
        } else {
            script.println("location.href = '/clubPage/club.jsp?boardKind=" + boardKind + "'");
        }
        script.println("</script>");
    } else if ((!studentNumber.equals(board.getBoardWriter())) || (studentNumber == null)) {  // 이 게시물을 작성한 회원이 아니라면 삭제 불가
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.')");
        if (boardKind == -1) {
            script.println("location.href = '/BoardPage/noticeBoard.jsp?boardKind=" + boardKind + "'");
        } else {
            script.println("location.href = '/clubPage/club.jsp?boardKind=" + boardKind + "'");
        }
        script.println("</script>");
    } else {
        int result = new BoardDAO().delete(boardID);
        if (result == -1) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('데이터 베이스 오류')");
            script.println("history.back()");
            script.println("</script>");
        } else {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            if (boardKind == -1) {
                script.println("location.href = '/BoardPage/noticeBoard.jsp?boardKind=" + boardKind + "'");
            } else {
                script.println("location.href = '/clubPage/club.jsp?boardKind=" + boardKind + "'");
            }
            script.println("</script>");
        }
    }
%>
</body>
</html>
