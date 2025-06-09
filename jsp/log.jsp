<%@ page language="java" import="java.sql.*, javax.sql.DataSource, java.io.*, java.time.*" contentType="text/html;charset=utf8" pageEncoding="utf8"%>
<% request.setCharacterEncoding("UTF-8");%>
<%!
    public void writeLog(String message, HttpServletRequest request, HttpSession session) {
        try { 
            ServletContext application = request.getServletContext();
            String logFileName = application.getRealPath(request.getServletPath().replaceAll("[^/]+$", "log.txt"));
            BufferedWriter writer = new BufferedWriter(new FileWriter(logFileName, true));

            writer.append("\nTime:\t" + LocalDate.now() + " " + LocalTime.now()
                    + "\tSessionID:\t" + session.getId()
                    + "\tURI:\t" + request.getRequestURI()
                    + "\tPrevious:\t" + request.getHeader("referer")
                    + "\tBrowser:\t" + request.getHeader("User-Agent")
                    + "\tMessage:\t" + message);

            String searchTerm = request.getParameter("search");         //검색한 게임
            if (searchTerm != null && !searchTerm.isEmpty()) {
                writer.append("\tSearch:\t" + searchTerm);
            }

            String gameId = request.getParameter("gameId");             //게임 id(장바구니에서)
            if (gameId != null) {
                writer.append("\tGameID:\t" + gameId);
            }

            String[] gameIds = request.getParameterValues("remove");
            if (gameIds != null) {
                for (String gameIdd : gameIds) {
                    // 각 게임ID 별로 로그 기록 또는 DB 처리 등 가능
                    out.println("결제된 게임ID: " + gameIdd + "<br>");
                }
            }

            String userId = request.getParameter("userId");             //유저 id(로그인)
            if (userId != null) {
                writer.append("\tUserID:\t" + userId);
            }

            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
%>
