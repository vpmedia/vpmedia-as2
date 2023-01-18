/**
 * com.sekati.events.Dispatcher
 * @version 1.1.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreObject;
import com.sekati.events.Event;
import com.sekati.events.IDispatchable;
import mx.events.EventDispatcher;

/**
 * A centralized EventDispatcher to decouple event listeners & dispatchers from direct addressing.
 * {@code Usage:
 * var receiveObj:Object = {_name:"receiveObj"};
 * // define a generic method for the reciever object to use
 * function onEventReceived (event:Object):Void {
 * var str:String = (this._name + " received Event = { type:" + event.type + ", target:" + event.target + ", data: {");
 * for (var i in event.data) { str += " " + i + ":" + event.data[i] + ","; }
 * trace (str+" }};");
 * }
 * // add the method to our reciever object as 'testEvent'
 * receiveObj.testEvent = onEventReceived;
 * // add reciever object as an event listener for "testEvent"
 * Dispatcher.getInstance().addEventListener ("testEvent",receiveObj);
 * // define sender and data objects (optional)
 * var senderObj:Object = this;
 * var dataObj:Object = {message:"hello", someNumber:42};
 * // Dispatch the event to all 'testEvent' EventListeners
 * Dispatcher.getInstance().dispatchEvent (new Event ("testEvent", senderObj, dataObj));
 * }
 * Some excellent explanations of the AS2/3 event models and broadcasters vs dispatchers
 * @see <a href="http://www.communitymx.com/content/article.cfm?page=1&cid=76FDB">http://www.communitymx.com/content/article.cfm?page=1&cid=76FDB</a>
 * @see <a href="http://www.kirupa.com/developer/actionscript/eventdispatcher.htm">http://www.kirupa.com/developer/actionscript/eventdispatcher.htm</a>
 * @see {@link com.sekati.events.Broadcaster}
 */
class com.sekati.events.Dispatcher extends CoreObject implements IDispatchable {

	private static var _instance:Dispatcher;
	private var _manager:Object;

	/**
	 * Singleton Private Constructor: initializes centralized management of mx.events.EventDispatcher
	 */
	private function Dispatcher() {
		super( );
		_manager = new Object( );
		EventDispatcher.initialize( _manager );
	}

	/**
	 * Singleton Accessor
	 * @return Dispatcher
	 */
	public static function getInstance():Dispatcher {
		if (!_instance) _instance = new Dispatcher( );
		return _instance;
	}

	/**
	 * shorthand singleton accessor getter
	 */
	public static function get $():Dispatcher {
		return Dispatcher.getInstance( );	
	}

	/**
	 * Add the event listener to the centralized event manager
	 * @param event (String) the name of the event ("click", "change", etc)
	 * @param handler (Object) the function or object that should be called
	 * @return Void
	 */
	public function addEventListener(event:String, handler:Object):Void {
		_manager.addEventListener( event, handler );
	}

	/**
	 * Remove the event listener from the centralized event manager
	 * @param event (String) the name of the event ("click", "change", etc)
	 * @param handler (Object) the function or object that should be called
	 * @return Void
	 */
	public function removeEventListener(event:String, handler:Object):Void {
		_manager.removeEventListener( event, handler );
	}

	/**
	 * Dispatch the event to all listeners via the centralized event manager
	 * @param e (Event) an Event or one of its subclasses describing the event
	 * @return Void
	 * {@code Usage:
	 * Dispatcher.getInstance().dispatchEvent(new Event("myEvent", this, {foo:true, bar:false}));
	 * }
	 */
	public function dispatchEvent(e:Event):Void {
		_manager.dispatchEvent( e );
	}

	/**
	 * Bubbles event up the chain. The target property is added on the route
	 * and then replaced by the new target.
	 * @param e (Event)
	 * @return Void
	 */
	public function bubbleEvent(e:Event):Void {
		e.bubble( this );
		dispatchEvent( e );
	}

	/**
	 * Wrapper to dispatchEvent: creates an Event object and dispatchs it to all event listeners
	 * {@code Usage:
	 * Dispatcher.getInstance().broadcastEvent("myEvent",targetObject, {param0:value0, param1:value1, paramn:valuen});
	 * }
	 * @param _type (String) type of event
	 * @param _target (Object) he object that dispatched this event. There is a known bug with this property: It always returns as '/'. This may be a flaw in EventDispatcher; if you need to pass the event source use {@link dispatchEvent}.
	 * @param _data (Object) a transport object for any needed data
	 * @return Void
	 */
	public function broadcastEvent(_type:String, _target:Object, _data:Object):Void {
		var event:Event = new Event( _type, _target, _data );
		_manager.dispatchEvent( event );
	}

	/**
	 * Destroy singleton instance.
	 * @return Void
	 */
	public function destroy():Void {
		delete _manager;
		delete _instance;
		super.destroy( );
	}	
}