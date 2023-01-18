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
import com.gaiaframework.core.EventListener;
import com.gaiaframework.core.BranchTools;
import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.flow.FlowManager;
import mx.utils.Delegate;

// Events in Gaia get routed through EventHQ
// Application provides an easy API for hijacking the four primary events

class com.gaiaframework.core.EventHQ extends ObservableClass
{
	private var listeners:Object;
	private var uniqueID:Number = 0;
	private var hijackDelegate:Function;
	
	private var gotoValidBranch:String;
	private var gotoFullBranch:String;
	private var gotoExternal:Boolean;
	private var gotoSrc:String;
	
	private static var _instance:EventHQ;
	
	private function EventHQ()
	{
		super();
		listeners = {};
		listeners.beforeGoto = {};
		listeners.afterGoto = {};
		listeners.beforeTransitionOut = {};
		listeners.afterTransitionOut = {};
		listeners.beforePreload = {};
		listeners.afterPreload = {};
		listeners.beforeTransitionIn = {};
		listeners.afterTransitionIn = {};
		listeners.afterComplete = {};
		hijackDelegate = Delegate.create(this, onHijackComplete);
	}
	public static function birth():Void
	{
		if (_instance == null) _instance = new EventHQ();
	}
	public static function get instance():EventHQ
	{
		return _instance;
	}
	// Called by Application
	public function addListener(event:String, target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		if (listeners[event] != undefined) 
		{
			var listener:EventListener = generateListener(event, target);
			if (!listener.hijack && hijack) 
			{
				listener.addEventListener("complete", hijackDelegate);
			}
			else if (listener.hijack && !hijack)
			{
				listener.removeEventListener("complete", hijackDelegate);
			}
			listener.hijack = hijack;
			listener.completed = Boolean(!hijack);
			listener.onlyOnce = onlyOnce;
			this.addEventListener(event, listener.target);
			return (hijack) ? Delegate.create(listener, listener.completeCallback) : null;
		}
		else
		{
			_global.tt("EventHQ Error! addListener: " + event + " is not a valid event");
		}
	}
	public function removeListener(event:String, target:Function):Void
	{
		if (listeners[event] != undefined) 
		{
			for (var id:String in listeners[event])
			{
				if (listeners[event][id].target == target) 
				{
					removeListenerByID(event, id);
					break;
				}
			}
		}
		else 
		{
			_global.tt("EventHQ Error! removeListener: " + event + " is not a valid event");
		}
	}
	
	// This method is the beginning of the event chain
	public function goto(branch:String):Void
	{
		if (branch.substr(0, 5) != "index") branch = "index/" + branch;
		gotoValidBranch = BranchTools.getValidBranch(branch);
		gotoFullBranch = BranchTools.getFullBranch(branch);
		var page:PageAsset = BranchTools.getPage(gotoValidBranch);
		gotoExternal = page.external;
		gotoSrc = page.src;
		beforeGoto();
	}
	public function onGoto(evt:Object):Void
	{
		goto(evt.branch);
	}
	
	// EVENT HIJACKS
	
	// BEFORE GOTO
	public function beforeGoto():Void
	{
		onEvent("beforeGoto");
	}
	public function beforeGotoDone():Void
	{
		dispatchEvent({type:"goto", validBranch:gotoValidBranch, fullBranch:gotoFullBranch, external:gotoExternal, src:gotoSrc});
	}
	
	// TRANSITION OUT BEFORE / AFTER
	public function beforeTransitionOut():Void
	{
		onEvent("beforeTransitionOut");
	}
	public function beforeTransitionOutDone():Void
	{
		dispatchEvent({type:"transitionOut"});
	}
	public function afterTransitionOut():Void
	{
		onEvent("afterTransitionOut");
	}
	public function afterTransitionOutDone():Void
	{
		FlowManager.afterTransitionOutDone();
	}
	
