/** * com.sekati.events.AbstractEventBroadcaster * @version 1.0.0 * @author jason m horwitz | sekati.com | tendercreative.com * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved. * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php */import com.sekati.events.EventBroadcaster;
/** * AbstractEventBroadcaster Mixin class to be used when  * extending classes which broadcast "private" events. */class com.sekati.events.AbstractEventBroadcaster {
	private var _b:EventBroadcaster;
	/**	 * Constructoe	 */	public function AbstractEventBroadcaster() {		_b = EventBroadcaster.getInstance( );	}
	public function addEventListener(event:String, handler:Function):Void {		_b.addEventListener( this, event, handler );	}
	public function removeEventListener(event:String, handler:Function):Void {		_b.removeEventListener( this, event, handler );	}
	public function removeAllListeners():Void {		_b.removeAllFromBroadcaster( this );	}
	public function removeAllListenersToEvent(event:String):Void {		_b.removeAllFromBroadcasterAndEvent( this, event );	}
	public function broadcastEvent(event:String):Void {		_b.broadcastArrayArgs( this, event, arguments.slice( 1 ) );	}
	public function broadcastArrayArgs(event:String, args:Array):Void {		_b.broadcastArrayArgs( this, event, args );	}	}