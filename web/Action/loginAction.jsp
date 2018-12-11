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
<% request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=utf-8");
%>
<jsp:useBean id="user" class="user.User" scope="page"/>
<jsp:setProperty name="user" property="studentNumber"/>
<jsp:setProperty name="user" property="studentPassword"/>
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
    if (studentNumber != null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('이미 로그인 되어 있습니다.')");
        script.println("location.href = '/MainPage/main.jsp';");
        script.println("</script>");
    } else {
        UserDAO userDAO = new UserDAO();
        int result = userDAO.login(user);
        if (result == 1) {
            session.setAttribute("studentNumber", user.getStudentNumber()); // 세션관리 해당 학생의 학번 삽입
            session.setAttribute("isCaptain", userDAO.isCaptain(user.getStudentNumber())); // 세션관리 해당 학생이 동아리장인지 일반 학부생인지
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("location.href = '/MainPage/main.jsp';");
            script.println("</script>");
        } else if (result == 0 || result == -1) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('아이디 혹은 비빌번호가 틀렸습니다.')");
            script.println("history.back()");
            script.println("</script>");
        } else if (result == -2) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('데이터 베이스 오류')");
            script.println("history.back()");
            script.println("</script>");
        }
    }
%>
</body>
</html>
