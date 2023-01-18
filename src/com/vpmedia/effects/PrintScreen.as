// implementations
import flash.filters.*;
import flash.geom.*;
import flash.display.*;
import mx.transitions.*;
import mx.transitions.easing.*;
// start class
class com.vpmedia.effects.PrintScreen extends Object {
	// START CLASS
	public var className:String = "PrintScreen";
	public var classPackage:String = "com.vpmedia.effects";
	public var version:String = "1.0.0";
	public var author:String = "András Csizmadia";
	//
	// asbroadcaster
	public var addListener:Function;
	public var broadcastMessage:Function;
	// printscreen
	private var id:Number;
	public var record:LoadVars;
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	// Constructor
	function PrintScreen() {
		AsBroadcaster.initialize(this);
	}
	/**
	 * <p>Description: print specified movie clip with coordinates</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function print(mc:MovieClip, w:Number, h:Number, pid:Number) {
		broadcastMessage("onStart", mc);
		var bmp:BitmapData = new BitmapData(w, h, false);
		record = new LoadVars();
		record.width = w;
		record.height = h;
		record.id = pid;
		record.cols = w;
		record.rows = 0;
		bmp.draw(mc);
		id = setInterval(copysource, 1, this, mc, bmp);
	}
	/**
	 * copy bit from image
	 */
	private function copysource(scope, movie, bit) {
		var pixel:Number;
		var str_pixel:String;
		scope.record["px"+scope.record.rows] = new Array();
		for (var a = 0; a<bit.width; a++) {
			pixel = bit.getPixel(a, scope.record.rows);
			scope.record["px"+scope.record.rows].push(pixel);
		}
		scope.broadcastMessage("onProgress", movie, scope.record.rows, bit.height);
		// send back the progress status
		scope.record.rows += 1;
		if (scope.record.rows>=bit.height) {
			clearInterval(scope.id);
			trace("w:"+scope.record.width+",h:"+scope.record.height+",id:"+scope.record.id+",cols:"+scope.record.cols+",rows:"+scope.record.rows);
			scope.broadcastMessage("onComplete", movie, scope.record);
			// completed!
			bit.dispose();
		}
	}
}
