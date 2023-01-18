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

//Main initializes the framework.  It sets up the primary event broadcast/listener chains.

import net.stevensacks.utils.ObservableClass;
import com.gaiaframework.core.SiteModel;
import com.gaiaframework.core.SiteController;
import com.gaiaframework.core.BranchLoader;
import com.gaiaframework.core.BranchTools;
import com.gaiaframework.core.Preloader;
import com.gaiaframework.core.EventHQ;
import com.gaiaframework.core.SWFAddress;
import com.gaiaframework.core.GaiaContextMenu;
import com.gaiaframework.api.Application;
import com.gaiaframework.flow.FlowManager;
import com.gaiaframework.assets.AssetProgress;
import mx.utils.Delegate;

class com.gaiaframework.core.Main extends ObservableClass
{
	private var model:SiteModel;
	private var branchLoader:BranchLoader;
	private var preloader:Preloader;
	
	private var clip:MovieClip;
	private var site:SiteController;
	
	function Main(target:MovieClip)
	{
		super();
		clip = target;
		site = new SiteController(clip.createEmptyMovieClip("site", 5));
		model = new SiteModel();
		model.addEventListener("ready", Delegate.create(this, onSiteReady));
	}
	
	// when the model xml is parsed, initialize the framework, set up event listeners and Application API
	private function onSiteReady():Void
	{	
		branchLoader = new BranchLoader();
		preloader = new Preloader(clip.createEmptyMovieClip("preloader", 9999), SiteModel.preloader);
		//
		// Optimized Singleton Instantiation
		EventHQ.birth();
		AssetProgress.birth();
		SWFAddress.birth();
		//
		// EVENT HQ EVENT REGISTRATION
		EventHQ.instance.addEventListener("goto", Delegate.create(site, site.onGoto));
		EventHQ.instance.addEventListener("transitionOut", Delegate.create(site, site.onTransitionOut));
		EventHQ.instance.addEventListener("transitionIn", Delegate.create(site, site.onTransitionIn));
		EventHQ.instance.addEventListener("preload", Delegate.create(site, site.onPreload));
		EventHQ.instance.addEventListener("complete", Delegate.create(site, site.onComplete));
		//
		// BRANCH LOADER EVENT REGISTRATION
		branchLoader.addEventListener("loadPage", Delegate.create(site, site.onLoadPage));
		branchLoader.addEventListener("loadAsset", Delegate.create(site, site.onLoadAsset));
		branchLoader.addEventListener("load", Delegate.create(preloader, preloader.onStart));
		branchLoader.addEventListener("progress", Delegate.create(preloader, preloader.onProgress));
		branchLoader.addEventListener("complete", Delegate.create(preloader, preloader.onComplete));
		branchLoader.addEventListener("error", Delegate.create(EventHQ.instance, EventHQ.instance.onAssetError));
		//
		// ASSET LOAD PROGRESS TRACKER EVENT REGISTRATION
		AssetProgress.instance.addEventListener("load", Delegate.create(preloader, preloader.onStart));
		AssetProgress.instance.addEventListener("progress", Delegate.create(preloader, preloader.onProgress));
		AssetProgress.instance.addEventListener("complete", Delegate.create(preloader, preloader.onComplete));
		//
		// SITE CONTROLLER EVENT REGISTRATION
		site.addEventListener("redirect", Delegate.create(EventHQ.instance, EventHQ.instance.onGoto));
		site.addEventListener("preload", Delegate.create(branchLoader, branchLoader.onLoadBranch));
		site.addEventListener("preloadInterrupt", Delegate.create(branchLoader, branchLoader.onInterrupt));
		//
		// PRELOADER EVENT REGISTRATION
		preloader.addEventListener("ready", Delegate.create(this, initSite));
		preloader.addEventListener("complete", Delegate.create(site, site.onPreloadComplete));
		//
		Application.preloader = preloader;
		_global.Gaia = Application;
		//
		GaiaContextMenu.init(SiteModel.context);
	}
	// when preloader is ready, load the index page (background) only
	// hijack EventHQ transitionInComplete with an onlyOnce listener to load the rest of the model after index is loaded
	private function initSite():Void
	{
		EventHQ.instance.addListener("afterComplete", Delegate.create(this, indexLoaded), false, true);
		EventHQ.instance.goto("index");
	}
	// after the index page is loaded, load the first branch (or the deeplink from the browser)
	private function indexLoaded():Void
	{
		EventHQ.instance.addEventListener("goto", Delegate.create(SWFAddress.instance, SWFAddress.instance.onGoto));
		SWFAddress.instance.addEventListener("goto", Delegate.create(EventHQ.instance, EventHQ.instance.onGoto));
		SWFAddress.instance.init();
	}
}