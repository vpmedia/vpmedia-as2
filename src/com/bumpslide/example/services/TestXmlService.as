
import com.bumpslide.services.*;
import com.bumpslide.util.Debug;

class com.bumpslide.example.services.TestXmlService extends XmlService {


	function buildUrl () {
		return "http://api.flickr.com/services/feeds/photos_public.gne?id=14007096@N00&format=rss_200";
	}	
	
	function handleResult() {
		
		// get all item nodes and store in an array
		// we could use XPath here, but this is cheaper
		var items:Array = [];	
		var searchNodes:Array = xml.firstChild.firstChild.childNodes;
		
		for(var n=0; n<searchNodes.length; n++) {
			if(searchNodes[n].nodeName=='item') {
				items.push( searchNodes[n] );
			}
		}
		
		// use our handy nodesToObject function to get a nice array of 
		// anonymous objects instead of nodes
		result = nodesToObjects( items );
	}
	
}
