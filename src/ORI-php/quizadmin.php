<?php
/*
-- Individual Points
SELECT COUNT(*) AS points
FROM wquiz_answer 
WHERE id_answer IN (SELECT id_answer
	FROM wquiz_person_answers
	WHERE id_quiz = 1
	AND id_person = 5)
AND correct = 1

*/

require("header.php");

// Parameters
$action = $_REQUEST['action'];

switch($action) {
	case 'savenew':
		savenew(); // 
		break;
	case 'updateRule':
		updateRule(); // 
		break;
	case 'rules':
		rules(); // 
		break;
	case 'rank':
		rank(); // 
		break;
	case 'players':
		players(); // 
		break;
	case 'quiz':
		quiz(); // 
		break;
	case 'question':
		question(); // 
		break;
	case 'answer':
		answer(); // 
		break;
	case 'save':
		saveChange(); // 
		break;
	case 'finish':
		finishQuiz(); // 
		break;
	default:
}

function savenew() {
// http://localhost/quiz/php/quizadmin.php?action=savenew&control=answer&content=my_quiz_is_beautiful&questionID=4

	include("config.php");
	
	// load variables from POST collection
	$control  = $_REQUEST['control'];
	
	// open connection to MySQL-server
	$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

	// select active database
	mysql_select_db($DBname, $DBconn);

	if ($control == 'quiz') {
		$content = $_REQUEST['content'];
		$query = "INSERT INTO `".$DBPrefix."quiz` (`description`) VALUES ('$content')";
	}else if ($control == 'question') {
		$quizID = $_REQUEST['quizID'];
		$content = $_REQUEST['content'];
		$query = "INSERT INTO `".$DBPrefix."question` (`id_quiz`,`question`) VALUES ($quizID,'$content')";
	}else if ($control == 'answer') {
		$questionID = $_REQUEST['questionID'];
		$content = $_REQUEST['content'];
		$query = "INSERT INTO `".$DBPrefix."answer` (`id_question`,`answer`) VALUES ($questionID,'$content')";
	}

	// use SQL query
	$result = mysql_query($query, $DBconn);

	echo "";
}

function updateRule() {
// http://localhost/quiz/php/quizadmin.php?action=save&ID=1&option=quiz&ativo=0&content=QUIZZZZZZZZZ

	include("config.php");
	
	// open connection to MySQL-server
	$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

	// select active database
	mysql_select_db($DBname, $DBconn);

	$id 	= $_REQUEST['id'];
	$rule 	= $_REQUEST['rule'];

	// create doctype
	$xml  = '<?xml version="1.0" encoding="iso-8859-1"?>';
	$xml .= '<status>';
	
	// get QUIZ
	$sql  = " UPDATE wquiz_rules SET rule_description='$rule' WHERE id_rule = $id";

	$result_quiz = mysql_query( $sql, $DBconn );
	
	$xml .= '</status>';

	echo $xml;
}

function rules() {
// http://localhost/quiz/php/quizadmin.php?action=rules

	include("config.php");
	
	// open connection to MySQL-server
	$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

	// select active database
	mysql_select_db($DBname, $DBconn);

	// create doctype
	$xml  = '<?xml version="1.0" encoding="iso-8859-1"?>';
	$xml .= '<rules>';
	
	// get Rules
	$sql  = " SELECT * FROM wquiz_rules ";
	
	$result_quiz = mysql_query( $sql, $DBconn );
	
	// Rules
	while ( $data = mysql_fetch_object( $result_quiz ) ) {
		$xml .= '<rule>';
			$xml .= '<description>'.$data->rule_description.'</description>';
			$xml .= '<id>'.$data->id_rule.'</id>';
		$xml .= '</rule>';
	}
	
	$xml .= '</rules>';

	echo $xml;
}
	
function rank() {
// http://localhost/quiz/php/quizadmin.php?action=rank&id_quiz=1

	include("config.php");
	
	// open connection to MySQL-server
	$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

	// select active database
	mysql_select_db($DBname, $DBconn);

	$id_quiz = $_REQUEST['id_quiz'];

	// create doctype
	$xml  = '<?xml version="1.0" encoding="iso-8859-1"?>';
	$xml .= '<ranking>';
	
	// get Players
	$sql  = " SELECT p.name, pq.points, pq.totaltime FROM wquiz_person_quiz pq, wquiz_person p WHERE p.id_person = pq.id_person AND pq.id_quiz = $id_quiz ORDER BY points DESC, totaltime ";
	
	$result_quiz = mysql_query( $sql, $DBconn );
	
	// Players
	while ( $data = mysql_fetch_object( $result_quiz ) ) {
		$xml .= '<rank>';
			$xml .= '<name>'.$data->name.'</name>';
			$xml .= '<points>'.$data->points.'</points>';
			$xml .= '<totaltime>'.$data->totaltime.'</totaltime>';
		$xml .= '</rank>';
	}
	
	$xml .= '</ranking>';

	echo $xml;
}	

