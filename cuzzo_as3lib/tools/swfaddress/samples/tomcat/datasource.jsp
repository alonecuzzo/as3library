<%@page contentType="text/xml; charset=utf-8" %><% 

    String swfaddress = request.getParameter("swfaddress");
    if (swfaddress != null) {
        swfaddress = swfaddress.replaceAll("^(.+)/$", "$1");
    }

    String base = request.getProtocol().substring(0, request.getProtocol().indexOf("/")).toLowerCase() + 
        "://" + request.getServerName() + ':' + request.getServerPort() + request.getContextPath() + 
        request.getServletPath();
    base = base.substring(0, base.lastIndexOf("/"));

    if ("/".equals(swfaddress)) {

        out.print("<p>Quisque libero mauris, ornare in, faucibus ut, facilisis nec, quam. Mauris quis felis ac nisl laoreet adipiscing. Nunc libero. Vivamus nec libero. Fusce neque odio, interdum a, pharetra sit amet, mattis non, nisl. Donec quis metus et pede gravida pharetra. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Sed tincidunt ipsum ut mi. Sed tincidunt porta ipsum. Curabitur sem risus, egestas et, ultricies sed, sollicitudin a, nulla. Praesent eget lectus sed erat commodo ultrices. Donec purus enim, nonummy ut, iaculis sit amet, convallis a, est. Mauris consequat, elit et scelerisque posuere, dui est convallis quam, vitae dignissim tortor odio consectetuer leo. Donec turpis velit, varius id, tincidunt sed, sodales id, eros.</p>");

    } else if ("/about".equals(swfaddress)) {

        out.print("<p>Suspendisse vitae nibh. Curabitur laoreet auctor velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Etiam tortor. Sed porta diam vel augue. Praesent sollicitudin blandit lectus. Duis interdum, arcu vel convallis porttitor, magna tellus auctor odio, ac lobortis nulla orci vel lacus. Morbi tortor justo, sagittis et, interdum eget, placerat et, metus. Ut quis massa. Phasellus leo nulla, tempus sed, mattis mattis, sodales in, urna. Fusce in purus. Curabitur a lorem quis dolor ultrices egestas. Maecenas dolor elit, tincidunt vel, tempor ac, imperdiet a, quam. Nullam justo. Morbi sagittis. Ut suscipit pulvinar ante. Cras eu tortor. In nonummy, erat eget aliquet molestie, sapien eros pretium lorem, eu pretium urna neque eu purus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Pellentesque scelerisque lorem ut ligula.</p>");

    } else if ("/portfolio".equals(swfaddress)) {

        out.print("<p>Fusce at ipsum vel diam ullamcorper convallis. Morbi aliquet cursus lacus. Nunc nisi ligula, accumsan sit amet, condimentum nec, ullamcorper a, lectus. Vestibulum ut lectus. Ut rutrum mi nec lectus. Morbi quis nibh. Pellentesque congue, lorem quis porta tincidunt, tellus tortor venenatis leo, vel porttitor massa massa nec dui. In interdum euismod magna. In hac habitasse platea dictumst. Donec erat. Donec nunc ipsum, lobortis ac, feugiat sit amet, vehicula et, tellus. Donec in lacus ac metus condimentum gravida. Duis vehicula. In a neque in purus hendrerit molestie. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.</p>");

    } else if ("/portfolio/1".equals(swfaddress)) {

        out.print("<p><img src=\"" +  base + "/images/1.png\" alt=\"Portfolio 1\" width=\"400\" height=\"300\" /><br />");
        out.print(("true".equals(request.getParameter("desc"))) ? "Atlantic Hit Mix Calendar<br />" : "");
        out.print((request.getParameter("year") != null) ? request.getParameter("year") + "<br />" : "");
        out.print("<br /><a href=\"http://www.sergeevstudio.com\">Photos by Lyubomir Sergeev</a></p>");

    } else if ("/portfolio/2".equals(swfaddress)) {

        out.print("<p><img src=\"" + base + "/images/2.png\" alt=\"Portfolio 2\" width=\"400\" height=\"300\" /><br />");
        out.print(("true".equals(request.getParameter("desc"))) ? "Atlantic Hit Mix Calendar<br />" : "");
        out.print((request.getParameter("year") != null) ? request.getParameter("year") + "<br />" : "");
        out.print("<br /><a href=\"http://www.sergeevstudio.com\">Photos by Lyubomir Sergeev</a></p>");

    } else if ("/portfolio/3".equals(swfaddress)) {

        out.print("<p><img src=\"" +  base + "/images/3.png\" alt=\"Portfolio 3\" width=\"400\" height=\"300\" /><br />");
        out.print(("true".equals(request.getParameter("desc"))) ? "Atlantic Hit Mix Calendar<br />" : "");
        out.print((request.getParameter("year") != null) ? request.getParameter("year") + "<br />" : "");
        out.print("<br /><a href=\"http://www.sergeevstudio.com\">Photos by Lyubomir Sergeev</a></p>");

    } else if ("/contact".equals(swfaddress)) {

        out.print("<p>Nulla nec nunc id urna mollis molestie. Suspendisse potenti. Aliquam vitae dui. In semper ante eu massa. Praesent quis nunc. Vestibulum tristique tortor. Duis feugiat. Nam pharetra vulputate augue. Sed laoreet. Mauris id orci ac nisl consectetuer sollicitudin. Donec eu ante at velit cursus gravida. Suspendisse arcu.</p>");

    } else {
    
        out.print("<p><!-- Status(404) -->Page not found." + swfaddress + "</p>");
        
    }
%>