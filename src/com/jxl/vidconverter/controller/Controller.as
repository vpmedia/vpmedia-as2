/*
	Controller
    
	The ARP controller.  Registers events to trigger certain commands.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import org.osflash.arp.CommandRegistryTemplate;

import com.jxl.vidconverter.events.ConnectEvent;
import com.jxl.vidconverter.events.ConvertVideoEvent;
import com.jxl.vidconverter.events.VideoConversionSuccessEvent;
import com.jxl.vidconverter.events.VideoConversionFailureEvent;
import com.jxl.vidconverter.events.StartVideoConverterObserverEvent;
import com.jxl.vidconverter.events.StopVideoConverterObserverEvent;
import com.jxl.vidconverter.events.RegisterVideoConverterEvent;
import com.jxl.vidconverter.events.UnregisterVideoConverterEvent;
import com.jxl.vidconverter.events.CopyFileEvent;

import com.jxl.vidconverter.commands.ConnectCommand;
import com.jxl.vidconverter.commands.ConvertVideoCommand;
import com.jxl.vidconverter.commands.VideoConversionSuccessCommand;
import com.jxl.vidconverter.commands.VideoConversionFailureCommand;
import com.jxl.vidconverter.commands.StartVideoConverterObserverCommand;
import com.jxl.vidconverter.commands.StopVideoConverterObserverCommand;
import com.jxl.vidconverter.commands.RegisterVideoConverterCommand;
import com.jxl.vidconverter.commands.UnregisterVideoConverterCommand;
import com.jxl.vidconverter.commands.CopyFileCommand;



class com.jxl.vidconverter.controller.Controller extends CommandRegistryTemplate
{
	private static var inst:Controller; 	// instance of self
	
	public static function getInstance():Controller
	{
		if (inst == null) inst = new Controller();
		return inst;
	}	
	
	private function addCommands()
	{
		addCommand(ConnectEvent.CONNECT, 									ConnectCommand);
		addCommand(ConvertVideoEvent.CONVERT_VIDEO, 						ConvertVideoCommand);
		addCommand(VideoConversionSuccessEvent.SUCCESS, 					VideoConversionSuccessCommand);
		addCommand(VideoConversionFailureEvent.FAILURE, 					VideoConversionFailureCommand);
		addCommand(StartVideoConverterObserverEvent.START_OBSERVING, 		StartVideoConverterObserverCommand);
		addCommand(StopVideoConverterObserverEvent.STOP_OBSERVING, 			StopVideoConverterObserverCommand);
		addCommand(RegisterVideoConverterEvent.REGISTER, 					RegisterVideoConverterCommand);
		addCommand(UnregisterVideoConverterEvent.UNREGISTER,				UnregisterVideoConverterCommand);
		addCommand(CopyFileEvent.COPY_FILE, 								CopyFileCommand);
	}
}
