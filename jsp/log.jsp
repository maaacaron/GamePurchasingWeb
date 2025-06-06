<%@ page language="java" import="java.io.*, java.time.*" contentType="text/html;charset=utf8" pageEncoding="utf8" %>
<%!
    public void writeLog(String message, HttpServletRequest request, HttpSession session) {
        try {
            final String logFileName = "/usr/local/tomcat/webapps/ROOT/Web-DB/GamePurchasingWeb/jsp/log.txt";
            BufferedWriter writer = new BufferedWriter(new FileWriter(logFileName, true));

            writer.append("\nTime:\t" + LocalDate.now() + " " + LocalTime.now()
                    + "\tSessionID:\t" + session.getId()
                    + "\tURI:\t" + request.getRequestURI()
                    + "\tPrevious:\t" + request.getHeader("referer")
                    + "\tBrowser:\t" + request.getHeader("User-Agent")
                    + "\tMessage:\t" + message);

            String searchTerm = request.getParameter("search");
            if (searchTerm != null && !searchTerm.isEmpty()) {
                writer.append("\tSearch:\t" + searchTerm);
            }

            String gameId = request.getParameter("gameId");
            if (gameId != null) {
                writer.append("\tGameID:\t" + gameId);
            }

            String userId = request.getParameter("userId");
            if (userId != null) {
                writer.append("\tUserID:\t" + userId);
            }

            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
%>
