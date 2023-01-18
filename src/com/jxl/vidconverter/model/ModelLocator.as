/*
	ModelLocator
	
	Holds all application specific model data.  For now, only holds the video observer.
	This Observer class basically watches the server for specific messages, and dispatches
	events if a particular one of interest is found.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import mx.events.EventDispatcher;
import com.jxl.vidconverter.observers.VideoConverterObserver;

[Event("videoConverterObserverChanged")]
class com.jxl.vidconverter.model.ModelLocator
{
	public static function getInstance():ModelLocator
	{
		if(inst == null)
		{
			inst = new ModelLocator();
			inst.__ed = {};
			EventDispatcher.initialize(inst.__ed);
		}
		return inst;
	}
	
	public function addEventListener(eventName:String, list:Object):Void
	{
		__ed.addEventListener(eventName, list);
	}
	
	public function removeEventListener(eventName:String, list:Object):Void
	{
		__ed.removeEventListener(eventName, list);
	}
	
	public function get videoConverterObserver():VideoConverterObserver
	{
		return __videoConverterObserver;
	}
	
	public function set videoConverterObserver(val:VideoConverterObserver):Void
	{
		if(__videoConverterObserver != val)
		{
			__videoConverterObserver = val;
			__ed.dispatchEvent({type: "videoConverterObserverChanged", target: this});
		}
	}
	
	private static var inst:ModelLocator;
	
	private var __ed:Object;
	private var __videoConverterObserver:VideoConverterObserver;
	
}