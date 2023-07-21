<?php

/*
header("Content-Type: text/html; charset=utf-8", true);
header('Cache-Control: no-store, no-cache, must-revalidate');
header('Cache-Control: pre-check=0, post-check=0, max-age=0');
header("Pragma: no-cache");
*/

/*

* filter_has_var
* filter_id
* filter_input_array
* filter_input
* filter_list
* filter_var_array
* filter_var
	
if (filter_has_var  ( INPUT_POST , ’submit’)) {
	$submit = filter_input(INPUT_POST, ’submit’, FILTER_SANITIZE_SPECIAL_CHARS);
}


var_dump(filter_var('roberto@example.com', FILTER_VALIDATE_EMAIL));

*/

	require("header.php");

	// Parameters
	$action = $_REQUEST['action'];

	switch($action) {
		case 'build':
			buildQuiz(); // 
			break;
		case 'login':
			doLogin(); // 
			break;
		case 'addperson':
			addPlayer(); // 
			break;
		case 'vote':
			computeVote(); // 
			break;
		case 'finish':
			finishQuiz(); // 
			break;
		default:
	}
	
function buildQuiz() {
// http://localhost/quiz/php/quiz.php?action=build&id_quiz=1

	include("config.php");
	
	// open connection to MySQL-server
	$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

	// select active database
	mysql_select_db($DBname, $DBconn);

	// Receive PersonID
	$id_quiz = $_REQUEST['id_quiz'];
	
	// create doctype
	$xml  = '<?xml version="1.0" encoding="iso-8859-1"?>';
	$xml .= '<quiz>';
	
	// get QUIZ
	$sql  = " SELECT ";
	$sql .= " id_quiz, ";
	$sql .= " description ";
	$sql .= " FROM "; 
	$sql .= "`".$DBPrefix."quiz` ";
	$sql .= " WHERE ";
	$sql .= " id_quiz = " . $id_quiz;
	$sql .= " ORDER BY RAND()";

	$result_quiz = mysql_query( $sql, $DBconn );
	$data = mysql_fetch_object( $result_quiz );
	
	// QUIZ - Title
	$xml .= '<title id="'.$data->id_quiz.'" value="'.$data->description.'" />';
	
	// Quiz - QUESTIONS
	$sql  = " SELECT ";
	$sql .= " id_question, ";
	$sql .= " id_quiz, ";
	$sql .= " question ";
	$sql .= " FROM "; 
	$sql .= "`".$DBPrefix."question` ";
	$sql .= " WHERE ";
	$sql .= " id_quiz = " . $id_quiz;
	$sql .= " ORDER BY RAND()";
	
	$result_question = mysql_query( $sql, $DBconn );
	
	while ( $data_ques = mysql_fetch_object( $result_question ) ) {
		$xml .= '<question id="'.$data_ques->id_question.'" value="'.$data_ques->question.'" kind="single" >';

		// QUIZ - Answers
		$sql  = " SELECT "; 
		$sql .= "  id_answer, ";
		$sql .= "  answer, ";
		$sql .= "  correct ";
		$sql .= " FROM ";
		$sql .= "`".$DBPrefix."answer` "; 
		$sql .= " WHERE "; 
		$sql .= "  id_question = ".$data_ques->id_question;
		$sql .= " ORDER BY RAND()";
		
		$result_answer = mysql_query( $sql, $DBconn );
		
		while ( $data_answ = mysql_fetch_object( $result_answer ) ) {
			$xml .= '<answer id="'.$data_answ->id_answer.'" value="'.$data_answ->answer.'" />';
		}
		
		$xml  .= "</question>";
	}
	
	$xml .= '</quiz>';

	echo $xml;
}	

