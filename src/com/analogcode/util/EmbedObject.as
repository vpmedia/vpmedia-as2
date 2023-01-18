import flash.external.ExternalInterface;
import mx.utils.Delegate;
import mx.events.EventDispatcher;

/**
 *
 * @author astgtciv@analogcode.com
 * @version 1.2 (07/02/07)
 * 
 * The EmbedObject class allows you to retrieve information about the browser Embed Object for this swf. 
 **/
 
class com.analogcode.util.EmbedObject   {
	// The user has the option of specifing the id explicitly.
	static public var EMBED_OBJECT_ID_PARAM:String = "_embedObjectId";
	
	static public var EVENT_PARAMS_AVAILABLE = "EmbedObjectParamsAvailable";
	
	static private var _singleton:EmbedObject;
	
	static private var SET_CALLBACK_NAME:String = "asorg_setEmbedObjectProps";
	static private var SET_VARIABLE_NAME:String = "asorg_EmbedObjectProps";
	
	static private var TAG_NAMES:Array = ["embed", "object"];
	
	// millis to wait until asynch js executes
	static private var ASYNCH_JS_EXEC_WAIT_MILLIS:Number = 1000;
	static private var JS_AUTOGEN_ID:String = "if (!elts[i].getAttribute('id')) {elts[i].setAttribute('id','asorgid_'+Math.floor(Math.random()*100000));}";
	
	private var embedObjectProps:Object;
	private var attemptedPropsRetrieval:Boolean = false;
	// private var curEmergencyTagIndex:Number = -1;
		
	var addEventListener:Function;
    var removeEventListener:Function;
    var dispatchEvent:Function;
	
	function EmbedObject(){
		initialize();
	}

	
	function initialize() {
		initializeExternalCallback();
		mx.transitions.OnEnterFrameBeacon.init();
		MovieClip.addListener(this);
		EventDispatcher.initialize(this);
	}
	
	function initializeExternalCallback() {
		ExternalInterface.addCallback(SET_CALLBACK_NAME, this, external_SetEmbedObjectProps);
	}
	
	static public function get singleton():EmbedObject {
		if (!_singleton) {
			_singleton = new EmbedObject();
		}
		return _singleton;
	}
		
	/////////////////////////// Interface ////////////////////////////////
	/*
	* Returns an object with all the enumerable params of the embed object - i.e., params which are enumerable in 
	* a javascript loop over the object's attributes. The code always tries to return param 'id' as part of the object, 
	* whether it is considered enumerable by the browser or not.
	* 
	* Knowledge of the id property in params allows execution of javascript from flash
	* via ExternalInterface that references this embedded object (using document.getElementById()).
	* 
	* If it is not possible to get EmbedObjectParams, this function returns undefined.
	*/

	static public function getEnumerableParams():Object {
		if (!singleton.embedObjectProps) {
			singleton._getEmbedObjectProps();
		} 
		
		return singleton.embedObjectProps;
	}
	

	/*
	* Returns the value of an enumerable parameter "param" in the embed object in the page (<embed> or <object>).
	* This is a shortcut, calling this function is equivalent to calling getEnumerableParams()[param].
	* To get a non-enumerable (but readable) parameter, use getParamViaExternal.
	*/
	static public function getEnumerableParam(param:String):String {
		return String(getEnumerableParams()[param]);
	}


	/*
	* A shortcut function to getting the EmbedObject's id. 
	* Calling this function is equivalent to calling getEnumerableParam('id')
	*/
	static public function getId():String {
		if (_level0[EMBED_OBJECT_ID_PARAM] !== undefined) {
			return 	_level0[EMBED_OBJECT_ID_PARAM];
		}
		return getEnumerableParam('id');
	}
	
	/*
	* This is a js shortcut to getting a readable (!) EmbedObject param dynamically via ExternalInterface.
	*/
	static public function getParamViaExternal(param:String):Object {
		return Object(singleton.executeJS("return document.getElementById('"+getEnumerableParam('id')+"').getAttribute('" + param + "');"));
	}
	
	
	/*
	* This is a js shortcut to setting an attribute on the EmbedObject dynamically via ExternalInterface.
	*/
	static public function setParamViaExternal(param:String, value:String) {
		singleton.executeJS("document.getElementById('"+getEnumerableParam('id')+"').setAttribute('" + param + "', '"+value+"');");
	}
	
	static public function isInBrowser():Boolean {
		return ((System.capabilities.playerType == "PlugIn") || ((System.capabilities.playerType == "ActiveX")));
	}

	
	//////////////// Implementation /////////////////////////////////////////
	private function _getEmbedObjectProps():Object {
		if (!isInBrowser()) { 
			// it would be pointless to try to retrieve EmbedObject props when we are not in browser
			return;
		}
		
		// getURL("javascript:alert('attemptedPropsRetrieval: "+attemptedPropsRetrieval+"');");
		if (!attemptedPropsRetrieval) {
			retrieveEmbedObjectProps();
			if (!embedObjectProps) {
				// if we have failed to retrieve the props,
				// we perform an emergency retrieval!
				// emergencyRetrieveEmbedObjectProps();
			}
			attemptedPropsRetrieval = true;
		}

		return embedObjectProps;
	}
	
