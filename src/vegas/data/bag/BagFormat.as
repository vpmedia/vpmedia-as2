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
import vegas.core.IFormat;
import vegas.data.Bag;
import vegas.data.iterator.Iterator;

/**
 * Converts a Bag to a custom string representation.
 * @author eKameleon
 */
class vegas.data.bag.BagFormat extends CoreObject implements IFormat 
{

	/**
	 * Creates a new BagFormat instance.
	 */
	public function BagFormat() 
	{
		//
	}
	
	/**
	 * Converts the object to a custom string representation.
	 */	
	public function formatToString(o):String 
	{
		var b:Bag = Bag(o) ;
		var s:String = "{" ;
		var it:Iterator = b.uniqueSet().iterator() ;
		var cur ;
		var count:Number ;
		while (it.hasNext()) 
		{
			cur = it.next() ;
			count = b.getCount(cur) ;
			s += count + ":" + cur ;
			if (it.hasNext()) 
			{
				s += ",";
			}
		}
		s += "}" ;
		return s ;
	}
	
}