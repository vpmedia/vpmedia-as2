
/**
 *  Rss Service Test
 * 
 *  This is a copy of the Xml service test using the Rss service recently added
 *  to the main com.bumpslide.services namespace.
 * 
 *  Open this file in FlashDevelop and hit the "Quick MTASC Build" button.
 *   
 *  Copyright (c) 2006, David Knape
 *  Released under the open-source MIT license. 
 *  See LICENSE.txt for full license terms.
 * 
 *  Compiles in FlashDevelop. No FLA necessary.  
 *  @mtasc -swf com/bumpslide/example/services/Applet_4_Rss.swf -header 500:400:31:eeeedd -main 
 *  @author David Knape
 */

import com.bumpslide.data.types.RssFeed;
import com.bumpslide.data.types.RssItem;
import com.bumpslide.services.ServiceEvent;
import com.bumpslide.services.RssService;
import com.bumpslide.util.*;

class com.bumpslide.example.services.Applet_4_Rss extends com.bumpslide.core.MtascApplet
{	
	var rss:RssService;
	
	private function init() {			
		super.init();				
		
		sourceUrl = "Applet_4_Rss.as";
		
		// enabled HTML in message text
		_message_txt.html = true;
				
		// instantiate service
		rss = new RssService();
		
		message( 'Loading...');
		
		// listen for service events
		rss.addEventListener( ServiceEvent.EVENT_COMPLETE, Delegate.create( this, serviceComplete ) );
		rss.addEventListener( ServiceEvent.EVENT_ERROR, Delegate.create( this, serviceError) );
		
		// load xml service	
		var params = [ 'http://www.fullasagoog.com/xml/FlashMX.xml']
		rss.load(params);	
	}
	
	function onStageResize() {
		_message_txt._width = stage.width;
	}
	
	function serviceComplete( e:ServiceEvent ) {
		
		Debug.trace('service complete');
		Debug.trace( e.result );
				
		var channel:RssFeed = e.result;
		var items = channel.items;
		var item:RssItem;
				
		var out = '<b>'+channel.title+'</b> ('+items.length+ ' items) <br>';
		out += '<br>'+channel.description+'<br>';
		
		for(var n=0; n<items.length; n++) { 
			if(n>=11) { out+='<br>...'; break; } // max 12 items
			item = items[n];
			out += '<br><u><a href="'+item.link+'">'+item.title+'</a></u>';			
		
		}		
		_message_txt.htmlText = out;		
	}
	
	function serviceError( e:ServiceEvent ) {
		message( "Error: "+e.message);
	}
	
	// All applets must contain a custom version of this method
	// Just change 'SimpleApplet' to whatever your class name is
	static function main(root_mc:MovieClip) : Void {			
		ClassUtil.applyClassToObj( Applet_4_Rss, root_mc );		
	}
	
}