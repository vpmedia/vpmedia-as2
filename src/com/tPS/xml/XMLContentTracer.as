/**
 * Traces CDATA Contents
 * within given XML as String
 * @author tPS
 */
class com.tPS.xml.XMLContentTracer {
	
	static public function trace( $xml:XML ) : String {
		var contents:String = recursiveTrack($xml);		
		return contents;
	}
	
	static private function recursiveTrack($xml:XML, loc:String) : String{		
		var content:String;		
		
		//check if node is Textnode
		if($xml.nodeType == 3){
			content = $xml.nodeValue;
		}else{
		//else check recursive childNodes
			var i:Number = -1;
			while(++i < $xml.childNodes.length){
				content += "\r" + recursiveTrack($xml.childNodes[i], loc + " - " + $xml.nodeName);
			}
		}
		return loc + "\r" + content;
	}
}