function addPlayer() {
// http://localhost/quiz/getQuiz.php?action=addperson&name=a&email=a&phone=a&password=a

	include("config.php");
	
	// load variables from POST collection
	$name  = $_REQUEST['name'];
	$email = $_REQUEST['email'];
	$password = base64_encode ( $_REQUEST['password'] );
	$confirm  = base64_encode ( $_REQUEST['confirm'] );
	$phone = $_REQUEST['phone'];

	$isPassword = isNullOrEmpty($password);
	$isEmail 	= isNullOrEmpty($email);
	$isName		= isNullOrEmpty($name);
	$isPhone	= isNullOrEmpty($phone);
	
	if(($isPassword)||($isEmail)||($isName)||($isPhone)){
		echo xmlReturn("ERROR","Campos marcado com (*) são de preenchimento obrigatório.");
	}else if($password <> $confirm){
		echo xmlReturn("ERROR","Senha não confere. Por favor redigite.");
	}else{
		// open connection to MySQL-server
		$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

		// select active database
		mysql_select_db($DBname, $DBconn);

		// check if gallery exist
		// make SQL query
		$query = "INSERT INTO `".$DBPrefix."person` (`name`,`email`,`phone`,`password`) VALUES ('$name','$email','$phone','$password')";
		
		// use SQL query
		$result = mysql_query($query, $DBconn);

		// all done, no errors
		echo xmlReturn("OK","Cadastro realizado com sucesso.");	
	}
	
}

function doLogin(){
// http://localhost/quiz/php/quiz.php?action=login&email=&password=e

	include("config.php");

    // Verify if username and password are not empty
	$password   = $_REQUEST['password'];
	$email   	= $_REQUEST['email'];
	
	$isPassword = isNullOrEmpty($password);
	$isEmail 	= isNullOrEmpty($email);
	
	$password = base64_encode($password);
		
	if(($isEmail) || ($isPassword)){
		echo xmlReturn("ERROR","Campo(s) eMail e/ou Senha invalidos\n Sem conteudo.");
//	} else if (!checkEmail($email)) {
//		echo xmlReturn("ERROR","Email digitado incorretamente.");
	} else {
		$email 		= $email;
		$password 	= $password;
//		$id_quiz	= $_REQUEST['id_quiz'];

		// validate Login
		$sql  = "SELECT "; 
		$sql .= "  * ";
		$sql .= "FROM ";
		$sql .= "`".$DBPrefix."person` "; 
		$sql .= "WHERE "; 
		$sql .= "  email = '$email' ";
		$sql .= "AND ";
		$sql .= "  password = '$password'";
	
//		$sql = escape($sql,$email,base64_encode($password));
		
		// open connection to MySQL-server
		$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

		// select active database
		mysql_select_db($DBname, $DBconn);
		
		// use SQL query
		$result = mysql_query($sql, $DBconn);

		$xml  = '<?xml version="1.0" encoding="iso-8859-1"?>';
		$xml .= '<ids>';
		$xml .= '<ret>';

		// XML Returns
		if(mysql_affected_rows() == 1) {
			$data = mysql_fetch_array($result);
			
			$personID = $data['id_person'];
			$personNAME = $data['name'];
			
//			if($email == $data['email'] && base64_encode($password) == $data['password']) {
			
				// Look up for avaliable quiz and select ONE randomically to play
//				$sql = " SELECT q.id_quiz FROM wquiz_quiz q, wquiz_person p WHERE q.id_quiz NOT IN (SELECT pq.id_quiz FROM wquiz_person_quiz pq) AND p.id_person = $personID AND q.ativo = 1 ORDER BY RAND() LIMIT 1 ";
				$sql = " SELECT q.id_quiz FROM wquiz_quiz q, wquiz_person p WHERE q.id_quiz NOT IN (SELECT pq.id_quiz FROM wquiz_person_quiz pq WHERE pq.id_person = $personID) AND p.id_person = $personID AND q.ativo = 1 ORDER BY RAND() LIMIT 1 ";
				$res = mysql_query( $sql, $DBconn );
			
				// Verify if has do a quiz
//				$sql = "SELECT * FROM wquiz_person_quiz WHERE id_person = ".$data['id_person']." AND id_quiz = $id_quiz";
//				$res = mysql_query($sql, $DBconn);

				if(mysql_num_rows($res) == 1){
					$data = mysql_fetch_array($res);
					$xml .= "<status>OK</status>";
					$xml .= "<id>".$personID."</id>";
					$xml .= "<name>".$personNAME."</name>";
					$xml .= "<quizID>".$data['id_quiz']."</quizID>";
				} else{
					$xml .= "<status>ERROR</status>";
					$xml .= "<detail>Você já respondeu nosso quiz. Aguarde que em breve sairá o resultado.</detail>";
				}
//			} else {
//				$xml .= "<status>ERROR</status>";
//				$xml .= "<detail>Email ou Senha não conferem</detail>";
//			}
		} else {
			$xml .= "<status>ERROR</status>";
			$xml .= "<detail>Email ou Senha não conferem</detail>";
		}
		
		$xml .= '</ret>';
		$xml .= '</ids>';
		
		echo $xml;
	}
}

