/**
 * com.sekati.log.LCBinding
 * @version 1.1.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.events.Event;

/**
 * Centralize {@link Console} & {@link Logger} LocalConnections.
 */
class com.sekati.log.LCBinding {

	private static var _rx:LocalConnection = new LocalConnection( );
	private static var _tx:LocalConnection = new LocalConnection( );	
	public static var connectionName:String = "_com.sekati.log.LCBinding";
	public static var methodName:String = "lcHandler";

	/**
	 * Set reciever handler, allow sends from any dom and connect.
	 * @param handler (Function) Delegate to method call
	 * @return Void
	 */
	public static function connect(handler:Function):Void {
		LCBinding._rx.allowDomain = _rx.allowInsecureDomain = LCBinding.domain;
		LCBinding._rx[LCBinding.methodName] = handler;
		LCBinding._rx.connect( LCBinding.connectionName );
	}

	/**
	 * Disconnect reciever.
	 * @return Void
	 */
	public static function disconnect():Void {
		LCBinding._rx.close( );
	}

	/**
	 * Send a call to localConnection.
	 * @param eventObj (Event) item event data
	 * @return Void
	 */
	public static function send(eventObj:Event):Void {
		LCBinding._tx.allowDomain = LCBinding._tx.allowInsecureDomain = LCBinding.domain;
		LCBinding._tx.send( LCBinding.connectionName, LCBinding.methodName, eventObj.data );
	}	

	/**
	 * Open LocalConnection to all domains.
	 * @return Boolean
	 */
	public static function domain():Boolean {
		return true;
	}

	private function LCBinding() {	
	}
}