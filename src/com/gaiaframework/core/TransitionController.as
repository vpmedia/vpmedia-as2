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
import com.gaiaframework.core.BranchTools;
import mx.utils.Delegate;

// This class manages transitioning the Pages

class com.gaiaframework.core.TransitionController extends ObservableClass
{	
	public var pages:Array;
	
	private var index:Number;
	private var transitionInDelegate:Function;
	private var transitionOutDelegate:Function;
	private var transitionDirection:String;
	private var isInterrupted:Boolean;
	
	function TransitionController()
	{
		super();
		transitionInDelegate = Delegate.create(this, onTransitionInComplete);
		transitionOutDelegate = Delegate.create(this, onTransitionOutComplete);
		isInterrupted = false;
	}
	// transitionOut goes from front to back (child to parent)
	public function transitionOut(pageArray:Array)
	{
		transitionDirection = "out";
		isInterrupted = false;
		pages = pageArray;
		index = 0;
		if (pages.length == 0) 
		{
			onTransitionOutComplete();
		}
		else
		{
			index = pages.length - 1;
			pages[index].addEventListener("transitionOutComplete", transitionOutDelegate);
			pages[index].transitionOut();
		}
	}
	// transitionOut goes from back to front (parent to child)
	public function transitionIn(pageArray:Array)
	{
		transitionDirection = "in";
		isInterrupted = false;
		pages = pageArray;
		index = 0;
		if (pages.length == 0)
		{
			onTransitionInComplete();
		}
		else
		{
			index = 0;
			pages[index].addEventListener("transitionInComplete", transitionInDelegate);
			pages[index].transitionIn();
		}
	}
	private function onTransitionOutComplete(evt:Object)
	{
		evt.page.removeEventListener("transitionOutComplete", transitionOutDelegate);
		if (!isInterrupted) 
		{
			if (--index > -1) 
			{
				pages[index].addEventListener("transitionOutComplete", transitionOutDelegate);
				pages[index].transitionOut();
			}
			else 
			{
				dispatchEvent({type:"transitionOutComplete"});
			}
		} 
		else 
		{
			isInterrupted = false;
			dispatchEvent({type:"transitionOutComplete"});
		}
	}
	private function onTransitionInComplete(evt:Object)
	{
		evt.page.removeEventListener("transitionInComplete", transitionInDelegate);
		if (!isInterrupted)
		{			
			if (++index < pages.length) 
			{
				pages[index].addEventListener("transitionInComplete", transitionInDelegate);
				pages[index].transitionIn();
			}
			else 
			{
				dispatchEvent({type:"transitionInComplete"});
			}
		}
		else
		{
			isInterrupted = false;
			dispatchEvent({type:"transitionInComplete"});
		}
	}
	// if there isn't already an interrupt, interrupt the current transition
	public function interrupt():Void
	{
		if (!isInterrupted) 
		{
			isInterrupted = true;
			if (transitionDirection == "out")
			{
				_global.tt(">>> INTERRUPT OUT <<<");
				pages[index].interruptTransitionOut();
			}
			else
			{
				_global.tt(">>> INTERRUPT IN <<<");
				pages[index].interruptTransitionIn();
			}
		}
	}
}