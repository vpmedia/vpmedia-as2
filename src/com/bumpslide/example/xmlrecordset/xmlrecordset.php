<?php

	// This is a PHP script that returns a a fake bit of XML data
	// see flash actionscript:
	//
	//   put this file on a local test server, and then update the buildUrl method
	//   in the TestService.as class file
	// 

    $total  = 789;
    $start  = 1;
    $count  = 20; 
    
    if($_GET['count']) $count = $_GET['count'];
    if($_GET['start']) $start = $_GET['start'];
    
    $end    = min( $total, $start-1+$count);

    header("Content-type:text/xml");
    print '<?xml version="1.0"?>';
?>


<XmlRecordset total="<?php echo $total ?>" start="<?php echo $start ?>" end="<?php echo $end ?>">

<?php for($n=$start; $n<=$end; $n++) { ?>
    <item id="<?php echo $n ?>" something="goes here">
        <description><![CDATA[Description of Item <?php echo $n ?>]]></description>
        <details><![CDATA[Details go here.]]></details>
    </item>
<?php } ?>
</XmlRecordset>