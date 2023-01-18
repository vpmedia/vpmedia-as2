import com.bumpslide.ui.IResizable;
import com.bumpslide.util.*;
import com.bumpslide.events.Event;
import mx.events.EventDispatcher;

/**
* Loads and Handles Resizing of an Image
* 
* Uses Flash 8 Bitmapdata Smoothing
* 
* @author David Knape
*/
class com.bumpslide.ui.ResizableImage extends MovieClip implements IResizable
{
	
	static var EVENT_IMAGE_LOADED : String = "onImageLoaded";
	static var EVENT_IMAGE_PROGRESS : String = "onImageProgress";
	static var EVENT_IMAGE_NOT_FOUND : String = "onImageNotFound";
	
	var holder_mc:MovieClip;
	var image_mc:MovieClip;
	var mask_mc:MovieClip;
	
	private var loader:QueuedLoader;	
	private var tweenCompleteCount = 0;
	private var _imageLoaded:Boolean = false;
	
	private var targetWidth:Number;
	private var targetHeight:Number;
	
	private var actualWidth:Number;
	private var actualHeight:Number;
	
	private var _crop : Boolean = false;
	private var _allowStretching : Boolean = true;
	private var _applySmoothing : Boolean = true;
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	/**
	* Static method to create an instance
	* 
	* No need to create a dummy clip in our library this way.
	* 
	* @param	instance_name
	* @param	timeline_mc
	* @return
	*/
	public static function create( instance_name:String, timeline_mc:MovieClip ) : ResizableImage {
		return ResizableImage( ClassUtil.createMovieClip(instance_name, timeline_mc, ResizableImage) );
	} 
	
	/**
	* Constructor
	*/
	function ResizableImage() {
		super();
		
		// initialize EventDispatcher
		EventDispatcher.initialize(this);
		
		_focusrect = false;
		tabEnabled = false;
		
		loader = new QueuedLoader();
		loader.addEventListener( 'onLoadError', this );
		reset();
	}
	
	/**
	* Returns whether or not smoothing is applied
	* @return
	*/
	public function get applySmoothing () : Boolean {
		return _applySmoothing;
	}
	
	/**
	* whether or not smoothing is applied
	* @param	doSmooth
	*/
	public function set applySmoothing (doSmooth:Boolean)  {
		_applySmoothing = doSmooth;
		updateSize();
	}
	
	/**
	* Crop the image, or not 
	*/
	public function set crop (val:Boolean)  {
		_crop = val;
		updateSize();
	}
	
	/**
	* Crop the image, or not 
	*/
	public function get crop () : Boolean {
		return _crop;
	}
	
	/**
	* whether or not image can be stretched beyond it's original height
	* @return
	*/
	public function get allowStretching () : Boolean {
		return _allowStretching;
	}
	
	/**
	* whether or not image can be stretched beyond it's original height
	* @return
	*/
	public function set allowStretching (doStretch:Boolean)  {
		_allowStretching = doStretch;
		updateSize();
	}
	
	/**
	* Whether or not image has been loaded
	* @return
	*/
	public function get imageLoaded () : Boolean {
		return _imageLoaded;		
	}
	
	
	/**
	* Resize the image
	* 
	* @param	w
	* @param	h
	*/
	function setSize( w:Number, h:Number ) {
		
		if(!imageLoaded) return;
		
		targetWidth = Math.round(w);
		targetHeight = Math.round(h);
		
		updateSize();		
	}
	
	/**
	* Resets the image loader
	*/	
	function reset() {		
		// clear any pending loads
		loader.unloadItem( image_mc );
		loader.clearQueue();	
		_imageLoaded = false;
		
		holder_mc = createEmptyMovieClip('holder_mc', 1);
		image_mc = holder_mc.createEmptyMovieClip('image_mc', 1);		
		mask_mc = createEmptyMovieClip( 'mask_mc', 2);
		Draw.box( mask_mc, 100, 100, 0x00ff00, 0 );
		holder_mc.setMask( mask_mc );
		
		holder_mc._visible = false;
		holder_mc._x = holder_mc._y = -1;
	}
	
	/**
	* onLoadError Handler
	*/
	private function onLoadError() {
		dispatchEvent( new Event( ResizableImage.EVENT_IMAGE_NOT_FOUND, this ) );
		Debug.error("[ResizableImage] ERROR:");
		Debug.error( arguments );
	}
	
	/**
	* Loads an images from a URL
	* @param	url
	*/
	function loadImage(url:String) {		
		reset();
		loader.loadItem(image_mc, url, onImageLoadProgress, onImageLoadComplete, this ); 		
	}	
	
	/**
	* Notifies listeners of image load progress
	*/
	private function onImageLoadProgress(l,t) 
	{			
		var e:Object = new Event(ResizableImage.EVENT_IMAGE_PROGRESS, this);
		e.bytesLoaded = l;
		e.bytesTotal = t;
		dispatchEvent(e);
	}
	
	/**
	* once image is loaded, we update size and notify liteners
	*/
	private function onImageLoadComplete() 
	{	
		_imageLoaded = true;
		holder_mc._visible = true;	
		
		if(targetWidth==null) targetWidth = holder_mc._width;
		if(targetHeight==null) targetHeight = holder_mc._height;
		
		// bug fix?
		holder_mc.setMask( mask_mc );
		updateSize();
		
		dispatchEvent(new Event(ResizableImage.EVENT_IMAGE_LOADED, this));
	}
	
	/**
	* updates image size based on current target dimensions
	*/
	private function updateSize() {
		
		if(!imageLoaded) return;
		
		// target dimensions for scaling image
		var tw:Number = targetWidth;
		var th:Number = targetHeight;
		
		if(crop) {
			// find longest side of target and scale to fill that
			if(targetWidth>targetHeight) {
				tw = targetWidth;
				th = Number.MAX_VALUE;
			} else {
				th = targetHeight;
				tw = Number.MAX_VALUE;
			}
		}
		
		ImageUtil.resizeImage( holder_mc, image_mc, tw+2, th+2, applySmoothing, allowStretching);
			
		if(crop) {
			mask_mc._width = actualWidth = targetWidth;
			mask_mc._height = actualHeight = targetHeight;
			
			Align.middle( holder_mc, actualHeight );
			Align.center( holder_mc, actualWidth );
		} else {
			mask_mc._width = actualWidth = Math.floor( holder_mc._width - 2 );
			mask_mc._height = actualHeight = Math.floor( holder_mc._height - 2 );	
		}
		
	}
	
	/**
	* returns actual width after resizing has been applied
	*/
	public function get width () : Number {
		return actualWidth;
	}
	
	/**
	* returns actual height after resizing has been applied
	*/
	public function get height () : Number {
		return actualHeight;
	}
	
	
	
}
