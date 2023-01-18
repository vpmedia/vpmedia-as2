/*
	VideoConversionFailureCommand
    
	If the video failed to convert, this command runs.
    
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
import com.jxl.vidconverter.events.VideoConversionFailureEvent;
import com.jxl.vidconverter.business.VideoConversionFailureDelegate;

class com.jxl.vidconverter.commands.VideoConversionFailureCommand extends JXLCommand
{
	public function execute(event:ArpEvent):Void
	{
		super.execute(event);
		
		getDelegate().videoConversionFailure(VideoConversionFailureEvent(event).videoName);
	}
	
	private function getDelegate(p_scope:Object, p_result:Function, p_fault:Function):VideoConversionFailureDelegate
	{
		return new VideoConversionFailureDelegate(getRelayResponder(p_scope, p_result, p_fault));
	}
	
}