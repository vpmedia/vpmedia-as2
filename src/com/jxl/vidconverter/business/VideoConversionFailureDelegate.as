/*
	VideoConversionFailureDelegate
    
	Tell's the server that FFMPEG failed to convert the video.
    
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

class com.jxl.vidconverter.business.VideoConversionFailureDelegate extends JXLDelegate
{
	
	public function VideoConversionFailureDelegate(p_responder:Responder)
	{
		super(p_responder);
	}
	
	public function videoConversionFailure(p_videoName:String):Void
	{
		var nc:NetConnection = Services.getInstance().getService("netConnection");
		if(nc.isConnected == true)
		{
			nc.call(VideoConverterConstants.getNameSpace() + "videoConversionFailure",
					null,
					p_videoName);
		}
		else
		{
			var fault:Fault = new Fault("not connected", "error", "NetConnection is not connected.");
			var fe:FaultEvent = new FaultEvent(fault);
			responder.onFault(fe);
		}
	}
	
}