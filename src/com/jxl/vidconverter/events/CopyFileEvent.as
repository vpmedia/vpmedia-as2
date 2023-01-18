/*
	CopyFileEvent
    
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

class com.jxl.vidconverter.events.CopyFileEvent extends JXLEvent
{
	public static var COPY_FILE:String = "com.jxl.vidconverter.events.CopyFileEvent";
	
	public var encodeInfo:FCEncodeInfo;
	
	public function CopyFileEvent(p_type:String, 
									p_scope:Object,
									p_result:Function,
									p_fault:Function,
									p_encodeInfo:FCEncodeInfo)
	{
		super(p_type, p_scope, p_result, p_fault);
		
		encodeInfo = p_encodeInfo;
	}
}