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

import lunas.display.container.ScrollContainerDisplay;

import pegas.events.MouseEvent;
import pegas.events.MouseEventType;

import vegas.events.Delegate;
import vegas.events.TimerEvent;
import vegas.util.Timer;

/**
 * This scrollable container use an auto scroll effect.
 * @author ekameleon
 */
class lunas.display.container.AutoScrollContainerDisplay extends ScrollContainerDisplay 
{
	
	/**
	 * Creates a new AutoScrollContainerDisplay instance.
	 * @param sName:String the name of the display.
	 * @param target:MovieClip the DisplayObject instance control this target.
	 * @param id (optional) the id of the model.
	 * @param bGlobal (optional) the flag to use a global event flow or a local event flow.
	 * @param sChannel (optional) the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 * @param childs (optional) An Array of items to insert in the model.
	 */
	function AutoScrollContainerDisplay( sName:String, target:MovieClip , id , bGlobal:Boolean , sChannel:String , childs:Array ) 
	{ 
		super( sName, target, id, bGlobal, sChannel, childs ) ;
		_timer = new Timer(200);
		_timer.addEventListener(TimerEvent.TIMER, new Delegate(this, _mouseEvent));
		useHandCursor = false ;
		updateMouseEvent() ;
	}
	
	/**
	 * The default event name dispatched when the container is rollout.
	 */
	static public var ROLLOUT:String = MouseEventType.ROLLOUT ;

	/**
	 * The default event name dispatched when the container is rollover.
	 */
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
	 * Sets the auto scroll activity value.
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
	
	/**
	 * Returns {@code true} if the autoscroll mode is active.
	 * @return {@code true} if the autoscroll mode is active.
	 */
	public function getAutoScroll():Boolean 
	{ 
		return _auto ;
	}
	
	/**
	 * Returns {@code true} if the mouse is out of the bounds of the container.
	 * @return {@code true} if the mouse is out of the bounds of the container.
	 */
	public function getIsOut():Boolean 
	{
		return (__mouse.x < __min.x) || (__mouse.x > __max.x) || (__mouse.y < __min.y) || (__mouse.y > __max.y) ;
	}

	/**
	 * Returns the limit values. The limit object contains two properties 'min' and 'max'.
	 * @return the limit values.
	 */
	public function getLimit():Object 
	{ 
		return { min : __min , max : __max } ;
	}

	/**
	 * Returns the mouse position object.
	 * @return the mouse position object.
	 */
	public function getMousePos():Object 
	{ 
		return __mouse ; 
	}

	/**
	 * Returns the position ratio value of the container.
	 * @return the position ratio value of the container.
	 */
	public function getPosRatio():Number 
	{
		var prop:String = (_nDirection == Direction.VERTICAL) ? "y" : "x" ;
		var ratio:Number = Math.round (__mouse[prop] * 100 / __max[prop])  ;
		return ratio ;
	}
	
	/**
	 * Returns the scroll interval time value.
	 * @return the scroll interval time value.
	 */
	public function getScrollInterval():Number 
	{ 
		return _timer.getDelay() ;
	} 

	/**
	 * Sets if the container use an autoscroll policy or not.
	 */
	public function setAutoScroll(bool:Boolean):Void 
	{ 
		_auto = bool ; 
		stopMouseEvent() ;
	}

	/**
	 * Sets the min and max position of the container. 
	 */
	public function setLocalizer () : Void 
	{
		var c:MovieClip = getMask() ;
		__min = { x: c._x, y: c._y } ;
		__max = 
		{ 
			x: c._x + c._width , 
			y: c._y + c._height 
		};
	}
	
	/**
	 * Sets the scroll interval time value.
	 */
	public function setScrollInterval(n:Number):Void 
	{ 
		_timer.setDelay(n) ;
	} 
	
	/**
	 * Start the mouse event activity.
	 */
	public function startMouseEvent() : Void 
	{
		delete view.onRollOver ;
		dispatchEvent(new MouseEvent(ROLLOVER, this)) ;
		if (_auto) 
		{
			setLocalizer () ;
			_timer.start() ;
		}
	}
	
	/**
	 * Stops the mouse event activity.
	 */
	public function stopMouseEvent(noEvent:Boolean):Void 
	{
		if (noEvent != true) 
		{
			dispatchEvent(new MouseEvent(ROLLOUT, this)) ;
		}
		_timer.stop() ;
		 updateMouseEvent() ;
	}

	/**
	 * Update the mouse event activity.
	 */
	public function updateMouseEvent():Void 
	{
		if (_auto && enabled) 
		{
			view.onRollOver = Delegate.create(this, startMouseEvent) ;
		}
	}
	
	/**
	 * Invoqued if the view of the container is changed.
	 */
	/*override*/ public function viewChanged():Void 
	{
		super.viewChanged() ;
		stopMouseEvent(true) ;
	}
	
	/**
	 * Invoqued if the container MovieClip reference is release.
	 */
	/*override*/ public function viewDestroyed():Void 
	{
		super.viewDestroyed() ;
		_timer.stop() ;
	}
	
	/**
	 * Invoqued when the view enabled value change.
	 */
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
		
		__mouse = { x:view._xmouse , y: view._ymouse } ;
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