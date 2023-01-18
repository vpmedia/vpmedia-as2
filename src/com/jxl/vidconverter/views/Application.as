/*
	Application
	
	Top level view that sets up all the plumbing.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import mx.utils.Delegate;

// ARP-i-fy!
import com.jxl.vidconverter.vo.ValueObjects;
import org.osflash.arp.CommandRegistryTemplate;
import com.jxl.vidconverter.controller.Controller;

import com.jxl.vidconverter.views.VideoConverter;

class com.jxl.vidconverter.views.Application extends MovieClip
{
	public var createClassObject:Function;
	public var createObject:Function;
	
	private var valueObjects:ValueObjects;
	private var controller:Controller;
	private var vidConverter:VideoConverter;
	
	public function initApp():Void
	{
		Stage.scaleMode = "noScale";
		Stage.align = "TL";
		
		ssCore.init();
		ssDefaults.synchronousCommands = true;
	
		valueObjects = ValueObjects.getInstance();
		valueObjects.registerValueObjects();
		
		// setup our CommandRegistry
		controller = Controller.getInstance();
		controller.registerApp(this);
		
		createClassObject(VideoConverter, "vidConverter", 0);
	}
}