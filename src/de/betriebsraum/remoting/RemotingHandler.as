/**
 * RemotingHandler
 *
 * @author: Felix Raab, E-Mail: f.raab@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.2
 */


import mx.remoting.Service;
import mx.rpc.RelayResponder;
import mx.rpc.FaultEvent;
import mx.rpc.ResultEvent;
import mx.remoting.PendingCall;
import mx.remoting.debug.NetDebug;
import mx.events.EventDispatcher;

import mx.utils.Delegate;


class de.betriebsraum.remoting.RemotingHandler {
	
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;	

	private var service:Service;
	private var method:Object;
	
	private var queue:Array;
	private var isBusy:Boolean;
	
	
	public function RemotingHandler(gatewayUrl:String, serviceUrl:String) {		
		
		EventDispatcher.initialize(this);
		NetDebug.initialize();		
		
		clear();		
		service = new Service(gatewayUrl, null, serviceUrl, null, null);	
		
	}	
	

	private function getEventName():String {
		return (method.eventName != undefined) ? method.eventName : "on"+method.name.substr(0, 1).toUpperCase()+method.name.substr(1, method.name.length);
	}
	
	
	private function onRemoteResult(re:ResultEvent):Void {
	
		isBusy = false;		
		
		if (queue.length == 0) dispatchEvent({type:"onServiceResult", target:this});
		dispatchEvent({type:getEventName(), target:this, result:re.result});
		if (queue.length  > 0) doCall(queue.shift());
	
	}
	
	
	private function onRemoteFault(fe:FaultEvent):Void {
		
		isBusy = false;
		
		dispatchEvent({type:"onServiceFault", target:this});
		dispatchEvent({type:getEventName()+"Fault", target:this, fault:fe.fault});
		if (queue.length  > 0) doCall(queue.shift());
		
	}
	
	
	private function doCall(method:Object):Void {	
			
		isBusy = true;		
		this.method = method;			
		var resultScope:Object = new Object();
		
		var pc:PendingCall = service[method.name].apply(service, method.args);		
		pc.responder = new RelayResponder(resultScope, method.name+"_result", method.name+"_fault");
		resultScope[method.name+"_result"] = Delegate.create(this, onRemoteResult);
		resultScope[method.name+"_fault"] = Delegate.create(this, onRemoteFault);			
		
	}
	
	
	public function call(remoteFunc:String, args:Array, eventName:String):Void {	
	
		var method:Object = new Object();
		method.name = remoteFunc;
		method.args = args;
		method.eventName = eventName;
			
		if (isBusy) {
			queue.push(method);
		} else {			
			dispatchEvent({type:"onServiceCall", target:this});
			doCall(method);
		}
		
	}
	
	
	public function clear():Void {
		queue = new Array();
	}
	
	
	public function setCredentials(user:String, pass:String):Void {		
		service.connection.setCredentials(user, pass);		
	}
		
	
}