	private function retrieveEmbedObjectProps() {
		for (var i:Number=0; i<TAG_NAMES.length; i++) {
			var tagName:String = TAG_NAMES[i];
			retrieveEmbedObjectPropsForTagname(tagName);
			if (embedObjectProps) { 
				// got the props, no need to continue
				break;
			}
		}
	}
	
	
	// this function executes id-retrieving javascript searching for a particular tag name
	// (it will be called for "object" and "embed")
	private function retrieveEmbedObjectPropsForTagname(tagName:String) {
		// We iterate though all the tags with tagName, if the SET_ID_CALLBACK_NAME method is supported,
		// we call it.
		// The js used in version 1.0:
		// var js:String =  "var elts = document.getElementsByTagName('"+tagName+"'); for (var i=0;i<elts.length;i++) {if(typeof elts[i]."+SET_CALLBACK_NAME+" != 'undefined') { if (!elts[i].id) {elts[i].id='asorgid_'+Math.floor(Math.random()*100000);} var props = {}; props.id = elts[i].id; for (var j in elts[i]) { if ((typeof elts[i][j] == 'string')||(typeof elts[i][j] == 'number')||(typeof elts[i][j] == 'boolean')) { props[j] = elts[i][j]; } } elts[i]."+SET_CALLBACK_NAME+"(props); }}";
		var js:String =  "var elts = document.getElementsByTagName('"+tagName+"'); for (var i=0;i<elts.length;i++) {if(typeof elts[i]."+SET_CALLBACK_NAME+" != 'undefined') { "+JS_AUTOGEN_ID+" var props = {}; props.id = elts[i].getAttribute('id'); for (var x=0; x < elts[i].attributes.length; x++) { props[elts[i].attributes[x].nodeName] = elts[i].attributes[x].nodeValue;} elts[i]."+SET_CALLBACK_NAME+"(props); }}";
		executeJS(js);
	}
	
	/*
	* If we failed to obtain the embedObjectProps, it could have been because we are in IE 
	* and the embed object does not have an id. So, we perform an "emergency id bootstrap", and then
	* proceed to retry our normal retrieval procedure.
	* 
	* This code is unfinished.
	*/
	/*
	private function emergencyRetrieveEmbedObjectProps() {
		for (var i:Number=0; i<TAG_NAMES.length; i++) {
			var tagName:String = TAG_NAMES[i];
		
			// if (++curEmergencyTagIndex >= TAG_NAMES.length) {
				// we went through all the tags already, have to conclude that we have failed
				// return;
			// }
			// var tagName:String = TAG_NAMES[curEmergencyTagIndex];
			var js:String = "var elts = document.getElementsByTagName('"+tagName+"'); for (var i=0;i<elts.length;i++) { "+JS_AUTOGEN_ID+" var props='id='+escape(elts[i].getAttribute('id')); for (var x=0; x < elts[i].attributes.length; x++) {if(typeof elts[i].attributes[x].nodeValue == 'string') {props += '&'+escape(elts[i].attributes[x].nodeName)+'='+escape(elts[i].attributes[x].nodeValue);}} alert('"+SET_VARIABLE_NAME+" to ' + props); elts[i].SetVariable('"+SET_VARIABLE_NAME+"', props);}";
			// we can not use ExternalInterface here because in IE ExternalInterface calls fail
			// on id-less embeds. So, we use another way to get out to set the id, and then proceed
			// to use ExternalInterface as before.
			asynchExecuteJS(js);
			// Alternative to the Timeout - 
			// using SetVariable() from js and polling the _level0 variable via an onEnterFrame
			// A better solution, that. TODO.
			// _global["setTimeout"](Delegate.create(this, onEmergencyRetrieveForTagFinished), ASYNCH_JS_EXEC_WAIT_MILLIS);
		}
	}
	
	function onEnterFrame() {
		if (_level0[SET_VARIABLE_NAME]) {
			var props:Object = {};
			// decode
			var pairs:Array = _level0[SET_VARIABLE_NAME].split("&");
			for (var i:Number=0; i<pairs.length; i++) {
				var nameValue:Array = pairs[i].split("=");
				props[unescape(nameValue[0])] = unescape(nameValue[1]);
			}
			external_SetEmbedObjectProps(props);
			dispatchEvent({type: EVENT_PARAMS_AVAILABLE});
			delete this.onEnterFrame;
		}
	}
	

	private function onEmergencyRetrieveForTagFinished() {
		initializeExternalCallback();
		// "elts[i].CallFunction('<invoke name=\"'"+SET_CALLBACK_NAME+"\" returntype=\"javascript\">' + __flash__argumentsToXML(arguments,0) + '</invoke>'";
		retrieveEmbedObjectPropsForTagname(TAG_NAMES[curEmergencyTagIndex]);
		if (!embedObjectProps) {
			emergencyRetrieveEmbedObjectProps();
		}
	} */
	
	// Executes a chunk of javascript code via ExternalInterface and returns the result
	private function executeJS(js:String):Object {
		return ExternalInterface.call("function() {"+js+"}");
	}
	
	private function asynchExecuteJS(js:String) {
		getURL("javascript:"+js, "_self");
	}

	private function external_SetEmbedObjectProps(props:Object) {
		this.embedObjectProps = props;
	}

}