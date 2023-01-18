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
 * Utilitarian object allowing to treat a null value as an object.
 * A Null Object can be useful in recursive structures, typical of CompositePattern. But it is also useful in other contexts too. For example, it's commonly used in StrategyPattern (where no particular strategy is needed).
 * Usefull for some polymorphic situation.
 * @author eKameleon
 * @see <a href="http://c2.com/cgi/wiki?NullObject">Null Object</a>
 */
class vegas.core.types.NullObject extends CoreObject
{
	
	/**
	 * Creates a new NullObject instance.
	 */
	public function NullObject() 
	{
		super();
	}

	/**
	 * Returns the string representation of this object.
	 * @return the string representation of this object.
	 */
	public function toString():String
	{
		return "null" ;	
	}
	
	/**
	 * Returns the primitive value of the specified object.
	 * @return the primitive value of the specified object.
	 */
	public function valueOf()
	{
		return null ;	
	}

}