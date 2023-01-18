/*
	JXLDelegate
    
    Base class for ARP business delegates.  Mainly used
	for handling the common constructor task of capturing
	the responder.  This also gets around some casting
	challenges, ecspecially in Cairngorm's case where
	one uses their own Responder class/interface.
    
    Created by Jesse R. Warden a.k.a. "JesterXL"
	jesterxl@jessewarden.com
	http://www.jessewarden.com
	jesse@universalmind.com
	http://www.universalmind.com
	
	This is release under a Creative Commons license. 
    More information can be found here:
    
    http://creativecommons.org/licenses/by/2.5/
*/

import mx.rpc.Responder;
//import org.osflash.arp.ServiceLocatorTemplate;
import com.jxl.arp.JXLRelayResponder;

	
class com.jxl.arp.JXLDelegate
{
	private var responder:Responder;
	private var service:Object;
	
	public function JXLDelegate(p_responder:Responder)
	{
		//service = ServiceLocatorTemplate.getInstance();
		responder = p_responder;
	}
}