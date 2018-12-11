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
<%@ page import="list.clubusers" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="list.clublistDAO" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="sun.java2d.pipe.SpanShapeRenderer" %>
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
    int boardKind = -10;
    if (request.getParameter("boardKind") != null) {
        boardKind = Integer.parseInt(request.getParameter("boardKind"));
    }

    ArrayList<clubusers> clubusers = new ArrayList<>();
    clubusers = new clublistDAO().getMyList(studentNumber, boardKind);

    if (boardKind == -10) { // boardKind 가 넘어오지않으면 error
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('BK == -10 ERROR')");
        script.println("location.href = '/clubPage/clubCalendar.jsp?boardKind=" + boardKind + "'");
        script.println("</script>");
    }
    if (studentNumber == null) { // 회원이 아니라면
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인 하세요.')");
        script.println("location.href = '/MainPage/login.jsp'");
        script.println("</script>");
    } else if (clubusers.get(0).getIsStaff() != 1) { // 동아리 장이 아니라면
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.(동아리장만 추가 가능))'");
        script.println("location.href = '/clubPage/clubCalendar.jsp?boardKind=" + boardKind + "'");
        script.println("</script>");
    } else {
        if (request.getParameter("calData") == null || request.getParameter("calData") == "") { // 제목이 빈칸일 때
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('날자를 입력하세요')");
            script.println("history.back()");
            script.println("</script>");
        } else if (request.getParameter("calContent") == null || request.getParameter("calContent") == "") { // 내용이 없을 때
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('내용을 입력하세요')");
            script.println("history.back()");
            script.println("</script>");
        } else { // 둘다 입력된 경우
            int result = new clublistDAO().insertCal(boardKind, request.getParameter("calData"), request.getParameter("calContent"));
            if (result == -1) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('데이터 베이스 오류')");
                script.println("history.back()");
                script.println("</script>");
            } else {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("location.href = '/clubPage/clubCalendar.jsp?boardKind=" + boardKind + "'");
                script.println("</script>");
            }
        }
    }

%>
</body>
</html>
