/*  com.gousable.SWF_Protector
contains some methods to protect SWF file.

VERSION: 1.0
DATE: 3/08/2007
DESCRIPTION:
	Provides several ways to protect SWF files that can be used in any combination
		1) Good old "checking the _url" protection
		2) Loading external text file (url-encoded) from your server. Recommended for "smart" clients. 
		Remember about crossdomain.xml file !
		3) Expire by time (like trial version)
		4) Bytecode. If you have some good __bytecode__() at hand that will (as you think) crash decompilers, 
		place it in a frame in some clip in library and attach at runtime.
	If the violation is detected, you can
		1) Unload _root leaving the screen blank
		2) Show an alert message telling them ... something
		3) Call your own action after checking the *isViolated* flag property (see below for example).
	
	This "code-only" version is intended for programmers. 



ARGUMENTS FOR CONSTRUCTOR:
	1) url_check   An object that specifies parameters of "checking the _url" protection
		_use  	Boolean, use this protection or not
		goodUrl    String, should be present in any valid URL (_root._url)
		alert		String, message to show if URL is not valid  
	2) load_file  An object that specifies parameters of "external text file" protection
		_use  	Boolean, use this protection or not
		fileUrl	String, an URL of file to load
		keyName String, key name in the above file
		keyValue String, key value in the above file
		maxTime Number, max time to load file in seconds
		alert		String, message to show if file is not loaded or key is not valid  
	3) time_block  An object that specifies parameters of "expire by time" protection
		_use  	Boolean, use this protection or not
		msGetExpired   Number, timestamp to expire. For example:  ( new Date(2007,2,7,8,0,0).getTime() )  
		alert		String, message to show if time is expired  
	4) byte_code  An object that specifies parameters of "bytecode" protection
		_use 	Boolean, use this protection or not
		linkage	String, linkage ID of a clip in the library.
	5) options  An object that specifies some other parameters 
		_use 	Boolean, use options or not
		doUnload Boolean, unloads _root if true.
		showAlert Boolean,  will show alert message if true
		alert		Object, properties of alert box
			alert.linkage		String, linkage ID of a clip in the library.
			alert.textName	String, textfield inside this clip
				// both alert.linkage and alert.textName are required to attach a custom clip for alert box
			alert.posX		Number, X position of alert box
			alert.posY		Number, Y position of alert box
			alert.background	Boolean,  show bg for dynamically created text field or not. Same as TextField.background
			alert.backgroundColor	Same as TextField.backgroundColor
			alert.textColor			Same as TextField.textColor	
			alert.border			Same as TextField.border
			alert.borderColor		Same as TextField.borderColor
			alert.multiline		        Same as TextField.multiline
			alert.tFormat			TextFormat to apply to dynamically created text field
	

USAGE: 
	To use this class, you must do the following:
	1) Import it using "import"  statement
	2) Prepare arguments for constructor
	3) Call the constructor
	
	//================ Example =====================
	import com.gousable.SWF_Protector ;
	//
	var url_check:Object = {};
	url_check._use = true;
	url_check.goodUrl = "http://localhost/123";
	url_check.alert = "Sorry, this site should NOT be shown here.";
	//	
	var load_file:Object =  {};
	load_file._use = true;
	load_file.fileUrl = "http://localhost/123/123.txt";
	load_file.keyName = "my_check";
	load_file.keyValue = "123QWERTY";
	load_file.maxTime = 3; // max time to load file in seconds
	load_file.alert = "Sorry, this site should NOT be shown here.";
	//	
	var time_block:Object = {};
	time_block._use = true;
	time_block.msGetExpired = ( new Date(2007,2,7,8,0,0).getTime() ) ; // 
	time_block.alert = "\nSorry, time limit for this site has expired.\n ";
	//	
	var byte_code:Object =  {};
	byte_code._use = true;
	byte_code.linkage = "swf_protector_bytecode";	
	//		
	var options:Object =  {};
	options._use = true;
	options.doUnload = false;
	options.showAlert = true;
	options.alert = {};
	//options.alert.linkage = "swf_protector_alert";
	options.alert.textName = "alert_txt";
	options.alert.posX = 100;
	options.alert.posY = 100;
	//
	options.alert.background = true;
	options.alert.backgroundColor = 0xeeeeff;
	options.alert.textColor = 0xcc6666;
	options.alert.border = true;
	options.alert.borderColor = 0xccffcc;
	options.alert.tFormat = new TextFormat();
		options.alert.tFormat.font = "Courier New";
		options.alert.tFormat.leftMargin = options.alert.tFormat.rightMargin = 20;
	//
	// now call the constructor
	_root.swf_protector = new SWF_Protector(url_check, load_file, time_block, byte_code, options);	
	//
	var timer1:Number = setInterval(this, "checkProtection", 5000);
	function checkProtection(Void):Void{	
		clearInterval(timer1);
		// check if protection is violated
		if(_root.swf_protector.isViolated){
			_root.debug_txt.text = "\n SWF PROTECTION VIOLATED";		
		}else{
			_root.debug_txt.text = "\n SWF PROTECTION :  OK";
		}
	}
	// =============== end of example ======================
	
	
NOTES:
	The SWF_Protector  object has  a flag property, isViolated, that can be checked if you prefer to set your own actions.
	See setInterval and "checkProtection" function above - it shows a message in some special text field.
	

CODED BY: GOusable, info@gousable.com
Copyright 2007, GOusable (This code is released as open source under GPL license).
*/


