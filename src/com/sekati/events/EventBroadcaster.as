/**
 * com.sekati.events.EventBroadcaster
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * 
 * based on ca.nectere.events.Broadcaster
 */

import com.sekati.core.CoreObject;
import com.sekati.core.KeyFactory;
import com.sekati.events.IEventBroadcastable;
import com.sekati.except.Catcher;
import com.sekati.except.IllegalOperationException;
import com.sekati.validate.TypeValidation;

/**
 * EventBroadcaster 
 */
class com.sekati.events.EventBroadcaster extends CoreObject implements IEventBroadcastable {

	private static var _instance:EventBroadcaster;
	private var _listeners:Array;

	/**
	 * Singleton Private Constructor.
	 * @return Void
	 */
	private function EventBroadcaster() {
		super( );
		_listeners = new Array( );
	}

	/**
	 * Singleton Accessor.
	 * @return EventBroadcaster
	 */
	public static function getInstance():EventBroadcaster {
		if (!_instance) _instance = new EventBroadcaster( );
		return _instance;
	}

	/**
	 * Shorthand Singleton accessor getter.
	 * @return EventBroadcaster
	 */
	public static function get $():EventBroadcaster {
		return EventBroadcaster.getInstance( );	
	}

	/**
	 * Add an EventListener object
	 * @param o (Object)
	 * @param event (String)
	 * @param handler (Function)
	 * @return Void
	 */
	public function addEventListener(o:Object, event:String, handler:Function):Void {
		var index:Object = getIndex( o );
		if( !_listeners[index] ) _listeners[index] = new Array( );
		if( !_listeners[index][event] ) _listeners[index][event] = new Array( );
		_listeners[index][event].push( handler );
	}

	/**
	 * Remove an EventListener object
	 * @param o (Object)
	 * @param event (String)
	 * @param handler (Function)
	 * @return Void
	 */
	public function removeEventListener(o:Object, event:String, handler:Function):Void {
		var index:Object = getIndex( o );
		var e:Array = _listeners[index][event];
		for(var i in e) {
			if(e[i] === handler) delete _listeners[index][event][i];
		}
	}

	/**
	 * Remove all listeners and reset the broadcaster
	 * @return Void
	 */
	public function reset():Void {
		_listeners = new Array( );
	}

	/**
	 * Remove all listeners that are listening to a specific broadcaster
	 * @param o (Object)
	 * @return Void
	 */
	public function removeAllFromBroadcaster(o:Object):Void {
		var index:Object = getIndex( o );
		delete _listeners[index];
	}

	/**
	 * Remove all listeners that are listening to a specific broadcaster and a specific event
	 * @param o (Object)
	 * @param event (String)
	 * @return Void
	 */
	public function removeAllFromBroadcasterAndEvent(o:Object, event:String):Void {
		var index:Object = getIndex( o );
		delete _listeners[index][event];
	}

	/**
	 * Broadcast to all listeners (can accept extra args)
	 * @param o (Object)
	 * @param event (String)
	 * @return Void
	 */
	public function broadcastEvent(o:Object, event:String):Void {
		broadcastArrayArgs( o, event, arguments.slice( 2 ) );
	}

	/**
	 * Broadcast to all listeners (can accept extra args as array)
	 * @param o (Object)
	 * @param event (String)
	 * @param args (Array)
	 * @return Void
	 */
	public function broadcastArrayArgs(o:Object, event:String, args:Array):Void {
		var index:Object = getIndex( o );
		var e:Array = _listeners[index][event];
		for(var i in e) e[i].getFunction( ).apply( this, args );
	}

	/**
	 * Gets index to use, and will inject key in object if needed
	 * This allows using objects or strings/numbers as channel for the broadcaster
	 * Will return either a number or a string
	 * @param o (Object)
	 * @return Object
	 */
	private function getIndex(o:Object):Object {
		try {
			if (TypeValidation.isString( o ) || TypeValidation.isNumber( o )) {
				return String( o );
			} else if (TypeValidation.isObject( o ) || TypeValidation.isMovieClip( o ) || TypeValidation.isFunction( o )) {
				return KeyFactory.getKey( o );
			} else {
				throw new IllegalOperationException( this, "Unsupported broadcaster type (must be object, clip, function, string or number).", arguments );
			}
		} catch (e:IllegalOperationException) {
			Catcher.handle( e );
		}
	}
}