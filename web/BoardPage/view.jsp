<%--
  Created by IntelliJ IDEA.
  User: rwgga
  Date: 2018-10-20
  Time: 오후 11:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.Board" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="board.comment" %>
<!DOCTYPE html>
<html>
<head>
    <title>DONG_DONG</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width" , initial-scale="1">
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
    <link href="https://fonts.googleapis.com/css?family=Cute+Font|Gaegu:300,400,700|Gamja+Flower|Gugi|Jua|Sunflower:300,500,700&amp;subset=korean" rel="stylesheet">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
    <style type="text/css">
        *{
            font-family: 'Jua', sans-serif;
        }
    </style>
</head>
<!-- 시작 -->
<body class="bg-secondary">
<%
    String studentNumber = null; // 현재 접속된 회원이 있는지 ?
    if (session.getAttribute("studentNumber") != null) {
        studentNumber = (String) session.getAttribute("studentNumber");
    }
    int boardKind = -10;
    if (request.getParameter("boardKind") != null) {
        boardKind = Integer.parseInt(request.getParameter("boardKind"));
    }
    int boardID = 0; // 현재 수정 하려는 게시물 id 받아오기
    if (request.getParameter("boardID") != null) {
        boardID = Integer.parseInt(request.getParameter("boardID"));
    }

    String studentName = new UserDAO().userName(studentNumber); // 학번으로 이름 따오기

    if (studentNumber == null) { // 로그인을 안했으면 게시판에 접근 할 수 없다.
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인 하세요.')");
        script.println("location.href = '/MainPage/login.jsp' ");
        script.println("</script>");
    }
    if (boardID == 0 || boardKind == -10) { // 없는 게시물 id는 접근 불가
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유요하지 않은 접근 입니다..')");
        if (boardKind == -1) {
            script.println("location.href = '/BoardPage/noticeBoard.jsp?boardKind=" + boardKind + "'");
        } else {
            script.println("location.href = '/BoardPage/clubBoard.jsp?boardKind=" + boardKind + "'");
        }
        script.println("</script>");
    }
    BoardDAO noticeDAO = new BoardDAO();
    Board bbs = noticeDAO.getBbs(boardID); // 게시물 내용 받아오기
    noticeDAO.setCount(boardID); // 조회수 증가
