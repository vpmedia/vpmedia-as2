import com.bumpslide.util.Debug;
/**
* A simple RSS service that returns the metadata and items in an RSS feed
* 
*/
class com.bumpslide.services.RssService extends com.bumpslide.services.XmlService
{
	
	var defaultUrl:String = 'http://rss.cnn.com/rss/cnn_topstories.rss';
	
	// URL is first arument passed to 'load'
	function get url () {
		return args[0] != null ? args[0] : defaultUrl;
	}
	
	// url definition
	function buildUrl () {
		return url;
	}
	
	function handleResult() {	
		
		result = {};
				
		var items:Array = [];		
		
		var searchNodes:Array = xml.firstChild.firstChild.childNodes;
		var potentialItemNodes:Array = searchNodes;
		
		// if RDF (RSS1), look for items elsewhere
		if(xml.firstChild.nodeName.indexOf( 'rdf' ) !=-1 ) {
			potentialItemNodes = xml.firstChild.childNodes;			
		}
		
		for(var n=0; n<searchNodes.length; n++) {			
			switch( searchNodes[n].nodeName ) {				
				case 'title':
				case 'link':
				case 'description':
				case 'pubData':
				case 'language':
				case 'generator':					
					result[ searchNodes[n].nodeName ] = searchNodes[n].firstChild.nodeValue;
					break;
			}
		}		
		
		for(var n=0; n<potentialItemNodes.length; n++) {			
			if( potentialItemNodes[n].nodeName == 'item' ) {
				items.push( potentialItemNodes[n] );
			}
		}	
		
		result.items = nodesToObjects( items );		
	}
	
	
}
