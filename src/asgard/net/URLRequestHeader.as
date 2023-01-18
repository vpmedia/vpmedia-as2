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
import vegas.util.ConstructorUtil;

/**
 * A URLRequestHeader object encapsulates a single HTTP request header and consists of a name/value pair.
 * @author eKameleon
 */
class asgard.net.URLRequestHeader extends CoreObject 
{
	
	/**
	 * Creates a new URLRequestHeader instance.
	 * @param sName An HTTP request header name (such as Content-Type or SOAPAction).
	 * @param sValue The value associated with the name property (such as text/plain).
	 */
	public function URLRequestHeader(sName:String, sValue:String) 
	{
		super() ;
		name = sName || "" ;
		value = sValue || "" ;
	}

	/**
	 * An HTTP request header name (such as Content-Type or SOAPAction).
	 */
	public var name:String ;
	
	/**
	 * The value associated with the name property (such as text/plain).
	 */
	public var value:String ;
	
	/**
	 * Returns the {@code String} representation of this object.
	 * @return the {@code String} representation of this object.
	 */	
	/*override*/ public function toString():String 
	{
		return "[" + ConstructorUtil.getName(this) + " name:" + name + ", value:" + value + "]" ;
	}

}