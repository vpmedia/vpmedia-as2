/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * {@code EventBroadcaster} dispatches events to all added listeners with the help
 * of an {@link BasicEvent}.
 * 
 * <p>Can use single access point using {@link #getInstance} and get always the 
 * same #@code EventBroadcaster} instance.
 * 
 * <p>Example using full Pixlib API
 * <code>
 *   var oEB : EventBroadcaster = new EventBroadcaster(this);
 *   var e : BasicEvent = new BasicEvent( myClass.onSomeThing, this);
 *   
 *   oEB.addEventListener( myClass.onSomeThing, this);
 *   oEB.broadcastEvent( e );
 * </code>
 * 
 * <p>Example using Macromedia compatible event structure
 * <code>
 *   var oEB : EventBroadcaster = new EventBroadcaster(this);
 *   var e : BasicEvent = new BasicEvent( myClass.onSomeThing, this);
 *   
 *   oEB.addEventListener( myClass.onSomeThing, this);
 *   oEB.dispatchEvent( e ); //send a DynBasicEvent event
 * </code>
 * 
 * @author Francis Bourre
 * @version 1.0
 */
 
import com.bourre.commands.Delegate;
import com.bourre.core.HashCodeFactory;
import com.bourre.events.DynBasicEvent;
import com.bourre.events.IEvent;
import com.bourre.events.IEventDispatcher;
import com.bourre.events.ListenerArray;
import com.bourre.log.PixlibStringifier;

class com.bourre.events.EventBroadcaster
	implements IEventDispatcher
{
	//-------------------------------------------------------------------------
	// Private properties
	//-------------------------------------------------------------------------
	
	private var _oL:Object;
	private var _aAll:ListenerArray;
	private var _oE:Object;
	private var _oOwner;
	
	private static var _oI:EventBroadcaster;
	private static var _bInitialization:Function = com.bourre.core.HashCodeFactory;
	
	
	//-------------------------------------------------------------------------
	// Public API
	//-------------------------------------------------------------------------
	
	/**
	 * Returns {@code EventBroadcaster} instance.
	 * 
	 * <p>Always return the same instance.
	 * 
	 * @return {@code EventBroadcaster} instance
	 */
	public static function getInstance() : EventBroadcaster
	{
		return (EventBroadcaster._oI instanceof EventBroadcaster) ? EventBroadcaster._oI : EventBroadcaster._buildInstance();
	}
	
 	/**
	 * Constructs a new {@code EventBroadcaster} instance.
	 * 
	 * @param owner (optional) Object responsible of event broadcasting.
	 */
	public function EventBroadcaster( owner )
	{
		_oOwner = owner ? owner : this;
		_init();
	}
	
	/**
	 * Returns an {@link ListenerArray} of listeners that suscribed for passed-in {@code t} event 
	 * or for all events if parameter is omitted.
	 * 
	 * <p>Example
	 * <code>
	 *   var oEB : EventBroadcaster = new EventBroadcaster(this);
	 *   oEB.addEventListener( myClass.onSometingEVENT, myFirstObject);
	 *   oEB.addEventListener( myClass.onSometingElseEVENT, mySecondObject);
	 *   
	 *   var aL : ListenerArray = oEB.getListenerArray( myClass.onSometingEVENT );
	 *   trace( aL.length ); //return 1
	 *   
	 *   var aAll : ListenerArray = oEB.getListenerArray( );
	 *   trace( aAll.length ); //return 2
	 * </code>
	 * 
	 * @param t Event type. If event type is undefined, method will return listeners that suscribed for all events.
	 * 
	 * @return a {@link ListenerArray} instance
	 */
	public function getListenerArray(t:String) : ListenerArray
	{
		return (t == undefined) ? _aAll : _oL[t];
	}
	
	/**
	 * Indicates if a listeners list already exists for passed-in {@code t} event type.
	 * 
	 * <p>Example
	 * <code>
	 *   var oEB : EventBroadcaster = new EventBroadcaster(this);
	 *   oEB.addEventListener( myClass.onSometingEVENT, myFirstObject);
	 *   oEB.addEventListener( myClass.onSometingElseEVENT, mySecondObject);
	 *   
	 *   var b : Boolean = oEB.listenerArrayExists( myClass.onSomeCaseEVENT ); //return false
	 * </code>
	 * 
	 * @param t Event type
	 * 
	 * @return {@code true} if listeners exist, either {@code false}
	 */
	public function listenerArrayExists(t:String) : Boolean
	{
		return _oL[t] != undefined;
	}
	
	/**
	 * Adds passed-in {@code oL} listener for receiving all events.
	 * 
	 * <p>Example
	 * <code>
	 *   var oEB : EventBroadcaster = new EventBroadcaster(this);
	 *   oEB.addListener( myListener );
	 * </code>
	 * 
	 * @param oL Listener object
	 * @param f (optional) new callback function
	 */
	public function addListener(oL, f:Function) : Void
	{
		if (f) oL = _getEventProxy.apply( this, arguments );
		if (_aAll.insert(oL)) _clean(f?HashCodeFactory.getKey(oL.t):HashCodeFactory.getKey(oL));
	}
	
	/**
	 * Removes passed-in {@code oL} listener for receiving all events.
	 * 
	 * <p>Example
	 * <code>
	 *   oEB.removeListener( myListener );
	 * </code>
	 * 
	 * @param oL Listener object.
	 */
	public function removeListener(oL) : Void 
	{
		_clean( HashCodeFactory.getKey( oL ) );
		_aAll.remove(oL); 
	}
	
	/**
	 * Removes all listeners.
	 * 
	 * <p>Example
	 * <code>
	 *   oEB.removeAllListeners( );
	 * </code>
	 */
	public function removeAllListeners() : Void 
	{
		_init();
	}
   
	/**
	 * Adds passed-in {@code oL} listener for receiving passed-in {@code t} event type.
	 * 
	 * <p>Take a look at example below to see all possible method call.
	 * 
	 * <p>Example
	 * <code>
	 *   var oEB : EventBroadcaster = new EventBroadcaster(this);
	 *   oEB.addEventListener( myClass.onSometingEVENT, myFirstObject);
	 *   oEB.addEventListener( myClass.onSometingElseEVENT, this, __onSomethingElse);
	 *   oEB.addEventListener( myClass.onSometingElseEVENT, this, Delegate.create(this, __onSomething) );
	 * </code>
	 * 
	 * @param t Name of the Event.
	 * @param oL Listener object.
	 */
	public function addEventListener(t:String, oL) : Void 
	{
		var f : Function = arguments[2];
		if (f) oL = _getEventProxy.apply( this, arguments.splice(1) );

		if (!_aAll.listenerExists(oL))
		{
			if (!listenerArrayExists(t)) _oL[t] = new ListenerArray();
			if (getListenerArray(t).insert(oL))
			{
				var n:Number = f ? HashCodeFactory.getKey( oL.t ) : HashCodeFactory.getKey( oL );
				if (_oE[n] == undefined) _oE[n] = new Object();
				_oE[n][t] = oL;
			}
		}
	}

	/**
	 * Removes passed-in {@code oL} listener that suscribed for passed-in {@code t} event.
	 * 
	 * <p>Example
	 * <code>
	 *   var oEB : EventBroadcaster = new EventBroadcaster(this);
	 *   oEB.removeEventListener( myClass.onSometingEVENT, myFirstObject);
	 *   oEB.removeEventListener( myClass.onSometingElseEVENT, this);
	 * </code>
	 * 
	 * @param t Name of the Event.
	 * @param oL Listener object.
	 */
	public function removeEventListener(t:String, oL) : Void 
	{
		if (listenerArrayExists(t))
		{
			var a:ListenerArray = getListenerArray(t);
			if (a.remove(oL)) 
			{
				delete _oE[ HashCodeFactory.getKey(oL) ][t];
				if ( a.isEmpty() ) delete _oL[t];
			}
		}
	}
	
	/**
	 * Removes all listeners that suscribed for passed-in {@code t} event.
	 * 
	 * <p>Example
	 * <code>
	 *   oEB.removeAllEventListeners( myClass.onSometingEVENT );
	 * </code>
	 * 
	 * @param t event name
	 */
	public function removeAllEventListeners(t:String) : Void 
	{
		if (listenerArrayExists(t))
		{
			delete _oL[t];
			for (var n in _oE) delete _oE[n][t];
		}
	}
	
	/**
	 * Broadcasts event to suscribed listeners.
	 * 
	 * <p>Example using full Pixlib API
	 * <code>
	 *   var oEB : EventBroadcaster = new EventBroadcaster(this);
	 *   var e : IEvent = new BasicEvent( myClass.onSomeThing, this);
	 *   
	 *   oEB.addEventListener( myClass.onSomeThing, this);
	 *   oEB.broadcastEvent( e );
	 * </code>
	 * 
	 * @param e an {@link IEvent} instance
	 */
	public function broadcastEvent(e:IEvent) : Void
	{
		if (e.getTarget() == undefined) e.setTarget( _oOwner );
		var aL:ListenerArray = getListenerArray(e.getType());
		if (aL != undefined) _broadcast(aL, e);
		if (_aAll.length > 0) _broadcast(_aAll, e);
	}
	
	/**
	 * Wrapper for Macromedia {@code EventDispatcher} polymorphism.
	 * 
	 * <p>Use {@link DynBasicEvent} to build compatible event structure.
	 * 
	 * <p>Example
	 * <code>
	 *   oEB.dispatchEvent( {type:'onSomething', target:this, param:12} );
	 * </code>
	 * 
	 * @param o Event object.
	 */
	public function dispatchEvent(o:Object) : Void 
	{
		var e:DynBasicEvent = new DynBasicEvent(o["type"], o["target"]);
		for (var p:String in o) if (o[p] != "type" && o[p] != "target") e[p] = o[p];
		broadcastEvent( e );
	}
	
	/**
	 * Indicates if listeners array are empty.
	 * 
	 * @return {@code true} if no listeners are registred, either {@code false}
	 */
	public function isEmpty() : Boolean
	{
		var p:String;
		for (p in _oL) if (p) break;
		return _aAll.length == 0 && p == undefined;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	
	//-------------------------------------------------------------------------
	// Private implementation
	//-------------------------------------------------------------------------
	
	private static function _buildInstance() : EventBroadcaster
	{
		EventBroadcaster._oI = new EventBroadcaster();
		return _oI;
	}
	
	private function _init() : Void
	{
		_oL = new Object();
		_aAll = new ListenerArray();
		_oE = new Object();
	}
	
	private function _broadcast(aL:ListenerArray, e:IEvent) : Void
	{
		var l:Number = aL.length;
		while( --l > -1 )
		{
			var o = aL[l];
			var sType:String = typeof(o);
			if (sType == "object" || sType == "movieclip") 
			{
				if (o.handleEvent != undefined)
				{
					o.handleEvent(e);
				} else
				{
					o[String(e.getType())](e);
				}
			} else
			{
				o.apply( this, [e] );
			}
		}
	}
	
	private function _clean(key:Number) : Void
	{
		if (_oE[key] != undefined) 
		{
			var o:Object = _oE[key];
			for (var p:String in o) removeEventListener( p, o[p] );
			delete _oE[key];
		}
	}
	
	private function _getEventProxy(oL, f:Function) : Function
	{
		return Delegate.create.apply( Delegate, [oL, f].concat(arguments.splice(2)) );
	}
}