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
import com.gaiaframework.core.BranchIterator;
import com.gaiaframework.assets.AbstractAsset;
import com.gaiaframework.assets.PageAsset;
import mx.utils.Delegate;

// BranchLoader takes a branch string and uses BranchIterator to load every page and asset for each Branch
// It dispatches the total and individual file progress

class com.gaiaframework.core.BranchLoader extends ObservableClass
{
	private var progressDelegate:Function;
	private var completeDelegate:Function;
	
	private var percLoaded:Number;
	private var eachPerc:Number;	
	private var loadedFiles:Number;
	private var totalFiles:Number;
	
	private var currentAsset:AbstractAsset;
	
	private var isInterrupted:Boolean = false;
	
	private var timeoutLength:Number = 3000;
	private var loadTimeoutInterval:Number;
	private var retryAttempts:Number = 0;
	private var maximumAttempts:Number = 3;
	
	function BranchLoader()
	{
		super();
		progressDelegate = Delegate.create(this, onProgress);
		completeDelegate = Delegate.create(this, onComplete);
	}
	
	public function onLoadBranch(evt:Object):Void
	{
		percLoaded = 0;
		loadedFiles = 0;
		totalFiles = BranchIterator.init(evt.branch);
		eachPerc = 100 / totalFiles;
		isInterrupted = false;
		retryAttempts = 0;
		dispatchEvent({type:"load"});
		loadNext();
	}
	public function onInterrupt(evt:Object):Void
	{
		_global.tt(">>> INTERRUPT PRELOAD <<<");
		isInterrupted = true;
	}
	private function loadNext():Void
	{
		currentAsset = BranchIterator.next();
		if (!currentAsset.active) {
			clearInterval(loadTimeoutInterval);
			if (currentAsset.preloadAsset)
			{
				loadTimeoutInterval = setInterval(this, "loadRetry", timeoutLength);
				currentAsset.addEventListener("progress", progressDelegate);
				currentAsset.addEventListener("complete", completeDelegate);
			}
			if (currentAsset instanceof PageAsset) 
			{
				dispatchEvent({type:"loadPage", data:currentAsset});
			} 
			else 
			{
				dispatchEvent({type:"loadAsset", data:currentAsset});
			}
			if (!currentAsset.preloadAsset) onComplete({asset:currentAsset});
		}
		else 
		{
			totalFiles--;
			eachPerc = 100 / totalFiles;
			next(true);
		}
	}
	private function onProgress(evt:Object):Void
	{
		if (isNaN(evt.perc)) evt.perc = 0;
		if (loadTimeoutInterval != undefined && evt.perc > 0) 
		{
			clearInterval(loadTimeoutInterval);
			delete loadTimeoutInterval;
		}
		percLoaded = Math.round((loadedFiles * eachPerc) + (eachPerc * evt.perc));
		dispatchProgress();
	}
	private function onComplete(evt:Object):Void
	{
		var asset:AbstractAsset = evt.asset;
		asset.removeEventListener("progress", progressDelegate);
		asset.removeEventListener("complete", completeDelegate);
		next();
	}
	private function next(skip:Boolean):Void
	{
		if (!skip) ++loadedFiles;
		if (loadedFiles < totalFiles && !isInterrupted) 
		{
			percLoaded = loadedFiles * eachPerc;
			dispatchProgress();
			loadNext();
		} 
		else 
		{
			isInterrupted = false;
			totalFiles = loadedFiles;
			dispatchComplete();
		}
	}
	private function dispatchProgress():Void
	{
		dispatchEvent({type:"progress", perc:percLoaded, asset:currentAsset, currentFile:loadedFiles - 1, totalFiles:totalFiles});
	}
	private function dispatchComplete():Void
	{
		dispatchEvent({type:"complete"});
	}
	
	// if a file doesn't show any progress within timeoutLength
	// retry maximumAttempt times and if it still hasn't loaded
	// abort it, dispatch an error and load the next file
	private function loadRetry():Void
	{
		if (++retryAttempts == maximumAttempts || isInterrupted)
		{
			clearInterval(loadTimeoutInterval);
			retryAttempts = 0;
			currentAsset.removeEventListener("progress", progressDelegate);
			currentAsset.removeEventListener("complete", completeDelegate);
			dispatchEvent({type:"error", asset:currentAsset});
			_global.tt(currentAsset.id + ".abort()");
			currentAsset.abort();
			next();
		}
		else
		{
			_global.tt(currentAsset.id + ".retry(" + retryAttempts + ")");
			currentAsset.retry();
		}
	}
}