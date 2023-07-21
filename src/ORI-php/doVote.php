<?php
	$IP = $_SERVER[REMOTE_ADDR];
	//Pega o IP da mбquina cliente para que o mesmo nгo possa votar novamente num perнodo de 2 dias

	$votou = $_GET[votou];
	//pega o id da resposta que vem do Flex

	if ($votou!=”") //Se a variбvel $votou nгo for nula, atualiza o voto.
	{
		$atualizaVoto = "UPDATE respostas SET voto=voto+1 WHERE unico=$votou";
		$result = mysql_query($atualizaVoto);
		setcookie("IP", "$IP", time()+172800); //Fixa a expiraзгo do cookie em 48 horas
	}

	mysql_free_result( $result );


?>