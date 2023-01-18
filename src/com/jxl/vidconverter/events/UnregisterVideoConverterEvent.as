/*
	UnregisterVideoConverterEvent
    
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

class com.jxl.vidconverter.events.UnregisterVideoConverterEvent extends JXLEvent
{
	public static var UNREGISTER:String = "com.jxl.vidconverter.events.UnregisterVideoConverterEvent";
	
	public function UnregisterVideoConverterEvent(p_type:String,
													 p_scope:Object,
													 p_result:Function,
													 p_fault:Function)
	{
		super(p_type, p_scope, p_result, p_fault);
	}
}