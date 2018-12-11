<%--
  Created by IntelliJ IDEA.
  User: rwgga
  Date: 2018-10-20
  Time: 오후 11:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="list.clublistDAO" %>
<%@ page import="user.UserDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>
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
    int boardKind = -10; // 가입하려는 동아리 kind
    if (request.getParameter("boardKind") != null) {
        boardKind = Integer.parseInt(request.getParameter("boardKind"));
    }
    String clubName = null; // 가입라혀는 동아리 이름
    if (request.getParameter("clubName") != null) {
        clubName = request.getParameter("clubName");
    }
    String waitContent = null;
    if (request.getParameter("waitContent") != null) {
        waitContent = request.getParameter("waitContent");
    }

    if (boardKind == -10) { // boardKind 가 넘어오지않으면 error
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('BK == -10 ERROR')");
        script.println("location.href = '/MainPage/findClub.jsp?clubKind=" + 0 + "&CurClubKind=" + "전체" + "'");
        script.println("</script>");
    } else if (studentNumber == null) { // 회원이 아니면 가입 불가
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.')");
        script.println("location.href = '/MainPage/login.jsp' ");
        script.println("</script>");
    } else {
        /**
         * 이미 wait table에 있으면 신청 불가*/
        int result = 0;
        if(new clublistDAO().isWait(studentNumber, boardKind)){
            /**
             * 이미 wait table에 존재한다.*/
            result = -3;
        }else{
            /**
             * wait에 없으면 이미 회원인지 확인*/
            if(new clublistDAO().isClubUser(boardKind, studentNumber)){
                result = -2;
            }else{
                result = new clublistDAO().InsertWait(boardKind, studentNumber, waitContent);
            }
        }


        if (result == -1) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('유효하지 않은 접근합니다.')");
            script.println("history.back()");
            script.println("</script>");
        } else if (result == -2) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('이미 가입한 동아리 입니다.')");
            script.println("history.back()");
            script.println("</script>");
        } else if (result == -3) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('이미 가입 신청이 진행중입니다..')");
            script.println("history.back()");
            script.println("</script>");
        } else {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('가입 신청완료.')");
            script.println("location.href = '/MainPage/findClub.jsp?clubKind=" + 0 + "&CurClubKind=" + "전체" + "'");
            script.println("</script>");
        }
    }

%>
</body>
</html>
