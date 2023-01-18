/*
	ConvertVideoCommand
    
	This command will convert a video to an FLV.
    
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
import com.jxl.vidconverter.events.ConvertVideoEvent;
import com.jxl.vidconverter.business.ConvertVideoDelegate;
import com.jxl.vidconverter.vo.fcs.FCEncodeInfo;

class com.jxl.vidconverter.commands.ConvertVideoCommand extends JXLCommand
{
	public function execute(event:ArpEvent):Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("ConvertVideoCommand::execute");
		
		super.execute(event);
		
		switch(event.type)
		{
			case ConvertVideoEvent.CONVERT_VIDEO:
				convertVideo(ConvertVideoEvent(event).encodeInfo);
				break;
		}
	}
	
	private function convertVideo(p_encodeInfo:FCEncodeInfo):Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("ConvertVideoCommand::convertVideo, p_encodeInfo.videoName: " + p_encodeInfo.videoName);
		
		getDelegate().convertVideo(p_encodeInfo);
	}
	
	private function getDelegate(p_scope:Object, p_result:Function, p_fault:Function):ConvertVideoDelegate
	{
		return new ConvertVideoDelegate(getRelayResponder(p_scope, p_result, p_fault));
	}
	
}