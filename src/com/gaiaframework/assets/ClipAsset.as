/**********************************************************************************************************************
* Gaia Framework for Adobe Flash ©2007
* Written by: Steven Sacks
* email: stevensacks@gmail.com
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaframework.com/
* By using the Gaia Framework, you agree to keep the above contact information in the source code.

Distributed under Creative Commons Attribution-ShareAlike 3.0 Unported License
http://creativecommons.org/licenses/by-sa/3.0/

THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC LICENSE ("CCPL" OR "LICENSE"). 
THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW. ANY USE OF THE WORK OTHER THAN AS AUTHORIZED UNDER THIS 
LICENSE OR COPYRIGHT LAW IS PROHIBITED.

BY EXERCISING ANY RIGHTS TO THE WORK PROVIDED HERE, YOU ACCEPT AND AGREE TO BE BOUND BY THE TERMS OF THIS LICENSE. 
TO THE EXTENT THIS LICENSE MAY BE CONSIDERED TO BE A CONTRACT, THE LICENSOR GRANTS YOU THE RIGHTS CONTAINED HERE IN 
CONSIDERATION OF YOUR ACCEPTANCE OF SUCH TERMS AND CONDITIONS.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
**********************************************************************************************************************/

import com.gaiaframework.assets.AbstractAsset;
import com.gaiaframework.assets.AssetProgress;
import mx.utils.Delegate;

class com.gaiaframework.assets.ClipAsset extends AbstractAsset
{
	public var depth:String;
	private var _clip:MovieClip;
	
	function ClipAsset()
	{
		super();
		_clip = null;
	}
	public function get clip():MovieClip
	{
		return _clip;
	}
	public function init(target:MovieClip):Void
	{
		isActive = true;
		_clip = target;
	}
	public function preload(target:MovieClip):Void
	{
		_clip.loadMovie(src);
		super.load();
	}
	public function load():Void
	{
		if (showPreloader) AssetProgress.instance.load(this);
		_clip.loadMovie(src);
		super.load();
	}
	public function getBytesLoaded():Number
	{
		return _clip.getBytesLoaded();
	}
	public function getBytesTotal():Number
	{
		return _clip.getBytesTotal();
	}
	public function destroy():Void
	{
		_clip.removeMovieClip();
		_clip = null;
		super.destroy();
	}
	public function loadComplete():Void
	{
		_clip._visible = false;
		_clip._x = _clip._y = 0;
		super.loadComplete();
	}
	public function retry():Void
	{
		_clip.loadMovie(src);
	}
	
	// PROXY MOVIECLIP PROPS/FUNCS
	public function get _x():Number
	{
		return _clip._x;
	}
	public function set _x(x:Number):Void
	{
		_clip._x = x;
	}
	public function get _y():Number
	{
		return _clip._y;
	}
	public function set _y(y:Number):Void
	{
		_clip._y = y;
	}
	public function get _width():Number
	{
		return _clip._width;
	}
	public function set _width(w:Number):Void
	{
		_clip._width = w;
	}
	public function get _height():Number
	{
		return _clip._height;
	}
	public function set _height(h:Number):Void
	{
		_clip._height = h;
	}
	public function get _xscale():Number
	{
		return _clip._xscale;
	}
	public function set _xscale(xs:Number):Void
	{
		_clip._xscale = xs;
	}
	public function get _yscale():Number
	{
		return _clip._yscale;
	}
	public function set _yscale(ys:Number):Void
	{
		_clip._yscale = ys;
	}
	public function get _xmouse():Number
	{
		return _clip._xmouse;
	}
	public function get _ymouse():Number
	{
		return _clip._ymouse;
	}
	public function get _alpha():Number
	{
		return _clip._alpha;
	}
	public function set _alpha(a:Number):Void
	{
		_clip._alpha = a;
	}
	public function get _visible():Boolean
	{
		return _clip._visible;
	}
	public function set _visible(v:Boolean):Void
	{
		_clip._visible = v;
	}
	public function get _rotation():Number
	{
		return _clip._rotation;
	}
	public function set _rotation(r:Number):Void
	{
		_clip._rotation = r;
	}
	public function gotoAndPlay(f):Void
	{
		_clip.gotoAndPlay(f);
	}
	public function gotoAndStop(f):Void
	{
		_clip.gotoAndStop(f);
	}
	public function play():Void
	{
		_clip.play();
	}
	public function stop():Void
	{
		_clip.stop();
	}
	// ON METHODS
	public function set onPress(func:Function):Void
	{
		_clip.onPress = func;
	}
	public function set onRelease(func:Function):Void
	{
		_clip.onRelease = func;
	}
	public function set onReleaseOutside(func:Function):Void
	{
		_clip.onReleaseOutside = func;
	}
	public function set onRollOut(func:Function):Void
	{
		_clip.onRollOut = func;
	}
	public function set onRollOver(func:Function):Void
	{
		_clip.onRollOver = func;
	}
	public function set onDragOver(func:Function):Void
	{
		_clip.onDragOver = func;
	}
	public function set onDragOut(func:Function):Void
	{
		_clip.onDragOut = func;
	}
	public function set onEnterFrame(func:Function):Void
	{
		_clip.onEnterFrame = func;
	}
	public function set onKeyUp(func:Function):Void
	{
		_clip.onKeyUp = func;
	}
	public function set onKeyDown(func:Function):Void
	{
		_clip.onKeyDown = func;
	}
	public function get onPress():Function
	{
		return _clip.onPress;
	}
	public function get onRelease():Function
	{
		return _clip.onRelease;
	}
	public function get onReleaseOutside():Function
	{
		return _clip.onReleaseOutside;
	}
	public function get onRollOut():Function
	{
		return _clip.onRollOut;
	}
	public function get onRollOver():Function
	{
		return _clip.onRollOver;
	}
	public function get onDragOver():Function
	{
		return _clip.onDragOver;
	}
	public function get onDragOut():Function
	{
		return _clip.onDragOut;
	}
	public function get onEnterFrame():Function
	{
		return _clip.onEnterFrame;
	}
	public function get onKeyUp():Function
	{
		return _clip.onKeyUp;
	}
	public function get onKeyDown():Function
	{
		return _clip.onKeyDown;
	}
}
