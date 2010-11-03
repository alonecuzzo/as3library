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
        echo(swfaddress_base() . $link . '" onclick="SWFAddress.setValue(this.rel); this.blur(); return false;"  rel="' . $link);
    }
    
    function swfaddress_social($link) {
        global $swfaddress_value;
        $names = swfaddress_path_names();
        $title = '';
        for ($i = 0; $i < count($names); $i++) {
            $title .= ' / ' . strtoupper(substr($names[$i], 0, 1)) . substr($names[$i], 1);
        }
        $link = str_replace('$url', strtolower(array_shift(explode('/', $_SERVER['SERVER_PROTOCOL']))) . '://' . $_SERVER['SERVER_NAME'] . swfaddress_base() . $swfaddress_value, $link);
        $link = str_replace('$title', $title, $link);
        $link = str_replace(' ', '%20', $link);
        echo($link . '" onclick="SWFAddress.href(this.href); this.blur(); return false;');
    }
    
    function swfaddress_content() {
        global $swfaddress_content;
        echo($swfaddress_content);
    }

    function swfaddress_optimizer($resource) {
        global $swfaddress_value;
        $base = swfaddress_base();
        echo($base . $resource . (strstr($resource, '?') ? '&amp;' : '?') . 'swfaddress=' . urlencode($swfaddress_value) . '&amp;base=' . urlencode($base));        
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
    
     swfaddress();
     
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <script type="text/javascript" src="<?php swfaddress_optimizer('/swfaddress/swfaddress-optimizer.js'); ?>"></script>
        <title><?php swfaddress_title('SWFAddress Website'); ?></title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <link type="text/css" rel="stylesheet" href="<?php swfaddress_resource('/styles.css'); ?>" media="screen" />        
        <script type="text/javascript" src="<?php swfaddress_resource('/swfaddress/swfaddress.js'); ?>"></script>
        <script type="text/javascript" src="<?php swfaddress_resource('/scripts.js'); ?>"></script>
    </head>
    <body>
        <div class="container">
            <h1><a href="<?php swfaddress_link('/'); ?>">SWFAddress Website</a></h1>
            <ul class="navigation">
                <li><a href="<?php swfaddress_link('/history/'); ?>">History</a></li>
                <li><a href="<?php swfaddress_link('/technologies/?param1=value1'); ?>">Technologies</a></li>
                <li><a href="<?php swfaddress_link('/justification/?param1=value1&amp;param2=value2'); ?>">Justification</a></li>
            </ul>
            <div id="content" class="content">
                <noscript><?php swfaddress_content(); ?></noscript>
            </div>
            <div class="links">
                <ul id="social">
                    <li>
                        <a href="<?php swfaddress_social('http://digg.com/submit?phase=2&amp;url=$url&amp;title=SWFAddress Website$title&amp;bodytext=SWFAddress sample that demonstrates search engine indexing for Ajax websites&amp;topic=software'); ?>">
                            <img src="<?php swfaddress_resource('/images/digg.png'); ?>" alt="Digg" width="16" height="16" />
                        </a>
                    </li>
                    <li>
                        <a href="<?php swfaddress_social('http://www.stumbleupon.com/submit?url=$url&amp;title=SWFAddress Website$title'); ?>">
                            <img src="<?php swfaddress_resource('/images/stumbleit.png'); ?>" alt="Stumble Upon" width="16" height="16" />
                        </a>
                    </li>
                    <li>
                        <a href="<?php swfaddress_social('http://del.icio.us/post?url=$url&amp;title=SWFAddress Website$title&amp;notes=SWFAddress sample that demonstrates search engine indexing for Ajax websites&amp;tags=swfaddress'); ?>">
                            <img src="<?php swfaddress_resource('/images/delicious.png'); ?>" alt="Delicious" width="16" height="16" />
                        </a>
                    </li>
                    <li>
                        <a href="<?php swfaddress_social('http://www.google.com/bookmarks/mark?op=add&amp;bkmk=$url&amp;title=SWFAddress Website$title'); ?>">
                            <img src="<?php swfaddress_resource('/images/google.png'); ?>" alt="Google" width="16" height="16" />
                        </a>
                    </li>
                    <li>
                        <a href="<?php swfaddress_social('http://myweb2.search.yahoo.com/myresults/bookmarklet?u=$url&amp;t=SWFAddress Website$title&amp;d=SWFAddress sample that demonstrates search engine indexing for Ajax websites&amp;tag=swfaddress'); ?>">
                            <img src="<?php swfaddress_resource('/images/yahoo.png'); ?>" alt="Yahoo" width="16" height="16" />
                        </a>
                    </li>
                </ul>
                <p>
                    <a href="#" onclick="copyLink(); return false;">Copy link to clipboard</a>
                </p>
            </div>
        </div>
    </body>
</html>