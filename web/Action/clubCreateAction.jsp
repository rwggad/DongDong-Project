<%--
  Created by IntelliJ IDEA.
  User: rwgga
  Date: 2018-10-20
  Time: 오후 11:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="list.clublistDAO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="list" class="list.clublist" scope="page"/>
<jsp:setProperty name="list" property="clubCaptain"/>
<jsp:setProperty name="list" property="clubName"/>
<jsp:setProperty name="list" property="clubContent"/>
<jsp:setProperty name="list" property="clubLocation"/>
<jsp:setProperty name="list" property="clubPhoneNumber"/>
<jsp:setProperty name="list" property="clubKind"/>
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

    if (studentNumber == null) { // 회원이 아니라면
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인 하세요.')");
        script.println("location.href = '/MainPage/login.jsp' ");
        script.println("</script>");
    }else if( isCaptain == 0){ // 동아리 장이 아니라면
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('권한이 없습니다.(동아리장만 개설 가능))'");
        script.println("location.href = '/MainPage/findClub.jsp?clubKind=" + 0 + "&CurClubKind=" + "전체" + "'");
        script.println("</script>");
    } else {
        if ((list.getClubName() == null)) { // 개설할 폼에 동아리 이름을 미입력 했을 시
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('동아리 이름을 입력하세요!')");
            script.println("history.back()");
            script.println("</script>");
        } else if ((list.getClubContent() == null)) { // 개설할 폼에 동아리 소개 내용 미입력시
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('동아리를 간단히 소개 해주세요!')");
            script.println("history.back()");
            script.println("</script>");
        } else {
            int result = new clublistDAO().createClub(list, studentNumber);
            if (result == -1) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('이미 존재하는 동아리 이름 입니다.')");
                script.println("history.back()");
                script.println("</script>");
            } else {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("location.href = '/MainPage/findClub.jsp?clubKind=0&CurClubKind=" + "전체" + "'");
                script.println("</script>");
            }
        }

    }
%>
</body>
</html>
