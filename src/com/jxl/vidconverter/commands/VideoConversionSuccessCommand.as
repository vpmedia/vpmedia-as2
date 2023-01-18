/*
	VideoConversionSuccessCommand
    
	If the video converted successfully, this command runs.
    
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
import com.jxl.vidconverter.events.VideoConversionSuccessEvent;
import com.jxl.vidconverter.business.VideoConversionSuccessDelegate;
import com.jxl.vidconverter.vo.fcs.FCEncodeInfo;

class com.jxl.vidconverter.commands.VideoConversionSuccessCommand extends JXLCommand
{
	public function execute(event:ArpEvent):Void
	{
		super.execute(event);
		
		getDelegate().videoConversionSuccess(VideoConversionSuccessEvent(event).encodeInfo);
	}
	
	private function getDelegate(p_scope:Object, p_result:Function, p_fault:Function):VideoConversionSuccessDelegate
	{
		return new VideoConversionSuccessDelegate(getRelayResponder(p_scope, p_result, p_fault));
	}
	
}