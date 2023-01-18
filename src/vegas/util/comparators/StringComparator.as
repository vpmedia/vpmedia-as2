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
import vegas.util.StringUtil;
import vegas.util.TypeUtil;

/**
 * This comparator compare String objects.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.util.comparators.StringComparator ;
 * 
 * var comp1:StringComparator = new StringComparator() ;
 * var comp2:StringComparator = new StringComparator(true) ; // ignore case
 * 
 * var s0:String = "HELLO" ;
 * var s1:String = "hello" ;
 * var s2:String = "welcome" ;
 * var s3:String = "world" ;
 * 
 * trace( comp1.compare(s1, s2) ) ;  -1
 * trace( comp1.compare(s2, s1) ) ;   1
 * trace( comp1.compare(s1, s3) ) ;  -1
 * trace( comp1.compare(s1, s1) ) ;  0
 * 
 * trace( comp1.compare(s1, s0) ) ;  -1
 * trace( comp2.compare(s1, s0) ) ;  0
 * }
 * @author eKameleon
 */
class vegas.util.comparators.StringComparator extends CoreObject implements IComparator
{

	/**
	 * Creates a new StringCompator instance.
	 * @param ignoreCase a boolean to define if the comparator ignore case or not.
	 */
	function StringComparator( ignoreCase:Boolean ) 
	{
		this.ignoreCase = ignoreCase ;
	}

	/**
	 * Allow to take into account the case for comparison.
	 */
	public var ignoreCase:Boolean ;

	/**
	 * Returns an integer value to compare two String objects.
	 * @param o1 the first String object to compare.
	 * @param o2 the second String object to compare.
	 * @return <p>
	 * <li>-1 if o1 is "lower" than (less than, before, etc.) o2 ;</li>
	 * <li> 1 if o1 is "higher" than (greater than, after, etc.) o2 ;</li>
	 * <li> 0 if o1 and o2 are equal.</li>
	 * </p>
	 * @throws ClassCastError if compare(a, b) and 'a' or 'b' aren't String objects.
	 */
	public function compare(o1, o2):Number 
	{
		if ( o1 == null || o2 == null) 
		{
			if (o1 == o2) 
			{
				return 0 ;
			}
			else if (o1 == null) 
			{
				return -1 ;
			}
			else 
			{
				return 1 ;
			}
		}
		else 
		{
			if ( !TypeUtil.typesMatch(o1, String) || !TypeUtil.typesMatch(o2, String)) 
			{
				throw new ClassCastError(this + " compare method failed, Arguments string expected.") ;
			}
			else 
			{
				o1 = o1.toString() ;
				o2 = o2.toString() ;
				if (ignoreCase == true) 
				{
					o1 = o1.toLowerCase() ;
					o2 = o2.toLowerCase() ;
				}
				if (o1 == o2) 
				{
					return 0 ;
				}
				var i:Number = 0 ;
				var c:Number ;
				while ( i < Math.min(o1.length,o2.length) )
				{
					c = StringUtil.compareChars( o1.charAt(i), o2.charAt(i));
					if ( c != 0 ) 
					{
						return c;
					}
					i++ ;
				}
				if ( o1.length > o2.length ) 
				{
					return 1 ;
				}
				if (o1.length < o2.length ) 
				{
					return -1 ;
				}
			}
		}
	}

	/**
	 * Returns the {@code StringComparator} singleton with the a {@code false} ignoreCase property.
	 * Clients are encouraged to use the value returned from this method instead of constructing a new instance to reduce allocation and garbage collection overhead when multiple StringComparators may be used in the same application.
	 * @return the {@code StringComparator} singleton with the a {@code false} ignoreCase property.
	 */
	static public function getStringComparator():StringComparator
	{
		if ( _comparator == null )
		{
			_comparator = new StringComparator(false) ;	
		}
		return _comparator ;
	}
		

	/**
	 * Returns the {@code StringComparator} singleton with the a {@code true} ignoreCase property.
	 * Clients are encouraged to use the value returned from this method instead of constructing a new instance to reduce allocation and garbage collection overhead when multiple StringComparators may be used in the same application.
	 * @return the {@code StringComparator} singleton with the a {@code true} ignoreCase property.
	 */
	static public function getIgnoreCaseStringComparator():StringComparator
	{
		if ( _ignoreCaseComparator == null )
		{
			_ignoreCaseComparator = new StringComparator(true) ;	
		}
		return _ignoreCaseComparator ;
	}
	
	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent : Number, indentor : String):String 
	{
		return "new vegas.util.comparators.StringComparator(" + ( (ignoreCase == true) ? "true" : "false") + ")" ;
	}

	/**
	 * The internal Case StringComparator.
	 */
	static private var _comparator:StringComparator ;

	/**
	 * The internal ignoreCase StringComparator.
	 */
	static private var _ignoreCaseComparator:StringComparator ;

}