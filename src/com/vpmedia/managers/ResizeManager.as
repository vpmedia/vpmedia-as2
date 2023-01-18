import mx.events.EventDispatcher;
import com.vpmedia.Delegate;
// Start
class com.vpmedia.managers.ResizeManager extends MovieClip {
	// START CLASS
	/**
	 * <p>Description: Decl.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public var className:String = "ResizeManager";
	public var classPackage:String = "com.vpmedia.managers";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	/**
	 * <p>Description: Constructor</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	function ResizeManager() {
		EventDispatcher.initialize(this);
	}
	/**
	 * <p>Description: Get Class version</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getVersion():String {
		//trace ("%%" + "getVersion" + "%%");
		var __version = this.version;
		return __version;
	}
	/**
	 * <p>Description: Get Class name</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function toString():String {
		return ("["+className+"]");
	}
	/**
	 * <p>Description: Desc</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public static function resizeInArea(t:MovieClip, w:Number, h:Number):Void {
		var ow = t._width;
		var oh = t._height;
		if (ow>=oh) {
			var multi = w/ow;
		} else {
			var multi = h/oh;
		}
		t._width = multi*ow;
		t._height = multi*oh;
	}
	/**
	 * <p>Description: Desc</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public static function stretchInArea(t:MovieClip, w:Number, h:Number):Void {
		var ow = t._width;
		var oh = t._height;
		var wDiff = Math.abs(ow-w);
		var hDiff = Math.abs(oh-h);
		if (w<h) {
			var multi = w/ow;
		} else {
			var multi = h/oh;
		}
		t._width = multi*ow;
		t._height = multi*oh;
	}
	// END CLASS
}
