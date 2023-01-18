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
import com.gaiaframework.core.EventHQ;
import com.gaiaframework.flow.NormalFlow;
import com.gaiaframework.flow.PreloadFlow;
import com.gaiaframework.flow.ReverseFlow;
import mx.utils.Delegate;

class com.gaiaframework.flow.FlowManager
{
	private static var flow;
	
	public static function init(type):Void
	{
		if (type == "normal" || type == undefined)
		{
			flow = NormalFlow;
		}
		if (type == "preload")
		{
			flow = PreloadFlow;
		}
		else if (type == "reverse")
		{
			flow = ReverseFlow;
		}
	}
	
	// from SiteController
	public static function start():Void
	{
		flow.start();
	}
	public static function transitionOutComplete():Void
	{
		EventHQ.instance.afterTransitionOut();
	}
	public static function preloadComplete():Void
	{
		EventHQ.instance.afterPreload();
	}
	public static function transitionInComplete():Void
	{
		EventHQ.instance.afterTransitionIn();
	}
	
	// from EventHQ
	public static function afterTransitionOutDone():Void
	{
		flow.afterTransitionOutDone();
	}
	public static function afterPreloadDone():Void
	{
		flow.afterPreloadDone();
	}
	public static function afterTransitionInDone():Void
	{
		flow.afterTransitionInDone();
	}
	
	// from flow
	public static function transitionOut():Void
	{
		EventHQ.instance.beforeTransitionOut();
	}
	public static function preload():Void
	{
		EventHQ.instance.beforePreload();
	}
	public static function transitionIn():Void
	{
		EventHQ.instance.beforeTransitionIn();
	}
	public static function complete():Void
	{
		EventHQ.instance.afterComplete();
	}
}