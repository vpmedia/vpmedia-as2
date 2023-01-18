
/**
 *  Xml Service Test
 * 
 *  Open this file in FlashDevelop and hit the "Quick MTASC Build" button.
 *   
 *  Copyright (c) 2006, David Knape
 *  Released under the open-source MIT license. 
 *  See LICENSE.txt for full license terms.
 * 
 *  Compiles in FlashDevelop. No FLA necessary.  
 *  @mtasc -swf com/bumpslide/example/services/Applet_2_Xml.swf -header 500:400:31:eeeedd -main 
 *  @author David Knape
 */

import com.bumpslide.example.services.*;
import com.bumpslide.services.*;
import com.bumpslide.util.*;

class com.bumpslide.example.services.Applet_2_Xml extends com.bumpslide.core.MtascApplet
{	
	var svc:TestXmlService;
	
	private function Applet_2_Xml() {	
		
		super();		
		
		sourceUrl = "Applet_2_Xml.as";
		
		// enabled HTML in message text
		_message_txt.html = true;
				
		FramerateMonitor.display( this );
				
		// instantiate service
		svc = new TestXmlService();
		
		// listen for service events
		svc.addEventListener( ServiceEvent.EVENT_COMPLETE, Delegate.create( this, serviceComplete ) );
		svc.addEventListener( ServiceEvent.EVENT_ERROR, Delegate.create( this, serviceError) );
		
		// load xml service
		svc.load();		
	}
	
	function serviceComplete( e:ServiceEvent ) {
		Debug.trace('service complete');
		Debug.trace( e.result );
		
		var items:Array = e.result;		
		var htmlMessage = '<br><font face="Verdana"><b>Loaded '+items.length+ ' items:</b>';				
		for(var n=0; n<items.length; n++) { 			
			htmlMessage += '<br><u><a href="'+items[n].link+'">'+items[n].title+'</a></u>';			
		}		
		_message_txt.htmlText = htmlMessage;		
	}
	
	function serviceError( e:ServiceEvent ) {
		message( "Error: "+e.message);
	}
	
	// All applets must contain a custom version of this method
	// Just change 'SimpleApplet' to whatever your class name is
	static function main(root_mc:MovieClip) : Void {			
		ClassUtil.applyClassToObj( Applet_2_Xml, root_mc );		
	}
	
}