/*
	ConvertVideoEvent
    
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

class com.jxl.vidconverter.events.ConvertVideoEvent extends JXLEvent
{
	public static var CONVERT_VIDEO:String = "com.jxl.vidconverter.events.ConvertVideoEvent";
	
	public var encodeInfo:FCEncodeInfo;
	
	public function ConvertVideoEvent(p_type:String, 
										 p_scope:Object, 
										 p_result:Function, 
										 p_fault:Function,
										 p_encodeInfo:FCEncodeInfo)
	{
		super(p_type, p_scope, p_result, p_fault);
		
		encodeInfo = p_encodeInfo;
	}
}