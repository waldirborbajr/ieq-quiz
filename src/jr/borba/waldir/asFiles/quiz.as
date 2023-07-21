/**
 * @author Waldir Borba Junior
 * @version 0.1
 * 
 * This action script file provides a place to define some logic of quiz. 
 * 
 * Use, spread, modify, improve.
 * ATBSiS (2008)
 * http://wborbajr.wordpress.com
 * wborbajr@gmail.com
 * 
 * ATBSiS - Information System
 */

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.effects.Effect;
import mx.effects.Glow;
import mx.events.ItemClickEvent;
import mx.rpc.AsyncResponder;
import mx.rpc.AsyncToken;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

[Bindable] private var xmlResult:XML;
[Bindable] private var name_person:String;
[Bindable] private var num_questions:int;
[Bindable] private var quiz_title:String;

[Bindable] private var answer:Array;			 
[Bindable] private var indx:int = 0;
[Bindable] private var xmlReturn:ArrayCollection;
[Bindable] private var timer:Timer;
[Bindable] private var iTimer:int;

[Bindable] private var xmlGame:XML;

[Bindable] private var id_person:String;
[Bindable] private var id_quiz:int;

[Bindable] private var hts:HTTPService;

/**
 * 
 * 
 * @method onInit() 
 * @comment Initialiate some variables 
 * 
 */
private function onInit():void{
//	id_quiz = 1;
	xmlGame = new XML("<palyerinfo></palyerinfo>");
}
			
/**
 * 
 * 
 * @method addPerson() 
 * @comment Insert new player to database 
 * 
 */
private function addPerson() : void {
	var objDTO:Object = new Object();
	objDTO.action="addperson";
	objDTO.name=txName.text;
	objDTO.email=txEmail.text;
	objDTO.phone=txPhone.text;
	objDTO.password=txPassword.text;
	objDTO.confirm=txConfirm.text;		

	hts = new HTTPService();
	hts.url = "php/quiz.php";
	hts.method="POST";

	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder = 
		new AsyncResponder(onAddResult, onAddFault, token);
	token.addResponder(responder);
}
private function onAddResult(event:ResultEvent, token:Object=null):void {
	xmlReturn = new ArrayCollection([event.result.ids.ret]);
	
	if (xmlReturn[0].status == "OK") {
		lblResult.text = xmlReturn[0].detail;
		btAdd.visible = false;
		btBack.visible = true;
	} else if (xmlReturn[0].status == "ERROR") {
		Alert.show(xmlReturn[0].detail);
	}
}
private function onAddFault(event:FaultEvent, token:Object=null):void {
	cursorManager.removeBusyCursor();
	
	var errors:String = "Some errors occurred \n";
	errors += "\n Fault Code is : \n" + event.fault.faultCode;
	errors += "\n Fault Detail is : \n" + event.fault.faultDetail;
	errors += "\n Fault String is : \n" + event.fault.faultString;
	Alert.show(errors);
}

/**
 * 
 * 
 * @method buildQuiz() 
 * @comment Build quiz array 
 * 
 */
private function buildQuiz() : void {
	var objDTO:Object = new Object();
	objDTO.action="build";
	objDTO.id_quiz=id_quiz;		
	
	hts = new HTTPService();
	hts.url = "php/quiz.php";
	hts.method = "POST";
	hts.resultFormat="e4x";
	
	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder = 
		new AsyncResponder(onBuildResult, onBuildFault, token);
	token.addResponder(responder);
	
}
private function onBuildResult(event:ResultEvent, token:AsyncToken):void {
   	xmlResult = (XML)(event.result);
	
	num_questions = xmlResult.child("question").length();
	
	/* change to quiz state */
	currentState='doQuiz';

	lbQuiz.text = xmlResult.title.@value;
	
	/* Welcome Screen */
	showWelcome(name_person, num_questions.toString());
 }
private function onBuildFault(event:FaultEvent, token:AsyncToken):void {
	cursorManager.removeBusyCursor();
	
	var errors:String = "Some errors occurred \n";
	errors += "\n Fault Code is : \n" + event.fault.faultCode;
	errors += "\n Fault Detail is : \n" + event.fault.faultDetail;
	errors += "\n Fault String is : \n" + event.fault.faultString;
	Alert.show(errors);
}
private function showWelcome(personName:String, numQuestions:String):void{
	
//	personalAlert.msg.htmlText =  
//		"Olá <b>"+personName+"</b>, seja bem-vindo ao Quiz Evangélico.\n"+
//		"Você irá responder <b>"+numQuestions+"</b> questões, que irão testar seus conhecimentos sobre a Bíblia Sagrada.\n"+
//		"Procure responder no menor tempo possível, e concorra a vários brindes.\n"+
//		"A equipe 4IEQ lhe deseja boa sorte!\n\n"+
//		"Quanto estiver pronto clique no botão Iniciar.";
//	personalAlert.visible = true;
}

