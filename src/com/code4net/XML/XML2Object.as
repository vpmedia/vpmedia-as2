import com.code4net.XML.ParserXML;
import com.code4net.system.SmartCallback;

class com.code4net.XML.XML2Object {
	public var parsedObj:Object; 
	public var archiveToLoad:String;
	public var onLoad:Function;
	
	private var myParser:ParserXML;
	
	public function XML2Object() {
		init.apply(this,arguments);
	}
	
	private function init() {
		parsedObj = new Object();
		myParser = new ParserXML();
	}
	
	public function load (archive:String) {
		archiveToLoad = archive;
		var sc:SmartCallback = new SmartCallback(this,_onLoad);
		myParser.init(parsedObj,sc);
		myParser.load(archiveToLoad);
	}
	
	private function _onLoad (success) {
		delete myParser;
		onLoad.call(this,success);
	}
}