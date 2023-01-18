/*
	JXLCommand
    
    Base class for ARP commands.  Handles some low-level plumbing,
	and allows callbacks for Views.  Since some View's would
	like to know when a Command is "done", this handles
	multiple levels of callbacks via default relay responders,
	default result/fault handlers, etc.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import mx.rpc.ResultEvent;
import mx.rpc.FaultEvent;
import mx.rpc.Responder;
import org.osflash.arp.CommandTemplate;
import org.osflash.arp.events.ArpEvent;
import com.jxl.arp.JXLRelayResponder;
import com.jxl.arp.JXLEvent;

class com.jxl.arp.JXLCommand
{
	
	public var responder:Responder;
	
	public function execute(event:ArpEvent):Void
	{
		if(JXLEvent(event).responder != null)
		{
			responder = JXLEvent(event).responder;
		}
	}
	
	public function onResult(event:ResultEvent):Void
	{
		if(responder != null) responder.onResult(event);
	}
	
	public function onFault(event:FaultEvent):Void
	{
		if(responder != null) responder.onFault(event);
	}
	
	public function getRelayResponder(p_scope:Object, p_result:Function, p_fault:Function):Responder
	{
		var handler:Responder;
		if(p_result != null || p_fault != null)
		{
			handler = new JXLRelayResponder(p_scope, p_result, p_fault);
		}
		else
		{
			handler = responder;
		}
		return handler;
	}
}