<%--
  Created by IntelliJ IDEA.
  User: rwgga
  Date: 2018-10-20
  Time: 오후 11:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=utf-8");
%>
<%--<jsp:useBean id="bbs" class="board.Bbs" scope="page"/>
<jsp:setProperty name="bbs" property="bbsTitle"/>
<jsp:setProperty name="bbs" property="bbsContent"/>--%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>DONG_DONG</title>
</head>
<body>
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

    if (boardKind == -10) { // boardKind 가 넘어오지않으면 error
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('BK == -2 ERROR')");
        if (boardKind == -1) {
            script.println("location.href = '/BoardPage/noticeBoard.jsp?boardKind=" + boardKind + "'");
        } else {
            script.println("location.href = '/clubPage/club.jsp?boardKind=" + boardKind + "'");
        }
        script.println("</script>");
    } else if (studentNumber == null || ((isCaptain == 0 && boardKind == -1))) { // 회원이 아니거나, 홍보 게시판일 경우 동아리 장이 아니면 작성 불가
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
        if (request.getParameter("boardTitle") == null || request.getParameter("boardTitle") == "") { // 제목이 빈칸일 때
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('제목을 입력하세요')");
            script.println("history.back()");
            script.println("</script>");
        } else if (request.getParameter("boardContent") == null || request.getParameter("boardContent") == "") { // 내용이 없을 때
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('내용을 입력하세요')");
            script.println("history.back()");
            script.println("</script>");
        } else { // 둘다 입력된 경우
            int result = new BoardDAO().write(boardKind, studentNumber, request.getParameter("boardTitle"), request.getParameter("boardContent"));
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
    }

%>
</body>
</html>