function computeVote() {
// http://localhost/quiz/php/quiz.php?action=vote&id_person=1&id_quiz=1&question=2&answer=1&time=2

	include("config.php");

	$id_person  = $_REQUEST['id_person'];
	$id_quiz = $_REQUEST['id_quiz'];
	$id_question = $_REQUEST['question'];
	$id_answer  = $_REQUEST['answer'];
	$laptime = $_REQUEST['time'];
	
//	$query = "INSERT INTO `".$DBPrefix."person_quiz` (`id_quiz`,`id_person`) VALUES ($id_quiz, $id_person)";

	$query = "INSERT INTO `".$DBPrefix."person_answers` (`id_question`,`id_answer`,`id_quiz`,`laptime`,`id_person`) VALUES ($id_question, $id_answer, $id_quiz, $laptime, $id_person)";

	// open connection to MySQL-server
	$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

	// select active database
	mysql_select_db($DBname, $DBconn);

	// use SQL query
	$result = mysql_query($query, $DBconn);
	
	echo xmlReturn("OK","Voto computado com sucesso.");
}

function finishQuiz() {
// http://localhost/quiz/php/quiz.php?action=finish&id_person=5&id_quiz=1

	include("config.php");

	$id_person  = $_REQUEST['id_person'];
	$id_quiz = $_REQUEST['id_quiz'];

	// open connection to MySQL-server
	$DBconn = mysql_connect($DBhost,$DBuser,$DBpass);

	// select active database
	mysql_select_db($DBname, $DBconn);

	// Compute Individual Points
	$sql = " SELECT COUNT(*) AS points FROM wquiz_answer WHERE id_answer IN (SELECT id_answer FROM wquiz_person_answers WHERE id_quiz = $id_quiz AND id_person = $id_person) AND correct = 1 ";
	$res = mysql_query($sql, $DBconn);
	$data = mysql_fetch_array($res);
	
	// Compute total time
	$sql = " SELECT SUM(laptime) AS total FROM  wquiz_person_answers WHERE id_quiz = $id_quiz AND id_person = $id_person ";	
	$res = mysql_query($sql, $DBconn);
	$datatime = mysql_fetch_array($res);
	
	$query = "INSERT INTO `".$DBPrefix."person_quiz` (`id_quiz`,`id_person`,`date`,`points`,`totaltime`) VALUES ($id_quiz, $id_person,'".date('Y-m-d H:i:i',time())."',".$data['points'].",".$datatime['total']." )";
	$res = mysql_query($query, $DBconn);

	echo xmlReturn("OK","Voto computado com sucesso.");
}

function isNullOrEmpty($condition){
	$bRet = false;
	if (empty($condition) || is_null($condition)) {
		$bRet = true;
	}		
	return $bRet;
}

function xmlReturn($type, $detail) {

	// XML Returns
	$xml  = '<?xml version="1.0" encoding="iso-8859-1"?>';
	$xml .= '<ids>';
	$xml .= '<ret>';
	$xml .= "<status>$type</status>";
	$xml .= "<detail>$detail</detail>";
	$xml .= '</ret>';
	$xml .= '</ids>';
	
	return $xml;
}

function escape($sql) {
	$args = func_get_args();
	foreach($args as $key => $val) {
		$args[$key] = mysql_real_escape_string($val);
	}
	$args[0] = $sql;
	
	return call_user_func_array('sprintf', $args);
} 	

function checkEmail($eMailAddress) {
	if (eregi("^[0-9a-z]([-_.]?[0-9a-z])*@[0-9a-z]([-.]? [0-9a-z])*\\.[a-z]{2,3}$", $eMailAddress, $check)) {
		return true;
    }
		return false;
}
		
?>