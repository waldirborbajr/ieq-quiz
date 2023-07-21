<?php

	$handle = fopen ("log.txt", "w+");

	$xml = new DOMDocument();
	$xml->$xml->XML("quiz.xml");
	fwrite($handle, $_REQUEST['compute']);
	$useranswers = $xml->getElementsByTagName( "userchoice" );
	foreach( $useranswers as $content ) {
		$question = $content->getAttribute ( "question" );
		$answer = $content->getAttribute ( "answer" );
		$time = $content->getAttribute ( "time" );
		
		$wrt = "$question - $answer - $time\n";
		fwrite($handle, $wrt);
		fwrite($handle, $wrt);
		
	}
	
//	fwrite($handle, $_SERVER['QUERY_STRING']);		
	fclose($handle);

?>