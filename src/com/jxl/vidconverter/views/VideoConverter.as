/*
	VideoConverter
	
	The main application.  This is the class that starts the VideoConverter
	application.  It makes the initial connection and starts listening
	for Flashcom instructions.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import mx.core.View;
import mx.controls.TextArea;
import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;

import org.osflash.arp.ArpEventDispatcher;

import com.jxl.vidconverter.events.ConnectEvent;
import com.jxl.vidconverter.events.StartVideoConverterObserverEvent;
import com.jxl.vidconverter.constants.PathConstants;

class com.jxl.vidconverter.views.VideoConverter extends View
{
	public static var symbolName:String = "com.jxl.vidconverter.views.VideoConverter";
	public static var symbolOwner:Object = com.jxl.vidconverter.views.VideoConverter;
	public var className:String;
	
	private var __debug_ta:TextArea;
	
	
	private function createChildren():Void
	{
		super.createChildren();
		
		__debug_ta = TextArea(createChild(TextArea, "__debug_ta"));
	}
	
	private function initLayout():Void
	{
		super.initLayout();
		
		DebugWindow.debugHeader();
		DebugWindow.debug("VideoConverter::Connecting...");
		// Connect
		var ce:ConnectEvent = new ConnectEvent(ConnectEvent.CONNECT,
											   this,
											   onConnectSuccess,
											   onConnectFailure,
											   PathConstants.RTMP_URL);
		ArpEventDispatcher.getInstance().dispatchEvent(ce);
	}
	
	private function doLayout():Void
	{
		super.doLayout();
		
		__debug_ta.setSize(width, height);
	}
	
	private function onConnectSuccess(event:ResultEvent):Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("Connection success, starting VideoConverter Observer...");
		// if connected, start observing
		var svce:StartVideoConverterObserverEvent = new StartVideoConverterObserverEvent(StartVideoConverterObserverEvent.START_OBSERVING,
																						 this,
																						 onStartVideoConverterObservingSuccess,
																						 onStartVideoConverterObservingFailure);
		ArpEventDispatcher.getInstance().dispatchEvent(svce);
	}
	
	private function onConnectFailure(event:FaultEvent):Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("Failed to connect.");
	}
	
	private function onStartVideoConverterObservingSuccess(event:ResultEvent):Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("VideoConverter Observer started.");
	}
	
	private function onStartVideoConverterObservingFailure(event:FaultEvent):Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("Failed to start VideoConverter Observer.");
	}
	
	
}