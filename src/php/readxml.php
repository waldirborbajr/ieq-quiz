<?php

// create doctype
$domXML = new DOMDocument('1.0', 'iso-8859-1');

// display document in browser as plain text
// for readability purposes
header("Content-Type: text/plain");

// save and display tree
echo $domXML->saveXML();

/* COMPLETO

// create doctype
$dom = new DOMDocument("1.0");

// create root element
$root = $dom->createElement("toppings");
$dom->appendChild($root);
$dom->formatOutput=true;

// create child element
$item = $dom->createElement("item");
$root->appendChild($item);

// create text node
$text = $dom->createTextNode("pepperoni");
$item->appendChild($text);

// create attribute node
$price = $dom->createAttribute("price");
$item->appendChild($price);

// create attribute value node
$priceValue = $dom->createTextNode("4");
$price->appendChild($priceValue);

// create CDATA section
$cdata = $dom->createCDATASection("\nCustomer requests that pizza be sliced into 16 square pieces\n");
$root->appendChild($cdata);

// create PI
$pi = $dom->createProcessingInstruction("pizza", "bake()");
$root->appendChild($pi);

// save tree to file
$dom->save("order.xml");

// save tree to string
$order = $dom->save("order.xml");

*/


/*
$xmlDoc = new DOMDocument;
$xmlDoc->load("quiz.xml");

print $xmlDoc->saveXML();
*/

/*
<?php
	session_start();

	$_SESSION['arrConfig'];

	$docConfigXML = new DOMDocument;
	$docConfigXML->preserveWhiteSpace = FALSE;
	$docConfigXML->load( 'resources/xml/config.xml' );

	$_SESSION['arrConfig']['fax'] = trim($docConfigXML->getElementsByTagName("fax")->item(0)->getAttribute('value'));
	$_SESSION['arrConfig']['phone'] = trim($docConfigXML->getElementsByTagName("phone")->item(0)->nodeValue);

	echo $_SESSION['arrConfig']['fax'];
	echo "<br />";
	echo $_SESSION['arrConfig']['phone'];

	$strConfigXML = "";

	$fax = "702-555-1faxxx";
	$phone = '702-555-phone';

	$strConfigXML =
	<<<END
	<?xml version="1.0" encoding="utf-8"?>
	<config>
	<fax value='$fax' />
	<phone>
	$phone
	</phone>
	</config>
	END;
	$file = "resources/xml/config.xml";
	writeFile($file,$strConfigXML);

	function writeFile($file,$strFileContent)
	{
	$fh = fopen($file, 'w' ) or die ("can't create file");
	fwrite($fh, $strFileContent);
	fclose($fh);
	}
?>


*/


/*
$xmlDoc = new DOMDocument('1.0', 'utf-8');
$xmlDoc->formatOutput = true;

$noticias = $xmlDoc->createElement('noticias');
$noticias = $xmlDoc->appendChild($noticias);

$item = $xmlDoc->createElement('item');
$item->setAttribute('id','162696');
$item = $noticias->appendChild($item);
$title = $xmlDoc->createElement('title',utf8_encode('Doença já matou 33 pessoas no Maranhão'));
$title = $item->appendChild($title);
$link = $xmlDoc->createElement('link',htmlentities('index.php?idpaginas=20&idmaterias=162696'));
$link = $item->appendChild($link);

header("Content-type:application/xml; charset=utf-8");
echo $xmlDoc->saveXML();

*/

  
/*
class QUIZ
{
  public $name;
  public $phone;
  public $address;
  public $notes;
}

$contacts = array();

$xml = new XMLReader();
$xml->XML(stripslashes($_GET["quiz"]));
$xml->setParserProperty(XMLReader::VALIDATE, false);
$xml->setParserProperty(XMLReader::LOADDTD, false);

while($xml->read())
{
  if($xml->nodeType == XMLReader::ELEMENT)
  {
    switch($xml->name)
    {
      case("quiz"):
        $quiz = new QUIZ();
        $quiz->name = $xml->getAttribute("name");
        $quiz->phone = $xml->getAttribute("phone");
        
        $xml->read(); // read start of address
        $xml->read(); // read text of address
        $quiz->address = $xml->value;
        $xml->read(); // read end of address
        
        $xml->read(); // read start of notes
        $xml->read(); // read text of address
        $quiz->notes = $xml->value;
        array_push($contacts, $quiz);
        break;
    }
  }
}

foreach($contacts as $c)
{
  print_r($c);
}
*/
?>