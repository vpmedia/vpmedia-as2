/**
 * CustomFilter
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
 * Project: CustomFilter
 * File: CustomFilter.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
import mx.events.EventDispatcher;
import com.vpmedia.events.Delegate;
import flash.filters.*;
import flash.display.*;
import flash.geom.*;
// Define Class
class com.vpmedia.CustomFilter extends MovieClip implements IFramework
{
	// START CLASS
	/**
	 * <p>Description: Decl.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public var className:String = "CustomFilter";
	public var classPackage:String = "com.vpmedia";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	private var pixelSize:Number = 1;
	// Constructor
	function CustomFilter ()
	{
		EventDispatcher.initialize (this);
	}
	/*
	 * High pass filter
	 */
	public static function applyHighPass (__mc:MovieClip):Void
	{
		var filter = new flash.filters.ConvolutionFilter ();
		filter.matrixX = 3;
		filter.matrixY = 3;
		filter.matrix = [-1, -1, -1, -1, 15, -1, -1, -1, -1];
		filter.bias = 0;
		filter.divisor = 7;
		__mc.filters = [filter];
	}
	/*
	 * Deinterlace filter
	 */
	public static function applyDeinterlace (__mc:MovieClip):Void
	{
		var filter = new flash.filters.ConvolutionFilter ();
		filter.matrixX = 3;
		filter.matrixY = 3;
		filter.matrix = [-1, 4, -1, -2, 8, -2, -1, 4, -1];
		filter.divisor = 8;
		__mc.filters = [filter];
	}
	/*
	 * Desaturate filter
	 */
	public function applySaturation (__mc:MovieClip, __amount)
	{
		var colorFilter = new flash.filters.ColorMatrixFilter ();
		// Each channel (RGBA) is represented in a ColorMatrixFilter instance with 5 values stored sequentially in its matrix
		// property (4x5 matrix stored in a one-dimensional array). Each value represents an RGBA and an additional adder
		// for that channel. The identity for this matrix will show an image with normal color and alpha. It is as follows
		var redIdentity = [1, 0, 0, 0, 0];
		var greenIdentity = [0, 1, 0, 0, 0];
		var blueIdentity = [0, 0, 1, 0, 0];
		var alphaIdentity = [0, 0, 0, 1, 0];
		// A desaturated channel has a luminance of 30% red, 59% green, and 11% blue. Its row in the matrix would be the following -
		// this will be used to blend with the identity rows to show a variable grayscale or desaturation in the image
		var grayluma = [.3, .59, .11, 0, 0];
		var colmatrix:Array = new Array ();
		// populate the array with values resulting from the blended grayluma array and the color identities given the amount
		// provided by the slider. 0 = all grayluma, no identity 1 = no grayluma, all identity
		colmatrix = colmatrix.concat (interpolateArrays (grayluma, redIdentity, __amount));
		colmatrix = colmatrix.concat (interpolateArrays (grayluma, greenIdentity, __amount));
		colmatrix = colmatrix.concat (interpolateArrays (grayluma, blueIdentity, __amount));
		colmatrix = colmatrix.concat (alphaIdentity);
		// alpha not affected assign the new matrix to colorFilter
		colorFilter.matrix = colmatrix;
		__mc.filters = [colorFilter];
	}
	// interpolateArrays interpolates the values
	// in two arrays by an amount t (0-1)
	private function interpolateArrays (ary1, ary2, t)
	{
		var result:Array = (ary1.length >= ary2.length) ? ary1.slice () : ary2.slice ();
		var i = result.length;
		while (i--)
		{
			result[i] = ary1[i] + (ary2[i] - ary1[i]) * t;
		}
		return result;
	}
	/*
	 * Shadow effect
	 */
	private function applyShadow (__mc)
	{
		var distance:Number = 10;
		var angleInDegrees:Number = 45;
		var color:Number = 0x000000;
		var alpha:Number = .8;
		var blurX:Number = 16;
		var blurY:Number = 16;
		var strength:Number = 1;
		var quality:Number = 3;
		var inner:Boolean = false;
		var knockout:Boolean = false;
		var hideObject:Boolean = false;
		var filter:DropShadowFilter = new DropShadowFilter (distance, angleInDegrees, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		var filterArray:Array = new Array ();
		filterArray.push (filter);
		__mc.filters = filterArray;
	}
	/*
	 * Desaturate
	 */
	public function getDesaturationFilter (t:Number):BitmapFilter
	{
		//http://chattyfig.figleaf.com/pipermail/flashcoders/2005-September/150592.html
		t = (t == undefined) ? 1 : t;
		var r = 0.212671;
		var g = 0.715160;
		var b = 0.072169;
		return new ColorMatrixFilter ([t * r + 1 - t, t * g, t * b, 0, 0, t * r, t * g + 1 - t, t * b, 0, 0, t * r, t * g, t * b + 1 - t, 0, 0, 0, 0, 0, 1, 0]);
	}
	/*
	 * Pixelate
	 */
	public function pixelateItem (__target, __source, __pixelsize)
	{
		this.pixelSize = __pixelsize;
		var bitmapData = new BitmapData (__source._width / pixelSize, __source._height / pixelSize, false);
		__target.attachBitmap (bitmapData, 1);
		var scaleMatrix = new Matrix ();
		scaleMatrix.scale (1 / pixelSize, 1 / pixelSize);
		bitmapData.draw (__source, scaleMatrix);
		__target._width = __source._width;
		__target._height = __source._height;
	}
	private function pixelateDummy (__target, __source, __direction)
	{
		pixelateItem (__target, __source, pixelSize);
		if (__direction == 0)
		{
			pixelSize *= 0.9;
			if (pixelSize <= 1)
			{
				delete __target._parent.onEnterFrame;
			}
		}
		else
		{
			pixelSize *= 1.1;
			if (pixelSize >= __source._width / 4)
			{
				delete __target._parent.onEnterFrame;
			}
		}
	}
	public function pixelateEffect (__target, __source, __direction)
	{
		__target._parent.onEnterFrame = Delegate.create (this, this.pixelateDummy, __target, __source, __direction);
	}
	/*
	 * Static Noise
	 */
	public function staticNoiseEffect (__target, __x, __y, __w, __h)
	{
		!__x ? __x = 0 : null;
		!__y ? __y = 0 : null;
		!__w ? __w = 320 : null;
		!__h ? __h = 240 : null;
		__target.createEmptyMovieClip ("static_mc", __target.getNextHighestDepth ());
		__target.static_mc._x = __x;
		__target.static_mc._y = __y;
		var bmp = new flash.display.BitmapData (__w, __h);
		__target.static_mc.attachBitmap (bmp, 1);
		//__target.static_mc.setMask (mask_mc);
		__target.static_mc.onEnterFrame = function ()
		{
			//trace (bmp);
			var grayscale = (!Key.isDown (1));
			bmp.noise (Math.floor (1000 * Math.random ()), 0, 255, 1 | 2 | 4, grayscale);
		};
	}
	function stopNoiseEffect (__target)
	{
		delete __target.static_mc.onEnterFrame;
	}
	/*
	 * Distract
	 */
	public function distractEffect (__source, __areaW, __areaH, __w, __h)
	{
		//Bitmap data for next image 
		var trans:BitmapData = new BitmapData (__source._width, __source._height, true, 0x666666);
		trans.draw (__source);
		var pieces:Array = new Array ();
		var col:Number = __w / __areaW;
		var fil:Number = __h / __areaH;
		var p:Point = new Point (0, 0);
		var counter:Number = 150;
		// Copy image and show in MovieClips
		for (var c = 0; c < col; c++)
		{
			for (var f = 0; f < fil; f++)
			{
				//Create a bitmapData for each slot
				this[c + "_" + f] = new BitmapData (__areaW, __areaH, false, 0xFF0000);
				//Create a container and store in an array
				var t = __source._parent.createEmptyMovieClip ("slice_" + c + "_" + f, counter++);
				pieces.push (t);
				//getRandomPosition (t);
				//copy bitmap to MovieClip     
				t.attachBitmap (this[c + "_" + f], 1);
				//calculate area to copy
				var px:Number = c * __areaW;
				var py:Number = f * __areaH;
				t.velx = px + 335;
				t.vely = py;
				t._x = __source._parent.holder._x + px;
				t._y = __source._parent.holder._y + py;
				var zone:Rectangle = new Rectangle (px, py, __areaW, __areaH);
				//copy pixels on this area
				this[c + "_" + f].copyPixels (trans, zone, p);
			}
		}
		var c = 0;
		for (var i in pieces)
		{
			//trace (pieces[i]);
			pieces[i].slideTo (pieces[i].velx, pieces[i].vely, 1, "easeInOut", c / 100);
			c++;
		}
		trans.dispose ();
	}
	/**/
	private function getRandomPosition (t)
	{
		//store a random velocity for transition
		t.velx = Math.random (100) * 800;
		t.vely = Math.random (100) * 600;
		//trace (t.velx + "," + t.vely);
	}
	/**
	 * <p>Description: Get Class version</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getVersion ():String
	{
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
	public function toString ():String
	{
		return ("[" + className + "]");
	}
	// END CLASS
	// END CLASS
}
