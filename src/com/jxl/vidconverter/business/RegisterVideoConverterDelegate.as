/*
	RegisterVideoConverterDelegate
    
	Tell's the server to add the VideoConverter from the server-side.  Afterwards, the server
	can now contact this EXE to convert videos.  If the server doesn't know this EXE exist,
	it won't process convert video requests.  I like to think of it as a WebService.
    
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



class com.jxl.vidconverter.business.RegisterVideoConverterDelegate extends JXLDelegate
{
	
	public function RegisterVideoConverterDelegate(p_responder:Responder)
	{
		super(p_responder);
	}
	
	public function registerVideoConverter():Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("RegisterVideoConverterDelegate::registerVideoConverter");
		var nc:NetConnection = Services.getInstance().getService("netConnection");
		DebugWindow.debug("nc.isConnected: " + nc.isConnected);
		if(nc.isConnected == true)
		{
			var respond:JXLRelayResponder = new JXLRelayResponder(this, 
																  onRegisterVideoConverterResult, 
																  onRegisterVideoConverterFault);
			DebugWindow.debug("calling nc.call ( registerVideoConverter)...");
			nc.call(VideoConverterConstants.getNameSpace() + "registerVideoConverter", respond);
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
		responder.onFault(new FaultEvent(new Fault("error", "register video converter failed", event.fault.detail)));
	}
	
}