
/**
 *  JSON Service Test
 * 
 *  Open this file in FlashDevelop and hit the "Quick MTASC Build" button.
 *   
 *  Copyright (c) 2007, David Knape
 *  Released under the open-source MIT license. 
 *  See LICENSE.txt for full license terms.
 * 
 *  Compiles in FlashDevelop. No FLA necessary.  
 *  @mtasc -swf classes/com/bumpslide/example/services/Applet_5_Json.swf -header 500:400:31:eeeedd -main 
 */


import com.bumpslide.example.services.*;
import com.bumpslide.services.*;
import com.bumpslide.util.*;

class com.bumpslide.example.services.Applet_5_Json extends com.bumpslide.core.MtascApplet
{	
	var svc:JsonService;
	
	private function Applet_5_Json() {	
		
		super();
		
		sourceUrl = "Applet_5_Json.as";
		
		// instantiate service
		svc = new JsonService();
		
		// listen for service events
		svc.addEventListener( ServiceEvent.EVENT_COMPLETE, Delegate.create( this, serviceComplete ) );
		svc.addEventListener( ServiceEvent.EVENT_ERROR, Delegate.create( this, serviceError) );
		
		// call method 'sayHello'
		svc.loadUrl( "json_data.js" );
	}
	
	function serviceComplete( e:ServiceEvent ) {
			
		var len = e.result.length;
		for( var n=0; n<len; n++) {			
			message( e.result[n] );
		}
	}
	
	function serviceError( e:ServiceEvent ) {
		message( "Error: "+e.message);
	}
	
	// All applets must contain a custom version of this method
	// Just change 'SimpleApplet' to whatever your class name is
	static function main(root_mc:MovieClip) : Void {			
		ClassUtil.applyClassToObj( Applet_5_Json, root_mc );		
	}
	
}