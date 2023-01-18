/*
	Services
    
	Default ServiceLocator.  For now, only holds the NetConnection service to Flashcom.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import org.osflash.arp.ServiceLocatorTemplate;

import com.jxl.net.JXLConnection;

class com.jxl.vidconverter.business.Services extends ServiceLocatorTemplate
{
	public static function getInstance():ServiceLocatorTemplate
	{
		if(inst == null) inst = new Services();
		return inst;
	}
	
	private function addServices():Void
	{
		addService("netConnection", new JXLConnection());
	}
	
	private static var inst:ServiceLocatorTemplate;
}