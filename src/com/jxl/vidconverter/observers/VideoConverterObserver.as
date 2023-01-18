/*
	VideoConverterObserver
	
	Client side equivalent to the Flashcom's VideoConverter.asc class.
	This class listens for server-side messages that come from the
	server and dispatches informative events.  It doesn't actually
	ever send messages back to the server.  Instead, it dispatches
	relevant events and assumes that if ARP/Cairngorm wants to send
	a message to the server, it'll do so via the Event > Command > Delegate way
	that those frameworks typically handle.  Since ARP & Cairngorm were
	built for a Request / Response model, they don't handle server push.
	This class is an example where you can have an Observer listen for
	push messages, and basically inject them into the framework in a clean
	way.
	
	Props to Thomas Burleson for helping hash out this idea!
	http://blog.universalmind.com
	
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
import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;

import org.osflash.arp.ArpEventDispatcher;

import com.jxl.vidconverter.observers.NetConnectionObserver;
import com.jxl.vidconverter.events.ClientMethodEvent;
import com.jxl.vidconverter.events.ConvertVideoEvent;
import com.jxl.vidconverter.events.VideoConversionSuccessEvent;
import com.jxl.vidconverter.events.VideoConversionFailureEvent;
import com.jxl.vidconverter.constants.VideoConverterConstants;
import com.jxl.vidconverter.business.Services;
import com.jxl.vidconverter.utils.SharedObjectUtils;
import com.jxl.vidconverter.events.RegisterVideoConverterEvent;
import com.jxl.vidconverter.events.UnregisterVideoConverterEvent;
import com.jxl.vidconverter.events.CopyFileEvent;
import com.jxl.vidconverter.vo.fcs.FCEncodeInfo;

class com.jxl.vidconverter.observers.VideoConverterObserver extends NetConnectionObserver
{
	
	private var videoConverterInstanceName:String;
	private var videoQue_so:SharedObject;
	private var videoQueSyncDelegate:Function;
	private var encode_array:Array;
	private var isEncoding:Boolean = false;
	
	public function VideoConverterObserver(p_serviceName:String, p_instanceName:String)
	{
		super(p_serviceName);
		
		if(typeof(p_instanceName) == "string")
		{
			if(p_instanceName == null && p_instanceName == "")
			{
				videoConverterInstanceName = p_instanceName;
			}
			else
			{
				videoConverterInstanceName = VideoConverterConstants.defaultInstanceName;
			}
		}
		else
		{
			videoConverterInstanceName = VideoConverterConstants.defaultInstanceName;
		}
		
		//if(videoQueSyncDelegate == null) videoQueSyncDelegate = Delegate.create(this, onVideoQueSync);
	}
	
	public function startObserving():Void
	{
		super.startObserving();
		
		//var nc:NetConnection = Services.getInstance().getService("netConnection");
		
		//videoQue_so = SharedObjectUtils.getEventDispatchingRemoteSharedObject(VideoConverterConstants.getNameSpace() + "videoQue", 
																				//nc.uri, 
																				//false);
		
		//videoQue_so.removeEventListener("sync", videoQueSyncDelegate);
		//videoQue_so.addEventListener("sync", videoQueSyncDelegate);
		
		var rvce:RegisterVideoConverterEvent = new RegisterVideoConverterEvent(RegisterVideoConverterEvent.REGISTER);
		ArpEventDispatcher.getInstance().dispatchEvent(rvce);
	}
	
	public function stopObserving():Void
	{
		//videoQue_so.removeEventListener("sync", videoQueSyncDelegate);
		
		var urvce:UnregisterVideoConverterEvent = new UnregisterVideoConverterEvent(UnregisterVideoConverterEvent.UNREGISTER);
		ArpEventDispatcher.getInstance().dispatchEvent(urvce);
		
		super.stopObserving();
	}
	/*
	private function onVideoQueSync(event:Object):Void
	{
		encode_array = [];
		for(var p in event.target.data)
		{
			var ei:EncodeInfo = EncodeInfo(event.target.data[p]);
			encode_array.push(ei);
		}
		encode_array.reverse(); // Flash Player 8 and below does for in backwards
	}
	*/
	private function onClientMethod(event:ClientMethodEvent):Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("VideoConverterObserver::onClientMethod");
		DebugWindow.debug("className: " + event.className + ", instanceName: " + event.instanceName);
		DebugWindow.debug("VideoConverterConstants.className: " + VideoConverterConstants.className);
		DebugWindow.debug("videoConverterInstanceName: " + videoConverterInstanceName);
		
		if(event.className == VideoConverterConstants.className)
		{
			if(event.instanceName == videoConverterInstanceName)
			{
				DebugWindow.debug("this[event.methodName]: " + this[event.methodName]);
				this[event.methodName].apply(this, event.methodArguments);
			}
		}
	}
	
	private function onConvertVideoSuccess(event:ResultEvent):Void
	{
		// second, copy the file
		
		var encodeInfo:FCEncodeInfo = FCEncodeInfo(event.result);
		var cfe:CopyFileEvent = new CopyFileEvent(CopyFileEvent.COPY_FILE,
												  this,
												  onCopyFileResult,
												  onCopyFileFault,
												  encodeInfo);
		
		ArpEventDispatcher.getInstance().dispatchEvent(cfe);
	}
	
	private function onConvertVideoFailure(event:FaultEvent):Void
	{
		var vcfe:VideoConversionFailureEvent = new VideoConversionFailureEvent(VideoConversionFailureEvent.FAILURE,
																			  this,
																			  null,
																			  null,
																			  String(event.fault.faultcode));
		ArpEventDispatcher.getInstance().dispatchEvent(vcfe);
	}
	
	private function onCopyFileResult(event:ResultEvent):Void
	{
		// third, now that file is copied, report success
		var encodeInfo:FCEncodeInfo = FCEncodeInfo(event.result);
		var vcse:VideoConversionSuccessEvent = new VideoConversionSuccessEvent(VideoConversionSuccessEvent.SUCCESS,
																			  this,
																			  null,
																			  null,
																			  encodeInfo);
		ArpEventDispatcher.getInstance().dispatchEvent(vcse);
	}
	
	private function onCopyFileFault(event:FaultEvent):Void
	{
	}
	
	// <<<<<<< Server to Client <<<<<<<
	private function encodeVideo(p_encodeInfo:FCEncodeInfo):Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("VideoConverterObserver::encodeVideo, p_encodeInfo: " + p_encodeInfo);
		DebugWindow.debug("p_encodeInfo instanceof FCEncodeInfo: " + (p_encodeInfo instanceof FCEncodeInfo));
		DebugWindow.debugProps(p_encodeInfo);
		// first, encode the video
		var cve:ConvertVideoEvent = new ConvertVideoEvent(ConvertVideoEvent.CONVERT_VIDEO,
														  this,
														  onConvertVideoSuccess,
														  onConvertVideoFailure,
														  p_encodeInfo);
		ArpEventDispatcher.getInstance().dispatchEvent(cve);
	}
	
	
	
}