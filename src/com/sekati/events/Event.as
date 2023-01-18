/**
 * com.sekati.events.Event
 * @version 1.1.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreObject;
import com.sekati.events.IEvent;
/**
 * SASAPI Base Event class, works similarly to the AS3 Event class<br><br>
 * 
 * The {@link com.sekati.events.Dispatcher} class excepts an object with at least one property: 'type:String'
 * which is the identifier of the event. This is either the listener's function that is called when the event
 * is dispatched, or the link through Delegate to the function to be called. Other optional properties 
 * are:'target:Object', which is the source of the event & 'data:Object', which may contain any information 
 * you wish to pass along with the event.
 */
class com.sekati.events.Event extends CoreObject implements IEvent {
	private var _type:String;
	private var _target:Object;
	private var _data:Object;
	private var _route:Array;
	/**
	 * Constructor creates an event object fit for dispatching
	 * Note: the contents of the data parameter are copied to
	 * the Event object for legacy support.
	 * @param type (String) type of event
	 * @param target (Object) the object that dispatched this event.
	 * @param data (Object) optional data to pass with the event
	 * @return Void
	 */
	public function Event(type:String, target:Object, data:Object) {
		_type = type;
		_target = target;
		_data = data;
		// clone _data properties to the Event instance
		for (var i in _data) this[i] = _data[i];
		_route = new Array( );
	}
	public function get type():String {
		return _type;	
	}
	public function get target():Object {
		return _target;
	}
	public function get data():Object {
		return _data;	
	}
	public function bubble(newTarget:Object):Void {
		_route.push( _target );
		_target = newTarget;
	}	
}