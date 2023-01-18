import com.fear.xml.SimpleXML;
import com.fear.yahoo.services.SearchUtil;

class com.fear.yahoo.services.impl.SimpleSearchResultXML extends XML
{
	private var $queryURL:String;
	private var $parseHandler:Function;
	private var $context:Object;
	private var $sender:Object;
	private var $offset:Number;
	
	public function SimpleSearchResultXML(sender, parseHandler:Function, needle:String, searchType:String)
	{
		this.ignoreWhite = true;
		var zip = arguments[4];
		this.$sender = sender;
		this.$context = arguments[5];
		this.$offset = arguments[6];
		this.$parseHandler = parseHandler;
		//this.onLoad = doMe;
		this.$queryURL = SearchUtil.getServiceURL(needle, searchType, zip, this.$offset);
		//_root.debug.htmlText = 'parseHandler:'+parseHandler
		this.load(this.$queryURL);
	}
	public function onLoad(success)
	{
		this.$parseHandler(this.$sender, success, this, this.$context);
	}
}