%>
<hr>
<!-- 게시판 내용 -->
<section class="container">
    <div class="jumbotron  bg-light">
        <div>
            <table class="table table-light" style="border:1px solid #d1d1d1">
                <tbody>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <!-- 게시물 제목 -->
                            <%=bbs.getBoardTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")%>
                        </td>
                        <td class="small" style="text-align: right">
                            <!-- 게시물 일자 -->
                            <u><%=bbs.getBoardDate().substring(0, 11) + bbs.getBoardDate().substring(11, 13) + ":" + bbs.getBoardDate().substring(14, 16)%></u>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div>
            <table class="table table-light table-bordered">
                <tbody>
                <tr>
                    <td class="small">
                        <div style="font-weight: bold">
                            <!-- 작성자 -->
                            <u><%=new UserDAO().userName(bbs.getBoardWriter()) + "(" + bbs.getBoardWriter() + ")"%></u>
                        </div>
                        <hr>
                        <div style="min-height: 200px; height: 350px;">
                            <!-- 게시글 내용 -->
                            <%=bbs.getBoardContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")%>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <% if(boardKind != -1) { %>
        <!-- 홍보 게시판은 댓글 작성 x -->
        <!-- 댓글 작성 보드 -->
        <div>
            <table class="table table-light" style="border:1px solid #d1d1d1">
                <thead>
                <tr>
                    <td align="left">
                        <!-- 댓글 보기 -->
                        <button class="btn btn-primary btn-sm" type="button" data-toggle="collapse" data-target="#comments" aria-expanded="false" aria-controls="comments">댓글펼치기</button>
                    </td>
                    <td align="right">
                        <button class="btn btn-info btn-sm" type="button" data-toggle="collapse" data-target="#commentsWrite" aria-expanded="false" aria-controls="comments">댓글작성</button>
                    </td>
                </tr>
                </thead>
            </table>
        </div>
        <!-- 댓글 리스트 -->
        <div class="collapse" id="comments">
            <div class="card card-body">
                <%
                    ArrayList<comment> comments = new ArrayList<>();
                    comments = new BoardDAO().getCList(boardID);
                    if (comments.size() == 0) { %>
                <!-- 작성된 댓글이 없을 때 -->
                <table class="table table-light" style="border:1px solid #d1d1d1">
                    <tr>
                        <td>
                            아직 작성된 댓글이 없습니다.
                        </td>
                    </tr>
                </table>
                    <% } else {
                        for (int i = 0; i < comments.size(); i++) { %>
                <!-- 댓글이 있을때 출력 -->
                <table class="table table-light" style="border:1px solid #d1d1d1">
                    <tr class="small" class="table-sm">
                        <td style="font-weight: bold" align="left">
                            <!-- 작성자 정보 -->
                            <%=new UserDAO().userName(comments.get(i).getCommentWriter()) + "(" + comments.get(i).getCommentWriter() + ")"%>
                        </td>
                        <td align="right">
                            <!-- 댓글 작성 일자 -->
                            <u><%=comments.get(i).getCommentDate().substring(0, 11) + comments.get(i).getCommentDate().substring(11, 13) + ":" + comments.get(i).getCommentDate().substring(14, 16) %>
                            </u>
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <!-- 댓글 내용 -->
                            <%=comments.get(i).getCommentContent()%>
                        </td>
                        <td align="right">
                            <% if(comments.get(i).getCommentWriter().equals(studentNumber) ) { %>
                            <a class="btn btn-danger btn-sm" href="/Action/commentDeleteAction.jsp?boardID=<%=boardID%>&boardKind=<%=boardKind%>&commentID=<%=comments.get(i).getCommentID()%>">삭제</a>
                            <% } %>
                        </td>
                    </tr>
                </table>
                <%
                        }
                    }
                %>
            </div>
            <br>
        </div>
        <!-- 댓글 작성 하기 -->
        <div class="collapse" id="commentsWrite">
            <div class="card card-body">
                <form method="post" action="/Action/commentWriteAction.jsp?boardID=<%=boardID%>&boardKind=<%=boardKind%>">
                    <div align="center">
                    <textarea class="form-control" placeholder="댓글 내용" name="commentContent" maxlength="1024"
                              style="height: 150px;"></textarea> <!-- 댓글 입력 -->
                    </div>
                    <br>
                    <div align="right">
                        <input type="submit" class="btn btn-primary pull-right btn-sm" value="작성">
                    </div>
                </form>
            </div>
            <br>
        </div>
        <% } %>
        <div align="right">
            <%
                if (studentNumber != null && studentNumber.equals(bbs.getBoardWriter())) { // 글쓴 사람이 작성자 본인 이라면
            %>
            <a onclick="if(!confirm('정말로 삭제하시겠습니까?')){return false}"
               href="../Action/boardDeleteAction.jsp?boardID=<%=boardID%>&boardKind=<%=bbs.getBoardKind()%>"
               class="btn btn-danger btn-sm">삭제</a> <!--삭제-->
            <a href="/BoardPage/update.jsp?boardID=<%=boardID%>&boardKind=<%=bbs.getBoardKind()%>"
               class="btn btn-primary btn-sm">수정</a> <!--수정-->
            <%
                }if (boardKind == -1) {
            %>
            <a class="btn btn-primary btn-sm" href="/BoardPage/noticeBoard.jsp?boardKind=-1">목록</a>
            <%} else {%>
            <a class="btn btn-primary btn-sm" href="/clubPage/club.jsp?boardKind=<%=boardKind%>">목록</a>
            <%}%>
        </div>
    </div>
</section>
<footer>
    <hr>
    <div align="right"><p>dongdong!&nbsp;&nbsp;</p></div>
</footer>
</body>
</html>
