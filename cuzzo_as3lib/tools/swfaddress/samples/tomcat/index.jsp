<%@page import="java.io.File,
                java.util.Arrays,
                java.util.Date,
                java.util.LinkedList,                
                java.util.List,
                java.util.HashMap,                
                java.net.URL,
                java.net.URLConnection,
                java.net.URLEncoder,
                java.net.MalformedURLException,
                java.io.BufferedReader,
                java.io.InputStreamReader,
                java.io.IOException,
                javax.servlet.ServletContext,
                javax.servlet.http.HttpSession" 
%><%@page contentType="text/html; charset=utf-8" %><%!

    public ServletContext application;
    public HttpServletRequest request;
    public HttpServletResponse response;
    public HttpSession session;
    public JspWriter out;

    public String swfaddress;
    public String swfaddressPath;
    public HashMap swfaddressParameters;
    public String swfaddressContent;
    
    public void swfaddress(ServletContext application, 
        HttpServletRequest request, HttpServletResponse response, 
        HttpSession session, JspWriter out) throws IOException {
    
        this.application = application;
        this.request = request;
        this.response = response;
        this.session = session;
        this.out = out;
    
        if ("application/x-swfaddress".equals(request.getHeader("content-type"))) {
            swfaddress = ((String) request.getQueryString()).replaceAll("&hash=(.*)$", "#$1");
            session.setAttribute("swfaddress", swfaddress);
            out.print("location.replace(\"" + getBase() + "/#" + swfaddress + "\")");
            out.close();
        }
    
        if (session.getAttribute("swfaddress") != null) {
            swfaddress = (String) session.getAttribute("swfaddress");
            session.setAttribute("swfaddress", null);
        } else {
            String requestURI = (String) (request.getAttribute("javax.servlet.forward.request_uri") != null ? 
                request.getAttribute("javax.servlet.forward.request_uri") : request.getRequestURI());
            swfaddress = requestURI.replace(getBase(), "") + (request.getAttribute("javax.servlet.forward.query_string") != null ? 
                "?" + ((String) request.getAttribute("javax.servlet.forward.query_string")) : "");
            String jsp = request.getContextPath() + request.getServletPath();
            jsp = jsp.substring(jsp.lastIndexOf("/") + 1);
            swfaddress = swfaddress.replace(jsp, "");
        }
        
        swfaddress = swfaddress.replaceAll("^([^\\?.]*[^\\/])(\\?|$)", "$1/$2");
        swfaddressParameters = new HashMap();
        String queryString = (swfaddress.indexOf("?") != -1) ? swfaddress.substring(swfaddress.indexOf("?") + 1) : "";
        
        if (!"".equals(queryString)) {
            swfaddressPath = swfaddress.substring(0, swfaddress.indexOf("?"));
            String[] params = swfaddress.replace(swfaddressPath + "?", "").split("&");
            for (int i = 0; i < params.length; i++) {
                String[] pair = params[i].split("=");
                swfaddressParameters.put(pair[0], pair[1]);
            }
        } else {
            swfaddressPath = swfaddress;
        }
        
        String url = request.getProtocol().split("/")[0].toLowerCase() + "://" + 
            request.getServerName() + ":" + request.getServerPort() + getBase() + 
            "/datasource.jsp?swfaddress=" + swfaddressPath;
        url += (swfaddress.indexOf("?") != -1) ? "&" + swfaddress.substring(swfaddress.indexOf("?") + 1) : "";

        URLConnection urlc = new URL(url).openConnection();
        BufferedReader br = new BufferedReader(new InputStreamReader(urlc.getInputStream()));
        
        swfaddressContent = "";
        
        String line = "";
        while (line != null) {
            swfaddressContent += line;        
            line = br.readLine();
        }
        
        if (swfaddressContent.indexOf("Status(") != -1) {
            int begin = swfaddressContent.indexOf("Status(", 0);
            int end = swfaddressContent.indexOf(")", begin);
            String status = swfaddressContent.substring(begin + 7, end);
            response.setStatus(Integer.parseInt(status));
        }
        
        if (isMSIE()) {
        
            Long ifModifiedSince = request.getDateHeader("If-Modified-Since");
            
            File file = new File(application.getRealPath(request.getServletPath()));
            Long fileLastModified = file.lastModified();
            
            if(ifModifiedSince != null && ifModifiedSince/1000 == fileLastModified/1000) {
                response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
                return;
            } 
    
            response.addDateHeader("Expires", new Date().getTime() + 86400000);
            response.addDateHeader("Last-Modified", fileLastModified);
            response.addDateHeader("Cache-control: max-age=", 86400);
        }
    }
    
    public boolean isMSIE() {
        return request.getHeader("user-agent").toUpperCase().indexOf("MSIE") != -1;
    }
    
    public String getBase() {
        String base = request.getContextPath() + request.getServletPath();
        return base.substring(0, base.lastIndexOf("/"));
    }

    public String[] getPathNames() {
        String path = swfaddressPath;
        if ("/".equals(path.substring(0, 1))) {
            path = path.substring(1);
        }
        if (path.length() != 0) {
            return path.split("/");
        } else {
            return new String[0];
        }
    }

    public void swfaddressTitle(String title) throws IOException {
        if (!isMSIE()) {
            String[] names = getPathNames();
            for (int i = 0; i < names.length; i++) {
                title += " / " + names[i].substring(0, 1).toUpperCase() + names[i].substring(1);
            }
        }        
        out.print(title);
    }

    public void swfaddressLink(String link) throws IOException {
        out.print(getBase() + link);
    }

    public void swfaddressResource(String resource) throws IOException {
        out.print(getBase() + resource);
    }
    
    public void swfaddressContent() throws IOException, MalformedURLException {
        out.print(swfaddressContent);
    }
    
    public void swfaddressOptimizer(String resource) throws IOException {
        out.print(getBase() + resource + (resource.indexOf("?") != -1 ? "&amp;" : "?") + "swfaddress=" + URLEncoder.encode(swfaddress) + "&amp;base=" + URLEncoder.encode(getBase()));
    }

