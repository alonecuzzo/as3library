<?php include_once('includes/swfaddress.php') ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
<?php include_once('includes/head.php') ?>
    </head>
    <body>
        <div id="container">
<?php include_once('includes/navigation.php') ?>
            <div id="content">
<?php
    $base = strtolower(substr($_SERVER['SERVER_PROTOCOL'], 0, strrpos($_SERVER['SERVER_PROTOCOL'], '/'))) . '://' . $_SERVER['SERVER_NAME'] . substr($_SERVER['PHP_SELF'], 0, strrpos($_SERVER['PHP_SELF'], '/'));
    switch($_GET['id']) {
        case '1':
?>
                <p><img src="<?php echo($base) ?>/images/1.png" alt="Portfolio 1" width="400" height="300" /><br />Atlantic Hit Mix Calendar<br />2001<br /><br /><a href="http://www.sergeevstudio.com">Photos by Lyubomir Sergeev</a></p>
<?php
            break;
        case '2':
?>
                <p><img src="<?php echo($base) ?>/images/2.png" alt="Portfolio 2" width="400" height="300" /><br />Atlantic Hit Mix Calendar<br />2001<br /><br /><a href="http://www.sergeevstudio.com">Photos by Lyubomir Sergeev</a></p>
<?php
            break;
        case '3':
?>
                <p><img src="<?php echo($base) ?>/images/3.png" alt="Portfolio 3" width="400" height="300" /><br />Atlantic Hit Mix Calendar<br />2001<br /><br /><a href="http://www.sergeevstudio.com">Photos by Lyubomir Sergeev</a></p>
<?php
            break;
        default:
?>
                <p>Fusce at ipsum vel diam ullamcorper convallis. Morbi aliquet cursus lacus. Nunc nisi ligula, accumsan sit amet, condimentum nec, ullamcorper a, lectus. Vestibulum ut lectus. Ut rutrum mi nec lectus. Morbi quis nibh. Pellentesque congue, lorem quis porta tincidunt, tellus tortor venenatis leo, vel porttitor massa massa nec dui. In interdum euismod magna. In hac habitasse platea dictumst. Donec erat. Donec nunc ipsum, lobortis ac, feugiat sit amet, vehicula et, tellus. Donec in lacus ac metus condimentum gravida. Duis vehicula. In a neque in purus hendrerit molestie. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.</p>
<?php            
            break;
    }
?>
            </div>
        </div>
<?php include_once('includes/swfin.php') ?>
    </body>
</html>