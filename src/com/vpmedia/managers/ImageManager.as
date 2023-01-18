import flash.display.BitmapData;
import mx.events.EventDispatcher;
import com.vpmedia.Delegate;
/**
 * ImageManager
 * Copyright © 2006 András Csizmadia
 * Copyright © 2006 VPmedia
 * http://www.vpmedia.hu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 * 
 * Project: ImageManager
 * File: ImageManager.as
 *
 * @author Martijn de Visser, Extended by András Csizmadia
 * @usage 
 * <code>
 * var loader:ImageLoader = new ImageLoader();
 * loader.loadImage( "some_image.jpg", image_mc );
 * </code>
 */
import com.vpmedia.utils.DrawingUtil;
import com.vpmedia.text.TextContainer;
class com.vpmedia.managers.ImageManager extends MovieClip {
	private var mLoader:MovieClipLoader;
	// class
	public var className:String = "ImageManager";
	public var classPackage:String = "com.vpmedia.managers";
	public var version:String = "2.0.0";
	public var author:String = "Martijn de Visser, András Csizmadia";
	public var scope:MovieClip;
	public var holder:MovieClip;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	private var itemHolder:MovieClip;
	/**
	 * Constructor
	 */
	public function ImageManager (__scope) {
		this.scope = __scope;
		this.mLoader = new MovieClipLoader ();
		EventDispatcher.initialize (this);
		addListener (this);
	}
	/**
	 * Pass along any events from internally used MovieClipLoader
	 */
	public function addListener (inListener:Object) {
		this.mLoader.addListener (inListener);
	}
	public function removeListener (inListener:Object) {
		this.mLoader.removeListener (inListener);
	}
	/**
	 * CreateWithBorderFunction
	 */
	public static function createBorder (target_mc) {
		var img_border_out:MovieClip = target_mc._parent.createEmptyMovieClip ("out_mc", target_mc._parent.getNextHighestDepth ());
		var img_border_in:MovieClip = target_mc._parent.createEmptyMovieClip ("in_mc", target_mc._parent.getNextHighestDepth ());
		target_mc.swapDepths (target_mc._parent.getNextHighestDepth ());
		//trace ("onLoadInit" + ", " + o.image);
		var iw = Math.floor (target_mc._width);
		var ih = Math.floor (target_mc._height);
		DrawingUtil.drawShape (img_border_out, 0, 0, iw + 4, ih + 4, 0x000000, 100);
		DrawingUtil.drawShape (img_border_in, 1, 1, iw + 2, ih + 2, 0xfefefe, 100);
		target_mc._y = 2;
		target_mc._x = 2;
	}
	public static function createTitle (__target_mc, __title_text:String) {
		var __refText = TextContainer.drawTextField (__target_mc._parent, __title_text, 5, __target_mc._y + __target_mc._height + 7, __target_mc._width - 10, 100, 0x000000);
		var t = __target_mc._parent.bg_mc;
		var x = 0;
		var y = __target_mc._y+2;
		var w = __target_mc._width;
		var h = __refText._height + 5;
		trace (h + ": " + __refText._height);
		var c = 0xCCCCCC;
		var a = 100;
		if (__target_mc._parent.out_mc) {
			w += 4;
		}
		DrawingUtil.drawShape (t, x, y, w, h, c, a);
	}
	/**
	 * Triggered by MovieClipLoader
	 */
	private function onLoadInit (target_mc:MovieClip):Void {
		var timerMS:Number = target_mc.completeTimer - target_mc.startTimer;
		var bitmap:BitmapData = new BitmapData (target_mc._width, target_mc._height, true, 0x000000);
		bitmap.draw (target_mc);
		//bitmap.dispose();	
		var img:MovieClip = target_mc._parent.createEmptyMovieClip ("imageloader_smooth_mc", target_mc._parent.getNextHighestDepth ());
		//
		unloadMovie (target_mc);
		//this.mLoader.unloadClip (target_mc);
		target_mc.removeMovieClip ();
		//
		img.attachBitmap (bitmap, img.getNextHighestDepth (), "auto", true);
		this.itemHolder = img;
		//
		this.dispatchEvent ({type:"onLoadInit", target:this, image:img, time:timerMS});
	}
	private function onLoadError (target_mc:MovieClip, errorCode:String, httpStatus:Number) {
		this.dispatchEvent ({type:"onLoadError", target:this, image:target_mc, errorCode:errorCode, httpStatus:httpStatus});
	}
	private function onLoadProgress (target_mc:MovieClip, loadedBytes:Number, totalBytes:Number) {
		this.dispatchEvent ({type:"onLoadProgress", target:this, image:target_mc, loadedBytes:loadedBytes, totalBytes:totalBytes});
	}
	private function onLoadStart (target_mc:MovieClip) {
		target_mc.startTimer = getTimer ();
		this.dispatchEvent ({type:"onLoadStart", target:this, image:target_mc});
	}
	private function onLoadComplete (target_mc:MovieClip, httpStatus:Number) {
		target_mc.completeTimer = getTimer ();
		this.dispatchEvent ({type:"onLoadComplete", target:this, image:target_mc});
	}
	/**
	 * Starts loading an image.
	 */
	public function load (inImage:String, target_mc:MovieClip):Void {
		// create mc to load bitmap in
		var raw:MovieClip = target_mc.createEmptyMovieClip ("imageloader_raw_mc", target_mc.getNextHighestDepth ());
		// start loader
		this.mLoader.loadClip (inImage, raw);
	}
	public function unload (target_mc:MovieClip):Void {
		this.mLoader.unloadClip (target_mc);
	}
	/**
	 * @return Package and class name
	 */
	public function toString ():String {
		return "ImageLoader";
	}
}
