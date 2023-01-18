// implementations
import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
// start class
class com.vpmedia.effects.SnapShot {
	// START CLASS
	public var className:String = "SnapShot";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	private var mc:MovieClip;
	private var bmp:BitmapData;
	private var target:MovieClip;
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	// Constructor
	function SnapShot (m:MovieClip) {
		mc = m;
		bmp = new BitmapData (m._width, m._height, true, 0xFFFFFF);
		bmp.draw (m);
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
	 * <p>Description: </p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function showSnapShot (t:MovieClip):Void {
		target = t;
		target.createEmptyMovieClip ("snapShot", target.getNextHighestDepth ());
		target.snapShot.attachBitmap (bmp, 1);
	}
	/**
	 * <p>Description: </p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function removeSnapShot ():Void {
		removeMovieClip (target.snapShot);
	}
	/**
	 * <p>Description: </p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function takeSnapShot () {
		bmp.draw (mc);
	}
}
