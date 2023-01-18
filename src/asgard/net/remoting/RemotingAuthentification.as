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

/**
 * This class is used to create a credential authentification with a Flash remoting method.
 * @author eKameleon
 */
class asgard.net.remoting.RemotingAuthentification extends CoreObject 
{
	
	/**
	 * Creates a new RemotingAuthentification instance.
	 * @param id the id of the authentification.
	 * @param pass the password of the authentification.
	 */
	public function RemotingAuthentification(id:String, pass:String) 
	{
		userid = id ;
		password = pass ;
	}

	/**
	 * The user id.
	 */
	public var userid:String ;
	
	/**
	 * The user password.
	 */
	public var password:String ;
	
	/**
	 * Returns the {@code Object} representation of this object.
	 * @return the {@code Object} representation of this object.
	 */
	public function toObject():Object
	{
		return { userid : userid , password: password } ; 
	}

	/**
	 * Returns the Eden string representation of this object.
	 * @return the Eden string representation of this object.
	 */	
	/*override*/ public function toSource():String
	{
		return 'new asgard.remoting.RemotingAuthentification("' + userid + '","' + password + '")' ;	
	}
	
}