/**
 * 
 * 
 * @method showQuiz()
 * @comment Display quiz at screen 
 * 
 */
private function showQuiz():void{
	if (indx == 0) {
		btNext.visible = true;
		btBegin.visible = false;

        // Store PlayerID and QuizID
        xmlGame.@quiz   = id_quiz;
        xmlGame.@player = id_person;
	}
	
   	idquizForm.enabled = true;
	
	// disable next button
	var isLast:int = indx + 1;
	if ( isLast == num_questions ) {
		btNext.visible = false;
	}
	
//	lbQuiz.text = lbQuiz.text + " = " + num_questions;
	lbQuiz.visible = true;
	
	// Show Question
	sQuestion.text = xmlResult.question[indx].@value;
	
	// Show Answers
	rp.dataProvider = xmlResult.question[indx].answer;
	
	timerStar();
	
	displayInfo();
}
	
/**
 * 
 * 
 * @method timerStar
 * @comment Initialize time control 
 * 
 */
private function timerStar():void{
	timer = new Timer(1000,0);
	timer.addEventListener(TimerEvent.TIMER,
    	function onTimerEvent(e:TimerEvent):void{
    		iTimer++;
    		
    		displayInfo();
    	}
	);
	timer.start();
}

/**
 * 
 * 
 * @method rgClick
 * @comment Radiobutton answer click control 
 * 
 */
private function rgClick(evtObj:ItemClickEvent):void {
//	Alert.show( evtObj.item + " " + evtObj.label );

	idquizForm.enabled = false;
	
	var idquestion:String = xmlResult.question[indx].@id;

	// 
	var objDTO:Object = new Object();
	objDTO.action="vote";
	objDTO.id_person=id_person;
	objDTO.id_quiz=id_quiz;
	objDTO.question=idquestion;
	objDTO.answer=evtObj.item.toString();
	objDTO.time=iTimer;

	hts = new HTTPService();
	hts.url = "php/quiz.php";
	hts.method = "POST";
	cursorManager.setBusyCursor();

	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder =
		new AsyncResponder(onVoteResult, onVoteFault, token);
	token.addResponder(responder);
	
//    //Adding child node using .appendChild
//    var choice:XML   = <userchoice></userchoice>;
//    choice.@question = idquestion;
//    choice.@answer   = evtObj.item.toString();
//    choice.@time     = iTimer;
//    xmlGame = xmlGame.appendChild(choice);

//    arrayGame.addItem({question:idquestion, choice:evtObj.item.toString(), time:iTimer });

    timer.stop();
    iTimer = 0;
				
	var isLast:int = indx + 1;
	if ( isLast == num_questions ) {
        Alert.show("Parabéns, você conclui o quiz.\n"+
            "Vamos torcer para que você seja o ganhador");
        finishQuiz();
////        currentState = "";
	}

	// Add 1 to questions counter
	indx++;

}
private function onVoteResult(event:ResultEvent, token:Object=null):void {
	cursorManager.removeBusyCursor();

	xmlReturn = new ArrayCollection([event.result.ids.ret]);

	if (xmlReturn[0].status == "OK") {
	} else if (xmlReturn[0].status == "ERROR") {
	}
}
private function onVoteFault(event:FaultEvent, token:Object=null):void {
	cursorManager.removeBusyCursor();
	
	var errors:String = "Some errors occurred \n";
	errors += "\n Fault Code is : \n" + event.fault.faultCode;
	errors += "\n Fault Detail is : \n" + event.fault.faultDetail;
	errors += "\n Fault String is : \n" + event.fault.faultString;
	Alert.show(errors);
}

/**
 * 
 * 
 * @method finishQuiz()
 * @comment Finish quiz sending data to server 
 * 
 */
private function finishQuiz():void{
	// 
	var objDTO:Object = new Object();
	objDTO.action="finish";
	objDTO.id_person=id_person;
	objDTO.id_quiz=id_quiz;

	hts = new HTTPService();
	hts.url = "php/quiz.php";
	hts.method = "POST";
	cursorManager.setBusyCursor();

	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder =
		new AsyncResponder(onFinishResult, onFinishFault, token);
	token.addResponder(responder);
}	        
private function onFinishResult(event:ResultEvent, token:Object=null):void {
	cursorManager.removeBusyCursor();

	xmlReturn = new ArrayCollection([event.result.ids.ret]);

	if (xmlReturn[0].status == "OK") {
	} else if (xmlReturn[0].status == "ERROR") {
	}
}
private function onFinishFault(event:FaultEvent, token:Object=null):void {
	cursorManager.removeBusyCursor();
	
	var errors:String = "Some errors occurred \n";
	errors += "\n Fault Code is : \n" + event.fault.faultCode;
	errors += "\n Fault Detail is : \n" + event.fault.faultDetail;
	errors += "\n Fault String is : \n" + event.fault.faultString;
	Alert.show(errors);
}
/**
 * 
 * 
 * @method sendLogin()
 * @comment Validade User to play quiz 
 * 
 */
