/**
 * com.sekati.remoting.RemoteEvent
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.events.Event;

/**
 * RemoteEvent for use by {@link RemoteCall}.
 */
class com.sekati.remoting.RemoteEvent extends Event {

	public static var onRemoteResultEVENT:String = "onRemoteCallResult";
	public static var onRemoteFaultEVENT:String = "onRemoteCallFault";

	/**
	 * Constructor creates a RemoteEvent via {@link RemoveCall} to be dispatched.
	 * @param type (String) - one of the remote event types listed above.
	 * @param target (Object) - the object that dispatched this event.
	 * @param data (Object) - contains remoting transaction data for recieve and error.
	 * @return Void
	 */
	public function RemoteEvent(type:String, target:Object, data:Object) {
		super( type, target, data );
	}	
}