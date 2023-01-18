/*
	NetConnectionObserver
	
	Base class for watching server-side messages.  Typically used for
	building a client side class that watches for messages from a
	server-side equivalent.  While Flash MX 2004 & MX used a 1 to 1
	relationship via a Decorated View class, it was too tightly coupled
	for my tastes.  You couldn't change the View, couldn't turn it off,
	and had to code a lot of state management.  Furthermore, it didn't
	port well to Flex 2, nor does it allow the ability to "turn things on and off".
	
	Therefore, this abstract base class makes it easy to extend
	and listen for relevant server-side messages.
    
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
import com.jxl.net.JXLConnection;

import com.jxl.vidconverter.business.Services;
import com.jxl.vidconverter.events.ClientMethodEvent;


class com.jxl.vidconverter.observers.NetConnectionObserver
{
	private var nc:JXLConnection;
	//private var __connectedDelegate:Function;
	private var __clientMethodDelegate:Function;
	
	public function NetConnectionObserver(p_serviceName:String)
	{
		nc = Services.getInstance().getService("netConnection");
		//__connectedDelegate = Delegate.create(this, onConnected);
		__clientMethodDelegate = Delegate.create(this, onClientMethod);
	}
	
	public function startObserving():Void
	{
		//nc.removeEventListener(JXLConnection.CONNECTED, __connectedDelegate);
		nc.removeEventListener(ClientMethodEvent.CLIENT_METHOD, __clientMethodDelegate);
		
		//nc.addEventListener(JXLConnection.CONNECTED, __connectedDelegate);
		nc.addEventListener(ClientMethodEvent.CLIENT_METHOD, __clientMethodDelegate);
	}
	
	public function stopObserving():Void
	{
		//nc.removeEventListener(JXLConnection.CONNECTED, __connectedDelegate);
		nc.removeEventListener(ClientMethodEvent.CLIENT_METHOD, __clientMethodDelegate);
	}
	
	//private function onConnected(event:Object):Void
	//{
	//}
	
	private function onClientMethod(event:ClientMethodEvent):Void
	{
	}
}