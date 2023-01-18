// implementations
import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
//
import mx.events.EventDispatcher;
import com.vpmedia.Delegate;
// Define Class
class com.vpmedia.effects.Pattern {
	// START CLASS
	public var className:String = "Pattern";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	public var bitmapData:BitmapData;
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	// Constructor
	function Pattern () {
		EventDispatcher.initialize (this);
	}
	/**
	 * <p>Description: Get Class name</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function toString ():String {
		return ("[" + className + "]");
	}
	/**
	 * <p>Description: Get Class version</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getVersion ():String {
		//trace ("%%" + "getVersion" + "%%");
		var __version = this.version;
		return __version;
	}
	/**
	 * <p>Description: setPattern</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function setPattern (__bitmapURL:String):Void {
		this.bitmapData = BitmapData.loadBitmap (__bitmapURL);
	}
	/**
	 * <p>Description: createPattern</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function createPattern (scope):Void {
		if (!scope) {
		  var scope = _level0;
		}
		with (scope) {
			beginBitmapFill (this.bitmapData);
			moveTo (0, 0);
			lineTo (Stage.width, 0);
			lineTo (Stage.width, Stage.height);
			lineTo (0, Stage.height);
			lineTo (0, 0);
			endFill ();
		}
	}
	// END CLASS
}
