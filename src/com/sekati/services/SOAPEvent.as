/**
 * com.sekati.services.SOAPEvent
 * @version 1.0.1
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */
 
import com.sekati.events.Event;
import com.sekati.services.SOAPClient;

/**
 * SoapEvent for use by {@link Logger} for {@link Console}.
 */
class com.sekati.services.SOAPEvent extends Event {

	public static var CONNECT:String = "onSoapConnect";
	public static var FAULT:String = "onSoapConnectFault";
	public static var CALL_RESULT:String = "onSoapCallResult";
	public static var CALL_FAULT:String = "onSoapCallFault";
	private static var _target:SOAPClient = SOAPClient.getInstance( );

	/**
	 * Constructor creates a SoapEvent via {@link SoapClient} to be dispatched.
	 * @param type (String) - one of the Soap event types listed above.
	 * @param data (Object) - contains Soap transaction data for connect, connectFaunt,callResult, callFault.
	 * @return Void
	 */
	public function SOAPEvent(type:String, data:Object) {
		super( type, _target, data );
	}
}