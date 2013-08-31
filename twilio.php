<?php 
Header('Content-type: text/xml');
?>
<?xml version="1.0" encoding="UTF-8"?>
    <Say voice="alice">Alert!</Say>
    <Pause length="1"/>
    <Say voice="alice"><?php echo $_GET['subject']; ?></Say>
    <Hangup/>
</Response>
