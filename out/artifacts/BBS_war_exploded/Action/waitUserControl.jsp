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
<%@ page import="list.clublistDAO" %>
<%@ page import="list.clublist" %>
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
    String otherStudentNumber = null;
    if (request.getParameter("otherStudentNumber") != null) {
        otherStudentNumber = (String) request.getParameter("otherStudentNumber");
    }
    int boardKind = -10;
    if (request.getParameter("boardKind") != null) {
        boardKind = Integer.parseInt(request.getParameter("boardKind"));
    }
    int option = -1;
    if (request.getParameter("option") != null) {
        option = Integer.parseInt(request.getParameter("option"));
    }

    if (studentNumber == null) { //로그인을 하지 않으면 사용 불가
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인 하세요')");
        script.println("location.href = '/MainPage/login.jsp' ");
        script.println("</script>");
    }
    else {
        /**
         * 현재 동아리 정보 가져오기*/
        clublist club = new clublist();
        club = new clublistDAO().getClubInfo(boardKind);
        int result = 0;
        if(option == 1){ // 가입 허가했을 때
            new clublistDAO().deleteWait(otherStudentNumber);
            /**
             * 가입을 허가 했으면 그 동아리에 넣어준다.*/
            new clublistDAO().joinClub(club.getBoardKind(), club.getClubName(), otherStudentNumber, 0);
        }
        else{  // 가입 거절 했을 때
            new clublistDAO().deleteWait(otherStudentNumber);
        }

        if (result == -1) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('데이터 베이스 오류')");
            script.println("history.back()");
            script.println("</script>");
        } else {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("location.href = '/clubPage/managementClub.jsp?boardKind=" + boardKind + "'");
            script.println("</script>");
        }
    }
%>
</body>
</html>
