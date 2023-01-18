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

import vegas.util.ArrayUtil;

/**
 * The SharedData status enumeration list.
 * @author eKameleon
 * @version 1.0.0.0
 **/	
class asgard.net.SharedDataStatus extends String 
{
	
	/**
	 * Creates a new SharedDataStatus instance.
	 * @param s the String value of the SharedDataStatus instance.
	 */
	public function SharedDataStatus( s:String ) 
	{
		super(s) ;
	}

	/**
	 * The "change" SharedDataStatus.
	 */
	static public var CHANGE:SharedDataStatus  = new SharedDataStatus("change") ;

	/**
	 * The "clear" SharedDataStatus.
	 */
	static public var CLEAR:SharedDataStatus   = new SharedDataStatus("clear") ;

	/**
	 * The "delete" SharedDataStatus.
	 */
	static public var DELETE:SharedDataStatus  = new SharedDataStatus("delete") ;

	/**
	 * The "reject" SharedDataStatus.
	 */
	static public var REJECT:SharedDataStatus  = new SharedDataStatus("reject") ;

	/**
	 * The "success" SharedDataStatus.
	 */
	static public var SUCCESS:SharedDataStatus = new SharedDataStatus("success") ;

	/**
	 * Convert onSync code value in SharedData.onSync.
	 */
	static public function format(code:String):SharedDataStatus 
	{
		var status:Array = [CHANGE, CLEAR, DELETE, REJECT, SUCCESS] ;
		var l:Number = status.length ;
		while(--l > -1) 
		{
			if (status[l].toString() == code) return status[l] ;	
		}
	}

	/**
	 * Returns {@code true} if the specified value is a valid SharedDataStatus object.
	 * @return {@code true} if the specified value is a valid SharedDataStatus object.
	 */
	static public function validate( o ):Boolean 
	{
		var status:Array = [CHANGE, CLEAR, DELETE, REJECT, SUCCESS] ;
		return ArrayUtil.contains(status, o) ;	
	}

}