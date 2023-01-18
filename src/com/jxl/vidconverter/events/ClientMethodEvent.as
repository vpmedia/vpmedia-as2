/*
	ClientMethodEvent
    
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

class com.jxl.vidconverter.events.ClientMethodEvent extends JXLEvent
{
	public static var CLIENT_METHOD:String = "com.jxl.vidconverter.events.ClientMethodEvent";
	
	public var className:String;
	public var instanceName:String;
	public var methodName:String;
	public var methodArguments:Array;
	
	public function ClientMethodEvent(p_type:String, 
										 p_className:String,
										 p_instanceName:String,
										 p_methodName:String,
										 p_methodArguments:Array)
	{
		type = 				p_type;
		className = 		p_className;
		instanceName = 		p_instanceName;
		methodName = 		p_methodName;
		methodArguments	=	p_methodArguments;
	}
}