// ConfigScript
// Author: Satori Canton
// http;//www.actionscript.com
//
//This work is licensed under a Creative Commons Attribution 2.5 License.
//http://creativecommons.org/licenses/by/2.5/deed.en

////////////////////////////////////////////////////////////////////////////////
// Imports
////////////////////////////////////////////////////////////////////////////////
import mx.utils.Delegate;
import mx.events.EventDispatcher;

////////////////////////////////////////////////////////////////////////////////
//
// Class: ConfigScript
//
////////////////////////////////////////////////////////////////////////////////
class com.actionscript.configuration.ConfigScript {
	
	//
	// Properties
	//
	private var _lv:LoadVars;
	private var _data:Array;
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Constructor
	//
	////////////////////////////////////////////////////////////////////////////	
	function ConfigScript() {
		
		//EventDispatcher will initialize the event handling methods:
		//dispatchEvent(), addEventListener()
		//removeEventListener() and dispatchQueue()
		EventDispatcher.initialize(this);
		_lv = new LoadVars();
		//We'll use onData instead of onLoad so that we can parse the raw data
		//before the LoadVars object tries (and fails) to parse our data file.
		_lv.onData = Delegate.create(this, this.onDataHandler);
		_lv.onHTTPStatus = Delegate.create(this, this.onHTTPStatusHandler);
	}
	
	//These functions are mixed in by the EventDispatcher
	public function dispatchEvent() {};
	public function addEventListener() {};
	public function removeEventListener() {};
	public function dispatchQueue() {};
	
	////////////////////////////////////////////////////////////////////////////
	// loadConfig() - loads the specified data file
	////////////////////////////////////////////////////////////////////////////
	public function load(uri:String):Void {
		_lv.load(uri);
	}
	
	////////////////////////////////////////////////////////////////////////////
	// getItemValue() - retrieves a value from the _data array by name
	////////////////////////////////////////////////////////////////////////////
	public function getItemValue(s:String):Object {
		//I have a standard of using lowercase "L" as a variable representing array length
		//it can be easily mistaken for the number 1 if you're not aware of this
		var l:Number = _data.length;
		//loop through the data array
		while(l--) {
			if(_data[l][0] == s) {
				//once a match is found, return the value
				return _data[l][1];
			}
		}
		return;
	}
	
	////////////////////////////////////////////////////////////////////////////
	// getBytesLoaded() - returns the current bytes loaded in the LoadVars object
	////////////////////////////////////////////////////////////////////////////
	public function getBytesLoaded():Number {
		return _lv.getBytesLoaded();
	}
	
	////////////////////////////////////////////////////////////////////////////
	// getBytesTotal() - returns the total bytes to be loaded in the LoadVars object
	////////////////////////////////////////////////////////////////////////////
	public function getBytesTotal():Number {
		return _lv.getBytesTotal();
	}
	
	////////////////////////////////////////////////////////////////////////////
	//
	// Private Methods
	//
	////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////
	// onDataHandler() - Parses the data once received from the LoadVars object
	////////////////////////////////////////////////////////////////////////////
	private function onDataHandler(s:String):Void {
		//check that data was returned
		if(s != undefined) {
			//clean up string formatting
			s = cleanString(s);
			//create the _data array
			_data = parseData(s);
			//let anyone interested know that we have data
			dispatchEvent({type:"Data", target:this});
		} else {
			throw new Error("ConfigScript file not found");
		}
	}
	
	////////////////////////////////////////////////////////////////////////////
	// onHTTPStatusHandler() - Supports onHTTPStatus events from the LoadVars object
	////////////////////////////////////////////////////////////////////////////
	private function onHTTPStatusHandler(n:Number):Void {
		dispatchEvent({type:"HTTPStatus", target:this, status:n});
	}
	
	////////////////////////////////////////////////////////////////////////////
	// cleanString() - Calls a number of procedural methods to clean the data up
	//                 before parsing into the _data array
	////////////////////////////////////////////////////////////////////////////
	private function cleanString(s:String):String {
		//these are just procedural functions that clean up the string
		//I may add more functionality here in the future
		s = removeLineBreaks(s);
		s = removeDuplicateSemicolons(s);
		s = stripNonStringSpaces(s);
		return s;
	}
	
	////////////////////////////////////////////////////////////////////////////
	// removeLineBreaks() - removes all line breaks and carrage returns from the
	//                      data while inserting possible missing semicolons
	////////////////////////////////////////////////////////////////////////////
	private function removeLineBreaks(s:String):String {
		//this cleans all new lines and carrage returns from the string
		//split/join is an easy way to parse data from strings
		//this artilce explains more about this technique:
		//http://www.actionscript.com/Article/tabid/54/ArticleID/mastering-the-array/Default.aspx
		return s.split("\n").join(";").split("\r").join("");
	}
	
	////////////////////////////////////////////////////////////////////////////
	// removeDuplicateSemicolons() - removes instances of redundant semicolons
	////////////////////////////////////////////////////////////////////////////
	private function removeDuplicateSemicolons(s:String):String {
		//in the removeLineBreaks method, it's common that the procedure will
		//introduce too many semicolons, so this addresses that problem
		while (s.indexOf(";;") > -1) {
			s = s.split(";;").join(";");
		}
		return s;
	}
	
	////////////////////////////////////////////////////////////////////////////
	// stripNonStringSpaces() - Strips all spaces out of everthing that is not
	//                          enclosed in double quotes
	////////////////////////////////////////////////////////////////////////////
	private function stripNonStringSpaces(s:String):String {
		//white space (spaces outside of strings and line breaks) can cause problems
		//so this function strips all spaces that are not contained inside of double quotes
		var a:Array = s.split("\"");
		//even numberd items in the array represent strings, so we're only stripping
		//spaces from the odd numbered items.
		for(var i:Number = 0; i < a.length; i += 2) {
			a[i] = a[i].split(" ").join("");
		}
		return a.join("\"");
	}
	
	////////////////////////////////////////////////////////////////////////////
	// parseData() - parses the clean data string into a _data array
	////////////////////////////////////////////////////////////////////////////
	private function parseData(s:String):Array {
		//at this point our data "s" should be clean of whitespace and all lines
		//should end with a semicolon.
		var a:Array = s.split(";");
		//now a is a single dimensional array of strings containing name/value pairs
		//as in myProperty=myValue
		var l:Number = a.length;
		while(l--) {
			//split each element in the array by the equals sign to seperate the
			//name/value pairs.
			var a2:Array = a[l].split("=");
			//remove any lingering quotes from strings
			a2[1] = a2[1].split("\"").join("");
			//assign the new array to the old string value in the old array
			//this creates a two dimensional array (an array of arrays)
			a[l] = a2;
		}
		return a;
	}
}