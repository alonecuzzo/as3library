<?php

    // SWFAddress code fully compatible with Apache HTTPD
    
    $swfaddress_value = '/';
    $swfaddress_path = '/';
    $swfaddress_parameters = array();
    $swfaddress_content = '';
    
    function is_msie() {
        return strstr(strtoupper($_SERVER['HTTP_USER_AGENT']), 'MSIE');
    }
    
    function swfaddress() {
    
        global $swfaddress_value, $swfaddress_path, $swfaddress_parameters, $swfaddress_content;

        $base = swfaddress_base();
    
        session_start();

        if ('application/x-swfaddress' == (isset($_SERVER['CONTENT_TYPE']) ? $_SERVER['CONTENT_TYPE'] : 
            (isset($_SERVER['HTTP_CONTENT_TYPE']) ? $_SERVER['HTTP_CONTENT_TYPE'] : ''))) {
            $swfaddress_value = preg_replace('/&hash=(.*)$/', '#$1', $_SERVER['QUERY_STRING']);
            $_SESSION['swfaddress'] = $swfaddress_value;
            echo('location.replace("' . $base . '/#' . $swfaddress_value . '")');
            exit();
        }
        
        if (isset($_SESSION['swfaddress'])) {
            $swfaddress_value = $_SESSION['swfaddress'];
            unset($_SESSION['swfaddress']);
        } else {
            $page = substr($_SERVER['PHP_SELF'], strrpos($_SERVER['PHP_SELF'], '/') + 1);
            $swfaddress_value = str_replace($base, '', (strpos($page, '.php') && $page != 'index.php') ? $_SERVER['REQUEST_URI'] : str_replace($page, '', $_SERVER['REQUEST_URI']));
        }
        
        $query_string = (strpos($swfaddress_value, '?')) ? substr($swfaddress_value, strpos($swfaddress_value, '?') + 1, strlen($swfaddress_value)) : '';
        
        if ($query_string != '') {
            $swfaddress_path = substr($swfaddress_value, 0, strpos($swfaddress_value, '?'));
            $params = explode('&', str_replace($swfaddress_path . '?', '', $swfaddress_value));
            for ($i = 0; $i < count($params); $i++) {
                $pair = explode('=', $params[$i]);
                $swfaddress_parameters[$pair[0]] = $pair[1];
            }
        } else {
            $swfaddress_path = $swfaddress_value;
        }
        
        $url = strtolower(array_shift(explode('/', $_SERVER['SERVER_PROTOCOL']))) . '://';
        $url .= $_SERVER['SERVER_NAME'];
        $url .= swfaddress_base() . '/datasource.php?swfaddress=' . $swfaddress_path;
        $url .= (strpos($swfaddress_value, '?')) ? '&' . substr($swfaddress_value, strpos($swfaddress_value, '?') + 1, strlen($swfaddress_value)) : '';

        $fh = fopen($url, 'r');
        while (!feof($fh)) {
            $swfaddress_content .= fgets($fh, 4096);
        }    
        fclose($fh);

        if (strstr($swfaddress_content, 'Status(')) {
            $begin = strpos($swfaddress_content, 'Status(', 0);
            $end = strpos($swfaddress_content, ')', $begin);
            $status = substr($swfaddress_content, $begin + 7, $end - $begin - 7);
            if (php_sapi_name() == 'cgi') {
                header('Status: ' . $status);
            } else {
                header('HTTP/1.1 ' . $status);
            }
        }
        
        if (is_msie()) {
        
            $if_modified_since = isset($_SERVER['HTTP_IF_MODIFIED_SINCE']) ? 
                preg_replace('/;.*$/', '', $_SERVER['HTTP_IF_MODIFIED_SINCE']) : '';
            
            $file_last_modified = filemtime($_SERVER['SCRIPT_FILENAME']);
            $gmdate_modified = gmdate('D, d M Y H:i:s', $file_last_modified) . ' GMT';
        
            if ($if_modified_since == $gmdate_modified) {
                if (php_sapi_name() == 'cgi') {
                    header('Status: 304 Not Modified');
                } else {
                    header('HTTP/1.1 304 Not Modified');
                }
                exit();
            }
        
            header('Expires: ' . gmdate('D, d M Y H:i:s', time() + 86400) . ' GMT');
            header('Last-Modified: ' . $gmdate_modified);
            header('Cache-control: max-age=' . 86400);
        }
     }

    function swfaddress_base() {
        return substr($_SERVER['PHP_SELF'], 0, strrpos($_SERVER['PHP_SELF'], '/'));
    }
         
    function swfaddress_title($title) {
        if (!is_msie()) {
            $names = swfaddress_path_names();
            for ($i = 0; $i < count($names); $i++) {
                $title .= ' / ' . strtoupper(substr($names[$i], 0, 1)) . substr($names[$i], 1);
            }
        }
        echo($title);
    }
    
    function swfaddress_resource($resource) {
        echo(swfaddress_base() . $resource);
    }
    
    function swfaddress_link($link) {
        echo(swfaddress_base() . $link);
    }
    
    function swfaddress_content() {
        global $swfaddress_content;
        echo($swfaddress_content);
    }
    
    function swfaddress_path() {
        global $swfaddress_path;
        return $swfaddress_path;
    }
    
    function swfaddress_path_names() {
        global $swfaddress_path;
        $names = explode('/', $swfaddress_path);
        if (substr($swfaddress_path, 0, 1) == '/')
            array_splice($names, 0, 1);
        if (substr($swfaddress_path, count($swfaddress_path) - 1, 1) == '/')
            array_splice($names, count($names) - 1, 1);
        return $names;
    }

    function swfaddress_optimizer($resource) {
        global $swfaddress_value;
        $base = swfaddress_base();
        echo($base . $resource . (strstr($resource, '?') ? '&amp;' : '?') . 'swfaddress=' . urlencode($swfaddress_value) . '&amp;base=' . urlencode($base));        
    }
    
    swfaddress();
    
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <script type="text/javascript" src="<?php swfaddress_optimizer('/swfaddress/swfaddress-optimizer.js?flash=8'); ?>"></script>
        <title><?php swfaddress_title('SWFAddress Website'); ?></title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <style type="text/css">
        /*<![CDATA[*/
            html, body {
                height: 100%;
                overflow: hidden;
            }
            body {
                background: #CCCCCC;
                font: 86% Arial, "Helvetica Neue", sans-serif;
                margin: 0;                
            }
            #content {
                height: 100%;
            }
        /*]]>*/
        </style>
        <script type="text/javascript" src="<?php swfaddress_resource('/swfobject/swfobject.js'); ?>"></script>
        <script type="text/javascript" src="<?php swfaddress_resource('/swfaddress/swfaddress.js'); ?>"></script>
    </head>
    <body>
        <div id="content">
            <div>
                <h1><a href="<?php swfaddress_link('/'); ?>">SWFAddress Website</a></h1>
                <ul>
                    <li><a href="<?php swfaddress_link('/about/'); ?>">SWFAddress Website / About</a></li>
                    <li>
                        <a href="<?php swfaddress_link('/portfolio/'); ?>">SWFAddress Website / Portfolio</a>
                        <ul>
                            <li><a href="<?php swfaddress_link('/portfolio/1/?desc=true&amp;year=2001'); ?>">SWFAddress Website / Portfolio / 1</a></li>
                            <li><a href="<?php swfaddress_link('/portfolio/2/?desc=true'); ?>">SWFAddress Website / Portfolio / 2</a></li>
                            <li><a href="<?php swfaddress_link('/portfolio/3/?desc=false&amp;year=2001'); ?>">SWFAddress Website / Portfolio / 3</a></li>
                        </ul>
                    </li>
                    <li><a href="<?php swfaddress_link('/contact/'); ?>">SWFAddress Website / Contact</a></li>
                </ul>
            </div>
            <div><?php swfaddress_content(); ?></div>
        </div>
        <script type="text/javascript">
        // <![CDATA[
            (new SWFObject('<?php swfaddress_resource('/website.swf?datasource=datasource.php'); ?>', 'website', '100%', '100%', '8', '#CCCCCC', 'high')).write('content');
        // ]]>
        </script>
    </body>
</html>