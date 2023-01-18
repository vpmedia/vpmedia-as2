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

import asgard.events.NetServerEvent;
import asgard.events.NetServerEventType;
import asgard.net.NetServerPolicy;
import asgard.net.NetServerStatus;

import pegas.process.Action;

import vegas.core.HashCode;
import vegas.core.IFormattable;
import vegas.core.IHashable;
import vegas.core.ISerializable;
import vegas.data.Set;
import vegas.events.Delegate;
import vegas.events.Event;
import vegas.events.EventDispatcher;
import vegas.events.EventListener;
import vegas.events.EventListenerCollection;
import vegas.events.IEventDispatcher;
import vegas.events.TimerEvent;
import vegas.logging.ILogable;
import vegas.logging.ILogger;
import vegas.util.ConstructorUtil;
import vegas.util.Timer;
import vegas.util.TypeUtil;

/**
 * This class extends the NetConnection class and defined an implementation based on VEGAS to used Flash Remoting or Flash MediaServer (with AMF protocol).
 * @author eKameleon
 */	
class asgard.net.NetServerConnection extends NetConnection implements Action, IEventDispatcher, IFormattable, IHashable, ILogable, ISerializable 
{
	
	/**
	 * Creates a new NetServerConnection instance.
	 * @param bGlobal the flag to use a global event flow or a local event flow.
	 * @param sChannel the name of the global event flow if the {@code bGlobal} argument is {@code true}.
	 */
	function NetServerConnection( bGlobal:Boolean , sChannel:String ) 
	{
		setGlobal( bGlobal , sChannel ) ;	
		_timer   = new Timer(DEFAULT_DELAY, 1) ;
		_timeOut = new Delegate(this, _onTimeOut) ;		
		initEvent() ;
	}

	/**
	 * The default internal timeout delay value in milliseconds.
	 */
	public static var DEFAULT_DELAY:Number = 8000 ; // 8 secondes

	/**
	 * (read-only) Returns the value of the isGlobal flag of this model. Use the {@code setGlobal} method to modify this value.
	 * @return {@code true} if the model use a global EventDispatcher to dispatch this events.
	 */
	public function get isGlobal():Boolean 
	{
		return getIsGlobal() ;
	}