function players() {
// http://localhost/quiz/php/quizadmin.php?action=players

	include("config.php");
	
	// open connection to MySQL-server
	$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

	// select active database
	mysql_select_db($DBname, $DBconn);

//	$id_quiz = $_REQUEST['id_quiz'];

	// create doctype
	$xml  = '<?xml version="1.0" encoding="iso-8859-1"?>';
	$xml .= '<players>';
	
	// get Players
	$sql  = " SELECT * FROM wquiz_person ORDER BY name DESC ";

	$result_quiz = mysql_query( $sql, $DBconn );
	
	// Players
	while ( $data = mysql_fetch_object( $result_quiz ) ) {
		$xml .= '<player>';
			$xml .= '<id>'.$data->id_person.'</id>';
			$xml .= '<description>'.$data->name.'</description>';
			$xml .= '<phone>'.$data->phone.'</phone>';
			$xml .= '<mail>'.$data->email.'</mail>';
		$xml .= '</player>';
	}
	
	$xml .= '</players>';

	echo $xml;
}	

function quiz() {
// http://localhost/quiz/php/quizadmin.php?action=quiz

	include("config.php");
	
	// open connection to MySQL-server
	$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

	// select active database
	mysql_select_db($DBname, $DBconn);

	$id_quiz = $_REQUEST['id_quiz'];

	// create doctype
	$xml  = '<?xml version="1.0" encoding="iso-8859-1"?>';
	$xml .= '<quizes>';
	
	// get QUIZ
	$sql  = " SELECT * FROM wquiz_quiz ORDER BY ativo DESC ";

	$result_quiz = mysql_query( $sql, $DBconn );
	
	// QUIZ
	while ( $data = mysql_fetch_object( $result_quiz ) ) {
		$xml .= '<quiz>';
			$xml .= '<id>'.$data->id_quiz.'</id>';
			$xml .= '<description>'.$data->description.'</description>';
			$xml .= '<ativo>'.$data->ativo.'</ativo>';
		$xml .= '</quiz>';
	}
	
	$xml .= '</quizes>';

	echo $xml;
}	

function question() {
// http://localhost/quiz/php/quizadmin.php?action=question&quizid=1

	include("config.php");
	
	// open connection to MySQL-server
	$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

	// select active database
	mysql_select_db($DBname, $DBconn);

	$quizid = $_REQUEST['quizid'];

	// create doctype
	$xml  = '<?xml version="1.0" encoding="iso-8859-1"?>';
	$xml .= '<questions>';
	
	// get QUIZ
	$sql  = " SELECT * FROM wquiz_question WHERE id_quiz = $quizid";

	$result_quiz = mysql_query( $sql, $DBconn );
	
	// QUIZ
	while ( $data = mysql_fetch_object( $result_quiz ) ) {
		$xml .= '<question>';
			$xml .= '<id>'.$data->id_question.'</id>';
			$xml .= '<description>'.$data->question.'</description>';
		$xml .= '</question>';
	}
	
	$xml .= '</questions>';

	echo $xml;
}	

function answer() {
// http://localhost/quiz/php/quizadmin.php?action=answer&questionID=1

	include("config.php");
	
	// open connection to MySQL-server
	$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

	// select active database
	mysql_select_db($DBname, $DBconn);

	$questionID = $_REQUEST['questionID'];

	// create doctype
	$xml  = '<?xml version="1.0" encoding="iso-8859-1"?>';
	$xml .= '<answers>';
	
	// get QUIZ
	$sql  = " SELECT * FROM wquiz_answer WHERE id_question = $questionID";

	$result_quiz = mysql_query( $sql, $DBconn );
	
	// QUIZ
	while ( $data = mysql_fetch_object( $result_quiz ) ) {
		$xml .= '<answer>';
			$xml .= '<id>'.$data->id_answer.'</id>';
			$xml .= '<description>'.$data->answer.'</description>';
			$xml .= '<correct>'.$data->correct.'</correct>';
		$xml .= '</answer>';
	}
	
	$xml .= '</answers>';

	echo $xml;
}	

function saveChange() {
// http://localhost/quiz/php/quizadmin.php?action=save&ID=1&option=quiz&ativo=0&content=QUIZZZZZZZZZ

	include("config.php");
	
	// open connection to MySQL-server
	$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

	// select active database
	mysql_select_db($DBname, $DBconn);

	$ID 	= $_REQUEST['ID'];
	$option = $_REQUEST['option'];
	$ativo	= $_REQUEST['ativo'];
	$content	= $_REQUEST['content'];

	// create doctype
	$xml  = '<?xml version="1.0" encoding="iso-8859-1"?>';
	$xml .= '<status>';
	
	// get QUIZ
	if ($option == 'quiz') {
		$sql  = " UPDATE wquiz_quiz SET description = '$content', ativo='$ativo' WHERE id_quiz = $ID";
	} else if ($option == 'question') {
		$sql  = " UPDATE wquiz_question SET question = '$content' WHERE id_question = $ID";
	} else if ($option == 'answer') {
		$sql  = " UPDATE wquiz_answer SET answer = '$content', correct='$ativo' WHERE id_answer = $ID";
	}

	$result_quiz = mysql_query( $sql, $DBconn );
	
	$xml .= '</status>';

	echo $xml;
}

?>