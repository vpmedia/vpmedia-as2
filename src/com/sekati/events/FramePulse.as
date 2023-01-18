/**
 * com.sekati.events.FramePulse
 * @version 1.1.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreObject;
import com.sekati.core.FWDepth;
import com.sekati.events.IPulsable;
import com.sekati.utils.ClassUtils;
import com.sekati.utils.Delegate;

/**
 * Framerate FramePulse Broadcaster
 */
class com.sekati.events.FramePulse extends CoreObject implements IPulsable {

	// AsBroadcaster stubs
	private var addListener:Function;
	private var removeListener:Function;
	private var broadcastMessage:Function;
	private var _listeners:Array;
	private static var _instance:FramePulse;
	private var _mc:MovieClip;
	private var _f:Function;
	public static var onEnterFrameEVENT:String = "_onEnterFrame";

	/**
	 * Singleton Private Constructor: initializes centralized management of mx.events.EventDispatcher
	 */
	private function FramePulse() {
		AsBroadcaster.initialize( this );
		_mc = ClassUtils.createEmptyMovieClip( com.sekati.display.BaseClip, _root, "___FramePulse", {_depth:FWDepth.FramePulse} );
		_f = Delegate.create( this, broadcastMessage, onEnterFrameEVENT );
	}

	/**
	 * Singleton Accessor
	 * @return Dispatcher
	 */
	public static function getInstance():FramePulse {
		if (!_instance) _instance = new FramePulse( );
		return _instance;
	}

	/**
	 * Shorthand singleton accessor getter
	 */
	public static function get $():FramePulse {
		return FramePulse.getInstance( );	
	}

	/**
	 * Start OEF FramePulse
	 * @return Void
	 */
	public function start():Void {
		_mc.onEnterFrame = _f;		
	}	

	/**
	 * Stop OEF FramePulse
	 */
	public function stop():Void {
		_mc.onEnterFrame = null;
	}

	/**
	 * Check if OEF FramePulse is running
	 * @return Boolean
	 */
	public function isRunning():Boolean {
		return _mc.onEnterFrame == _f;
	}	

	/**
	 * Add a FramePulse listener and auto-start FramePulse if not running
	 * @param o (Object) to register
	 * @return Void
	 */
	public function addFrameListener(o:Object):Void {
		if (_listeners.length < 1) start( );
		addListener( o );
	}

	/**
	 * Add an array of FramePulse listeners
	 * @param a (Array) of objects to register
	 * @return Void
	 */
	public function addFrameListeners(a:Array):Void {
		for(var i:Number = 0; i < a.length ; i++) {
			addFrameListener( a[i] );	
		}	
	}

	/**
	 * remove a FramePulse listener and auto-stop FramePulse if no listeners remain
	 * @param o (Object) to unregister
	 * @return Void
	 */
	public function removeFrameListener(o:Object):Void {
		removeListener( o );
		if (_listeners.length < 1) stop( );
	}

	/**
	 * Remove an array of FramePulse listeners
	 * @param a (Array) of objects to unregister
	 * @return Void
	 */
	public function removeFrameListeners(a:Array):Void {
		for(var i:Number = 0; i < a.length ; i++) {
			removeFrameListener( a[i] );	
		}	
	}

	/**
	 * check is a FramePulse listener is registered
	 * @return Boolean
	 */
	public function isListenerRegistered(o:Object):Boolean {
		for (var i in _listeners) if(_listeners[i] === o) return true;
		return false;
	}

	/**
	 * Destroy OEF FramePulse
	 * @return Void
	 */
	public function destroy():Void {
		_instance.stop( );
		_mc.destroy( );
		delete _instance;
		super.destroy( );
	}	
}