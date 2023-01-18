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
import vegas.data.Entry;

/**
 * Defined a basic entry representation in a map.
 * @author eKameleon
 */
class andromeda.data.map.BasicMapEntry extends CoreObject implements Entry 
{
	
	/**
	 * Creates a new BasicMapEntry instance.
	 * @param key the key of this entry.
	 * @param value the value of this entry.
	 */
	public function BasicMapEntry( key , value ) 
	{
		this.key   = key ;
		this.value = value ;
	}

	/**
	 * The key of this entry.
	 */
	public var key ;
	
	/**
	 * The value of this entry.
	 */
	public var value ;

	/**
	 * Returns the key corresponding to this entry.
	 * @return the key corresponding to this entry.
	 */
	public function getKey() 
	{
		return key ;
	}

	/**
	 * Returns the value corresponding to this entry.
	 * @return the value corresponding to this entry.
	 */
	public function getValue() 
	{
		return value ;
	}

	/**
	 * Sets the key of this entry.
	 */
	public function setKey( key ):Void 
	{
		this.key = key ;
	}

	/**
	 * Replaces the value corresponding to this entry with the specified value (optional operation).
	 */
	public function setValue(value):Void 
	{
		this.value = value ;
	}

}