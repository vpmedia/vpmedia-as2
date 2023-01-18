/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import asgard.display.DisplayObject;

import flash.display.BitmapData;

/**
 * Display a BitmapData object in a MovieClip.
 * <p><b>Example :</b></p>
 * {@code
 * import asgard.display.Bitmap ; 
 * import flash.display.BitmapData ;
 * 
 * var url:String = "pic/picture.jpg" ;
 * var container:MovieClip = createEmptyMovieClip("container", 1) ;
 * container._x = 10 ;
 * container._y = 10 ;
 * 
 * var loader:MovieClipLoader = new MovieClipLoader() ;
 * loader.addListener(this) ;
 * 
 * var bmp:BitmapData ;
 * var bmpMC:MovieClip = createEmptyMovieClip("bmpMC", 2) ;
 * 
 * var bitmap:Bitmap = new Bitmap("bmp1", bmpMC) ;
 * 
 * var onLoadInit:Function = function ( target ):Void
 * {
 *     bmp = new BitmapData(target._width, target._height) ;
 *     bmp.draw(target) ;
 *     
 *     bitmap.x = container._x + container._width + 10 ;
 *     bitmap.y = container._y ;
 *     
 *     trace(bitmap.width + " : " + bitmap.height) ;
 *     
 *     bitmap.bitmapData = bmp ;
 *     
 *     trace(bitmap.width + " : " + bitmap.height) ;
 * }
 * 
 * loader.loadClip(url, container) ;
 * 
 * var onKeyDown:Function = function():Void
 * {
 *     // bitmap.clear() ; // test clear method
 *     bitmap.bitmapData = null ;
 *     trace(bitmap.width + " : " + bitmap.height) ;
 * }
 * Key.addListener(this) ;
 * 
 * }
 * @author eKameleon
 */
class asgard.display.Bitmap extends DisplayObject 
{
	
	/**
	 * Creates a new Bitmap instance.
	 */
	public function Bitmap( sName:String, target:MovieClip, bmp:BitmapData, pixelSnapping:String, smoothing:Boolean ) 
	{
		
		super( sName, target ) ;
		
		clear() ;
		
		setPixelSnapping(pixelSnapping, true) ;
		
		setSmoothing(smoothing, true) ;
		
		setBitmapData(bmp) ;
		
	}

	/**
	 * The depth of the internal container of this display.
	 * Overrides this protected constant if you want change this level in your extended display of this Bitmap display.
	 */
	/*protected*/ static private var CONTAINER_DEPTH:Number = 100 ;

	/**
	 * Returns the BitmapData object being referenced.
	 * @return the BitmapData object being referenced.
	 */
	public function get bitmapData():BitmapData
	{
		return getBitmapData() ;	
	}

	/**
	 * Sets the BitmapData object being referenced.
	 */
	public function set bitmapData(bmp:BitmapData):Void
	{
		setBitmapData(bmp) ;	
	}
	
	/**
	 * (read-only) Returns the bitmap container reference.
	 * @return the bitmap container reference. 
	 */
	public function get container():MovieClip
	{
		return _container ;	
	}
	
	/**
	 * (read-write) Controls whether or not the Bitmap object is snapped to the nearest pixel.
	 * <p>The PixelSnapping class includes possible values :
	 * <ul>
	 * <li>PixelSnapping.NEVER No pixel snapping occurs.</li>
	 * <li>PixelSnapping.ALWAYS The image is always snapped to the nearest pixel, independent of transformation.</li>
	 * <li>PixelSnapping.AUTO The image is snapped to the nearest pixel if it is drawn with no rotation or skew and it is drawn at a scale factor of 99.9% to 100.1%. If these conditions are satisfied, the bitmap image is drawn at 100% scale, snapped to the nearest pixel. Internally, this value allows the image to be drawn as fast as possible using the vector renderer.</li>
	 * </ul>
	 * </p>
	 * @since Flash Player 8.5
	 */
	public function get pixelSnapping():String
	{
		return getPixelSnapping() ;	
	}

