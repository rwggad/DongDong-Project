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
<%@ page import="user.UserDAO" %>
<%@ page import="management.managementDAO" %>
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
    int boardKind = -10;
    if (request.getParameter("boardKind") != null) {
        boardKind = Integer.parseInt(request.getParameter("boardKind"));
    }
    int boardID = -2;
    if (request.getParameter("boardID") != null) {
        boardID = Integer.parseInt(request.getParameter("boardID"));
    }

    if (studentNumber == null) { //로그인을 하지 않으면 사용 불가
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인 하세요')");
        script.println("location.href = '/MainPage/login.jsp' ");
        script.println("</script>");
    }
    else {
        int result = new managementDAO().boardDrop(boardID);
        if (result == -1) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('데이터 베이스 오류')");
            script.println("history.back()");
            script.println("</script>");
        } else {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            if(boardKind == -9999){ // 홈페이지 관리
                script.println("location.href = '/MainPage/management.jsp?'");
            }else{ // 동아리 관리
                script.println("location.href = '/clubPage/managementClub.jsp?boardKind=" + boardKind + "'");
            }
            script.println("</script>");
        }
    }
%>
</body>
</html>
