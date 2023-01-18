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
import mx.utils.Delegate;

class com.gaiaframework.core.Preloader extends ObservableClass
{
	private var _clip:MovieClip;	
	private var showInterval:Number;
	private var showDelay:Number = 125;
	private var loadInterval:Number;	
	private var isComplete:Boolean;
	private var ignoreDispatch:Boolean;
	
	function Preloader(target:MovieClip, src:String)
	{
		super();
		_clip = target;
		_clip.loadMovie(src);
		loadInterval = setInterval(this, "preloaderProgress", 100);
	}
	public function get clip():MovieClip
	{
		return _clip;
	}
	public function onStart():Void
	{
		isComplete = false;
		clearInterval(showInterval);
		showInterval = setInterval(this, "show", showDelay);
	}
	public function onProgress(evt:Object):Void
	{
		if (!isComplete) _clip.onProgress(evt.perc, evt.asset, evt.currentFile, evt.totalFiles);
	}
	public function onComplete(evt:Object):Void
	{
		isComplete = true;
		ignoreDispatch = (evt.noDispatch == true);
		_clip.transitionOut();
	}
	private function transitionOutComplete():Void
	{
		clearInterval(showInterval);
		if (!ignoreDispatch) dispatchEvent({type:"complete"});
	}
	private function show():Void
	{
		clearInterval(showInterval);
		if (!isComplete)
		{
			_clip.transitionIn();
		}
		else
		{
			transitionOutComplete();
		}
	}
	private function preloaderProgress():Void
	{
		if (_clip.getBytesLoaded() == _clip.getBytesTotal() && _clip.getBytesTotal() > 4)
		{
			clearInterval(loadInterval);
			_clip.transitionOutComplete = Delegate.create(this, transitionOutComplete);
			dispatchEvent({type:"ready"});
		}
	}
}