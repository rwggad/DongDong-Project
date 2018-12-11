<%--
  Created by IntelliJ IDEA.
  User: rwgga
  Date: 2018-10-20
  Time: 오후 11:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:setProperty name="user" property="studentNumber"/>
<jsp:setProperty name="user" property="studentPassword"/>
<jsp:setProperty name="user" property="studentName"/>
<jsp:setProperty name="user" property="isCaptain"/>
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

    if (studentNumber != null) { // 이미 로그인된 세션이 있다면 회원 가입 할 필요가 없음
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('이미 로그인 되어 있습니다.')");
        script.println("location.href = '/MainPage/main.jsp' ");
        script.println("</script>");
    } else {
        if ((user.getStudentNumber() == null)) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('아이디를 입력하세요!')");
            script.println("history.back()");
            script.println("</script>");
        } else if ((user.getStudentPassword() == null)) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('비밀번호를 입력하세요!')");
            script.println("history.back()");
            script.println("</script>");
        } else if ((user.getStudentName() == null)) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('이름을 입력하세요!')");
            script.println("history.back()");
            script.println("</script>");
        } else {
            int result = new UserDAO().join(user);
            if (result == -1) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('이미 존재하는 아이디 입니다.')");
                script.println("history.back()");
                script.println("</script>");
            } else {
                session.setAttribute("studentNumber", user.getStudentNumber()); // 세션관리 해당 학생의 학번 삽입
                session.setAttribute("isCaptain", user.getIsCaptain()); // 세션관리 해당 학생이 동아리장인지 일반 학부생인지
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("location.href = '/MainPage/main.jsp' ");
                script.println("</script>");
            }
        }
    }
%>
</body>
</html>
