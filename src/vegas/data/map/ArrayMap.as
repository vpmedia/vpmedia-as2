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

import vegas.data.map.HashMap;

/**
 * ArrayMap is an Map implementation based on two arrays to defines the collections of the keys and the values. 
 * @author eKameleon
 */
class vegas.data.map.ArrayMap extends HashMap 
{

	/**
	 * Creates a new ArrayMap instance.
	 */
	public function ArrayMap() 
	{
		if ( arguments.caller == null )
		{
			Function( HashMap ).apply(this, [].concat(arguments) ) ;
		} 
	}

	/**
	 * Sets the value of the "key" in the HashMap (ArrayMap) with the specified index.
	 * @return the old 'key' value in the map if exist.
	 */
	public function setKeyAt( index:Number, key ) 
	{
		var old = _keys[index] ;
		if (old === undefined)
		{
			return null ;	
		}
		_keys[index] = key ;
		return old ;
	}

	/**
	 * Sets the value of the "value" in the HashMap (ArrayMap) with the specified index.
	 * @return the old value in the map if exist.
	 */
	public function setValueAt( index:Number, value ) 
	{
		var old = _values[index] ;
		if (old === undefined)
		{
			return null ;	
		}
		_values[index] = value ;
		return old ;
	}

}