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

class com.gaiaframework.assets.AbstractAsset extends ObservableClass
{
	public var id:String;
	public var src:String;
	public var title:String;
	public var preloadAsset:Boolean;
	public var showPreloader:Boolean;
	
	private var isActive:Boolean;
	private var progressInterval:Number;
	
	function AbstractAsset()
	{
		super();
	}
	// returns whether this asset is in the active tree 
	public function get active():Boolean
	{
		return isActive;
	}
	public function load():Void
	{
		isActive = true;
		clearInterval(progressInterval);
		progressInterval = setInterval(this, "updateProgress", 30);
	}
	private function updateProgress():Void
	{
		var l:Number = getBytesLoaded();
		var t:Number = getBytesTotal();
		var p:Number = l / t;
		dispatchEvent({type:"progress", asset:this, loaded:l, total:t, perc:p});
		if (t > 4 && p == 1) loadComplete();
	}
	private function loadComplete():Void
	{
		clearInterval(progressInterval);
		dispatchEvent({type:"complete", asset:this});
	}
	public function abort():Void
	{
		clearInterval(progressInterval);
		destroy();
	}
	public function destroy():Void 
	{
		isActive = false;
	}
	// stub methods for concrete classes
	public function init():Void {}
	public function preload():Void {}
	public function getBytesLoaded():Number { return 0; }
	public function getBytesTotal():Number { return 0; }
	public function retry():Void {}
}