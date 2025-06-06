<%@ page language="java" import="java.io.*, java.time.*" contentType= "text/html;charset=utf8" pageEncoding="utf8"%>
<%!
        public void writeLog( String message, HttpServletRequest request, HttpSession session )
        {
                try
                {
                        final String logFileName = "/usr/local/tomcat/webapps/ROOT/Web-DB/GamePurchasingWeb/jsp/log.txt";
                        BufferedWriter writer = new BufferedWriter( new FileWriter( logFileName, true ) );

                        writer.append( "\nTime:\t" + LocalDate.now() + " " + LocalTime.now()    // 시간
                                + "\tSessionID:\t" + session.getId()                            // 세션 ID
                                + "\tURI:\t" + request.getRequestURI()                          // URI
                                + "\tPrevious:\t" + request.getHeader("referer")                // 이전 페이지
                                + "\tBrowser:\t" + request.getHeader("User-Agent")              // 브라우저 
                                + "\tMessage:\t" + message );                                   

                        writer.close();
                }
                catch (IOException e)
                {
                        e.printStackTrace();
                }
        }
%>