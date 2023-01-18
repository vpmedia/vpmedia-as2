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

import com.gaiaframework.core.SiteModel;
import com.gaiaframework.core.BranchTools;
import com.gaiaframework.core.BranchManager;
import com.gaiaframework.core.EventHQ;
import com.gaiaframework.core.SWFAddress;
import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.core.Preloader;
import com.gaiaframework.core.SiteController;
import com.gaiaframework.core.Tracking;
import mx.utils.Delegate;

class com.gaiaframework.api.Application
{
	public static var preloader:Preloader;
	
	public static function goto(branch:String):Void
	{
		_global.tt("goto", branch);
		EventHQ.instance.goto(branch);
	}
	public static function getSiteTree():PageAsset
	{
		return SiteModel.tree;
	}
	public static function getSiteTitle():String
	{
		return SiteModel.title;
	}
	public static function getTitle():String
	{
		return SWFAddress.instance.getTitle();
	}
	public static function setTitle(title:String):Void
	{
		SWFAddress.instance.setTitle(title);
	}
	public static function getPage(branch:String):PageAsset
	{
		return BranchTools.getPage(branch);
	}
	public static function getValidBranch(branch:String):String
	{
		return BranchTools.getValidBranch(branch);
	}
	public static function getCurrentBranch():String
	{
		return SiteController.getCurrentBranch();
	}
	public static function getPreloader():MovieClip
	{
		return preloader.clip;
	}
	public static function getDeeplink():String
	{
		return SWFAddress.deeplink;
	}
	public static function track():Void
	{
		Tracking.track(arguments);
	}

	// Hijack Events
	public static function beforeGoto(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return EventHQ.instance.addListener("beforeGoto", target, hijack, onlyOnce);
	}
	public static function afterGoto(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return EventHQ.instance.addListener("afterGoto", target, hijack, onlyOnce);
	}
	
	public static function beforeTransitionOut(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return EventHQ.instance.addListener("beforeTransitionOut", target, hijack, onlyOnce);
	}
	public static function afterTransitionOut(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return EventHQ.instance.addListener("afterTransitionOut", target, hijack, onlyOnce);
	}
	
	public static function beforePreload(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return EventHQ.instance.addListener("beforePreload", target, hijack, onlyOnce);
	}
	public static function afterPreload(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return EventHQ.instance.addListener("afterPreload", target, hijack, onlyOnce);
	}
	
	public static function beforeTransitionIn(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return EventHQ.instance.addListener("beforeTransitionIn", target, hijack, onlyOnce);
	}
	public static function afterTransitionIn(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return EventHQ.instance.addListener("afterTransitionIn", target, hijack, onlyOnce);
	}
	
	public static function afterComplete(target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		return EventHQ.instance.addListener("afterComplete", target, false, onlyOnce);
	}
	
	// Remove Hijack Events (just in case you need to manually)
	public static function removeBeforeGoto(target:Function):Void
	{
		EventHQ.instance.removeEventListener("beforeGoto", target);
	}
	public static function removeAfterGoto(target:Function):Void
	{
		EventHQ.instance.removeEventListener("afterGoto", target);
	}
	
	public static function removeBeforeTransitionOut(target:Function):Void
	{
		EventHQ.instance.removeListener("beforeTransitionOut", target);
	}
	public static function removeAfterTransitionOut(target:Function):Void
	{
		EventHQ.instance.removeListener("afterTransitionOut", target);
	}
	
	public static function removeBeforePreload(target:Function):Void
	{
		EventHQ.instance.removeListener("beforePreload", target);
	}
	public static function removeAfterPreload(target:Function):Void
	{
		EventHQ.instance.removeListener("afterPreload", target);
	}
	
	public static function removeBeforeTransitionIn(target:Function):Void
	{
		EventHQ.instance.removeListener("beforeTransitionIn", target);
	}
	public static function removeAfterTransitionIn(target:Function):Void
	{
		EventHQ.instance.removeListener("afterTransitionIn", target);
	}
	
	public static function removeAfterComplete(target:Function):Void
	{
		EventHQ.instance.removeListener("afterComplete", target);
	}
	
	// Deeplink event
	public static function addDeeplinkListener(target:Function):Void
	{
		SWFAddress.instance.addEventListener("deeplink", target);
	}
	public static function removeDeeplinkListener(target:Function):Void
	{
		SWFAddress.instance.removeEventListener("deeplink", target);
	}
	
	// Asset Error event
	public static function addAssetErrorListener(target:Function):Void
	{
		EventHQ.instance.addEventListener("assetError", target);
	}
	public static function removeAssetErrorListener(target:Function):Void
	{
		EventHQ.instance.removeEventListener("assetError", target);
	}
}