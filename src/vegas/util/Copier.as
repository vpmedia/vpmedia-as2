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

import vegas.core.ICopyable;
import vegas.util.ArrayUtil;
import vegas.util.BooleanUtil;
import vegas.util.DateUtil;
import vegas.util.ErrorUtil;
import vegas.util.FunctionUtil;
import vegas.util.ObjectUtil;
import vegas.util.TypeUtil;

/**
 * The {@code Copier} utility class is an all-static class with a method to returns a copy representation of an object.
 * @author eKameleon
 */
class vegas.util.Copier 
{

	/**
	 * Returns a deep copy of the specified object passed in argument. You can use a {@code ICopyable} instance or a native object.
	 * <p><b>Example :</b></p>
	 * {@code
	 * import vegas.data.list.LinkedList ;
	 * import vegas.util.Copier ;
	 * var list:LinkedList = new LinkedList() ;
	 * list.insert("item1") ;
	 * list.insert("item2") ;
	 * var copy:LinkedList = LinkedList(Copier.copy(list)) ;
	 * trace( copy.equals(list) ) ; // true
	 * }
	 * @return a deep copy of the specified object passed in argument.
	 */	
	static public function copy( o ) 
	{
		if (o === undefined) 
		{
			return undefined ;
		}
		if (o === null) 
		{
			return null ;
		}
		if (o instanceof ICopyable) 
		{
			return o.copy() ;
		}
		else if (TypeUtil.typesMatch(o, Array)) 
		{
			return ArrayUtil.copy(o) ;
		}
		else if (TypeUtil.typesMatch(o, Boolean)) 
		{
			return BooleanUtil.copy(o) ;
		}
		else if (TypeUtil.typesMatch(o, Date))
		{
			return DateUtil.copy(o) ;
		}
		else if (TypeUtil.typesMatch(o, Function))
		{
			return FunctionUtil.copy(o) ;
		}
		else if (TypeUtil.typesMatch(o, Number))
		{
			return o.valueOf() ;
		}
		else if (TypeUtil.typesMatch(o, String))
		{
			return o.valueOf() ;
		}
		else if (TypeUtil.typesMatch(o, Error))
		{
			return ErrorUtil.copy(o) ;
		}
		else if (typeof(o) === "object")
		{
			return ObjectUtil.copy(o) ;
		}
		else
		{
			return undefined ;
		}
	}	
	
}