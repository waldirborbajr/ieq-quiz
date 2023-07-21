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
 
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.controls.Alert;
import mx.rpc.AsyncResponder;
import mx.rpc.AsyncToken;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.mxml.HTTPService;
 
[Bindable] private var xmlResult:XML;
[Bindable] private var hts:HTTPService;
[Bindable] private var control:String;
[Bindable] private var QID:String;
[Bindable] private var QQID:String;

[Bindable] private var language:Array = [
                {data:"pt_br.xml", label:"Português"},
                {data:"en_us.xml", label:"English"}
            ];
//[Bindable] private var lu.LabelUtil = LabelUtil.getInstance();

/*
<langage>
    <label></label>
    <label></label>
    <label></label>
</langage>
*/

private var xml:XMLList; 

private function loadLanguage():void{
    var loader:URLLoader = new URLLoader();
    loader.addEventListener(Event.COMPLETE, loadLabels);
    loader.load(new URLRequest("languages/pt_br.xml"));
}
private function loadLabels(e:Event):void {
    xml = new XMLList(e.target.data);
//    lu.label1 = xml.label[0];
//    lu.label2 = xml.label[1];
//    lu.label3 = xml.label[2];
//    lu.label4 = xml.label[3];
}


/**
 * 
 * 
 * @method loadQuiz
 * @comment Load all avaliable quiz 
 * 
 */
