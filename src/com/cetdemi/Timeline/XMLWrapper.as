import com.cetdemi.Timeline.*;

/**
 * Provides extra functionality to XML object
 *
 * @revision $Id XMLWrapper.cvs 2005-01-21 20:52 Rev$
 */
class com.cetdemi.Timeline.XMLWrapper extends XML
{
	//The location of the base URL
	static var _location:String = "";
	function XMLWrapper()
	{
		
	}
	// Sets the base URL to be preprended to XML.load
	// @param location The base location of the XML files
	static function setBaseLocation(location:String):Void
	{
		_location = location;
	}
	
	// Loads and eliminates cache
	// @param file The XML file to load
	function load(file)
	{
		var ndate = new Date();
		var nocache = ndate.getTime() add random(1000);
		ignoreWhite = true;
		super.load(_location + file/* + '&nocache=' + nocache*/);
	}
}