/**
 * DrawingUtil
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
 * Project: DrawingUtil
 * File: DrawingUtil.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
import mx.events.EventDispatcher;
import com.vpmedia.events.Delegate;
// Start
class com.vpmedia.utils.DrawingUtil extends MovieClip implements IFramework {
	// START CLASS
	public var className:String = "DrawingUtil";
	public var classPackage:String = "com.vpmedia.utils";
	public var version:String = "1.0.0";
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
	function DrawingUtil () {
		EventDispatcher.initialize (this);
	}
	public static function drawShape (t, x, y, w, h, c, a) {
		//trace(this.toString()+"");
		t.beginFill (c, a);
		t.moveTo (x, y);
		t.lineTo (x + w, y);
		t.lineTo (x + w, y + h);
		t.lineTo (x, y + h);
		t.lineTo (x, y);
		t.endFill ();
	}
	public static function drawTriangle (__target:MovieClip, b, l, lc, la, fc, fa) {
		var h = (Math.sqrt (3) * b) * .5;
		var area = .25 * (Math.sqrt (3 * Math.pow (b, 2)));
		if (l != '') {
			__target.lineStyle (l, lc, la);
		}
		if (fc) {
			__target.beginFill (fc, fa);
		}
		__target.moveTo (-b / 2, h / 2);
		__target.lineTo (b / 2, h / 2);
		__target.lineTo (0, -h + h / 2);
		__target.lineTo (-b / 2, h / 2);
		if (fc) {
			__target.endFill ();
		}
	}
	public static function drawCircle (__target:MovieClip, thex, they, theradius, lineW, lineColor, fillColor, fillAlpha) {
		var x, y, r, u, v;
		x = thex;
		y = they;
		r = theradius;
		u = r * 0.4086;
		v = r * 0.7071;
		if (lineW != '') {
			__target.lineStyle (lineW, lineColor, 100);
		}
		if (fillColor != undefined || fillColor != '') {
			__target.beginFill (fillColor, fillAlpha);
		}
		__target.moveTo (x - r, y);
		__target.curveTo (x - r, y - u, x - v, y - v);
		__target.curveTo (x - u, y - r, x, y - r);
		__target.curveTo (x + u, y - r, x + v, y - v);
		__target.curveTo (x + r, y - u, x + r, y);
		__target.curveTo (x + r, y + u, x + v, y + v);
		__target.curveTo (x + u, y + r, x, y + r);
		__target.curveTo (x - u, y + r, x - v, y + v);
		__target.curveTo (x - r, y + u, x - r, y);
		if (fillColor != undefined || fillColor != '') {
			__target.endFill ();
		}
	}
	public static function drawRect (__target:MovieClip, x:Number, y:Number, w:Number, h:Number, cornerRadius:Number) {
		if (arguments.length < 5) {
			return;
		}
		// if the user has defined cornerRadius our task is a bit more complex. :)                                     
		if (cornerRadius > 0) {
			// init vars
			var theta, angle, cx, cy, px, py;
			// make sure that w + h are larger than 2*cornerRadius
			if (cornerRadius > Math.min (w, h) / 2) {
				cornerRadius = Math.min (w, h) / 2;
			}
			// theta = 45 degrees in radians                                     
			theta = Math.PI / 4;
			// draw top line
			__target.moveTo (x + cornerRadius, y);
			__target.lineTo (x + w - cornerRadius, y);
			//angle is currently 90 degrees
			angle = -Math.PI / 2;
			// draw tr corner in two parts
			cx = x + w - cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			cy = y + cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			px = x + w - cornerRadius + (Math.cos (angle + theta) * cornerRadius);
			py = y + cornerRadius + (Math.sin (angle + theta) * cornerRadius);
			__target.curveTo (cx, cy, px, py);
			angle += theta;
			cx = x + w - cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			cy = y + cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			px = x + w - cornerRadius + (Math.cos (angle + theta) * cornerRadius);
			py = y + cornerRadius + (Math.sin (angle + theta) * cornerRadius);
			__target.curveTo (cx, cy, px, py);
			// draw right line
			__target.lineTo (x + w, y + h - cornerRadius);
			// draw br corner
			angle += theta;
			cx = x + w - cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			cy = y + h - cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			px = x + w - cornerRadius + (Math.cos (angle + theta) * cornerRadius);
			py = y + h - cornerRadius + (Math.sin (angle + theta) * cornerRadius);
			__target.curveTo (cx, cy, px, py);
			angle += theta;
			cx = x + w - cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			cy = y + h - cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			px = x + w - cornerRadius + (Math.cos (angle + theta) * cornerRadius);
			py = y + h - cornerRadius + (Math.sin (angle + theta) * cornerRadius);
			__target.curveTo (cx, cy, px, py);
			// draw bottom line
			__target.lineTo (x + cornerRadius, y + h);
			// draw bl corner
			angle += theta;
			cx = x + cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			cy = y + h - cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			px = x + cornerRadius + (Math.cos (angle + theta) * cornerRadius);
			py = y + h - cornerRadius + (Math.sin (angle + theta) * cornerRadius);
			__target.curveTo (cx, cy, px, py);
			angle += theta;
			cx = x + cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			cy = y + h - cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			px = x + cornerRadius + (Math.cos (angle + theta) * cornerRadius);
			py = y + h - cornerRadius + (Math.sin (angle + theta) * cornerRadius);
			__target.curveTo (cx, cy, px, py);
			// draw left line
			__target.lineTo (x, y + cornerRadius);
			// draw tl corner
			angle += theta;
			cx = x + cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			cy = y + cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			px = x + cornerRadius + (Math.cos (angle + theta) * cornerRadius);
			py = y + cornerRadius + (Math.sin (angle + theta) * cornerRadius);
			__target.curveTo (cx, cy, px, py);
			angle += theta;
			cx = x + cornerRadius + (Math.cos (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			cy = y + cornerRadius + (Math.sin (angle + (theta / 2)) * cornerRadius / Math.cos (theta / 2));
			px = x + cornerRadius + (Math.cos (angle + theta) * cornerRadius);
			py = y + cornerRadius + (Math.sin (angle + theta) * cornerRadius);
			__target.curveTo (cx, cy, px, py);
		} else {
			// cornerRadius was not defined or = 0. This makes it easy.
			__target.moveTo (x, y);
			__target.lineTo (x + w, y);
			__target.lineTo (x + w, y + h);
			__target.lineTo (x, y + h);
			__target.lineTo (x, y);
		}
	}
	public static function drawBorder (__target, color, alpha) {
		var border = __target.createEmptyMovieClip ("border_mc", __target.getNextHighestDepth ());
		border.lineStyle (0.5, color, alpha, true, true);
		var x = 0;
		var y = 0;
		var w = __target._width - 0.5;
		var h = __target._height - 0.5;
		border.moveTo (x, y);
		border.lineTo (x + w, y);
		border.lineTo (x + w, y + h);
		border.lineTo (x, y + h);
		border.lineTo (x, y);
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
	 * <p>Description: Get Class name</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function toString ():String {
		return ("[" + className + "]");
	}
	// END CLASS
}