class com.gousable.SWF_Protector 
{
	//
	private var urlCheck:Object; // parameters of "checking the _url" protection
	private var loadFile:Object;  // parameters of "external text file" protection
	private var timeBlock:Object; // parameters of "expire by time" protection
	private var byteCode:Object;  // parameters of "bytecode" protection
	private var myOptions:Object; // other params
	//
	private var protectionResults:Object = {};
	private var __violated:Boolean; // accessible via getter method
	//
	private var timer1:Number; // timer
	//
	
// ================ class constructor ===========================
	function SWF_Protector (url_check:Object, load_file:Object, time_block:Object, byte_code:Object, options:Object)
	{	
		// hello
		//trace ("== new SWF_Protector  == ");
		//
		urlCheck = url_check._use? url_check : null;
		loadFile = load_file._use? load_file : null;
		timeBlock = time_block._use? time_block : null;
		byteCode = byte_code._use? byte_code : null;
		myOptions = options._use? options : null;
		//
		init();
	}
	// ============ END of constructor ===============================
	
// ================ Methods ===========================	
//
// init
private function init(Void):Void{	
	protectionResults.url_ok = setUrlCheckProtection();
	setLoadFileProtection();
	protectionResults.time_ok = setTimeBlockProtection();
	setByteCodeProtection();
	//
	protectionResults.startedAt = getTimer();
	checkProtection();
	if( !isViolated){
		timer1 = setInterval(this, "checkProtection", 1000);
	}
	//
}
//
// setUrlCheckProtection
private function setUrlCheckProtection(Void):Boolean{	
	if(!urlCheck){ return true; }
		//trace("setUrlCheckProtection");
	if( _root._url.indexOf(urlCheck.goodUrl) != -1){ 
		return true;
	}
	return false;
}
//
//
// setLoadFileProtection
private function setLoadFileProtection(Void):Void{	
	if(!loadFile){ return; }
		//trace("setLoadFileProtection");
	var my_lv:LoadVars = new LoadVars();
	my_lv.myObj = this;
	my_lv._keyName = loadFile.keyName;
	my_lv._keyValue = loadFile.keyValue;
	my_lv.load(loadFile.fileUrl);
	my_lv.onLoad = function(success:Boolean) {
		this.myObj.protectionResults.file_loaded = true;
		if (success) {
			this.myObj.protectionResults.file_ok = ( this[this._keyName] == this._keyValue );			
		}else{
			this.myObj.protectionResults.file_ok = false;
		}
	};
}
//
//
// setTimeBlockProtection
private function setTimeBlockProtection(Void):Boolean{	
	if(!timeBlock){ return true; }
		//trace("setTimeBlockProtection");
	var msNow:Number = new Date().getTime();
	if(msNow < timeBlock.msGetExpired ){
		return true; 
	}
	return false; 
}
//
//
// setByteCodeProtection
private function setByteCodeProtection(Void):Void{	
	if(!byteCode){ return; }
		//trace("setByteCodeProtection");
	_root.attachMovie(byteCode.linkage, byteCode.linkage, _root.getNextHighestDepth());
	//	
}
//
//
// checkProtection
private function checkProtection(Void):Void{	
		//trace("checkProtection...");
	if( !protectionResults.url_ok ){
		stopViolation("url");
		return;
	}
	if( !protectionResults.time_ok ){
		stopViolation("time");
		return;
	}
	//
	if( !protectionResults.file_ok && protectionResults.file_loaded){
		stopViolation("file");
		return;
	}else if( !protectionResults.file_loaded && getTimer() > (protectionResults.startedAt + loadFile.maxTime*1000) ){
		stopViolation("file");
		return;
	}else if( protectionResults.file_loaded && getTimer() > (protectionResults.startedAt + loadFile.maxTime*1000) ){
		// all is OK, stop checking
		clearInterval(timer1);
	}
	//
}
//
//
// stopViolation
private function stopViolation(c:String):Void{	
		//trace("stopViolation,  cause = "+c);
	clearInterval(timer1);	
	//
	__violated = true;
	//
	if(myOptions.doUnload){
		_root.unloadMovie();
		return;
	}
	//
	showAlert(c);
	//
}
//
//
// showAlert
private function showAlert(c:String):Void{	
	if(!myOptions.showAlert){ return; }
		//trace("showAlert,  cause = "+c);
	var msg:String = "";
	switch(c){
		case "url":
			msg = urlCheck.alert;
		break;
		case "time":
			msg = timeBlock.alert;
		break;
		case "file":
			msg = loadFile.alert;
		break;
	}
	msg = msg? msg : "Sorry, you are not allowed to view this site.";
	//
	var alert_mc:MovieClip;
	var alert_txt:TextField;
	var posX:Number = myOptions.alert.posX? myOptions.alert.posX : 200;
	var posY:Number = myOptions.alert.posY? myOptions.alert.posY : 200;
	if(myOptions.alert.linkage && myOptions.alert.textName ){
		alert_mc = _root.attachMovie(myOptions.alert.linkage, myOptions.alert.linkage, _root.getNextHighestDepth());
		alert_mc._x = posX;
		alert_mc._y = posY;
		alert_mc[myOptions.alert.textName].text = msg;
		
	}else{
		var s:String = (new Date().getTime())+"_txt";
		_root.createTextField(s,  _root.getNextHighestDepth(), posX, posY, 100, 100);
		alert_txt = _root[s];
		alert_txt.autoSize = true;
		alert_txt.multiline = myOptions.alert.multiline;
		alert_txt.wordWrap = alert_txt.multiline? true : false;
		alert_txt.background = myOptions.alert.background;
		alert_txt.backgroundColor = myOptions.alert.backgroundColor? myOptions.alert.backgroundColor : 0xeeeeee;
		alert_txt.border = myOptions.alert.border;
		alert_txt.borderColor = myOptions.alert.borderColor? myOptions.alert.borderColor : 0x999999;
		alert_txt.textColor = myOptions.alert.textColor? myOptions.alert.textColor : 0xcc9999;
		alert_txt.text = msg;
		alert_txt.setTextFormat(myOptions.alert.tFormat);
		var w:Number = alert_txt._width;
		if (alert_txt.multiline){
			alert_txt._width += myOptions.alert.tFormat.leftMargin *2;
		} else {
			alert_txt.autoSize = false;
			alert_txt._width = w + myOptions.alert.tFormat.leftMargin *2;
		}
			//trace("msg = "+msg);
		alert_txt.setTextFormat(myOptions.alert.tFormat);
		
	}
	//
}
//
// 
// === getter for __violated
public function get isViolated():Boolean{
	return __violated;
}
//
//



// ==============================
// END of class definition

}
