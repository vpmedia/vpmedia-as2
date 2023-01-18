/*
	VideoConversionSuccessEvent
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import com.jxl.arp.JXLEvent;
import com.jxl.vidconverter.vo.fcs.FCEncodeInfo;

class com.jxl.vidconverter.events.VideoConversionSuccessEvent extends JXLEvent
{
	public static var SUCCESS:String = "com.jxl.vidconverter.events.VideoConversionSuccessEvent";
	
	public var encodeInfo:FCEncodeInfo;
	
	public function VideoConversionSuccessEvent(p_type:String, 
												 p_scope:Object, 
												 p_result:Function, 
												 p_fault:Function,
												 p_encodeInfo:FCEncodeInfo)
	{
		super(p_type, p_scope, p_result, p_fault);
		
		encodeInfo = p_encodeInfo;
	}
}