%><%
    
    swfaddress(application, request, response, session, out);
    
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <script type="text/javascript" src="<% swfaddressOptimizer("/swfaddress/swfaddress-optimizer.js?flash=9.0.115"); %>"></script>
        <title><% swfaddressTitle("SWFAddress Website"); %></title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <style type="text/css">
        /*<![CDATA[*/
            body {
                height: 100%;
                margin: 0;
                padding: 0;
                background: #CCCCCC;
                font: 86% Arial, "Helvetica Neue", sans-serif;
            }
            #website div {
                margin: 10px;
            }
        /*]]>*/
        </style>
        <script type="text/javascript" src="<% swfaddressResource("/swfobject/swfobject.js"); %>"></script>
        <script type="text/javascript" src="<% swfaddressResource("/swfaddress/swfaddress.js"); %>"></script>
        <script type="text/javascript" src="<% swfaddressResource("/swffit/swffit.js"); %>"></script>
        <script type="text/javascript">
        /*<![CDATA[*/
            swfobject.embedSWF('website.swf', 'website', '480', '480', '9.0.115', 
                '', {}, {bgcolor: '#CCCCCC', menu: 'false'}, {id: 'website'});
            swffit.fit('website', 480, 480);
        /*]]>*/
        </script>
    </head>
    <body>
        <div id="website">
            <div>
                <h1><a href="<% swfaddressLink("/"); %>">SWFAddress Website</a></h1>
                <ul>
                    <li><a href="<% swfaddressLink("/about"); %>">SWFAddress Website / About</a></li>
                    <li>
                        <a href="<% swfaddressLink("/portfolio"); %>">SWFAddress Website / Portfolio</a>
                        <ul>
                            <li><a href="<% swfaddressLink("/portfolio/1?desc=true&amp;year=2001"); %>">SWFAddress Website / Portfolio / 1</a></li>
                            <li><a href="<% swfaddressLink("/portfolio/2?desc=true"); %>">SWFAddress Website / Portfolio / 2</a></li>
                            <li><a href="<% swfaddressLink("/portfolio/3?desc=false&amp;year=2001"); %>">SWFAddress Website / Portfolio / 3</a></li>
                        </ul>
                    </li>
                    <li><a href="<% swfaddressLink("/contact"); %>">SWFAddress Website / Contact</a></li>
                </ul>
            </div>
            <div><% swfaddressContent(); %></div>
        </div>
    </body>
</html>