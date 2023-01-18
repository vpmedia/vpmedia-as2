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
import vegas.data.map.HashMap;
import vegas.data.Queue;
import vegas.data.Set;
import vegas.data.set.HashSet;
import vegas.events.Event;
import vegas.events.EventListener;
import vegas.events.EventListenerCollection;
import vegas.events.EventListenerContainer;
import vegas.events.EventPhase;
import vegas.events.EventQueue;
import vegas.events.IEventDispatcher;
import vegas.util.factory.EventFactory;
import vegas.util.TypeUtil;

// TODO implement capturing with addGlobalEventDispatcher ?
// TODO test bubbling/capturing

/**
 * Stores the listeners object an notifies them with the DOM Events level 2/3 of the W3C.
 * The EventDispatcher class implements the IEventDispatcher interface. 
 * This object allows any object to be an {@code EventTarget}.
 * <p><b>Thanks</b>:</p>
 * <p>{@code EventDispatcher} is an AS2 port of the <b>Java.schst.net EventDispatcher</b>. Inspired by the NotificationCenter of Apple's Cocoa-Framework.
 * <li>EventDispatcher JAVA : Stephan Schmid - http://schst.net/</li><li>Cocoa-Framework : http://developer.apple.com/cocoa/</li><li>Notification center : http://developer.apple.com/documentation/Cocoa/Conceptual/Notifications/index.html</li>
 * </p>
 * @author eKameleon
 */
class vegas.events.EventDispatcher extends CoreObject implements IEventDispatcher 
{

	/**
	 * Creates a new EventDispatcher instannce.
	 * @param target The IEventDispatcher scope reference of this instance.
	 * @param parent The parent EventDispatcher reference of this instance.
	 * @param name The name value of this instance. 
	 */
	public function EventDispatcher( target:IEventDispatcher , parent:EventDispatcher , name:String ) 
	{
		
		_globalListeners = new EventListenerCollection() ;
		_captures = new HashMap() ;
		_listeners = new HashMap() ;
		_queue = new EventQueue() ;
		_target = target || this ;
		
		this.parent = parent || null ;
		
		_setName( name ) ;
		
	}

	/**
	 * Determinates the default singleton name.
	 */
	static public var DEFAULT_SINGLETON_NAME:String = "__default__" ;

	/**
	 * [read-write] Indicates the instance name of the EventDispatcher.
	 * @return the name of this EventDispatcher.
	 */
	public function get name():String 
	{
		return _sName ;
	}

	/**
	 * [read-write] Set the instance name of the DisplayObject.
	 */
	public function set name( sName:String ):Void 
	{
		_setName( sName ) ;
	}

	/**
	 * The parent EventDispatcher reference of this EventDispatcher.
	 */
	public var parent:EventDispatcher ;

	/**
	 * Adds a child EventDispatcher reference at this instance.
	 */
	public function addChild( child:EventDispatcher ):Void 
	{
		child.parent = this ;
	}

	/**
	 * Allows the registration of event listeners on the event target.
	 * @param eventName A string representing the event type to listen for. If eventName value is "ALL" addEventListener use addGlobalListener
	 * @param listener The object that receives a notification when an event of the specified type occurs. This must be an object implementing the {@code EventListener} interface.
	 * @param useCapture Determinates if the event flow use capture or not.
	 * @param priority Determines the priority level of the event listener.
	 * @param autoRemove Apply a removeEventListener after the first trigger
	 */
	public function addEventListener( eventName:String, listener:EventListener, useCapture:Boolean, priority:Number, autoRemove:Boolean):Void 
	{
		
		priority = isNaN(priority) ? 0 : priority ;
		
		if (eventName == "ALL") 
		{
			addGlobalEventListener(listener, priority, autoRemove) ;
		}
		else 
		{
			var map:HashMap = (!useCapture) ? _listeners : _captures ;
			if (!map.containsKey(eventName)) 
			{
				map.put(eventName, new EventListenerCollection()) ;
			}
			var col:EventListenerCollection = map.get(eventName) ;
			col.addListener(listener, autoRemove, priority) ;	
			_dispatchQueuedEvents() ;
		}
	}

	/**
	 * Allows the registration of global event listeners on the event target.
	 * @param listener The object that receives a notification when an event of the specified type occurs. This must be an object implementing the {@code EventListener} interface.
	 * @param priority Determines the priority level of the event listener.
	 * @param autoRemove Apply a removeEventListener after the first trigger
	 */
	public function addGlobalEventListener(listener:EventListener, priority:Number, autoRemove:Boolean):Void 
	{
		_globalListeners.addListener(listener, autoRemove, priority ) ;
        _dispatchQueuedEvents() ;
    }

