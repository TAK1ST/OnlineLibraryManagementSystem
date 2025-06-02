<%-- 
    Document   : error_page
    Created on : Jun 2, 2025, 9:35:19 PM
    Author     : CAU_TU
--%>

<%@page  isErrorPage="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Error Page</title>
    </head>
    <body>
        <h1>something wrong</h1>
        <h1><%= exception.getMessage() %></h1>
    </body>
</html>
