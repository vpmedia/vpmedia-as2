/**
 * TextContainer
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
 * Project: TextContainer
 * File: TextContainer.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import mx.events.EventDispatcher;
import com.vpmedia.Delegate;
// Start
class com.vpmedia.text.TextContainer extends MovieClip {
	// START CLASS
	/**
	 * <p>Description: Decl.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public var className:String = "TextContainer";
	public var classPackage:String = "com.vpmedia.text";
	public var version:String = "0.1";
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
	function TextContainer () {
		EventDispatcher.initialize (this);
	}
	public static function drawTextField (__target_mc:MovieClip, __text:String, __x, __y, __w, __h, __color, __size, __align, __font) {
		var bg_mc = __target_mc.createEmptyMovieClip ("bg_mc", __target_mc.getNextHighestDepth ());
		var border_mc = __target_mc.createEmptyMovieClip ("border_mc", __target_mc.getNextHighestDepth ());
		var title_mc = __target_mc.createEmptyMovieClip ("title_mc", __target_mc.getNextHighestDepth ());
		bg_mc._y = __target_mc._y + __target_mc._height;
		var __refText = title_mc.createTextField ("label_txt", title_mc.getNextHighestDepth (), __x, __y, __w, __h);
		//
		if (!__color)
		{
			__color = 0x000000;
		}
		if (!__align)
		{
			__align = "left";
		}
		if (!__font)
		{
			__font = "Arial";
		}
		if (!__size)
		{
			__size = 12;
		}
		var my_fmt:TextFormat = new TextFormat ();
		my_fmt.align = __align;
		my_fmt.font = __font;
		my_fmt.size = __size;
		//
		__refText.textColor = __color;
		__refText.align = __align;
		__refText.embedFonts = true;
		__refText.html = true;
		__refText.selectable = false;
		__refText.setNewTextFormat (my_fmt);
		__refText.multiline = true;
		__refText.wordWrap = true;
		__refText.htmlText = __text;
		__refText.autoSize = true;
		//
		__refText.type = "dynamic";
		//__refText._height;
		return __refText;
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
