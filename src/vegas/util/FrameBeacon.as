/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import vegas.data.iterator.ArrayIterator;
import vegas.data.iterator.Iterator;
import vegas.events.Delegate;
import vegas.util.ArrayUtil;

/**
 * This singleton create a virtual Frame interval with a onEnterFrame event. 
 * The use can register object listeners to receive onEnterFrame event.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.util.FrameBeacon ;
 * 
 * var i:Number = 0 ;
 * var max:Number = 25 ;
 * 
 * var o = {} ;
 * o.onEnterFrame = function () 
 * {
 *     trace (i) ;
 *     i++ ;
 *     if (i == max) 
 *     {
 *         FrameBeacon.removeFrameListener(this) ;
 *     }
 * }
 * 
 * FrameBeacon.addFrameListener(o) ;
 * 
 * this.onKeyDown = function () 
 * {
 *     if (FrameBeacon.running)
 *     {
 *         FrameBeacon.stop() ;
 *     }
 *     else
 *     {
 *         FrameBeacon.start() ;
 *     }
 * }
 * Key.addListener(this) ;
 * }  
 * @author eKameleon
 */
class vegas.util.FrameBeacon 
{

	static private var __initBroadcaster = AsBroadcaster.initialize(FrameBeacon) ;	

	static private var __initConstructor = FrameBeacon.initialize() ;

	/**
	 * Returns {@code true} if the {@code FrameBeacon} is in progress (read only property).
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.util.FrameBeacon ;
	 * FrameBeacon.start() ;
	 * trace(FrameBeacon.running) ; // true
	 * } 
	 * @return {@code true} if the {@code FrameBeacon} is in progress.
	 */
	static public function get running():Boolean 
	{
		return FrameBeacon._mc.onEnterFrame == FrameBeacon._proxy ;
	}

	/**
	 * Registers a listener to receive the onEnterFrame event.
	 */
	static public function addFrameListener(listener):Void  
	{
		if (!FrameBeacon.running) 
		{
			FrameBeacon.start() ;
		}
		FrameBeacon.addListener(listener) ;
	}

	/**
	 * Returns {@code true} if the listener is registered in the FrameBeacon tool.
	 * @return {@code true} if the listener is registered in the FrameBeacon tool.
	 */
	static public function containsListener(listener):Boolean
	{
		return ArrayUtil.contains( FrameBeacon._listeners, listener ) ;
	}

	/**
	 * Initialize the protected MovieClip who notify the onEnterFrame event.
	 * @return the internal reference of the movieclip used by the FrameBeacon tool class.
	 */
	static public function initialize():MovieClip 
	{
		FrameBeacon._mc = _level0.createEmptyMovieClip ("__mcFBeacon__", -9998) ;
		return FrameBeacon._mc ;
	}

	/**
	 * Returns {@code true} if this instance is empty of listeners.
	 * @return {@code true} if this instance is empty of listeners.
	 */
	static public function isEmpty():Boolean 
	{
		return FrameBeacon._listeners.length == 0 ;
	}

	/**
	 * Returns the iterator of this FrameBeacon singleton.
	 * @return the iterator of this FrameBeacon singleton.
	 */
	static public function iterator():Iterator 
	{
		return new ArrayIterator(FrameBeacon._listeners) ;
	}

	/**
	 * Release the {@code FrameBeacon} singleton.
	 */
	static public function release():Void 
	{
		FrameBeacon.stop() ;
		FrameBeacon._mc.swapDepths(_level0.getNextHighestDepth()) ;
		FrameBeacon._mc.removeMovieClip () ;
		FrameBeacon._mc = undefined ;
	}

	/**
	 * Removes a listener who receive the onEnterFrame event.
	 * If the {@code FrameBeacon} is empty the event broadcast is stopped.
	 */
	static public function removeFrameListener(listener):Void 
	{
		FrameBeacon.removeListener(listener) ;
		if (FrameBeacon.isEmpty())
		{
			FrameBeacon.stop();
		}
	}
	
	/**
	 * Returns the number of listeners in the tool.
	 * @return the number of listeners in the tool.
	 */
	static public function size():Number 
	{
		return FrameBeacon._listeners.length ;
	}
	
	/**
	 * Start the onEnterFrame broadcast.
	 */
	static public function start():Void 
	{
		FrameBeacon._mc.onEnterFrame = FrameBeacon._proxy ;
	}

	/**
	 * Stop the onEnterFrame broadcast.
	 */
	static public function stop():Void 
	{
		delete FrameBeacon._mc.onEnterFrame ;
	}

	/**
	 * Returns the string representation of this singleton.
	 * @return the string representation of this singleton.
	 */
	static public function toString():String 
	{
		return "[FrameBeacon]" ;
	}

	static private var addListener:Function ;

	static private var broadcastMessage:Function;

	static private var _listeners:Array = new Array() ;

	static private var _mc:MovieClip ;

	static private var _proxy:Function = Delegate.create( FrameBeacon, FrameBeacon.broadcastMessage , "onEnterFrame" ) ; 

	static private var removeListener:Function ;
	
}