private function sendLogin():void{
	var objDTO:Object = new Object();
	objDTO.action="login";
	objDTO.email=tiEmail.text;
	objDTO.password=tiPassword.text;
//	objDTO.id_quiz=id_quiz;		
	
	hts = new HTTPService();
	hts.url = "php/quiz.php";
	hts.method = "POST";
	cursorManager.setBusyCursor();

	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder =
		new AsyncResponder(onLoginResult, onLoginFault, token);
	token.addResponder(responder);
}
//	private function onLoginResult(event:ResultEvent, token:AsyncToken):void {
private function onLoginResult(event:ResultEvent, token:Object=null):void {
	cursorManager.removeBusyCursor();

	xmlReturn = new ArrayCollection([event.result.ids.ret]);

	if (xmlReturn[0].status == "OK") {
		// store user id 
		name_person = xmlReturn[0].name;
		id_person = xmlReturn[0].id;
		id_quiz = xmlReturn[0].quizID;
		
		// call method buildQuiz()
		buildQuiz();
	} else if (xmlReturn[0].status == "ERROR") {
//		personalAlert.msg.text = xmlReturn[0].detail;
//		personalAlert.visible = true;
		Alert.show(xmlReturn[0].detail);
	}
}
//	private function onLoginFault(event:FaultEvent, token:AsyncToken):void {
private function onLoginFault(event:FaultEvent, token:Object=null):void {
	cursorManager.removeBusyCursor();
	
	var errors:String = "Some errors occurred \n";
	errors += "\n Fault Code is : \n" + event.fault.faultCode;
	errors += "\n Fault Detail is : \n" + event.fault.faultDetail;
	errors += "\n Fault String is : \n" + event.fault.faultString;
	Alert.show(errors);
}
	
/**
 * 
 * 
 * Libs used at quiz 
 * 
 * 
 */
private function explode( delimiter:String, str:String ):Array {
	return str.split( delimiter );
}

private function displayTimer( iTime:int ) : String {
	var ret:String;
	if(iTime < 10) {
		ret = "00:0"+iTime;
	}else{
		ret = "00:"+iTime;				
	}
	
	return ret;
}

private function displayInfo() : void {
//	panQuiz.htmlText = "<b>"+name_person+"</b>, " + indx + " / " + num_questions + " ID="+id_person+" [" + displayTimer(iTimer) + "]";
	panQuiz.htmlText = "<b>"+displayTimer(iTimer)+"</b>";
}

private function iconMoveDown(id:Image):void{
	id.x = id.x+2;
	id.y = id.y+2;
}

private function iconMoveUp(id:Image):void{
	id.x = id.x-2;
	id.y = id.y-2;
}

private function iconMD(id:Image):void{
	id.y = id.y+2;
}

private function iconMU(id:Image):void{
	id.y = id.y-2;
}

private function get rollOverEffect():Effect {
	var effect:Glow = new Glow();
	effect.blurXTo = effect.blurYTo = 10;
	effect.alphaFrom = 0;
	effect.alphaTo = 0.6;
	effect.color = 0xFFFFFF;
	return effect;
}
 
private function get rollOutEffect():Effect {
	var effect:Glow = new Glow();
	effect.blurXTo = effect.blurYTo = 0;
	effect.alphaFrom = 0.6;
	effect.alphaTo = 0;
	effect.color = 0xFFFFFF;
	return effect;
}


/**
 * 
 * 
 * @method loadRules()
 * @comment Load all avaliable players 
 * 
 */
private function loadRules():void {
    var objDTO:Object = new Object();
	objDTO.action="rules";
	
	hts = new HTTPService();
	hts.url = "php/quizadmin.php";
	hts.method = "POST";
//	hts.resultFormat="e4x";
	
	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder = 
		new AsyncResponder(onloadRankingResult, onloadRankingFault, token);
	token.addResponder(responder);
	
}
private function onloadRankingResult(event:ResultEvent, token:AsyncToken):void {
    taRules.htmlText = event.result.rules.rule.description ;
}
private function onloadRankingFault(event:FaultEvent, token:AsyncToken):void {
	cursorManager.removeBusyCursor();
	
	var errors:String = "Some errors occurred \n";
	errors += "\n Fault Code is : \n" + event.fault.faultCode;
	errors += "\n Fault Detail is : \n" + event.fault.faultDetail;
	errors += "\n Fault String is : \n" + event.fault.faultString;
	Alert.show(errors);
}
