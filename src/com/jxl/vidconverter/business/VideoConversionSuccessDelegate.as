/*
	VideoConversionSuccessDelegate
    
	Tell's the server that FFMPEG successfully converted the video.
    
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
import com.jxl.vidconverter.constants.VideoConverterConstants;
import com.jxl.vidconverter.vo.fcs.FCEncodeInfo;



class com.jxl.vidconverter.business.VideoConversionSuccessDelegate extends JXLDelegate
{
	
	public function VideoConversionSuccessDelegate(p_responder:Responder)
	{
		super(p_responder);
	}
	
	public function videoConversionSuccess(p_encodeInfo:FCEncodeInfo):Void
	{
		var nc:NetConnection = Services.getInstance().getService("netConnection");
		if(nc.isConnected == true)
		{
			nc.call(VideoConverterConstants.getNameSpace() + "videoConversionSuccess",
					null,
					p_encodeInfo);
		}
		else
		{
			var fault:Fault = new Fault("not connected", "error", "NetConnection is connected.");
			var fe:FaultEvent = new FaultEvent(fault);
			responder.onFault(fe);
		}
	}
	
}