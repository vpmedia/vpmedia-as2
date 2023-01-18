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

import vegas.data.Map;

/**
 * The {@code MapUtil} utility class is an all-static class with methods for working with map.
 * @author eKameleon
 */
class vegas.data.map.MapUtil 
{

	/**
	 * Returns the value of the specified key in the map with a Number representation.
	 * @param map the map used by this method
	 * @param key the key in the map to used to return the number value.
	 * @return the value of the specified key in the map with a Number representation.
	 */
	static public function getNumber(map:Map, key):Number
	{
        if (map != null) 
        {
            var answer = map.get(key) ;
            if (answer != null) 
            {
                if (answer instanceof Number) 
                {
                    return Number(answer) ;
                }
                else if (answer instanceof String) 
                {
                    var r:Number = parseInt(answer) ;
					return (r == isNaN) ? null : Number(r) ;
                }
            }
        }
        return null ;
    }


}