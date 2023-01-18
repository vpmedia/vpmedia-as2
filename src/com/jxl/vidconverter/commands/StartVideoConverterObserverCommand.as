/*
	StartVideoConverterObserverCommand
    
	Makes the VideoConverter service start listening to server requests.  Think of it
	as an "addEventListener" for the client to server.
    
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
import com.jxl.vidconverter.events.StartVideoConverterObserverEvent;
import com.jxl.vidconverter.model.ModelLocator;
import com.jxl.vidconverter.observers.VideoConverterObserver;
import com.jxl.vidconverter.constants.VideoConverterConstants;

class com.jxl.vidconverter.commands.StartVideoConverterObserverCommand extends JXLCommand
{
	public function execute(event:ArpEvent):Void
	{
		DebugWindow.debugHeader();
		DebugWindow.debug("StartVideoConverterObserverCommand::execute");
		super.execute(event);
		
		var model:ModelLocator = ModelLocator.getInstance();
		if(model.videoConverterObserver == null)
		{
			model.videoConverterObserver = new VideoConverterObserver("netConnection",
																	  VideoConverterConstants.defaultInstanceName);
		}
		model.videoConverterObserver.startObserving();		
	}
}