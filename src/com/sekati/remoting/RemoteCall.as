/**
 * com.sekati.remoting.RemoteCall
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.core.CoreObject;
import com.sekati.events.Dispatcher;
import com.sekati.remoting.RemoteEvent;
import mx.rpc.RelayResponder;
import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;
import mx.remoting.PendingCall;
import mx.remoting.Service;

/**
 * Make Remoting calls to AMFPHP, Fluorine, etc.
 * TODO Replace Singleton Dispatcher for call result handling granularity.
 * @see <a href="http://www.amfphp.org">AMFPHP</a>
 * @see <a href="http://remoting.sekati.com/browser/">remoting.sekati.com</a>
 */
class com.sekati.remoting.RemoteCall extends CoreObject {

	private var _gateway:String;
	private var _service:String;
	private var _method:String;	

	/**
	 * RemoteCall Constructor
	 * @param gateway (String)
	 * @param service (String)
	 * @param method (String)
	 * @return Void
	 */
	public function RemoteCall(gateway:String, service:String, method:String) {
		super( );
		_gateway = gateway;
		_service = service;
		_method = method;		
	}

	/**
	 * Invoke the RPC; all arguments will be passed through.
	 * @param * (Object) your arguments here.
	 * @return Void
	 */
	public function call():Void {
		var s:Service = new Service( _gateway, null, _service );
		var pc:PendingCall = s[_method].apply( this, arguments );
		pc.responder = new RelayResponder( this, "callResult", "callFault" );		
	}

	/**
	 * Call onResult Handler
	 * @param res (ResultEvent)
	 * @return Void
	 */
	private function callResult(res:ResultEvent):Void {
		var result:Object = res.result;
		var error:Object = false;
		var remote:RemoteCall = this;
		Dispatcher.$.dispatchEvent( new RemoteEvent( RemoteEvent.onRemoteResultEVENT, this, {result:result, error:error, remote:remote} ) );
	}

	/**
	 * Call onFault Handler
	 * @param fault (FaultEvent)
	 * @return Void
	 */
	private function callFault(fault:FaultEvent):Void {
		var result:Object = null;
		var error:Object = {};
		var remote:RemoteCall = this;
		for(var i:String in fault.fault) error[i] = fault.fault[i];
		Dispatcher.$.dispatchEvent( new RemoteEvent( RemoteEvent.onRemoteFaultEVENT, this, {result:result, error:error, remote:remote} ) );
	}
}