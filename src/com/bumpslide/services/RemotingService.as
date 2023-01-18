import mx.rpc.*;
import mx.remoting.debug.NetDebug;
import com.bumpslide.util.*;

/**
 * Remoting service implementation 
 * 
 * <p>This is a simple remoting service class that will work with ServiceProxy
 * as it extends the abstract Service class
 * 
 * @author David Knape 
 * 
 * Copyright © 2006 David Knape (http://bumpslide.com)
 * Released under the open-source MIT license. 
 * http://www.opensource.org/licenses/mit-license.php
 * See LICENSE.txt for full license terms.
*/

dynamic class com.bumpslide.services.RemotingService extends com.bumpslide.services.Service {
	
	// gatewayURL will be pulled from flashvars (_root.gatewayUrl) 
	private var gatewayUrl:String = "http://localhost/bumpslidelibrary/amfphp/gateway.php";
	
	// remoting service name (i.e. amfphp service class name)
	private var serviceName:String = "";
	
	// MX remoting Service 
	private var remotingService : mx.remoting.Service;
	
	// MX remoting PendingCall
	private var pendingCall : mx.remoting.PendingCall;
	
	private var methodNameResolveEnabled = true;
	
	public var mDebug:Boolean = false;
	
	
	function RemotingService() {
		super();
		init();
	}
	
	/**
	* Called during construction to setup our remoting service
	*/
	function init() {		
		
		if(_root.gatewayUrl!=null) gatewayUrl = _root.gatewayUrl;
		
		if (gatewayUrl=="" || gatewayUrl==undefined) {
			Debug.error( this + " var gatewayUrl must be defined in RemotingService implementations.");
			return;
		}
				
		if (serviceName=="" || serviceName==undefined) {
			Debug.error( this + " var serviceName must be defined in RemotingService implementations.");
			return;
		}
	
		if(mDebug) {
			//NetDebug.initialize();
		}
			
		debug('initRemotingservice "'+serviceName+'" at '+gatewayUrl);
		
		remotingService = new mx.remoting.Service(gatewayUrl, null, serviceName);		
	}
	
	
	function run() {
		debug('running method "'+methodName+'" with args: '+args);
		
		pendingCall = remotingService[methodName].apply(remotingService, args);
		pendingCall.responder = new RelayResponder(this, "onRemotingResponse", "onRemotingError");
	} 
	
	function cancel() {
		super.cancel();
		pendingCall.responder = null;
		delete pendingCall;
	}	
	
	function onRemotingResponse(resultEvt:Object) {
		
		if(cancelled) {
			// don't handle result if this call was cancelled
			return;
		}
		
		debug( '('+methodName+') returned ...');
		debug( resultEvt.__result )
				
		// save result object 
		result = resultEvt.__result;
		
		// call subclass hook for model updating
		handleResult( result );
		
		// broadcast events and such
		notifyComplete();	
	}
	
	function onRemotingError(evt:FaultEvent) {
		if(cancelled) {
			// ignore errors if this call was cancelled
			return;
		}
		notifyError( evt.fault.faultstring );
	}	
	
	/**
	 * set credentials on connection
	 * @param user The username
	 * @param password The password
	 */
	public function setCredentials(user:String, pass:String):Void
	{
		remotingService.connection.setCredentials(user, pass);
	}
	
	public function toString() : String {
		return '[RemotingService] ';
	}
}
