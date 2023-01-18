/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is LunAS Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import asgard.display.Direction;

import lunas.display.components.container.ScrollContainer;

import pegas.events.MouseEvent;
import pegas.events.MouseEventType;

import vegas.events.Delegate;
import vegas.events.TimerEvent;
import vegas.util.Timer;

/**
 * @author ekameleon
 */
class lunas.display.components.container.AutoScrollContainer extends ScrollContainer 
{
	
	/**
	 * Creates a new AutoScrollContainer instance.
	 */
	private function AutoScrollContainer() 
	{
		super() ;
		_timer = new Timer(200);
		_timer.addEventListener(TimerEvent.TIMER, new Delegate(this, _mouseEvent));
		updateMouseEvent() ;
	}
	
	static public var ROLLOUT:String = MouseEventType.ROLLOUT ;

	static public var ROLLOVER:String = MouseEventType.ROLLOVER ;

	/**
	 * Returns {@code true} if the auto scroll is active.
	 * @return {@code true} if the auto scroll is active.
	 */
	public function get autoScroll():Boolean 
	{
		return getAutoScroll() ;	
	}

	/**
	 * Sets the auto scroll activity.
	 */
	public function set autoScroll(b:Boolean):Void 
	{
		setAutoScroll(b) ;	
	}

	/**
	 * Defines a value between 0 and 50%.
	 */
	public var scrollAutoRatio:Number = 10 ;

	/**
	 * Returns the delay in ms to refresh the scroll value.
	 * @return the delay in ms to refresh the scroll value.
	 */
	public function get scrollInterval():Number 
	{
		return getScrollInterval() ;	
	}
	
	/**
	 * Sets the delay in ms to refresh the scroll value.
	 */
	public function set scrollInterval(n:Number):Void 
	{
		setScrollInterval(n) ;	
	}
	
	public var useHandCursor = false ;

	public function getAutoScroll():Boolean 
	{ 
		return _auto ;
	}

	public function getIsOut():Boolean 
	{
		return (__mouse.x < __min.x) || (__mouse.x > __max.x) || (__mouse.y < __min.y) || (__mouse.y > __max.y) ;
	}

	public function getLimit():Object 
	{ 
		return { min : __min , max : __max } ;
	}

	public function getMousePos():Object 
	{ 
		return __mouse ; 
	}

	public function getPosRatio():Number 
	{
		var prop:String = (_nDirection == Direction.VERTICAL) ? "y" : "x" ;
		var ratio:Number = Math.round (__mouse[prop] * 100 / __max[prop])  ;
		return ratio ;
	}
	
	public function getScrollInterval():Number 
	{ 
		return _timer.getDelay() ;
	} 

	public function setAutoScroll(bool:Boolean):Void 
	{ 
		_auto = bool ; 
		stopMouseEvent() ;
	}

	public function setLocalizer () : Void 
	{
		var c:MovieClip = _mcMask ;
		__min = { x: c._x, y: c._y } ;
		__max = { 
			x: c._x + c._width , 
			y: c._y + c._height 
		};
	}
	
	public function setScrollInterval(n:Number):Void 
	{ 
		_timer.setDelay(n) ;
	} 
	
	public function startMouseEvent() : Void 
	{
		delete this.onRollOver ;
		dispatchEvent(new MouseEvent(ROLLOVER, this)) ;
		if (_auto) 
		{
			setLocalizer () ;
			_timer.start() ;
		}
	}
	
	public function stopMouseEvent(noEvent:Boolean):Void 
	{
		if (noEvent != true) 
		{
			dispatchEvent(new MouseEvent(ROLLOUT, this)) ;
		}
		_timer.stop() ;
		 updateMouseEvent() ;
	}

	public function updateMouseEvent():Void 
	{
		if (_auto && enabled) 
		{
			onRollOver = Delegate.create(this, startMouseEvent) ;
		}
	}
	
	/*override*/ public function viewChanged():Void 
	{
		super.viewChanged() ;
		stopMouseEvent(true) ;
	}
	
	/*override*/ public function viewDestroyed():Void 
	{
		super.viewDestroyed() ;
		_timer.stop() ;
	}
	
	/*override*/ public function viewEnabled():Void 
	{
		super.viewEnabled() ; 
		if (enabled) 
		{
			startMouseEvent();
		}
		else
		{
			stopMouseEvent() ;
		}
	}

	private var _auto:Boolean = true;

	private var __min:Object ;

	private var __max:Object ;

	private var __mouse:Object ;

	private var _timer:Timer ;
	
	private function _mouseEvent( e:TimerEvent ):Void 
	{
		
		__mouse = { x:_xmouse , y:_ymouse } ;
		var nR:Number = getPosRatio() ;
		var nMax:Number = scrollAutoRatio || 0 ;
		var nS:Number = getScroll() ;
		if (getIsOut()) 
		{
			stopMouseEvent () ;
		}
		else if (nR < nMax) 
		{
			setScroll(nS-1) ;
		}
		else if ( nR> (100-nMax)) 
		{
			setScroll(nS+1) ;
		}
		
		
	}
	
}