<?php include_once('includes/swfaddress.php') ?>
<?php
    
    if ($swfaddress_value != '/') {
        swfaddress_content();
        exit();
    }
    
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
<?php include_once('includes/head.php') ?>
    </head>
    <body>
        <div id="container">
<?php include_once('includes/navigation.php') ?>
            <div id="content">
                <p>Quisque libero mauris, ornare in, faucibus ut, facilisis nec, quam. Mauris quis felis ac nisl laoreet adipiscing. Nunc libero. Vivamus nec libero. Fusce neque odio, interdum a, pharetra sit amet, mattis non, nisl. Donec quis metus et pede gravida pharetra. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Sed tincidunt ipsum ut mi. Sed tincidunt porta ipsum. Curabitur sem risus, egestas et, ultricies sed, sollicitudin a, nulla. Praesent eget lectus sed erat commodo ultrices. Donec purus enim, nonummy ut, iaculis sit amet, convallis a, est. Mauris consequat, elit et scelerisque posuere, dui est convallis quam, vitae dignissim tortor odio consectetuer leo. Donec turpis velit, varius id, tincidunt sed, sodales id, eros.</p>
            </div>
        </div>
<?php include_once('includes/swfin.php') ?>
    </body>
</html>