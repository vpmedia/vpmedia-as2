/**
 * NavigationManager
 * Copyright © 2007 András Csizmadia
 * Copyright © 2007 VPmedia
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
 * Project: NavigationManager
 * File: NavigationManager.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import mx.events.EventDispatcher;
import com.vpmedia.events.Delegate;
// Start
class com.vpmedia.managers.NavigationManager extends MovieClip
{
	// START CLASS
	/**
	 * <p>Description: Decl.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public var className:String = "NavigationManager";
	public var classPackage:String = "com.vpmedia.managers";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	
	public var dispatcher:Object;
	public var listener:Object;
	//
	private var label_txt:TextField;
	private var icon_mc:MovieClip;
	public var menuLength:Number;
	public var menuSelected:MovieClip;
	public var menuType:Number;
	public var menuItems:Array;
	private var __scope:MovieClip;
	/**
	 * <p>Description: Constructor</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	function NavigationManager (__s)
	{
		EventDispatcher.initialize (this);
		this.__scope = __s;

	}
	/**
	 * <p>Description: create</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function create (__type, __data_dp, x, y, o)
	{
		this.menuType = __type;
		this.menuLength = __data_dp.length;
		this.menuItems = new Array ();
		
		for (var i = 1; i < __data_dp.length; i++)
		{
			var menu_item = this.__scope.attachMovie ("menu", "menu" + i, this.__scope.getNextHighestDepth());
			var __cT = this.__scope["menu" + i];
			this.menuItems[i] = __cT;
			var __pT = this.__scope["menu" + Number (i - 1)];
			var __kerning = 15;
			__cT._x = x;
			__cT._y = y;
			__cT.id = i;
			__cT.label_txt.autoSize = true;
			__cT.label_txt.embedFonts = true;
			__cT.label_txt.htmlText = __data_dp[i].text;
			//__cT.label_txt.textColor = "0x000000";
			if (this.menuType == 0)
			{
				__cT._x = Math.floor (__pT._x + __pT._width + __kerning);
			}
			else if (this.menuType == 1)
			{
				__cT._y = __pT._y + __pT._height + __kerning;
			}
			//
			__cT.onPress = Delegate.create (this, this.press,this.menuItems[i]);
			__cT.onRelease = Delegate.create (this, this.release,this.menuItems[i]);
			__cT.onRollOver = Delegate.create (this, this.over,this.menuItems[i]);
			__cT.onRollOut = __cT.onReleaseOutside = Delegate.create (this, this.out,this.menuItems[i]);
		}
		this.dispatchEvent ({type:"onItemCreate", target:this, result:this.menuItems});	
	}	
	function press (t)
	{
		var eventObject:Object = {target:this, type:'onPress',result:t};
    this.dispatchEvent(eventObject);
	}
	function release (t)
	{
		var eventObject:Object = {target:this, type:'onRelease',result:t};
    this.dispatchEvent(eventObject);
	}
	function over (t)
	{
		var eventObject:Object = {target:this, type:'onOver',result:t};
     this.dispatchEvent(eventObject);
	}
	function out (t)
	{
		var eventObject:Object = {target:this, type:'onOut',result:t};
    this.dispatchEvent(eventObject);
	}
	public function setActive (t:MovieClip):MovieClip
	{
		this.menuSelected = t;
		return this.menuSelected;
	}
	public function getActive (Void):MovieClip
	{
		return this.menuSelected;
	}
	private function destroy (Void)
	{
		//removeMovieClip(this);
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
}
