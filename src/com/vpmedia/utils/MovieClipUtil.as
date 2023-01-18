/**
 * MovieClipUtil
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
 * Project: MovieClipUtil
 * File: MovieClipUtil.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.utils.MovieClipUtil extends MovieClip implements IFramework {
	// START CLASS
	public var className:String = "MovieClipUtil";
	public var classPackage:String = "com.vpmedia.utils";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	//
	// Constructor
	function MovieClipUtil () {
		//
	}
	public static function getCoordinateProps (__target) {
		trace ("*****************************************");
		var bounds_obj:Object = __target.getBounds (__target);
		trace ("getBounds() output:");
		for (var i in bounds_obj) {
			trace (i + " --> " + bounds_obj[i]);
		}
		var rect_obj:Object = __target.getRect (__target);
		trace ("getRect() output:");
		for (var i in rect_obj) {
			trace (i + " --> " + rect_obj[i]);
		}
		return rect_obj;
	}
	// play backward
	public static function playBackwards (__target, proceed:Boolean, changeHandler:String, changeParams):Void {
		// trace(proceed) // +", "+changeHandler+", "+changeParams);
		if (proceed == undefined) {
			proceed = true;
		}
		//           
		__target.onEnterFrame = function () {
			if (!proceed || this._currentframe == 1) {
				delete this.onEnterFrame;
				this._parent[changeHandler] (changeParams);
			} else {
				this.prevFrame ();
			}
		};
	}
	static function createMask (__target:MovieClip, __w, __h):MovieClip {
		var bounds_obj:Object = __target.getBounds (__target);
		bounds_obj.w = bounds_obj.xMax - bounds_obj.xMin;
		bounds_obj.h = bounds_obj.yMax - bounds_obj.yMin;
		var mask = __target._parent.createEmptyMovieClip ("mask_mc", 1);
		mask._x = bounds_obj.xMin;
		mask._y = bounds_obj.yMin;
		mask.beginFill (0x00FF00);
		mask.moveTo (0, 0);
		mask.lineTo (__w, 0);
		mask.lineTo (__w, __h);
		mask.lineTo (0, __h);
		mask.lineTo (0, 0);
		mask.endFill ();
		mask._alpha = 100;
		__target.setMask (mask);
		return mask;
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