	/**
	 * Dispatches an event into the event flow.
	 * @param event The Event object that is dispatched into the event flow.
	 * @param isQueue if the EventDispatcher isn't register to the event type the event is bufferized.
	 * @param target the target of the event.
	 * @param contect the context of the event.
	 * @return the reference of the event dispatched in the event flow.
	 */
	public function dispatchEvent( event , isQueue:Boolean, target, context):Event 
	{
		if (!event) 
		{
			return null ;
		}
		var e:Event = EventFactory.create(event, target || this, context) ;
		if (e == null) 
		{
			return null ;
		}
		var phase:Number = e.getEventPhase() ;
		if (phase == EventPhase.AT_TARGET) 
		{
			_capture(e) ; // CAPTURING_PHASE
			e.setEventPhase(EventPhase.AT_TARGET) ;
			e.setCurrentTarget(this) ;
			_propagate(e, isQueue || false ) ; // AT_TARGET
			_bubble(e) ; // BUBBLING_PHASE
			e.setEventPhase(EventPhase.AT_TARGET) ; // TODO inclure cette initialisation dans initEvent ??
		}
		else if (phase == EventPhase.BUBBLING_PHASE) 
		{
			_propagateBubble(e) ;
		}
		else if (phase == EventPhase.CAPTURING_PHASE) 
		{
			_propagateCapture(e) ;
		}
		return e ;
	}

	/**
	 * Flush all global EventDispatcher singleton.
	 */
	static public function flush():Void 
	{
		EventDispatcher.instances.clear() ;
	}

	/**
	 * Returns the {@code EventListenerCollection} of the specified event name.
	 * @return the {@code EventListenerCollection} of the specified event name.
	 */
	public function getEventListeners(eventName:String):EventListenerCollection 
	{
		if ( _listeners.containsKey(eventName) ) 
		{
			return _listeners.get(eventName) ;
		}
		return new EventListenerCollection() ;
	}
	
	/**
	 * Returns the global {@code EventListenerCollection} of this EventDispatcher.
	 * @return the global {@code EventListenerCollection} of this EventDispatcher.
	 */
	public function getGlobalEventListeners():EventListenerCollection 
	{
        return _globalListeners ;
    }

	/**
	 * Returns a global {@code EventDispatcher} singleton. Uses this method to create [@code FrontController} patterns for example.
	 * @return a global {@code EventDispatcher} singleton.
	 */
	static public function getInstance(name:String):EventDispatcher 
	{
		if (!name) 
		{
			name = DEFAULT_SINGLETON_NAME ;
		}
		if (!EventDispatcher.instances.containsKey(name)) 
		{
			EventDispatcher.instances.put(name, new EventDispatcher(null, null, name)) ;
		}
		return EventDispatcher(EventDispatcher.instances.get(name));
	}

	/**
	 * Returns the name of the display.
	 * @return the name of the display.
	 */
	public function getName():String
	{
		return _sName || null ;
	}

	/**
	 * Returns a {@code Set} of all register event's name in this EventListener.
	 * @return a {@code Set} of all register event's name in this EventListener.
	 */
	public function getRegisteredEventNames():Set 
	{
    	return new HashSet(_listeners.getKeys()) ;
    }
	
	/**
	 * Returns the current target of this EventDispatcher.
	 * @return the current target of this EventDispatcher.
	 */
	public function getTarget() 
	{
		return _target ;	
	}
	
	/**
	 * Checks whether the EventDispatcher object has any listeners registered for a specific type of event.
	 * This allows you to determine where altered handling of an event type has been introduced in the event flow heirarchy by an EventDispatcher object.
	 */ 
	public function hasEventListener(eventName:String):Boolean 
	{
		return _listeners.containsKey(eventName) ;
	}

	/**
	 * Release the specified EventDispatcher singleton in your application.
	 */
	static public function release(name:String):EventDispatcher 
	{
		if (!name) 
		{
			name = "__default__" ;
		}
		return EventDispatcher.instances.remove(name) ;
	}

	/**
	 * Removes the EventDispatcher child reference of this EventDispatcher instance.
	 * @param child The EventDispatcher child reference of this instance.
	 */
	public function removeChild( child:EventDispatcher ):Void 
	{
		child.parent = null ;
	}

	/** 
	 * Removes a listener from the EventDispatcher object.
	 * If there is no matching listener registered with the EventDispatcher object, then calling this method has no effect.
	 * @param Specifies the type of event.
	 * @param the class name(string) or a EventListener object.
	 */
    public function removeEventListener(eventName:String, listener , useCapture:Boolean):EventListener 
    {
		if (eventName == "ALL") 
		{
			return removeGlobalEventListener(listener) ;
		}
		if (listener instanceof EventListener || TypeUtil.typesMatch(listener, String))  
		{
			var map:HashMap = (!useCapture) ? _listeners : _captures ;
			if (!map.containsKey(eventName) ) 
			{
				return null ;
			}
			var col:EventListenerCollection = map.get(eventName) ;
			var container:EventListenerContainer = col.removeListener(listener) ;
			if (container != null) 
			{
				return container.getListener() ;
			}
		}
        return null ;
    }