	// PRELOAD BEFORE / AFTER
	public function beforePreload():Void
	{
		onEvent("beforePreload");
	}
	public function beforePreloadDone():Void
	{
		dispatchEvent({type:"preload"});
	}
	public function afterPreload():Void
	{
		onEvent("afterPreload");
	}
	public function afterPreloadDone():Void
	{
		FlowManager.afterPreloadDone();
	}
	
	// TRANSITION IN BEFORE / AFTER
	public function beforeTransitionIn():Void
	{
		onEvent("beforeTransitionIn");
	}
	public function beforeTransitionInDone():Void
	{
		dispatchEvent({type:"transitionIn"});
	}
	public function afterTransitionIn():Void
	{
		onEvent("afterTransitionIn");
	}
	public function afterTransitionInDone():Void
	{
		FlowManager.afterTransitionInDone();
	}
	
	// AFTER COMPLETE
	public function afterComplete():Void
	{
		dispatchEvent({type:"complete"});
		onEvent("afterComplete");
	}
	public function afterCompleteDone():Void
	{
		// do nothing
	}
	
	// SEMI-PRIVATE METHODS FOR EVENT HANDLING	
	public function onAssetError(evt:Object):Void
	{
		dispatchEvent({type:"assetError", asset:evt.asset});
	}
	
	// WHEN GAIA EVENTS OCCUR THEY ARE ROUTED THROUGH HERE FOR HIJACKING
	private function onEvent(event:String):Void
	{
		var eventHasListeners:Boolean = false;
		var eventHasHijackers:Boolean = false;
		for (var id:String in listeners[event])
		{
			if (listeners[event][id] != undefined) 
			{
				eventHasListeners = true;
				if (listeners[event][id].hijack) eventHasHijackers = true;
			}
		}
		if (eventHasListeners) dispatchEvent({type:event, validBranch:gotoValidBranch, fullBranch:gotoFullBranch, external:gotoExternal, src:gotoSrc});
		if (!eventHasHijackers) this[event + "Done"]();
		removeOnlyOnceListeners(event);
	}
	
	// GENERATES AN EVENT HIJACKER
	private function generateListener(event:String, target:Function):EventListener
	{
		// prevent duplicate listeners
		for (var id:String in listeners[event])
		{
			if (listeners[event][id].target == target) 
			{
				this.removeEventListener(event, target);
				return listeners[event][id];
			}
		}
		// new listener
		var listener:EventListener = new EventListener();
		listener.event = event;
		listener.target = target;
		listeners[event][String(++uniqueID)] = listener;
		return listener;
	}
	// REMOVES EVENT LISTENERS BY THEIR UNIQUE ID
	private function removeListenerByID(event:String, id:String):Void
	{
		listeners[event][id].removeEventListener("complete", hijackDelegate);
		this.removeEventListener(event, listeners[event][id].target);
		delete listeners[event][id];
	}
	// REMOVES EVENT LISTENERS THAT ONLY LISTEN ONCE
	private function removeOnlyOnceListeners(event:String):Void
	{
		for (var id:String in listeners[event])
		{
			if (listeners[event][id].onlyOnce && !listeners[event][id].hijack) removeListenerByID(event, id);
		}
	}
	// RESET COMPLETED HIJACKERS AFTER ALL HIJACKERS ARE COMPLETE AND REMOVE ONLY ONCE HIJACKERS
	private function resetEventHijackers(event:String):Void
	{
		for (var id:String in listeners[event])
		{
			if (listeners[event][id].hijack)
			{
				if (!listeners[event][id].onlyOnce) 
				{
					listeners[event][id].completed = false;
				}
				else
				{
					removeListenerByID(event, id);
				}
			}
		}
	}
	// EVENT RECEIVED FROM EVENT HIJACKERS WHEN WAIT FOR COMPLETE CALLBACK IS CALLED
	private function onHijackComplete(evt:Object):Void
	{
		var allDone:Boolean = true;
		var event:String = evt.event;
		for (var id:String in listeners[event])
		{
			if (!listeners[event][id].completed)
			{
				allDone = false;
				break;
			}
		}
		if (allDone) 
		{
			resetEventHijackers(event);
			this[event + "Done"]();
		}
	}
}