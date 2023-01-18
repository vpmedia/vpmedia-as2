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

import net.stevensacks.utils.ObservableClass;
import com.gaiaframework.assets.AbstractAsset;
import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.assets.ClipAsset;
import com.gaiaframework.assets.XMLAsset;
import com.gaiaframework.assets.FLVAsset;
import com.gaiaframework.core.TransitionController;
import com.gaiaframework.core.BranchLoader;
import com.gaiaframework.core.BranchTools;
import com.gaiaframework.core.BranchManager;
import com.gaiaframework.flow.FlowManager;
import com.gaiaframework.core.SiteModel;
import flash.external.ExternalInterface;
import mx.utils.Delegate;

// This is the core class of the framework.  
// It creates the clips for pages and assets.
// It uses the TransitionController and BranchManager to handle Transitions

class com.gaiaframework.core.SiteController extends ObservableClass
{
	private var clip:MovieClip;
	
	// Default Container Clips
	private var BOTTOM:MovieClip;
	private var MIDDLE:MovieClip;
	private var TOP:MovieClip;
	private var PRELOADCOMPLETE:MovieClip;
	
	private static var currentBranch:String;
	private var queuedBranch:String;
	
	private var activePage:PageAsset;
	
	private var transitionController:TransitionController;
	private var transitionInDelegate:Function;
	private var transitionOutDelegate:Function;	
	
	private var isTransitioning:Boolean;
	private var isLoading:Boolean;
	
	function SiteController(target:MovieClip)
	{
		super();
		clip = target;
		clip.controller = this;
		currentBranch = "";
		queuedBranch = "";
		isTransitioning = false;
		isLoading = false;
		//
		BOTTOM = clip.createEmptyMovieClip("BOTTOM", 10);
		MIDDLE = clip.createEmptyMovieClip("MIDDLE", 20);
		TOP = clip.createEmptyMovieClip("TOP", 30);
		PRELOADCOMPLETE = clip.createEmptyMovieClip("PRELOADCOMPLETE", 99);
		//
		transitionController = new TransitionController();
		transitionInDelegate = Delegate.create(this, onTransitionInComplete);
		transitionOutDelegate = Delegate.create(this, onTransitionOutComplete);
		transitionController.addEventListener("transitionOutComplete", transitionOutDelegate);
		transitionController.addEventListener("transitionInComplete", transitionInDelegate);
	}
	public static function getCurrentBranch():String
	{
		return currentBranch;
	}
	// EVENT HQ RECEIVER
	public function onGoto(evt:Object):Void
	{
		BranchManager.cleanup();
		var validBranch:String = evt.validBranch;
		if (!evt.external)
		{
			if (validBranch != currentBranch)
			{
				if (!isTransitioning && !isLoading) 
				{
					queuedBranch = "";
					var transitionType:String;
					if (SiteModel.tree.active)
					{
						// need to get the branch root page that will transition in to determine transitionType
						var prevArray:Array = BranchTools.getPagesOfBranch(currentBranch);
						var newArray:Array = BranchTools.getPagesOfBranch(validBranch);
						var i:Number;
						for (i = 0; i < newArray.length; i++)
						{
							if (newArray[i] != prevArray[i]) break;
						}
						transitionType = newArray[i].transitionType;
						//
						currentBranch = validBranch;
					}
					else
					{
						// the first time just load the index
						currentBranch = "index";
						transitionType = SiteModel.tree.transitionType;
					}
					FlowManager.init(transitionType);
					FlowManager.start();
				}
				else 
				{
					queuedBranch = validBranch;			
					if (!isLoading) 
					{
						transitionController.interrupt();
					}
					else
					{
						dispatchEvent({type:"preloadInterrupt"});
					}
				}
			}
		}
		else
		{
			launchExternalPage(evt.src);
		}
	}
	
