/*
	UnregisterVideoConverterCommand
    
	Prevents this EXE from being able to convert anymore video; the "off-switch".
    
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
import com.jxl.vidconverter.events.UnregisterVideoConverterEvent;
import com.jxl.vidconverter.business.UnregisterVideoConverterDelegate;

class com.jxl.vidconverter.commands.UnregisterVideoConverterCommand extends JXLCommand
{
	public function execute(event:ArpEvent):Void
	{
		super.execute(event);
		
		unregisterVideoConverter();
	}
	
	private function unregisterVideoConverter():Void
	{
		getDelegate().unregisterVideoConverter();
	}
	
	private function getDelegate(p_scope:Object, p_result:Function, p_fault:Function):UnregisterVideoConverterDelegate
	{
		return new UnregisterVideoConverterDelegate(getRelayResponder(p_scope, p_result, p_fault));
	}
	
}