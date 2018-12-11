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
    int boardID = 0; // 현재 수정 하려는 게시물 id 받아오기
    if (request.getParameter("boardID") != null) {
        boardID = Integer.parseInt(request.getParameter("boardID"));
    }
    int boardKind = -10;
    if (request.getParameter("boardKind") != null) {
        boardKind = Integer.parseInt(request.getParameter("boardKind"));
    }

    if (boardID == 0) { //boardID가 넘어오지않으면 error
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('BK == -10 or BI = 0 ERROR')");
        script.println("location.href = '/BoardPage/view.jsp?boardID=" + boardID + "&boardKind=" + boardKind + "'");
        script.println("</script>");
    } else if (studentNumber == null) { // 회원이 아니면 작성 불가
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.')");
        script.println("location.href = '/MainPage/login.jsp'");
        script.println("</script>");
    } else {
        if (request.getParameter("commentContent") == null || request.getParameter("commentContent") == "") { // 내용이 없을 때
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('내용을 입력하세요')");
            script.println("history.back()");
            script.println("</script>");
        } else { // 둘다 입력된 경우
            int result = new BoardDAO().commentWrite(boardID, boardKind, studentNumber, request.getParameter("commentContent"));
            if (result == -1) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('데이터 베이스 오류')");
                script.println("history.back()");
                script.println("</script>");
            } else {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("location.href = '/BoardPage/view.jsp?boardID=" + boardID + "&boardKind=" + boardKind + "'");
                script.println("</script>");
            }
        }
    }

%>
</body>
</html>
