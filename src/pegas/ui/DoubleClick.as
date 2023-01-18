/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is PEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

import pegas.events.MouseEvent;

import vegas.events.Event;
import vegas.events.FastDispatcher;

/**
 * This class defines a double click manager in your applications.
 * <p><b>Example :</b></p>
 * {@code
 * import pegas.events.MouseEvent ;
 * import pegas.ui.DoubleClick ;
 * 
 * // Test with broadcaster
 * 
 * var doubleClick:Function = function (ev:MouseEvent):Void
 * {
 *     trace ( this + " -> " + ev.type) ;
 * }
 * 
 * DoubleClick.addListener( this )  ;
 * 
 * // Test with the static property ISDOUBLE.
 * 
 * bt.onPress = function ()
 * {
 *     if ( DoubleClick.ISDOUBLE )
 *     {
 *        trace (this + " -> " + MouseEvent.DOUBLE_CLICK) ;
 *     }
 * }
 * 
 * }
 * @author eKameleon
 */
class pegas.ui.DoubleClick 
{

	/**
	 * Returns the delay between 2 clicks.
	 * @return the delay between 2 clicks.
	 */
	static public function get delay():Number
	{
		return _delay ;
	}
   
   	/**
   	 * Sets the delay between 2 clicks.
   	 */
	static public function set delay(n:Number):Void 
	{
		_delay = n > 0 ? n : 0 ;
	}

	/**
	 * Returns {@code true} if the last click with the mouse is a double click.
	 * @return {@code true} if the last click with the mouse is a double click.
	 */
	static public function get ISDOUBLE():Boolean 
	{
		if (!_dispatcher) initialize() ;
		return __ISDOUBLE__ ;
	}
	
	/**
	 * Registers an object to receive event notification messages.
	 * @return {@code true} of the listener is register.
	 */
	static public function addListener(listener):Boolean 
	{
		if ( _dispatcher == null ) 
		{
			initialize() ;
		}
		return _dispatcher.addListener(listener) ;
	}
	
	/**
	 * Initialize the double click dispatcher.
	 * @return {@code true} if the initialize process is success.
	 */
	static public function initialize():Boolean 
	{
		if (_dispatcher == null)
		{
			_dispatcher = new FastDispatcher() ;
			Mouse.addListener(DoubleClick) ;
			reset() ;
			return true ;
		}
		else
		{
			return false ;
		}
	}
	
	/**
	 * Release the double click dispatcher.
	 * @return {@code true} if the release process is success.
	 */
	static public function release():Boolean
	{
		if ( _dispatcher != null )
		{
			_dispatcher = null ;
			reset() ;
			Mouse.removeListener(DoubleClick) ;
			return true ;
		}
		else
		{
			return false ;
		}
	}

	/**
	 * Removes an object from the list of objects that receive event notification messages.
	 * @return {@code true} of the listener is removed.
	 */
	static public function removeListener(listener):Boolean 
	{
		return _dispatcher.removeListener(listener) ;
	}
	
	/**
	 * Removes all objects from the list of objects that receive event notification messages.
	 */
	static public function removeAllListeners():Void 
	{
		_dispatcher.removeAllListeners() ;
	}
	
	/**
	 * Returns the string representation of this object.
	 * @return the string representation of this object.
	 */
	static public function toString():String 
	{
		return "[DoubleClick]" ;
	}

	static private var _delay:Number = 250 ;
	static private var _itv:Number ;
	static private var _cpt:Number ;
	static private var _dispatcher:FastDispatcher ;
	static private var __ISDOUBLE__:Boolean = false ;
	
	/**
	 * Invoqued when the mouse is down.
	 */
	static private function onMouseDown():Void
	{
		_cpt ++ ;
		__ISDOUBLE__ = _cpt == 2 ;
		clearInterval(_itv) ;
		var type:String = (_cpt == 2)  ? MouseEvent.DOUBLE_CLICK : MouseEvent.CLICK ;
		var ev:Event = new MouseEvent(type, DoubleClick) ;
		_dispatcher.dispatch( ev ) ;
		_itv = setInterval( reset , _delay) ;
	}

	/**
	 * Reset the effect.
	 */	
	static private function reset():Void
	{
		clearInterval(_itv);
		__ISDOUBLE__ = false ;
		_cpt = 0 ;
	}
	
}