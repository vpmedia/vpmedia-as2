/**
XmlLoader V3.1
@version 3.0
@since 03/03/2007
@author Shane McCartney - shanem@flashdynamix.com
@description  Converts XML to arrays of objects recursively
*/
import com.FlashDynamix.core.Base;
import com.FlashDynamix.events.Event;
import com.FlashDynamix.events.EventArgs;
import com.FlashDynamix.data.ProxyXml;
import com.FlashDynamix.utils.Delegate;
//
class com.FlashDynamix.loaders.XmlLoader extends Base {
	/**
	@ignore
	*/
	private var calls:Object;
	/**
	@ignore
	*/
	private var errors:Object;
	/*
	* Error call attempts maximum
	*/
	public var errorCallMax:Number = 3;
	/*
	* Seconds wait between calls on case of error
	*/
	public var callWaitSecs:Number = 1;
	/*
	* Stops a call of a same command name when calling another
	*/
	public var autoStop:Boolean = false;
	/*
	* Decides wether the xml is completely parsed or only parsed when accessed.
	*/
	public var lazyDecoding:Boolean = true;
	/**
	@ignore
	*/
	private function init():Void {
		calls = new Object();
		errors = new Object();
	}
	/**
	* Prepares and sends an XML call 
	* @description Prepares and sends an XML call containing a querystring using an object of named query parameters i.e.<BR>
	myObj = new Object();<BR>
	myObj.param1 = "value1";<BR>
	myObj.param2 = "value2";<BR>
	Translates to = "?param1=value1&amp;param2=value2<BR><BR>
	
	The querstring can also be hard coded into the XMLURL parameter<BR><BR>
	
	The name is used to identify the response when performing simaltaneuos data calls
	*/
	function load(url:String, name:String, query:Object, callMethod:String, compressed:Boolean):LoadVars {
		if (autoStop) {
			stopCall(name);
		}
		//             
		var cLV:LoadVars = new LoadVars();
		var rLV:LoadVars = new LoadVars();
		//
		rLV.onHTTPStatus = Delegate.create(this, HTTPResponse, rLV);
		rLV.onData = Delegate.create(this, response, rLV);
		//
		rLV.name = name;
		rLV.url = url;
		rLV.query = (query == undefined) ? null : query;
		rLV.compressed = (compressed == undefined) ? false : compressed;
		rLV.method = (callMethod == undefined) ? null : callMethod;
		rLV.state = "called";
		//
		if (errors[name] == undefined) {
			errors[name] = 0;
		}
		calls[name] = {response:rLV, call:cLV};
		//
		for (var paramName in query) {
			cLV[paramName] = query[paramName];
		}
		//
		cLV.sendAndLoad(url, rLV, callMethod);
		return cLV;
	}
	/**
	@ignore
	*/
	private function response(src:String):Void {
		//
		var lv:LoadVars = arguments.callee.origion;
		var name:String = lv.name;
		//
		if (src != undefined) {
			//
			var resultObj:Array = new Array();
			var xml = new XML();
			xml.ignoreWhite = true;
			// Does it use the LZ77 algorithm
			if (lv.compressed) {
				xml.parseXML(unCompress(src));
			} else {
				xml.parseXML(src);
			}
			//
			var data;
			if (lazyDecoding) {
				data = ProxyXml.create(xml);
			} else {
				data = ProxyXml.parse(xml);
			}
			//
			lv.state = "loaded";
			dispatchEvent(new Event(Event.LOADED, new EventArgs(XmlLoader, name, {name:name, data:data, xml:xml, src:src, callMethod:lv.method, query:lv.query})));
			deleteCall(name);
		} else {
			Delegate.create(this, HTTPResponse, lv)();
		}
	}
	private function unCompress(src):String {
		var ecPos = src.indexOf(" ")+1;
		var eC = src.charAt(ecPos);
		var src = src.substr(ecPos+1);
		var o = "";
		var iL = src.length;
		for (var n = 0; n<iL; n++) {
			if (src.charAt(n) == eC) {
				var p = src.charCodeAt(n+1)*114+src.charCodeAt(n+2)-1610;
				var l = src.charCodeAt(n+3)-14;
				o += o.substr(-p, l);
				n += 3;
			} else {
				o += src.charAt(n);
			}
		}
		return o;
	}
	private function HTTPResponse(httpStatusCode:Number):Void {
		//
		var lv:LoadVars = arguments.callee.origion;
		var name:String = lv.name;
		var call = calls[name];
		//
		if ((httpStatusCode >=400 && httpStatusCode <=500)  || httpStatusCode == undefined) {
			errors[name]++;
			if (errors[name] < errorCallMax) {
				//
				lv.state = "retry";
				Delegate.delay(callWaitSecs*1000, this, function (lv:LoadVars) {
					this.load(lv.url, lv.name, lv.query, lv.method);
				}, [lv]);
				//
			} else {
				lv.state = "failed";
				dispatchEvent(new Event(Event.ERROR, new EventArgs(XmlLoader, null, {name:name, xml:lv, method:lv.method, query:lv.query, status:error(lv.status), code:httpStatusCode})));
				deleteCall(name);
			}
			delete lv;
		}
	}
	/**
	@ignore
	*/
	private function error(code:Number):String {
		var msg:String;
		switch (code) {
		case 0 :
			msg = "No error - parse was completed successfully. Or domain was not contactable";
			break;
		case -2 :
			msg = "A CDATA section was not properly terminated.";
			break;
		case -3 :
			msg = "The XML declaration was not properly terminated.";
			break;
		case -4 :
			msg = "The DOCTYPE declaration was not properly terminated.";
			break;
		case -5 :
			msg = "A comment was not properly terminated.";
			break;
		case -6 :
			msg = "An XML element was malformed.";
			break;
		case -7 :
			msg = "Out of memory.";
			break;
		case -8 :
			msg = "An attribute value was not properly terminated.";
			break;
		case -9 :
			msg = "A start-tag was not matched with an end-tag.";
			break;
		case -10 :
			msg = "An end-tag was encountered without a matching start-tag.";
			break;
		default :
			msg = "An unknown error has occurr?d. Please contact FlashDynamix.com for more inparseion";
			break;
		}
		return msg;
	}
	/**
	* Stops all current XML calls in transaction
	*/
	public function stop():Void {
		for (var name in calls) {
			stopCall(name);
		}
	}
	public function myCall(name:String):Object {
		return calls[name];
	}
	public function stopCall(name:String):Boolean {
		if (myCall(name) != undefined) {
			deleteCall(name);
			return true;
		}
		return false;
	}
	private function deleteCall(name:String):Void {
		delete myCall(name);
		delete errors[name];
	}
}