private function loadQuiz():void {
    var objDTO:Object = new Object();
	objDTO.action="quiz";
	
	hts = new HTTPService();
	hts.url = "php/quizadmin.php";
	hts.method = "POST";
//	hts.resultFormat="e4x";
	
	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder = 
		new AsyncResponder(onBuildResult, onBuildFault, token);
	token.addResponder(responder);
	
}
private function onBuildResult(event:ResultEvent, token:AsyncToken):void {
	dbQuiz.dataProvider = event.result.quizes.quiz;
}
private function onBuildFault(event:FaultEvent, token:AsyncToken):void {
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
 * @method loadQuiz
 * @comment Load all avaliable quiz 
 * 
 */
private function loadQuiz2():void {
    var objDTO:Object = new Object();
	objDTO.action="quiz";
	
	hts = new HTTPService();
	hts.url = "php/quizadmin.php";
	hts.method = "POST";
//	hts.resultFormat="e4x";
	
	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder = 
		new AsyncResponder(onBuild2Result, onBuild2Fault, token);
	token.addResponder(responder);
	
}
private function onBuild2Result(event:ResultEvent, token:AsyncToken):void {
	dgQuiz.dataProvider = event.result.quizes.quiz;
}
private function onBuild2Fault(event:FaultEvent, token:AsyncToken):void {
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
 * @method lookupQuestion()
 * @comment Find all question of a quiz 
 * 
 */
private function lookupQuestion(quizID:String):void {
    if(dbQuiz.selectedItem.ativo == "1"){
        cbQuizEnable.selected = true;
    } else {
        cbQuizEnable.selected = false;
    }
    
    var objDTO:Object = new Object();
	objDTO.action="question";
	objDTO.quizid=quizID;
	
	hts = new HTTPService();
	hts.url = "php/quizadmin.php";
	hts.method = "POST";
//	hts.resultFormat="e4x";
	
	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder = 
		new AsyncResponder(onQuestionResult, onQuestionFault, token);
	token.addResponder(responder);
	
}
private function onQuestionResult(event:ResultEvent, token:AsyncToken):void {
    if (event.result.questions != null) {
        if (event.result.questions.question.length > 0) {
            dbQuestions.dataProvider = event.result.questions.question;
        }    
    }else{
        dbQuestions.dataProvider = null;
        dgAnswers.dataProvider = null;
    }
}
private function onQuestionFault(event:FaultEvent, token:AsyncToken):void {
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
 * @method lookupQuestion()
 * @comment Find all question of a quiz 
 * 
 */
private function lookupAnwswer(questionID:String):void {
    var objDTO:Object = new Object();
	objDTO.action="answer";
	objDTO.questionID=questionID;
	
	hts = new HTTPService();
	hts.url = "php/quizadmin.php";
	hts.method = "POST";
//	hts.resultFormat="e4x";
	
	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder = 
		new AsyncResponder(onAnswerResult, onAnswerFault, token);
	token.addResponder(responder);
	
}
private function onAnswerResult(event:ResultEvent, token:AsyncToken):void {
    if (event.result.answers != null) {
        if (event.result.answers.answer.length > 0) {
            dgAnswers.dataProvider = event.result.answers.answer;
        }    
    } else {
        dgAnswers.dataProvider = null;
    }
}
private function onAnswerFault(event:FaultEvent, token:AsyncToken):void {
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
 * @method changeQuiz()
 * @comment Update selected quiz 
 * 
 */
private function saveChange(ID:String, option:String):void {
    
    var objDTO:Object = new Object();
   	objDTO.action="save";

    if (option == "quiz"){
    	objDTO.ID        = ID;
    	objDTO.content   = tiQuiz.text;
    	objDTO.ativo     = (cbQuizEnable.selected)?"1":"0"; 
    	objDTO.option    = option;
    } else if (option == "question") {
    	objDTO.ID        = ID;
    	objDTO.content   = tiQuestion.text;
    	objDTO.option    = option;
    } else if (option == "answer") {
    	objDTO.ID        = ID;
    	objDTO.content   = tiAnswer.text;
    	objDTO.ativo     = (cbAnswerValid.selected)?"1":"0"; 
    	objDTO.option    = option;
    }

	hts = new HTTPService();
	hts.url = "php/quizadmin.php";
	hts.method = "POST";
//	hts.resultFormat="e4x";
	
	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder = 
		new AsyncResponder(onsaveChangeResult, onsaveChangeFault, token);
	token.addResponder(responder);
	
}
private function onsaveChangeResult(event:ResultEvent, token:AsyncToken):void {
    loadQuiz();
    dgAnswers.dataProvider = null;
    dbQuestions.dataProvider = null;
}
private function onsaveChangeFault(event:FaultEvent, token:AsyncToken):void {
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
 * @method loadPlayers()
 * @comment Load all avaliable players 
 * 
 */
private function loadPlayers():void {
    var objDTO:Object = new Object();
	objDTO.action="players";
	
	hts = new HTTPService();
	hts.url = "php/quizadmin.php";
	hts.method = "POST";
//	hts.resultFormat="e4x";
	
	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder = 
		new AsyncResponder(onLoadPlayersResult, onLoadPlayersFault, token);
	token.addResponder(responder);
	
}
private function onLoadPlayersResult(event:ResultEvent, token:AsyncToken):void {
	dgPlayers.dataProvider = event.result.players.player;
}
private function onLoadPlayersFault(event:FaultEvent, token:AsyncToken):void {
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
 * @method loadRanking()
 * @comment Load all avaliable players 
 * 
 */
private function loadRanking(id_quiz:String):void {
    var objDTO:Object = new Object();
	objDTO.action="rank";
	objDTO.id_quiz=id_quiz;
	
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
    if (event.result.ranking != null) {
        if (event.result.ranking.rank.length > 0) {
            dgRanking.dataProvider = event.result.ranking.rank;
        }    
    } else {
        dgRanking.dataProvider = null;
    }
}
private function onloadRankingFault(event:FaultEvent, token:AsyncToken):void {
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
		new AsyncResponder(onloadRulesResult, onloadRulesFault, token);
	token.addResponder(responder);
	
}
private function onloadRulesResult(event:ResultEvent, token:AsyncToken):void {
    taRules.htmlText = event.result.rules.rule.description;
    lblRuleID.text = event.result.rules.rule.id;
}
private function onloadRulesFault(event:FaultEvent, token:AsyncToken):void {
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
 * @method updateRule()
 * @comment Load all avaliable players 
 * 
 */
private function updateRule():void {
    var objDTO:Object = new Object();
	objDTO.action="updateRule";
	objDTO.id = lblRuleID.text;
	objDTO.rule = taRules.text;
	
	
	hts = new HTTPService();
	hts.url = "php/quizadmin.php";
	hts.method = "POST";
//	hts.resultFormat="e4x";
	
	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder = 
		new AsyncResponder(onupdateRuleResult, onupdateRuleFault, token);
	token.addResponder(responder);
	
}
private function onupdateRuleResult(event:ResultEvent, token:AsyncToken):void {

}
private function onupdateRuleFault(event:FaultEvent, token:AsyncToken):void {
	cursorManager.removeBusyCursor();
	
	var errors:String = "Some errors occurred \n";
	errors += "\n Fault Code is : \n" + event.fault.faultCode;
	errors += "\n Fault Detail is : \n" + event.fault.faultDetail;
	errors += "\n Fault String is : \n" + event.fault.faultString;
	Alert.show(errors);
}


private function newQuiz():void {
    twNew.visible = true;
    twNew.title = "Novo Quiz";

    newLBQuiz.text = "Título do Quiz";
    
    newLBQuestion.visible = false;
    tiNewQuestion.visible = false;
    
    newLBAnswer.visible = false;
    tiNewAnswer.visible = false;
    
    control = "quiz";
}

private function newQuestion():void {
    twNew.visible = true;
    twNew.title = "Nova Pergunta";

    newLBQuiz.text = "Quiz";
    tiNewQuiz.text = dbQuiz.selectedItem.description;
    tiNewQuiz.editable = false;
    
    newLBQuestion.text = "Pergunta";
    newLBQuestion.visible = true;
    tiNewQuestion.visible = true;
    
    newLBAnswer.visible = false;
    tiNewAnswer.visible = false;

    control = "question";
}

private function newAnswer():void {
    twNew.visible = true;
    twNew.title = "Nova Resposta";
    
    newLBQuiz.text = "Resposta";
    
    newLBQuiz.text = "Quiz";
    tiNewQuiz.text = dbQuiz.selectedItem.description;
    tiNewQuiz.editable = false;
    
    newLBQuestion.text = "Pergunta"
    tiNewQuestion.text = dbQuestions.selectedItem.description;
    tiNewQuestion.editable = false;
    newLBQuestion.visible = true;
    tiNewQuestion.visible = true;
    
    newLBAnswer.text = "Resposta";
    newLBAnswer.visible = true;
    tiNewAnswer.visible = true;

    control = "answer";
}

private function SaveData():void {
    twNew.visible = false;
    
    var objDTO:Object = new Object();
   	objDTO.action="savenew";

    if (control == "quiz"){
    	objDTO.content   = tiNewQuiz.text;
    	objDTO.control   = control;
    } else if (control == "question") {
        QID = dbQuiz.selectedItem.id;
    	objDTO.quizID   = QID;
    	objDTO.content   = tiNewQuestion.text;
    	objDTO.control   = control;
    } else if (control == "answer") {
        QQID = dbQuestions.selectedItem.id;
    	objDTO.questionID  = QQID;
    	objDTO.content   = tiNewAnswer.text;
    	objDTO.control   = control;
    }

	hts = new HTTPService();
	hts.url = "php/quizadmin.php";
	hts.method = "POST";
//	hts.resultFormat="e4x";
	
	var token:AsyncToken = hts.send(objDTO);
	var responder:AsyncResponder = 
		new AsyncResponder(onSaveDataResult, onSaveDataFault, token);
	token.addResponder(responder);
	
}
private function onSaveDataResult(event:ResultEvent, token:AsyncToken):void {
    if (control == "quiz"){
    	loadQuiz();
    } else if (control == "question") {
        lookupQuestion(QID);
    } else if (control == "answer") {
        lookupAnwswer(QQID);
    }
}
private function onSaveDataFault(event:FaultEvent, token:AsyncToken):void {
	cursorManager.removeBusyCursor();
	
	var errors:String = "Some errors occurred \n";
	errors += "\n Fault Code is : \n" + event.fault.faultCode;
	errors += "\n Fault Detail is : \n" + event.fault.faultDetail;
	errors += "\n Fault String is : \n" + event.fault.faultString;
	Alert.show(errors);
}

