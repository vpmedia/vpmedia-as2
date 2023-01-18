/*
	CopyFileCommand
    
	If you need to copy a file from one diretory to another,
	this is the Command to use.
    
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
import com.jxl.vidconverter.events.CopyFileEvent;
import com.jxl.vidconverter.business.CopyFileDelegate;
import com.jxl.vidconverter.vo.fcs.FCEncodeInfo;

class com.jxl.vidconverter.commands.CopyFileCommand extends JXLCommand
{
	public function execute(event:ArpEvent):Void
	{
		super.execute(event);
		
		copyFile(CopyFileEvent(event).encodeInfo);
	}
	
	private function copyFile(p_encodeInfo:FCEncodeInfo):Void
	{
		getDelegate().copyFile(p_encodeInfo);
	}
	
	private function getDelegate(p_scope:Object, p_result:Function, p_fault:Function):CopyFileDelegate
	{
		return new CopyFileDelegate(getRelayResponder(p_scope, p_result, p_fault));
	}
	
}