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
import mx.utils.Delegate;

class com.gaiaframework.assets.AssetProgress extends ObservableClass
{
	private static var _instance:AssetProgress;
	
	private var assets:Object;
	private var loadedBytes:Number;
	private var totalBytes:Number;
	private var assetCount:Number;
	
	private var progressDelegate:Function;
	private var completeDelegate:Function;
	
	private function AssetProgress()
	{
		super();
		assets = {};
		assetCount = 0;
		progressDelegate = Delegate.create(this, onProgress);
		completeDelegate = Delegate.create(this, onComplete);
	}
	public static function birth():Void
	{
		if (_instance == null) _instance = new AssetProgress();
	}
	public static function get instance():AssetProgress
	{
		return _instance;
	}
	public function load(asset:AbstractAsset):Void
	{
		if (!assets[asset.id])
		{
			if (assetCount == 0) dispatchEvent({type:"load"});
			assetCount++;
			assets[asset.id] = {asset:asset, loaded:0, total:0};
			asset.addEventListener("progress", progressDelegate);
			asset.addEventListener("complete", completeDelegate);
		}
	}
	private function onProgress(evt:Object):Void
	{
		if (isNaN(evt.loaded) || evt.loaded < 0) evt.loaded = 0;
		if (isNaN(evt.total) || evt.total < 4) evt.total = 4;
		assets[evt.asset.id].loaded = evt.loaded;
		assets[evt.asset.id].total = evt.total;
		loadedBytes = 0;
		totalBytes = 0;
		for (var a:String in assets)
		{
			loadedBytes += assets[a].loaded;
			totalBytes += assets[a].total;
		}
		var perc:Number = (loadedBytes / totalBytes) * 100;
		dispatchEvent({type:"progress", perc:perc});
	}
	private function onComplete(evt:Object):Void
	{
		var asset:AbstractAsset = evt.asset;
		asset.removeEventListener("progress", progressDelegate);
		asset.removeEventListener("complete", completeDelegate);
		delete assets[asset.id];
		assetCount = 0;
		for (var a:String in assets)
		{
			assetCount++;
		}
		if (assetCount == 0) dispatchEvent({type:"complete", noDispatch:true});
	}
}