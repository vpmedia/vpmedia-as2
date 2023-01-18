/*
	RegisterVideoConverterEvent
    
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

class com.jxl.vidconverter.events.RegisterVideoConverterEvent extends JXLEvent
{
	public static var REGISTER:String = "com.jxl.vidconverter.events.RegisterVideoConverterEvent";
	
	public function RegisterVideoConverterEvent(p_type:String,
												p_scope:Object,
												p_result:Function,
												p_fault:Function)
	{
		super(p_type, p_scope, p_result, p_fault);
	}
	
}