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
<%@ page import="list.clublist" %>
<%@ page import="list.clublistDAO" %>
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
    int option = -10;
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
        if(club.getClubUserCnt() > 1){
            result = -9999;
        }else{
            result = new managementDAO().clubDrop(boardKind);
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
            if(result == - 9999){
                script.println("alert('동아리 회원이 남아 있어 폐쇄 하실 수 없습니다. ')");
                script.println("location.href = '/clubPage/managementClub.jsp?boardKind=" + boardKind + "'");
            }else{
                if(option == 0){
                    script.println("location.href = '/MainPage/findClub.jsp?clubKind=" + 0 + "&CurClubKind=" + "전체" + "'");
                }else{
                    script.println("location.href = '/MainPage/management.jsp'");
                }
            }
            script.println("</script>");
        }
    }
%>
</body>
</html>
