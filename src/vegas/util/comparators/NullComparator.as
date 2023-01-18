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
import vegas.core.ISerializable;
import vegas.util.comparators.ComparableComparator;
import vegas.util.serialize.Serializer;

/**
 * This comparator compare Null objects.
 * When comparing two non-null objects, the ComparableComparator is used if the nonNullComparator isnt' define.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.util.comparators.NullComparator;
 * 
 * var comp1:NullComparator = new NullComparator(null, true) ;
 * var comp2:NullComparator = new NullComparator(null, false) ;
 * 
 * var n = null ;
 * var o = {} ;
 * 
 * trace( comp1.compare(n, n) ) ; // 0
 * trace( comp1.compare(n, o) ) ; // 1
 * trace( comp1.compare(o, n) ) ; // -1
 * 
 * trace("----") ;
 * 
 * trace( comp2.compare(n, n) ) ; // 0
 * trace( comp2.compare(n, o) ) ; // -1
 * trace( comp2.compare(o, n) ) ; // 1
 * }
 * @author eKameleon
 */
class vegas.util.comparators.NullComparator extends CoreObject implements IComparator
{

	/**
	 * Creates a new NullComparator instance.
	 * @param nonNullComparator the comparator to use when comparing two non-null objects.
	 * @param nullsAreHigh a {@code true} value indicates that null should be compared as higher than a non-null object. A {@code false} value indicates that null should be compared as lower than a non-null object. 
	 */
	public function NullComparator( nonNullComparator:IComparator, nullsAreHigh:Boolean ) 
	{
		this.nonNullComparator = nonNullComparator || null ;
		this.nullsAreHigh = nullsAreHigh || false  ;
	}
	
	/**
	 * Defines the comparator to use when comparing two non-null objects.
	 */
	public var nonNullComparator:IComparator = null ;

	/**
	 * Defines that null should be compared as higher than a non-null object. 
	 */
	public var nullsAreHigh:Boolean = false ;
	
	/**
	 * Perform a comparison between two objects. 
	 * If both objects are null, a 0 value is returned. 
	 * If one object is null and the other is not, the result is determined on whether the Comparator was constructed to have nulls as higher or lower than other objects.
	 * If neither object is null, an underlying comparator specified in the constructor (or the default) is used to compare the non-null objects.
	 * The default IComparator used to compare two non-null objects is the ComparableComparator.
	 * @param o1 the first 'null' object to compare.
	 * @param o2 the second 'null' object to compare.
	 * @return <p>
	 * <li>-1 if o1 is "lower" than (less than, before, etc.) o2 ;</li>
	 * <li> 1 if o1 is "higher" than (greater than, after, etc.) o2 ;</li>
	 * <li> 0 if o1 and o2 are equal.</li>
	 * </p>
	 * @see ComparableComparator
	 */
	public function compare(o1, o2):Number 
	{
		if (o1 == null && o2 == null)
		{
			return 0 ;
		}			
		else if (o1 == null && o2 != null)
		{
			return nullsAreHigh ? 1 : -1 ;
		}
		else if (o1 != null && o2 == null)
		{
			return nullsAreHigh ? -1 : 1 ;
		}
		else
		{
			if ( nonNullComparator != null )
			{
				return nonNullComparator.compare(o1, o2) ;	
			}
			else
			{
				return ComparableComparator.getInstance().compare(o1, o2) ;
			}
		}
	}

	/**
	 * Returns the singleton instance of this class.
	 * Developers are encouraged to use the comparator returned from this method instead of constructing a new instance to reduce allocation and GC overhead when multiple comparable comparators may be used in the same application.
	 * @return the singleton instance of this class.
	 */
	static public function getInstance():NullComparator
	{
		if (_instance == null)
		{
			_instance = new NullComparator() ;
		}
		return _instance ;	
	}

	/**
	 * The internal static singleton of this class.
	 */
	static private var _instance:NullComparator ;
	
	
	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent : Number, indentor : String):String 
	{
		var sources:Array = [
			ISerializable(nonNullComparator).toSource() || "null" , 
			Serializer.toSource( nullsAreHigh )
		] ;
		return Serializer.getSourceOf(this, sources ) ;
	}
	
}