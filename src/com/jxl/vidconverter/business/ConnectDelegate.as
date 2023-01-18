/*
	ConnectDelegate
    
	Connects to the Flash Media Server (Flashcom).
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import mx.utils.Delegate;
import mx.rpc.Responder;
import mx.rpc.Fault;
import mx.rpc.FaultEvent;
import mx.rpc.ResultEvent;
import com.jxl.arp.JXLDelegate;
import com.jxl.vidconverter.business.Services;
import com.jxl.net.JXLConnection;



class com.jxl.vidconverter.business.ConnectDelegate extends JXLDelegate
{
	
	private var nc:NetConnection;
	private var connectDelegate:Function;
	private var failedDelegate:Function;
	private var invalidAppDelegate:Function;
	private var rejectedDelegate:Function;
	
	public function ConnectDelegate(p_responder:Responder)
	{
		super(p_responder);
	}
	
	public function connect(p_rtmpURL:String):Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("ConnectDelegate::connect, p_rtmpURL: " + p_rtmpURL);
		
		nc = Services.getInstance().getService("netConnection");
		//DebugWindow.debug("nc: " + nc);
		//DebugWindow.debug("nc.connected: " + nc.connected);
		if(nc.isConnected == false)
		{
			connectDelegate = Delegate.create(this, onConnected);
			failedDelegate = Delegate.create(this, onFailedToConnect);
			invalidAppDelegate = Delegate.create(this, onInvalidApp);
			rejectedDelegate = Delegate.create(this, onRejected);
			nc.addEventListener(JXLConnection.CONNECTED, connectDelegate);
			nc.addEventListener(JXLConnection.FAILED, failedDelegate);
			nc.addEventListener(JXLConnection.INVALID_APP, invalidAppDelegate);
			nc.addEventListener(JXLConnection.REJECTED, rejectedDelegate);
			nc.connect(p_rtmpURL);
		}
		else
		{
			delete nc;
			var fault:Fault = new Fault("already connected", "error", "NetConnection already connected.");
			var fe:FaultEvent = new FaultEvent(fault);
			responder.onFault(fe);
		}
	}
	
	private function onConnected():Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("ConnectDelegate::onConnected");
		cleanUp();
		var result:ResultEvent = new ResultEvent(true);
		responder.onResult(result);
	}
	
	private function onFailedToConnect():Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("ConnectDelegate::onFailedToConnect");
		cleanUp();
		var fault:Fault = new Fault("failed", "error", "NetConnection failed to connect.");
		var fe:FaultEvent = new FaultEvent(fault);
		responder.onFault(fe);
	}
	
	private function onInvalidApp():Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("ConnectDelegate::onInvalidApp");
		cleanUp();
		var fault:Fault = new Fault("invalid app", "error", "Tried to connect to an invalid application.");
		var fe:FaultEvent = new FaultEvent(fault);
		responder.onFault(fe);
	}
	
	private function onRejected():Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("ConnectDelegate::onRejected");
		cleanUp();
		var fault:Fault = new Fault("rejected", "error", "NetConnection was rejected.");
		var fe:FaultEvent = new FaultEvent(fault);
		responder.onFault(fe);
	}
	
	private function cleanUp():Void
	{
		nc.removeEventListener(JXLConnection.CONNECTED, connectDelegate);
		nc.removeEventListener(JXLConnection.FAILED, failedDelegate);
		nc.removeEventListener(JXLConnection.INVALID_APP, invalidAppDelegate);
		nc.removeEventListener(JXLConnection.REJECTED, rejectedDelegate);
		delete connectDelegate;
		delete failedDelegate;
		delete invalidAppDelegate;
		delete rejectedDelegate;
		delete nc;
	}
	
}