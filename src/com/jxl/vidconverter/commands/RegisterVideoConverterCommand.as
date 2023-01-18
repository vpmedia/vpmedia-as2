/*
	StartVideoConverterObserverCommand
    
	This command tells the server that we are ready to go, and to start
	sending requests if it has any.
    
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
import com.jxl.vidconverter.events.RegisterVideoConverterEvent;
import com.jxl.vidconverter.business.RegisterVideoConverterDelegate;

class com.jxl.vidconverter.commands.RegisterVideoConverterCommand extends JXLCommand
{
	public function execute(event:ArpEvent):Void
	{
		super.execute(event);
		
		registerVideoConverter();
	}
	
	private function registerVideoConverter():Void
	{
		getDelegate().registerVideoConverter();
	}
	
	private function getDelegate(p_scope:Object, p_result:Function, p_fault:Function):RegisterVideoConverterDelegate
	{
		return new RegisterVideoConverterDelegate(getRelayResponder(p_scope, p_result, p_fault));
	}
	
}