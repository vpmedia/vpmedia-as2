/*
	UnregisterVideoConverterDelegate
    
	Tell's the server to remove the VideoConverter from the server-side.  This ensures
	that this EXE file will no longer process videos.  It's basically an "off-switch"
	that is technically never used.  If FCS has no reference to the VideoConverter,
	it will not be able to contact this EXE, and thus convert videos.  I like to
	think of it as a WebService.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import mx.rpc.Responder;
import mx.rpc.Fault;
import mx.rpc.FaultEvent;
import mx.rpc.ResultEvent;
import com.jxl.arp.JXLDelegate;
import com.jxl.vidconverter.business.Services;
import com.jxl.net.JXLConnection;
import com.jxl.arp.JXLRelayResponder;
import com.jxl.vidconverter.constants.VideoConverterConstants;
import com.jxl.vidconverter.vo.fcs.FCFault;
import com.jxl.vidconverter.vo.fcs.FCFaultEvent;
import com.jxl.vidconverter.vo.fcs.FCResultEvent;



class com.jxl.vidconverter.business.UnregisterVideoConverterDelegate extends JXLDelegate
{
	
	public function UnregisterVideoConverterDelegate(p_responder:Responder)
	{
		super(p_responder);
	}
	
	public function unregisterVideoConverter(p_videoName:String):Void
	{
		var nc:NetConnection = Services.getInstance().getService("netConnection");
		if(nc.isConnected == true)
		{
			var respond:JXLRelayResponder = new JXLRelayResponder(this, 
																  onRegisterVideoConverterResult, 
																  onRegisterVideoConverterFault);
			nc.call(VideoConverterConstants.getNameSpace() + "unregisterVideoConverterClient", respond);
		}
		else
		{
			var fault:Fault = new Fault("not connected", "error", "NetConnection is connected.");
			var fe:FaultEvent = new FaultEvent(fault);
			responder.onFault(fe);
		}
	}
	
	private function onRegisterVideoConverterResult(event:FCResultEvent):Void
	{
		responder.onResult(new ResultEvent(event.result));
	}
	
	private function onRegisterVideoConverterFault(event:FCFaultEvent):Void
	{
		responder.onFault(new FaultEvent(new Fault("error", "unregister video converter failed", event.fault.detail)));
	}
	
}