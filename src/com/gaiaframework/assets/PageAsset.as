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

import com.gaiaframework.assets.ClipAsset;
import com.gaiaframework.core.SWFAddress;
import mx.utils.Delegate;

class com.gaiaframework.assets.PageAsset extends ClipAsset
{
	public var parent:PageAsset;
	public var children:Object;
	public var assets:Object;
	public var external:Boolean;
	public var context:Boolean;
	public var transitionType:String;
	public var defaultChild:String;
	public var route:String;
	
	private var transitionInDelegate:Function;
	private var transitionOutDelegate:Function;
	private var deeplinkDelegate:Function;
	
	private var isTransitionedIn:Boolean;
	
	function PageAsset()
	{
		super();
		isTransitionedIn = false;
		transitionInDelegate = Delegate.create(this, transitionInComplete);
		transitionOutDelegate = Delegate.create(this, transitionOutComplete);
		deeplinkDelegate = Delegate.create(this, onDeeplink);
	}
	// branch recurses up the parent chain (Chain Of Responsibility)
	public function get branch():String
	{
		if (parent.branch != undefined) return parent.branch + "/" + id;
		return id;
	}	

	// transitionIn only if isTransitionedOut, otherwise transitionInComplete
	public function transitionIn():Void
	{
		if (!isTransitionedIn) 
		{
			_clip.transitionIn();
		}
		else
		{
			transitionInComplete();
		}
	}
	// transitionOut only if isTransitionedIn, otherwise transitionOutComplete
	public function transitionOut():Void
	{
		if (isTransitionedIn) 
		{
			_clip.transitionOut();
		} 
		else 
		{
			transitionOutComplete();
		}
	}
	// interrupt transition calls - if user doesn't set these, they fail silently
	public function interruptTransitionIn():Void
	{
		_clip.interruptTransitionIn();
	}
	public function interruptTransitionOut():Void
	{
		_clip.interruptTransitionOut();
	}
	// destroy
	public function destroy():Void
	{
		isTransitionedIn = false;
		SWFAddress.instance.removeEventListener("deeplink", deeplinkDelegate);
		for (var a:String in assets)
		{
			assets[a].destroy();
		}
		super.destroy();
	}
	// 
	// Decorator Pattern: decorates page _clip with functions, properties and event listeners
	private function decorate():Void
	{
		_clip.transitionInComplete = transitionInDelegate;
		_clip.transitionOutComplete = transitionOutDelegate;
		_clip.page = this;
		_clip.assets = assets;
	}
	// received from page through the transitionInDelegate
	private function transitionInComplete():Void
	{
		isTransitionedIn = true;
		dispatchEvent({type:"transitionInComplete", page:this});
	}
	// received from page through the transitionOutDelegate
	private function transitionOutComplete():Void
	{
		destroy();
		dispatchEvent({type:"transitionOutComplete", page:this});
	}
	// when loadComplete is called by AbstractAsset, decorate and make _clip visible (ClipAsset default is to hide _clip)
	private function loadComplete():Void
	{
		SWFAddress.instance.addEventListener("deeplink", deeplinkDelegate);
		decorate();
		super.loadComplete();
		_clip._visible = true;
		isTransitionedIn = false;
	}
	// SWFAddress sends deeplink events to active pages
	private function onDeeplink(evt:Object):Void
	{
		_clip.onDeeplink(evt.deeplink);
	}
}