	/**
	 * This method is overrides if you want receive Events from the server.
	 * @see NetServerGateway
	 */
	public var receiveSharedEvent:Function ;

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
		_dispatcher.addEventListener.apply(_dispatcher, arguments);
	}

	/**
	 * Allows the registration of global event listeners on the event target.
	 * 
	 * @param listener The object that receives a notification when an event of the specified type occurs. This must be an object implementing the <b>EventListener</b> interface.
	 * @param priority Determines the priority level of the event listener.
	 * @param autoRemove Apply a removeEventListener after the first trigger
	 */
	public function addGlobalEventListener(listener:EventListener, priority:Number, autoRemove:Boolean):Void 
	{
		_dispatcher.addGlobalEventListener(listener, priority, autoRemove) ;
	}

	/**
	 * Returns the shallow copy of this object.
	 * @return the shallow copy of this object.
	 */
	public function clone() 
	{
		return new NetServerConnection() ;	
	}

	/**
	 * Close the connection.
	 * @param noEvent if this argument is {@code true} the event propagation is disabled.
	 */
	/*override*/ public function close( noEvent:Boolean ):Void 
	{
		super.close() ;
		_timer.stop() ;
		if (!noEvent) 
		{
			notifyClose() ;
		}
	}

	/**
	 * Connect the client with this method.
	 */
	/*override*/ public function connect():Boolean 
	{
		if (isConnected) 
		{
			return false ;
		}
		notifyStarted() ;
		return super.connect.apply(this, arguments) ;
	}

	/**
	 * Returns and creates a new empty ModelObjectEvent. You can override this method.
	 * @param type the type of the event.
	 * @return a new empty ModelObjectEvent with the type specified in argument.
	 */
	public function createNewEvent( type:String ):NetServerEvent 
	{
		return new NetServerEvent( type || null , this ) ;
	}

	/**
	 * Dispatches an event into the event flow.
	 * @param event The Event object that is dispatched into the event flow.
	 * @param isQueue if the EventDispatcher isn't register to the event type the event is bufferized.
	 * @param target the target of the event.
	 * @param contect the context of the event.
	 * @return the reference of the event dispatched in the event flow.
	 */
	public function dispatchEvent(event, isQueue:Boolean, target, context):Event 
	{
		return _dispatcher.dispatchEvent(event, isQueue, target, context) ;
	}
	
	/**
	 * Returns the timeout interval duration.
	 * @return the timeout interval duration.
	 */
	public function getDelay():Number 
	{
		return _timer.getDelay() ;	
	}
	
	/**
	 * Returns the internal {@code EventDispatcher} reference.
	 * @return the internal {@code EventDispatcher} reference.
	 */
	public function getDispatcher():EventDispatcher 
	{
		return _dispatcher ;
	}

	/**
	 * Returns the internal {@code EventDispatcher} reference.
	 * @return the internal {@code EventDispatcher} reference.
	 */
	public function getEventDispatcher():EventDispatcher 
	{
		return _dispatcher ;
	}
	
	/**
	 * Returns the {@code EventListenerCollection} of the specified event name.
	 * @return the {@code EventListenerCollection} of the specified event name.
	 */
	public function getEventListeners(eventName:String):EventListenerCollection 
	{
		return _dispatcher.getEventListeners(eventName) ;
	}
	
	/**
	 * Returns the event name use in the connection is closed.
	 * @return the event name use in the connection is closed.
	 */
	public function getEventTypeCLOSE():String
	{
		return _eClose.getType() ;
	}

	/**
	 * Returns the event name use in the connection is finished.
	 * @return the event name use in the connection is finished.
	 */
	public function getEventTypeFINISH():String
	{
		return _eFinish.getType() ;
	}
	
	/**
	 * Returns the event name use in the connection is started.
	 * @return the event name use in the connection is started.
	 */
	public function getEventTypeSTART():String
	{
		return _eStart.getType() ;
	}
	
	/**
	 * Returns the event name use in the connection status changed.
	 * @return the event name use in the connection status changed.
	 */
	public function getEventTypeSTATUS():String
	{
		return _eStatus.getType() ;
	}

	/**
	 * Returns the event name use in the connection is out of time.
	 * @return the event name use in the connection is out of time.
	 */
	public function getEventTypeTIMEOUT():String
	{
		return _eTimeOut.getType() ;
	}

	/**
	 * Returns the {@code EventListenerCollection} of this EventDispatcher.
	 * @return the {@code EventListenerCollection} of this EventDispatcher.
	 */
	public function getGlobalEventListeners():EventListenerCollection 
	{
		return _dispatcher.getGlobalEventListeners() ;
	}

	/**
	 * Returns the singleton instance of class.
	 * @return singleton instance of class.
	 */
	public static function getInstance():NetServerConnection
	{
		if ( _instance == null )
		{
			_instance = new NetServerConnection() ;
		}
		return _instance ;
	}

	/**
	 * Returns the value of the isGlobal flag of this model.
	 * @return {@code true} if the model use a global EventDispatcher to dispatch this events.
	 */
	public function getIsGlobal():Boolean 
	{
		return _isGlobal ;
	}
	
	/**
	 * Returns the NetServerPolicy value of this object.
	 * @return the NetServerPolicy value of this object.
	 * @see NetServerPolicy
	 */
	public function getLimitPolicy():NetServerPolicy 
	{
		return _policy ;	
	}
	
	/**
	 * Returns the internal {@code ILogger} reference of this {@code ILogable} object.
	 * @return the internal {@code ILogger} reference of this {@code ILogable} object.
	 */
	public function getLogger():ILogger
	{
		return _logger ; 	
	}

	/**
	 * Returns a {@code Set} of all register event's name in this EventListener.
	 * @return a {@code Set} of all register event's name in this EventListener.
	 */	
	public function getRegisteredEventNames():Set 
	{
		return _dispatcher.getRegisteredEventNames() ;
	}
	
	/**
	 * Returns the EventDispatcher parent reference of this instance.
	 * @return the EventDispatcher parent reference of this instance.
	 */
	public function getParent():EventDispatcher 
	{
		return _dispatcher.parent ;
	}

	/**
	 * Returns a hash code value for the object.
	 * @return a hash code value for the object.
	 */
	public function hashCode():Number 
	{
		return null ;
	}

	/**
	 * Checks whether the EventDispatcher object has any listeners registered for a specific type of event.
	 * This allows you to determine where altered handling of an event type has been introduced in the event flow heirarchy by an EventDispatcher object.
	 */ 
	public function hasEventListener(eventName:String):Boolean 
	{
		return _dispatcher.hasEventListener(eventName) ;
	}
	
	/**
	 * This method is invoqued in the constructor of the class to initialize all events.
	 * Overrides this method.
	 */
	public function initEvent():Void
	{
		_eClose   = createNewEvent( NetServerEventType.CLOSE ) ;
		_eFinish  = createNewEvent( NetServerEventType.FINISH ) ;
		_eStart   = createNewEvent( NetServerEventType.START ) ;
		_eStatus  = createNewEvent( NetServerEventType.NET_STATUS ) ;
		_eTimeOut = createNewEvent( NetServerEventType.TIMEOUT ) ;	
	}
	
	/**
	 * Creates and returns the internal {@code EventDispatcher} reference (this method is invoqued in the constructor).
	 * You can overrides this method if you wan use a global {@code EventDispatcher} singleton.
	 * @return the internal {@code EventDispatcher} reference.
	 */
	public function initEventDispatcher():EventDispatcher 
	{
		return new EventDispatcher(this) ;
	}
	
	/**
	 * Invoqued when the connection is closed.
	 */
	public function notifyClose():Void 
	{
		dispatchEvent( _eClose ) ;	
	}

	/**
	 * Invoqued when the connection is finished.
	 */
	public function notifyFinished():Void 
	{
		dispatchEvent( _eFinish ) ;
	}

	/**
	 * Invoqued when the connection is started.
	 */
	public function notifyStarted():Void 
	{
		dispatchEvent( _eStart ) ;
	}
	
	/**
	 * Invoqued when the status of the connection is changed.
	 */
	public function notifyStatus( status:NetServerStatus , info ):Void 
	{
		_eStatus.setInfo(info) ;
		_eStatus.setStatus(status) ;
		dispatchEvent( _eStatus ) ;	
	}

	/**
	 * Invoqued when the connection is timeout.
	 */
	public function notifyTimeOut():Void 
	{
		dispatchEvent( _eTimeOut ) ;	
	}

	/** 
	 * Removes a listener from the EventDispatcher object.
	 * If there is no matching listener registered with the {@code EventDispatcher} object, then calling this method has no effect.
	 * @param Specifies the type of event.
	 * @param the class name(string) or a {@code EventListener} object.
	 */
	public function removeEventListener(eventName:String, listener, useCapture:Boolean):EventListener 
	{
		return _dispatcher.removeEventListener(eventName, listener, useCapture) ;
	}

	/** 
	 * Removes a global listener from the EventDispatcher object.
	 * If there is no matching listener registered with the EventDispatcher object, then calling this method has no effect.
	 * @param the string representation of the class name of the EventListener or a EventListener object.
	 */
	public function removeGlobalEventListener( listener ):EventListener 
	{
		return _dispatcher.removeGlobalEventListener(listener) ;
	}
	
	/**
	 * Runs the process of this NetServerConnection.
	 */
	public function run():Void 
	{
		connect(uri) ;	
	}

	/**
	 * Set timeout interval duration.
	 */
	public function setDelay(n:Number, useSeconds:Boolean):Void 
	{
		var t:Number = (n > 0) ? n : 0 ;
		if (useSeconds) t = Math.round(t * 1000) ;
		_timer.setDelay(t) ;
	}

	/**
	 * Sets the internal {@code EventDispatcher} reference.
	 */
	public function setEventDispatcher( e:EventDispatcher ):Void 
	{
		_dispatcher = e || initEventDispatcher() ;
	}

	/**
	 * Sets the event name use in the connection is closed.
	 */
	public function setEventTypeCLOSE( type:String ):Void
	{
		_eClose.setType( type ) ;
	}

	/**
	 * Sets the event name use in the connection is finished.
	 */
	public function setEventTypeFINISH( type:String ):Void
	{
		_eFinish.setType( type ) ;
	}
	
	/**
	 * Sets the event name use in the connection is started.
	 */
	public function setEventTypeSTART( type:String ):Void
	{
		_eStart.setType( type ) ;
	}
	
	/**
	 * Sets the event name use in the connection status changed.
	 */
	public function setEventTypeSTATUS( type:String ):Void
	{
		_eStatus.setType( type ) ;
	}

	/**
	 * Sets the event name use in the connection is out of time.
	 */
	public function setEventTypeTIMEOUT( type:String ):Void
	{
		_eTimeOut.setType( type ) ;
	}

	/**
	 * Sets if the model use a global {@code EventDispatcher} to dispatch this events, if the {@code flag} value is {@code false} the model use a local EventDispatcher.
	 * @param flag the flag to use a global event flow or a local event flow.
	 * @param channel the name of the global event flow if the {@code flag} argument is {@code true}.  
	 */
	public function setGlobal( flag:Boolean , channel:String ):Void 
	{
		_isGlobal = flag ;
		setEventDispatcher( flag ? EventDispatcher.getInstance( channel ) : null ) ;
	}

	/**
	 * Sets if the connection use the limit timeout interval.
	 * @param policy the NetServerPolicy.INFINITY or NetServerPolicy.LIMIT values.
	 * @see NetServerPolicy
	 */
	public function setLimitPolicy( policy:NetServerPolicy ):Void 
	{
		_policy = policy ;
		if (_policy == NetServerPolicy.LIMIT) 
		{
			_timer.addEventListener(TimerEvent.TIMER, _timeOut) ;
		}
		else 
		{
			_timer.removeEventListener(TimerEvent.TIMER, _timeOut) ;
		}
	}

	/**
	 * Sets the internal {@code ILogger} reference of this {@code ILogable} object.
	 */
	public function setLogger( log:ILogger ):Void 
	{
		_logger = log ;
	}

	/**
	 * Sets the parent EventDispatcher reference of this instance.
	 */
	public function setParent(parent:EventDispatcher):Void 
	{
		_dispatcher.parent = parent ;
	}

	/**
	 * Use this method to dispatch in FMS application an event.
	 */
	public function sharedEvent( event , context ):Void 
	{
		if (event instanceof Event) 
		{
			this.call( event.getType(), null, event ) ;
		}
		else if (TypeUtil.typesMatch(event, String)) 
		{
			this.call( event, null, context ) ;
		}
	}

	/**
	 * Returns the string Eden representation of this object.
	 * @return the string Eden representation of this object.
	 */
	/*override*/ public function toSource(indent : Number, indentor : String) : String 
	{
		return null ;
	}
	
	/**
	 * Returns the string representation of this object.
	 * @return the string representation of this object.
	 */
	public function toString():String 
	{
		return "[" + ConstructorUtil.getName(this) + "]" ;
	}

	private var _dispatcher:EventDispatcher ;
	private var _eClose:NetServerEvent ;
	private var _eFinish:NetServerEvent ;
	private var _eStart:NetServerEvent ;
	private var _eStatus:NetServerEvent ;
	private var _eTimeOut:NetServerEvent ;
	private static var _instance:NetServerConnection;
	private var _isGlobal:Boolean ;
	private var _logger:ILogger ;
	private var _policy:NetServerPolicy ;
	private var _timer:Timer ;
	private var _timeOut:EventListener ;

	static private var _initHashCode:Boolean = HashCode.initialize(NetServerConnection.prototype) ;

	/**
	 * Invoqued when the onStatus event is invoqued.
	 * @see NetServerStatus
	 */	
	private function onStatus( oInfo ):Void 
	{
		
		_timer.stop() ;

		var code:NetServerStatus = NetServerStatus.format(oInfo.code) ;
		
		getLogger().info(this + " status : " + code) ;
		
		switch (code) 
		{

			case NetServerStatus.SUCCESS :
			{
				notifyStatus( NetServerStatus.SUCCESS, oInfo ) ;
				notifyFinished() ;
				break ;
			}
			case NetServerStatus.BAD_VERSION :
			{
				notifyStatus(NetServerStatus.BAD_VERSION, oInfo) ;
				notifyFinished() ;
				break ;
			}
			case NetServerStatus.CLOSED :
			{
				notifyStatus(NetServerStatus.CLOSED, oInfo) ;
				break ;
			}
			case NetServerStatus.FAILED :
			{
				notifyStatus(NetServerStatus.FAILED, oInfo) ;
				notifyFinished() ;
				break ;
			}
			case NetServerStatus.INVALID :
			{
				notifyStatus(NetServerStatus.INVALID, oInfo) ;
				notifyFinished() ;
				break ;
			}	
			case NetServerStatus.REJECTED :
			{
				notifyStatus(NetServerStatus.REJECTED, oInfo) ;
				notifyFinished() ;
				break ;
			}
			case NetServerStatus.SHUTDOWN :
			{
				notifyStatus(NetServerStatus.SHUTDOWN, oInfo) ;
				notifyFinished() ;
				break ;
			}

		}
		
	}

	/**
	 * Invoqued when the connection is out of time.
	 */
	private function _onTimeOut(e:TimerEvent):Void 
	{
		notifyTimeOut() ;
		notifyFinished() ;
		close() ;
	}

}