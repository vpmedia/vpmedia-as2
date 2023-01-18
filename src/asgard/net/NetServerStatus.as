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

import vegas.core.IEquality;
import vegas.core.ISerializable;
import vegas.util.ArrayUtil;

/**
 * Defines the NetServer status.
 * @author eKameleon
 * @version 1.0.0.0
 */	
class asgard.net.NetServerStatus extends String implements IEquality, ISerializable 
{
	
	/**
	 * Creates a new NetServerStatus instance.
	 * @param s the String value of this object.
	 */
	public function NetServerStatus( s:String ) 
	{
		super(s) ;
	}

	/**
	 * Packet encoded in an unidentified format.
	 */
	static public var BAD_VERSION:NetServerStatus = new NetServerStatus("badversion") ;
	
	/**
	 * The connection was closed successfully.
	 */
	static public var CLOSED:NetServerStatus = new NetServerStatus("closed") ;

	/**
	 * The connection attempt failed or the NetConnection.call method was not able to invoke the server-side method or command.
	 */
	static public var FAILED:NetServerStatus = new NetServerStatus("failed") ;

	/**
	 * The application name specified during connect is invalid.
	 */
	static public var INVALID:NetServerStatus = new NetServerStatus("invalidapp") ;
	
	/**
	 * The connection attempt did not have permission to access the application.
	 */
	static public var REJECTED:NetServerStatus = new NetServerStatus("rejected") ;
	
	/**
	 *  The specified application is shutting down.
	 */
	static public var SHUTDOWN:NetServerStatus = new NetServerStatus("appshutdown") ;
	
	/**
	 * The connection attempt succeeded.
	 */
	static public var SUCCESS:NetServerStatus = new NetServerStatus("success") ;

	/**
	 * Compares the specified object with this object for equality.
	 * @return {@code true} if the the specified object is equal with this object.
	 */
	public function equals(o):Boolean
	{
		return o.valueOf() == valueOf() ;	
	}

	/**
	 * Convert onStatus code value in NetConnection.onStatus in a ConnectionStatus valid string.
	 */
	static public function format(code:String):NetServerStatus 
	{
		code = code.split(".").pop().toLowerCase() ;
		var status:Array = [BAD_VERSION, CLOSED, FAILED, INVALID, REJECTED, SHUTDOWN, SUCCESS] ;
		var l:Number = status.length ;
		while(--l > -1) 
		{
			if (status[l].toString() == code) 
			{
				return status[l] ;
			}	
		}
	}
	
	/**
	 * Returns the Eden String representation of this object.
	 * @return the Eden String representation of this object.
	 */
	public function toSource(indent : Number, indentor : String):String 
	{
		return "new asgard.net.NetServerStatus(\"" + toString() + "\")" ;
	}

	/**
	 * Validate if the specified object is a valid status value.
	 * @return {@code true} if the specified object is a valid status value.
	 */
	static public function validate( o ):Boolean 
	{
		var status:Array = [BAD_VERSION, CLOSED, FAILED, INVALID, REJECTED, SHUTDOWN, SUCCESS] ;
		return ArrayUtil.contains(status, o) ;	
	}

}