	// BRANCH LOADER EVENT RECEIVERS
	public function onLoadPage(evt:Object):Void
	{
		isLoading = true;
		activePage = evt.data;
		BranchManager.loadPage(activePage);
		var targetClipName:String = activePage.branch.split("/").join("_");
		var targetClip:MovieClip = clip[activePage.depth].createEmptyMovieClip(targetClipName, clip[activePage.depth].getNextHighestDepth());
		activePage.init(targetClip);
		activePage.preload();
	}
	public function onLoadAsset(evt:Object):Void
	{
		isLoading = true;
		var asset:AbstractAsset = evt.data;
		var targetClip:MovieClip;
		if (!(asset instanceof XMLAsset) && !(asset instanceof FLVAsset)) 
		{
			var assetClipName:String = activePage.branch.split("/").join("_") + "_$" + asset.id;
			if (asset instanceof ClipAsset)
			{
				targetClip = clip[ClipAsset(asset).depth].createEmptyMovieClip(assetClipName, clip[ClipAsset(asset).depth].getNextHighestDepth());
			}
			else
			{
				targetClip = clip[activePage.depth].createEmptyMovieClip(assetClipName, clip[activePage.depth].getNextHighestDepth());
			}
			// asset clips are put off stage until they're done loading (so they don't appear)
			targetClip._x = targetClip._y = 2000;
		}
		asset.init(targetClip);
		if (asset.preloadAsset) asset.preload();
	}
	
	// FLOW EVENT RECEIVERS
	public function onTransitionOut(evt:Object):Void
	{
		if (!checkQueuedBranch()) 
		{
			isTransitioning = true;
			transitionController.transitionOut(BranchManager.createTransitionOutArray(currentBranch));
		}
	}
	public function onTransitionIn(evt:Object):Void
	{
		if (!checkQueuedBranch()) 
		{
			isTransitioning = true;
			transitionController.transitionIn(BranchTools.getPagesOfBranch(currentBranch));
		}
	}
	public function onPreload(evt:Object):Void
	{
		if (!checkQueuedBranch()) 
		{
			isLoading = true;
			dispatchEvent({type:"preload", branch:currentBranch});
		}
	}
	
	// EVENT RECEIVERS FROM TRANSITION CONTROLLER
	private function onTransitionOutComplete(evt:Object):Void
	{
		isTransitioning = false;
		BranchManager.cleanup();
		FlowManager.transitionOutComplete();
	}
	private function onTransitionInComplete(evt:Object):Void
	{
		isTransitioning = false;
		BranchManager.cleanup();
		FlowManager.transitionInComplete();
	}	
	
	// PRELOAD COMPLETE EVENT RECEIVER FROM EVENT HQ
	public function onPreloadComplete(evt:Object):Void
	{
		isLoading = false;
		if (!PRELOADCOMPLETE.onEnterFrame)
		{
			PRELOADCOMPLETE.onEnterFrame = function()
			{
				FlowManager.preloadComplete();
				delete this.onEnterFrame;
			}
		}
	}
	
	// COMPLETE EVENT RECEIVER FROM EVENT HQ
	public function onComplete(evt:Object):Void
	{
		checkQueuedBranch();
	}
	
	// UTILITY FUNCTIONS
	private function checkQueuedBranch():Boolean
	{
		isLoading = false;
		isTransitioning = false;
		if (queuedBranch.length > 0)
		{
			dispatchRedirect();
			return true;
		}
		return false;
	}
	private function dispatchRedirect():Void
	{
		// Waiting one frame makes this more stable when spamming goto events
		clip.onEnterFrame = function()
		{
			this.controller.dispatchEvent({type:"redirect", branch:this.controller.queuedBranch});
			delete this.onEnterFrame;
		}
	}
	private function launchExternalPage(url:String):Void
	{
		if (url.indexOf("javascript:") > -1)
		// convert javascript calls to ExternalInterface because of IE bug
		// with ExternalInterface and getURL mixing and matching
		{
			var jsCall:Array = String(url.split("javascript:")[1]).split("(");
			var method:String = String(jsCall.shift());
			var args:Array = jsCall.join("").split(")").join("").split(";").join("").split("'").join("").split(",");
			args.unshift(method);
			ExternalInterface.call.apply(ExternalInterface, args);
		}
		else
		{
			getURL(url, "_blank");
		}
	}
}