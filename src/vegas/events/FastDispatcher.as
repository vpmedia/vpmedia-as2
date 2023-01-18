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

import vegas.core.CoreObject;
import vegas.data.iterator.ArrayIterator;
import vegas.data.iterator.Iterable;
import vegas.data.iterator.Iterator;
import vegas.events.DynamicEvent;
import vegas.events.Event;
import vegas.util.Mixin;

/**
 * This class is an implementation of the native AsBroadcaster event model but used {@code Event} object to dispatch the message.
 * <p>You can used this class with a simple instance, with an extends class or with the mixin(use initialize static method like AsBroadcaster).</p>
 * <p><b>Example : </b></p>
 * {@code
 * import vegas.events.Event ;
 * import vegas.events.FastDispatcher ;
 * 
 * function onTest( ev:Event ):Void 
 * {
 *     trace ("--------") ;
 *     trace ("type : " + ev.getType()) ;
 *     trace ("target : " + ev.getTarget()) ;
 *     trace ("context : " + ev.getContext()) ;
 *     trace ("this : " + this) ;
 * }
 * 
 * var oFD:FastDispatcher = new FastDispatcher() ;
 * 
 * trace ("addListener this : " + oFD.addListener(this)) ;
 * trace ("hasListeners : " + oFD.hasListeners()) ;
 * trace ("size : " + oFD.size()) ;
 * oFD.dispatch( { type : "onTest", target : this } ) ;
 * oFD.removeAllListeners() ;
 * oFD.dispatch( { type : "onTest", target : this } ) ;
 * }
 * @author eKameleon
 */
class vegas.events.FastDispatcher extends CoreObject implements Iterable 
{

	/**
	 * Creates a new FastDispatcher instance.
	 * @param ar an Array of listeners object.
	 */
	public function FastDispatcher( ar:Array ) {
		_listeners = (ar.length > 0) ? [].concat(ar) : [] ;
	}

	/**
	 * Registers an object to receive event notification messages.
	 * This method is called on the broadcasting object and the listener object is sent as an argument.
 	*/
	public function addListener(listener):Boolean 
	{
		return null ; // Mixin
	}

	/**
	 * Sends an event message to each object in the list of listeners.
	 * When the message is received by the listening object, Flash Player attempts to invoke a function of the same name on the listening object.
	 */
	public function broadcastMessage( eventName:String /* , [param1, param2, .., paramN] */):Void
	{
		//
	}

	/**
	 * Returns a shallow copy of this instance.
	 * @return a shallow copy of this instance.
	 */
	public function clone() 
	{
		return new FastDispatcher(_listeners) ;
	}
	
	/**
	 * Sends an Event Object to each object in the list of listeners.
	 * When the Event is received by the listening object, Flash Player attempts to invoke a function of the same name on the Event.type property.
	 */
	public function dispatch(event):Event 
	{
		if (!event) return null ;
		var e:Event ;
		var tof:String = typeof(event) ;
		if (event instanceof Event) 
		{
			e = event ;
		}
		else if (tof == "string") 
		{
			e = new DynamicEvent(event) ;
		}
		else if (tof == "object") 
		{
			if (event.type == undefined) 
			{
				return null ;
			}
			e = new DynamicEvent() ;
			e.setType(event.type) ;
			e.setTarget(event.target) ;
			e.setContext(event.context) ;
		}
		broadcastMessage(e.getType(), e) ;
		return e ;
	}
	
	/**
	 * Returns an array representation of all listeners.
	 * @return an array representation of all listeners.
	 */
	public function getListeners():Array 
	{
		return [].concat(_listeners) ;
	}

	/**
	 * Launch the mixin of the FastDispatcher methods in the specified target.
	 * @param target the object decorates by the FastDispatcher.
	 * @see Mixin
	 */
	static public function initialize ( target ):Void 
	{
		var properties:Array = 
		[
			"addListener" , "broadcastMessage", "dispatch", "iterator" ,
			"removeAllListeners" , "removeListener" , "size"
		] ;
		var mix:Mixin = new Mixin( FastDispatcher, target, properties ) ; 
		mix.run() ;
	}

	/**
	 * Returns {@code true} is the listeners list is empty.
	 * @return {@code true} is the listeners list is empty.
	 */
	public function isEmpty():Boolean 
	{
		return _listeners.length == 0 ;
	}
	
	/**
	 * Returns an iterator of the listeners list.
	 * @return an iterator of the listeners list.
	 */
	public function iterator():Iterator 
	{
		return new ArrayIterator(_listeners) ;
	}

	/**
	 * Removes all listeners.
	 */
	public function removeAllListeners():Void {
		_listeners.splice(0) ;
	}
	
	/**
	 * Removes the specified listener.
	 */
	public function removeListener(listener):Boolean 
	{
		return null ; // Mixin
	}
	
	/**
	 * Returns the number of listeners.
	 * @return the number of listeners.
	 */
	public function size():Number 
	{
		return _listeners.length ;
	}


	static private var _initBroadcaster = AsBroadcaster.initialize(FastDispatcher.prototype) ;

	/**
	 * The internal _listeners array injected by the AsBroadcaster class.
	 */
	private var _listeners:Array ;

}