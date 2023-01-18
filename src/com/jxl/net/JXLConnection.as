/*
	JXLConnection
    
	Proxy class for NetConnection.  I've had problems with getting Flashcom (FCS 1.5<) to support
	namespaces in Flash Player 9, namely Flex 2.  I think this is because the slash syntax is no
	longer supported in Flash Player 9, thus the server to client calls no longer work.  While
	this IS using Flash Player 8, it was easier to handle the namespaces here in a central class,
	and force the server to pass the namespace + method server-side.  This class then gathers the
	necessary information from the server to client call, and dispatches an event.  That way,
	I'm not hardcoding classes & methods server-side.  I can merely send a string, and have the client
	handle it how it see's fit.  This will port to Flash Player 9, ActionScript 3 easily.
	
	Secondly, this makes it easier to handle NetConnection via an EventDispatcher interface; dispatching
	events vs. the old way of adding anonymous event functions to the class.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import mx.events.EventDispatcher;
import mx.utils.Delegate;
import com.jxl.vidconverter.events.ClientMethodEvent;

[Event("connected")]
[Event("clientMethod")]
dynamic class com.jxl.net.JXLConnection
{
	
	public static var CONNECTED:String = "com.jxl.net.JXLConnection.connected";
	public static var FAILED:String = "com.jxl.net.JXLConnection.failed";
	public static var INVALID_APP:String = "com.jxl.net.JXLConnection.invalidApp";
	public static var REJECTED:String = "com.jxl.net.JXLConnection.rejected";
	public static var CLIENT_METHOD:String = ClientMethodEvent.CLIENT_METHOD;
	
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	
	private var nc:NetConnection;   
	
	public function JXLConnection()
	{
		nc = new NetConnection();
		nc.owner = this;
		nc.onStatus = Delegate.create(this, onNCStatus);
		nc.serverToClient = Delegate.create(this, serverToClient); // prizz-noxy
	}
	
	public function get isConnected():Boolean
	{
		return nc.isConnected;
	}
	
	public function connect(p_rtmpURL:String):Void
	{
		nc.connect(p_rtmpURL);
	}
	
	public function call(p_method:String, p_responder:Object):Void
	{
		nc.call.apply(nc, arguments);
	}
	
	private function onNCStatus(info:Object):Void
	{
		// FIXME: this mofo is NOT dispatching an event that the Delegate can get...
		
		//DebugWindow.debugHeader();
		//DebugWindow.debug("JXLConnection::onNCStatus");
		//DebugWindow.debugProps(info);
		//DebugWindow.debug("this: " + this);
		//DebugWindow.debug("dispatchEvent: " + dispatchEvent);
		if(info.code == "NetConnection.Connect.Success")
		{
			dispatchEvent({type: CONNECTED, target: this});
		}
		else if(info.code == "NetConnection.Connect.Failed")
		{
			dispatchEvent({type: FAILED, target: this});
		}
		else if(info.code == "NetConnection.Connect.InvalidApp")
		{
			dispatchEvent({type: INVALID_APP, target: this});
		}
		else if(info.code == "NetConnection.Connect.Rejected")
		{
			dispatchEvent({type: REJECTED, target: this});
		}
	}
	
	// Special method called by Flashcom.  This passes in
	// the namespace and any optional parameters.
	public function serverToClient(p_namespace:String):Void
	{
		//DebugWindow.debugHeader();
		//DebugWindow.debug("JXLConnection::serverToClient, p_namespace: " + p_namespace);
		
		var namespace_array:Array = p_namespace.split("/");
		var className:String = 		namespace_array[0];
		var instanceName:String = 	namespace_array[1];
		var methodName:String = 	namespace_array[2];
		arguments.shift();
		var args:Array = 			arguments.concat();
		var cme:ClientMethodEvent = new ClientMethodEvent(ClientMethodEvent.CLIENT_METHOD,
														  className,
														  instanceName,
														  methodName,
														  args);
		dispatchEvent(cme);
	}
	
	private static var mixit = EventDispatcher.initialize(JXLConnection.prototype);
}