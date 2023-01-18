/**
 * Utils
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
 * Project: Utils
 * File: Utils.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.events.Delegate;
// Start
class com.vpmedia.Utils extends MovieClip {
	// START CLASS
	/**
	 * <p>Description: Decl.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public var className:String = "Utils";
	public var classPackage:String = "com.vpmedia.utils";
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
	function Utils () {
		
	}
	/**
	 * <p>Description: Rect drawing</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 * @param paramName paramType paramDescription
	 * @method methodName()
	 */
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
	/**
	 * <p>Description: Color translator</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 * @param paramName paramType paramDescription
	 * @method methodName()
	 */
	public static function colorDict (__n) {
		var res;
		switch (__n.toString ().toLowerCase ()) {
		case "red" :
			res = "0xff0000";
			break;
		case "green" :
			res = "0x00ff00";
			break;
		case "blue" :
			res = "0x0000ff";
			break;
		case "orange" :
			res = "0xff6600";
			break;
		case "yellow" :
			res = "0xffff00";
			break;
		case "black" :
			res = "0x000000";
			break;
		case "white" :
			res = "0xffffff";
			break;
		default :
			res = __n;
			break;
		}
		//trace (__n + " > " + res);
		return res;
	}
	
	public static function getCoordinateProps (t) {
		//trace ("*****************************************");
		var bounds_obj:Object = t.getBounds (_root);
		/*trace ("getBounds() output:");
		for (var i in bounds_obj)
		{
		trace (i + " --> " + bounds_obj[i]);
		}*/
		var rect_obj:Object = t.getRect (_root);
		/*trace ("getRect() output:");
		for (var i in rect_obj)
		{
		trace (i + " --> " + rect_obj[i]);
		}*/
		var prop_obj:Object = {x:t._x, y:t._y, w:t._width, h:t._height};
		return prop_obj;
	}
	public static function getLocalToGlobal (t:MovieClip):Object {
		var point_obj:Object = new Object ({x:0, y:0});
		t.localToGlobal (point_obj);
		return point_obj;
	}
	public static function removeMovieGroup (__root) {
		for (var i in __root) {
			if (typeof (__root[i]) == "movieclip") {
				removeMovieClip (__root[i]);
			}
		}
		removeMovieClip (__root);
	}
	public static function setEmptyMovieClip (t:MovieClip, n:String, d:Number):MovieClip {
		if (!t) {
			t = _root;
		}
		if (!n) {
			var n:String = "base_mc";
		}
		if (!d) {
			var d:Number = t.getNextHighestDepth ();
		}
		var r:MovieClip = t.createEmptyMovieClip (n, d);
		return r;
	}
	public static function x2a (x) {
		var a = [];
		a.$ = x;
		a._ = [];
		a._$ = x.nodeName;
		for (var c in x.attributes) {
			var $ = x.attributes[c];
			a["_" + c] = a._[c] = !isNaN ($) ? Number ($) : $ == "true" ? true : $ == "false" ? false : $;
		}
		for (var c = 0; c < x.childNodes.length; c++) {
			var n = x.childNodes[c];
			a[c] = a[n.nodeName] = n.nodeType == 1 ? x2a (n) : n.toString ();
		}
		return a;
	}
	public static function resizeInArea (t:MovieClip, w:Number, h:Number):Void {
		var ow = t._width;
		var oh = t._height;
		if (ow >= oh) {
			var multi = w / ow;
		}
		else {
			var multi = h / oh;
		}
		t._width = multi * ow;
		t._height = multi * oh;
	}
	public static function stretchInArea (t:MovieClip, w:Number, h:Number):Void {
		var ow = t._width;
		var oh = t._height;
		var wDiff = Math.abs (ow - w);
		var hDiff = Math.abs (oh - h);
		if (w < h) {
			var multi = w / ow;
		}
		else {
			var multi = h / oh;
		}
		t._width = multi * ow;
		t._height = multi * oh;
	}
	// END CLASS
}
