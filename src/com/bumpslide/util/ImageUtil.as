

/**
* Some Bitmap and image-related utility functions
* 
* @author David Knape  
*/

import flash.display.BitmapData;
//import org.asapframework.util.types.Rectangle;
import flash.geom.Rectangle;

class com.bumpslide.util.ImageUtil
{
	
	/**
	* Smooths a dynamically attached JPG 
	* 
	* When resizing or rotating dynamically attached images, you can now apply 
	* smoothing in Flash 8 by taking a snapshot of the image as BitmapData
	* and then attaching that bitmap over the old image
	* 
	* @param	holder_mc MovieClip where bitmap will be attached
	* @param	image_mc  MovieClip that will be copied into holder
	*/
	static function smoothImage( holder_mc:MovieClip, image_mc:MovieClip ) {
		
		// make bitmap data out of image_mc
		var w:Number = image_mc._width;
		var h:Number = image_mc._height;
		
		var imagePixels:BitmapData = new BitmapData(w,h,true,0x00000000); 
		imagePixels.draw( image_mc );				
		
		// create empty clip to hold our soon to be attached bitmap
		var bmp_mc:MovieClip = holder_mc.createEmptyMovieClip('__bumpslide_bmp_mc', 987976);
		
		// attach bitmap data with smoothing
		var applySmoothing:Boolean = true;        
		bmp_mc.attachBitmap(imagePixels, 2, null, applySmoothing);		
		
		// hide the original image
		image_mc._visible = false;	
	}
	
	/**
	* Undo smoothing applied using the smoothImage function
	* 
	* @param	holder_mc
	* @param	image_mc
	*/
	static function undoSmoothing( holder_mc:MovieClip, image_mc:MovieClip ) {
		image_mc._visible = true;
		holder_mc.__bumpslide_bmp_mc._visible = false;
		//holder_mc.__bumpslide_bmp_mc.removeMovieClip();		
	}
	
	/**
	* Resizes an image or rectangle to fit within a bounding box
	* while preserving aspect ratio.  The third parameter is optional.
	* AllowStretching allows the image bounds to be stetched beyond the 
	* original size. By default this is off. We use this most often for sizing 
	* dynamically loaded JPG's, and we don't want them to be stetched larger 
	* 
	* Example:
	* <code>
	* 	var origSize, availableSpace, newSize : Rectangle;		
	*	origSize = Rectangle.rectOfMovieClip( image_mc );
	*	availableSpace = new Rectangle(0,0,500,300);
	*	newSize = ImageUtil.resizeRect( origSize, availableSpace );
	*   image_mc._width = newSize.width;
	*   image_mc._yscale = image_mc._xscale;
	* </code>
	* 
	* @param	original - image size as a rectangle, max dimensions if allowStetching is left to false
	* @param	bounds - the target size and/or available space for displaying the image
	* @param	allowStetching - default is false
	*/
	static public function resizeRect( original:Rectangle, bounds:Rectangle, allowStretching:Boolean ) {
		
		// stretching is off by default
		// that is, we can only make an image smaller
		if(allowStretching!==true) allowStretching=false;
				
		var size:Rectangle = original.clone();						
		
		// first we size based on width
		// check for max width, resize if necessary
		if(allowStretching || size.width>bounds.width) {
		  size.width = bounds.width;
		  size.height = original.height / original.width * bounds.width;
		}           

		// after size by width, check height
		// make it even smaller if necessary
		if(size.height>bounds.height) {			
			size.height = bounds.height;
			size.width = original.width/original.height * bounds.height;
		}     
		
		return size;
		
	}
	
	
	/**
	* Shortcut to resize an image without messing with rectangles
	* 
	* 
	* @param	image_mc
	* @param	maxWidth
	* @param	maxHeight
	*/
	static public function resizeImage( holder_mc:MovieClip, image_mc:MovieClip, maxWidth:Number, maxHeight:Number, applySmoothing:Boolean, allowStretching:Boolean) {
		
		if(allowStretching!==true) allowStretching=false;
		if(applySmoothing!==true) applySmoothing=false;
		
		
		ImageUtil.undoSmoothing(  holder_mc, image_mc );
		
		holder_mc._yscale = holder_mc._xscale = 100;
		
		// get new size using the static resizeRect method 
		// we pass in a rect that represents the unscaled size of the image_mc
		// as well as a rect contructed from our maxWidth and maxHeight params
		var mcRect:Rectangle = new Rectangle(0,0,holder_mc._width, holder_mc._height);
		var newSize:Rectangle = ImageUtil.resizeRect( mcRect, new Rectangle(0,0,maxWidth,maxHeight), allowStretching );
		
		holder_mc._width = newSize.width;
		holder_mc._yscale = holder_mc._xscale;
		
		if(applySmoothing) {
			ImageUtil.smoothImage( holder_mc, image_mc );
		}
		
	}
	/**
	* Private Constructor
	*/
	private function ImageUtil() {}
}
