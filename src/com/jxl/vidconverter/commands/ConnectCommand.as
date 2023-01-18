/*
	ConnectCommand
    
	This command connects to the Flashcom server.
    
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
import com.jxl.arp.JXLCommand;
import com.jxl.vidconverter.events.ConnectEvent;
import com.jxl.vidconverter.business.ConnectDelegate;

class com.jxl.vidconverter.commands.ConnectCommand extends JXLCommand
{
	public function execute(event:ArpEvent):Void
	{
		super.execute(event);
		
		switch(event.type)
		{
			case ConnectEvent.CONNECT:
				connect(ConnectEvent(event).rtmpURL);
				break;
		}
	}
	
	private function connect(p_rtmpURL:String):Void
	{
		getDelegate().connect(p_rtmpURL);
	}
	
	private function getDelegate(p_scope:Object, p_result:Function, p_fault:Function):ConnectDelegate
	{
		return new ConnectDelegate(getRelayResponder(p_scope, p_result, p_fault));
	}
}