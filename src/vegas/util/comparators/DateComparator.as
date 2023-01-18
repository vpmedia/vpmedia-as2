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
import vegas.core.IComparator;
import vegas.errors.ClassCastError;
import vegas.util.comparators.NumberComparator;
import vegas.util.TypeUtil;
	
/**
 * This comparator compare Date objects.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.util.comparators.DateComparator;
 * 
 * var comp:DateComparator = new DateComparator() ;
 * 
 * var d1:Date   = new Date(2007, 1, 1) ;
 * var d2:Number =  1170284400000 ;
 * var d3:Date   = new Date(2007, 2, 2) ;
 * var d4:Number = 1172790000000 ;
 * 
 * trace( comp.compare(d1, d1) ) ; // 0
 * trace( comp.compare(d1, d2) ) ; // 0
 * trace( comp.compare(d2, d1) ) ; // 0
 * trace( comp.compare(d1, d3) ) ; // -1
 * trace( comp.compare(d1, d4) ) ; // -1
 * trace( comp.compare(d3, d1) ) ; // 1
 * trace( comp.compare(d4, d1) ) ; // 1
 * }
 * @author eKameleon
 */
class vegas.util.comparators.DateComparator extends CoreObject implements IComparator
{

	/**
	 * Creates a new DateCompator instance.
	 */
	public function DateComparator() 
	{
		//
	}
	
	/**
	 * Returns an integer value to compare two Date objects.
	 * @param o1 the first Date object to compare.
	 * @param o2 the second Date object to compare.
	 * @return <p>
	 * <li>-1 if o1 is "lower" than (less than, before, etc.) o2 ;</li>
	 * <li> 1 if o1 is "higher" than (greater than, after, etc.) o2 ;</li>
	 * <li> 0 if o1 and o2 are equal.</li>
	 * </p>
	 * @throws ClassCastError if compare(a, b) and 'a' and 'b' must be Date or uint objects.
	 */
	public function compare(o1, o2):Number 
	{
		var b1:Boolean = TypeUtil.typesMatch(o1, Number) || TypeUtil.typesMatch(o1, Date) ;
		var b2:Boolean = TypeUtil.typesMatch(o2, Number) || TypeUtil.typesMatch(o2, Date) ;
		if ( b1 && b2 ) 
		{
			var a:Number = (o1 instanceof Date) ? o1.valueOf() : o1 ;
			var b:Number = (o2 instanceof Date) ? o2.valueOf() : o2 ;
			return NumberComparator.getInstance().compare(a, b) ;
		}
		else 
		{
			throw new ClassCastError(this + ".compare(a, b), 'a' and 'b' must be Date or Number objects.") ;
		}
	}

	/**
	 * Returns the singleton instance of a DateComparator.
	 * Developers are encouraged to use the comparator returned from this method instead of constructing a new instance to reduce allocation and GC overhead when multiple comparable comparators may be used in the same application.
 	 * @return the singleton instance of a DateComparator.
	 */
	static public function getInstance():DateComparator
	{
		if (_instance == null)
		{
			_instance = new DateComparator() ;
		}
		return _instance ;	
	}

	/**
  	 * The internal static singleton of this class.
 	 */
	static private var _instance:DateComparator ;

}