	/** 
	 * Removes a global listener from the EventDispatcher object.
	 * If there is no matching listener registered with the EventDispatcher object, then calling this method has no effect.
	 * @param the class name(string) or a EventListener object.
	 */
	public function removeGlobalEventListener( listener ):EventListener 
	{
		if (listener instanceof EventListener || typeof(listener) == "string") 
		{
			var container:EventListenerContainer = EventListenerContainer(_globalListeners.removeListener(listener));
			if (container != null) 	
			{
				return container.getListener();
			}
			return null;
		}
	}
	
	/**
	 * Removes a global EventDispatcher singleton.
	 */
	static public function removeInstance(name:String):Boolean 
	{
		if (!EventDispatcher.instances.containsKey(name)) 
		{
			return EventDispatcher.instances.remove(name) != null ;
		}
		else 
		{
			return false ;
		}
	}

	/**
	 * The static internal hashmap to register all global instances in your applications.
	 */	
	static private var instances:HashMap = new HashMap() ;
	
	/**
	 * The internal EventListenerCollection to register all global listeners.
	 */
	private var _globalListeners:EventListenerCollection ;
	
	/**
	 * The HashMap to put all captures.
	 */
	private var _captures:HashMap ;
	
	/**
	 * The HashMap of all listeners.
	 */
	private var _listeners:HashMap ;
	
	/**
	 * The internal EventQueue buffer. 
	 */
	private var _queue:EventQueue ;

	/**
	 * The internal name's property of the instance.
	 */
	private var _sName:String = null ;

	/**
	 * The internal IEventDispatcher target.
	 */
	private var _target:IEventDispatcher ;
	
	private function _bubble(e:Event):Boolean 
	{
		if (e["stop"] >= EventPhase.STOP ) return false ;
		var parents:Array = _getParents() ;
		if (parents != null) 
		{
			var l:Number = parents.length ;
			var i:Number = 0 ;
			var current:EventDispatcher ;
			while (i<l) 
			{
				if (e.getBubbles()) 
				{
					current = parents[i] ;
					e.setCurrentTarget(current.getTarget()) ;
					e.setEventPhase(EventPhase.BUBBLING_PHASE) ;
					current.dispatchEvent(e) ;
					if (e["stop"] >= EventPhase.STOP ) 
					{
						return false ;
					}
				}
				i++ ;
			}
		}
		return true ;
	}
	
	private function _capture(e:Event):Boolean 
	{
		var parents:Array = _getParents() ;
		if (parents != null) 
		{
			var l:Number = parents.length ;
			var current:EventDispatcher ;
			while (--l > -1) 
			{
				current = parents[l] ;
				e.setCurrentTarget(current.getTarget()) ;
				e.setEventPhase(EventPhase.CAPTURING_PHASE) ;
				current.dispatchEvent(e) ;
				if (e["stop"] >= EventPhase.STOP ) 
				{
					return false ;
				}
			}
		}
		return true ;
	}
	
	private function _dispatchQueuedEvents():Void 
	{
		var q:Queue = _queue.getQueuedEvents();
		if (q.size() > 0) 
		{
			var ar:Array = q.toArray() ;
			var len:Number = ar.length ;
			for (var i:Number = 0 ; i<len ; i++) 
			{
				var e:Event = ar[i] ;
				dispatchEvent(e, e.isQueued()) ;
			}
		}
	}

	private function _getParents():Array 
	{
		if (parent == null) 
		{
			return null ;
		}
		var ar:Array = [] ;
		var tmp:EventDispatcher = parent ;
		while(tmp != null) 
		{
			ar.push(tmp) ;
			tmp = tmp.parent ;
		}
		return ar ;
	}

	private function _propagate(e:Event, isQueue:Boolean):Event 
	{
		
		if (e["stop"] >= EventPhase.STOP ) 
		{
			return e ; // hack the interface limitation
		}
		
		if (_listeners.containsKey(e.getType())) 
		{
            var col:EventListenerCollection = EventListenerCollection(_listeners.get(e.getType())) ;
            col.propagate(e) ;
        }
        
        if (e.isCancelled()) 
        {
        	return e ;
        }
        
        _globalListeners.propagate(e);
        
        if (isQueue == false || e.isCancelled()) 
        {
        	return e ;
        }
        
        _queue.enqueue(e) ;
        
        return e ;
        
	}

	private function _propagateBubble(e:Event):Void 
	{
		if (e.getEventPhase(EventPhase.BUBBLING_PHASE)) 
		{
			e.setCurrentTarget(getTarget()) ;
			_propagate(e) ;
		}
	}
	
	private function _propagateCapture(e:Event):Void 
	{
		if (_captures.containsKey(e.getType())) 
		{
			e.getEventPhase(EventPhase.CAPTURING_PHASE) ;
            var col:EventListenerCollection = EventListenerCollection(_captures.get(e.getType())) ;
            col.propagate(e) ;
        }
	}
	
	/**
	 * Internal method to sets the name of the instance.
	 */
	/*protected*/ private function _setName( name:String ) : Void 
	{
		_sName = name ;
	}

}