/*
	JXLEvent
    
    Base event class.  Extends ArpEvent, but also
	allows a built-in responder to be created based
	on the result / fault functions the developer
	passes in.  These are optional, but allow commands
	run by dispatching this event to support callbacks.
	I don't really like supporting faults since I don't think
	View's should get a fault event, but here for consitency.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import org.osflash.arp.events.ArpEvent;
import com.jxl.arp.JXLRelayResponder;
import mx.rpc.Responder;

class com.jxl.arp.JXLEvent extends ArpEvent
{
	public var responder:Responder;
	
	public function JXLEvent(p_type:String, p_scope:Object, p_result:Function, p_fault:Function)
	{
		type = p_type;
		responder = new JXLRelayResponder(p_scope, p_result, p_fault);
	}
}