	/**
	 * (read-write) Controls whether or not the Bitmap object is snapped to the nearest pixel.
	 * <p>The PixelSnapping class includes possible values :
	 * <ul>
	 * <li>PixelSnapping.NEVER No pixel snapping occurs.</li>
	 * <li>PixelSnapping.ALWAYS The image is always snapped to the nearest pixel, independent of transformation.</li>
	 * <li>PixelSnapping.AUTO The image is snapped to the nearest pixel if it is drawn with no rotation or skew and it is drawn at a scale factor of 99.9% to 100.1%. If these conditions are satisfied, the bitmap image is drawn at 100% scale, snapped to the nearest pixel. Internally, this value allows the image to be drawn as fast as possible using the vector renderer.</li>
	 * </ul>
	 * </p>
	 * @since Flash Player 8.5
	 */
	public function set pixelSnapping( snapping:String ):Void
	{
		setPixelSnapping( snapping ) ;	
	}
	
	/**
	 * (read-write) Controls whether or not the bitmap is smoothed when scaled. 
	 * If true, the bitmap is smoothed when scaled. If false, the bitmap is not smoothed when scaled. 
	 */ 
	public function get smoothing():Boolean
	{
		return getSmoothing() ;	
	}

	/**
	 * (read-write) Controls whether or not the bitmap is smoothed when scaled. 
	 * If true, the bitmap is smoothed when scaled. If false, the bitmap is not smoothed when scaled. 
	 */
	public function set smoothing(b:Boolean):Void
	{
		setSmoothing(b) ;	
	}
	
	/**
	 * Clear the display.
	 */
	public function clear():Void
	{
		_container = view.createEmptyMovieClip("__container__", CONTAINER_DEPTH ) ;
		_container.view = _container.createEmptyMovieClip("view", 1) ; 
	}
	
	/**
	 * Disposes the BitmapData in the display.
	 */
	public function dispose():Void
	{
		_bmp.dispose() ;	
	}
	
	/**
	 * Returns the BitmapData reference.
	 * @return the BitmapData reference.
	 */
	public function getBitmapData():BitmapData
	{
		return _bmp ;	
	}

	/**
	 * Returns the bmp content target who contains the view of the BitmapData.
	 * @return the bmp content target.
	 */
	public function getContent():MovieClip
	{
		return _container.view ;	
	}

	/**
	 * Returns the pixel snapping value.
	 */
	public function getPixelSnapping():String
	{
		return _pixelSnapping ; 	
	} 

	/**
	 * Returns the smoothing value.
	 */
	public function getSmoothing():Boolean
	{
		return _smoothing ; 	
	} 

	/**
	 * Release the display.
	 */
	/*override*/ public function release():Void
	{
		super.release() ;
		dispose() ;
		_container.removeMovieClip() ;	
	}

	/**
	 * Sets the bitmapData reference in this display.
	 */
	public function setBitmapData(bmp:BitmapData):Void
	{
		if (_bmp != null)
		{
			_bmp.dispose() ;
			_bmp = null ;	
		}
		if ( bmp != null )
		{
			_bmp = bmp.clone() ;
		}
		update() ;	
	}

	/**
	 * Sets the pixel snapping value in this display.
	 */
	public function setPixelSnapping( snapping:String, noUpdate:Boolean ):Void
	{
		_pixelSnapping = snapping ;
		if ( noUpdate ) return ;
		update() ;
	} 

	/**
	 * Sets the smoothing value in this display.
	 */
	public function setSmoothing(b:Boolean, noUpdate:Boolean):Void
	{
		_smoothing = b ;
		if ( noUpdate ) return ;
		update() ; 	
	} 

	/**
	 * Update the display.
	 */
	public function update():Void
	{
		_container.view.attachBitmap(_bmp, 1, getPixelSnapping(), getSmoothing()) ;
	}

	/**
	 * The internal BitmapData reference.
	 */	
	private var _bmp:BitmapData ;

	/**
	 * The internal movieclip reference to attach the bitmap.
	 */
	private var _container:MovieClip ;

	/**
	 * The default value of the BitmapData pixelSnapping property.
	 */
	private var _pixelSnapping:String = "auto" ; 

	/**
	 * The default value of the BitmapData smoothing propety.
	 */
	private var _smoothing:Boolean = false ;

}