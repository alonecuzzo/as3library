<?php

    session_start();
    header('Content-Type: text/xml;charset=utf-8');
    
    $base = substr($_SERVER['PHP_SELF'], 0, strrpos($_SERVER['PHP_SELF'], '/'));
    $file = 'datasource/' . (($_GET['swfaddress'] == '/') ? 'home' : preg_replace('/\//', '', $_GET['swfaddress']));
    $handle = fopen($file . '.xml', 'r');
    if ($handle != false) {
        $content = fread($handle, filesize($file . '.xml'));
        $content = preg_replace('/^<\?xml version="1.0" encoding="utf-8"\?>/', '', $content);
        $content = preg_replace('/(\n|\r\n|\t)*/', '', $content);
        fclose($handle);
    } elseif(file_exists($file . '.php')) {
        include($file . '.php');
        $content = '';
    } else {
        $content = '<p><!-- Status(404 Not Found) -->Page not found.</p>';
    }
    echo($content);
    
?>