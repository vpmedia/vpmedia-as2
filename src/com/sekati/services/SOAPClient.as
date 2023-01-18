/**
 * com.sekati.services.SOAPClient
 * @version 1.0.6
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreObject;
import com.sekati.events.Dispatcher;
import com.sekati.log.Logger;
import com.sekati.services.ISOAPClient;
import com.sekati.services.SOAPEvent;
import com.sekati.utils.Delegate;
import com.sekati.validate.TypeValidation;
import mx.services.SOAPCall;
import mx.services.WebService;

/**
 * Soap Client class to be used with <a href="http://consume.sekati.com/?sid=swsdk">JNuSOAP</a>.<br>
 * TODO Replace Singleton Dispatcher for call result handling granularity.
 * 
 * <br>Q: 'There are multiple possible ports in the WSDL file; please specify a service name and port name!?'
 * <br>A: add port to class instance, seach for "port" in the wsdl & see url's below for more info.
 * 
 * @see <a href="http://www.intangibleinc.com/movabletype/archives/000007.html">http://www.intangibleinc.com/movabletype/archives/000007.html</a>
 * @see <a href="http://livedocs.macromedia.com/fms/2/docs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000796.html">http://livedocs.macromedia.com/fms/2/docs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00000796.html</a>
 * @see <a href="http://www.flash-db.com/Tutorials/lclasses/lclasses.php?page=2">http://www.flash-db.com/Tutorials/lclasses/lclasses.php?page=2</a>
 * @see <a href="http://www.adobe.com/devnet/flash/articles/flmxpro_webservices_03.html">http://www.adobe.com/devnet/flash/articles/flmxpro_webservices_03.html</a>
 */
class com.sekati.services.SOAPClient extends CoreObject implements ISOAPClient {

	private static var _instance:SOAPClient;
	private var _ws:WebService;
	private var _wsdl:String;
	private var _port:String;
	private var _isConnected:Boolean;
	private var _isVerbose:Boolean;

	/**
	 * Singleton Private Constructor
	 */
	private function SOAPClient() {
		super( );
		_isConnected = false;
		_isVerbose = false;
	}

	/**
	 * Singleton Accessor.
	 * @return SOAPClient
	 */
	public static function getInstance():SOAPClient {
		if (!_instance) {
			_instance = new SOAPClient( );
		}
		return _instance;
	}

	/**
	 * shorthand singleton accessor getter.
	 * @return SOAPClient
	 */
	public static function get $():SOAPClient {
		return SOAPClient.getInstance( );	
	}

	/**
	 * Connect the SOAP client to webservice.
	 * @param wsdl (String) wsdl URL.
	 * @param port (String) optional service port - <a href="http://www.adobe.com/devnet/flash/articles/flmxpro_webservices_03.html">see more</a>
	 * @return Void
	 */
	public function connect(wsdl:String, port:String):Void {
		_wsdl = wsdl;
		_port = port;
		_ws = new WebService( _wsdl );
		if (port) _ws._portName = port;
		_ws.onLoad = Delegate.create( _instance, connectLoad );
		_ws.onFault = Delegate.create( _instance, connectFault );
	}

	/**
	 * SOAP webservice method call.
	 * @param method (String) service method name
	 * @param args (Array) array of service method arguments
	 * @return Void
	 */
	public function call(method:String, args:Array):Void {
		/*
		 * Call Remote WebService Method using args array; then broadcast the result/fault event.
		 * NOTE: webservice method invocations return an asynchronous callback. 
		 * callback is undefined if the service itself is not created (and service.onFault fires)
		 */
		var _call:Function = _ws[method].apply( _ws, args );
		_call.onResult = Delegate.create( _instance, callResult, method );
		_call.onFault = Delegate.create( _instance, callFault, method, _call.request, _call.response );
	}

	/**
	 * Get verbosity SOAPClient sends to {@link Logger} 
	 * @return Boolean
	 */
	public function get verbose():Boolean {
		return _isVerbose;	
	}

	/**
	 * Set verbosity SOAPClient sends to {@link Logger} 
	 * @param b (Boolean)
	 * @return Void
	 */
	public function set verbose(b:Boolean):Void {
		_isVerbose = b;	
	}	

	/**
	 * Connect onLoad Handler
	 * @param wsdl (String)
	 * @return Void
	 */
	private function connectLoad(wsdl:String):Void {
		_isConnected = true;
		Dispatcher.$.dispatchEvent( new SOAPEvent( SOAPEvent.CONNECT, {wsdl:_wsdl} ) );
		if (_isVerbose) Logger.$.status( _instance.toString( ), "Webservice Connection SUCCESS Load: '" + _wsdl + "'" );		
	}

	/**
	 * Connect onFault Handler
	 * @param fault (Object)
	 * @return Void
	 */
	private function connectFault(fault:Object):Void {
		_isConnected = false;
		Dispatcher.$.dispatchEvent( new SOAPEvent( SOAPEvent.FAULT, {fault:fault} ) );
		if (_isVerbose) Logger.$.fatal( _instance.toString( ), "Webservice Connection FAILURE Fault: '" + _wsdl + "'\nfaultstring: " + fault.faultstring + "\nfaultcode: " + fault.faultcode + "\ndetail: " + fault.detail + "\nfaultactor: " + fault.faultactor + "\nfault: " + fault );		
	}

	/**
	 * Call onResult Handler
	 * @param method (String)
	 * @param result (Object)
	 * @return Void
	 */
	private function callResult(method:String, result:Object):Void {
		Dispatcher.$.dispatchEvent( new SOAPEvent( SOAPEvent.CALL_RESULT, {method:method, result:result} ) );	
		if (_isVerbose) {
			Logger.$.info( _instance.toString( ), "Webservice Call Result: '" + method + "'\nresult (" + TypeValidation.getType( result ).name + "): " + result );
		}
	}

	/**
	 * Call onFault Handler
	 * @param method (String)
	 * @param fault (Object)
	 * @return Void
	 */
	private function callFault(method:String, response:Object, request:Object, fault:Object):Void {
		Dispatcher.$.dispatchEvent( new SOAPEvent( SOAPEvent.CALL_FAULT, {method:method, fault:fault} ) );
		if (_isVerbose) {
			var props:String = "", call:String = "";
			for(var i:String in SOAPCall) props += "\nSOAPCall Properties: " + i + "  " + this[i];
			for (var j:String in SOAPCall) call += "\nSOAPCall-> " + j + " " + SOAPCall[j];
			Logger.$.error( _instance.toString( ), "Webservice Call Fault: '" + method + "'\nfaultstring: " + fault.faultstring + "\nfaultcode: " + fault.faultcode + "\ndetail: " + fault.detail + "\nfaultactor: " + fault.faultactor + "\nrequest: " + request + "\nSOAP response envelope: " + response + "\nfault: " + fault + "\n" + props + "\n" + call );
		}		
	}	
}