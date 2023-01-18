/*
	StopVideoConverterObserverEvent
    
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

class com.jxl.vidconverter.events.StopVideoConverterObserverEvent extends JXLEvent
{
	public static var STOP_OBSERVING:String = "com.jxl.vidconverter.events.StopVideoConverterObserverEvent";
	
	public function StopVideoConverterObserverEvent(p_type:String,
													 p_scope:Object,
													 p_result:Function,
													 p_fault:Function)
	{
		super(p_type, p_scope, p_result, p_fault);
	}
	
}