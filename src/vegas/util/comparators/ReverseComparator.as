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
import vegas.util.serialize.Serializer;

/**
 * Reverse an IComparator object. For example if the comparator must return 1 the reverse comparator return -1.
 * <p><b>Example :</b></p>
 * {@code
 * import vegas.util.comparators.ReverseComparator ;
 * import vegas.util.comparators.StringComparator ;
 * 
 * var c:StringComparator = new StringComparator() ;
 * var s:ReverseComparator = new ReverseComparator( c ) ;
 * 
 * trace( c.compare( "hello", "world" ) ) ; // -1
 * trace( s.compare( "hello", "world" ) ) ; // 1
 * }
 * @author eKameleon
 */
class vegas.util.comparators.ReverseComparator extends CoreObject implements IComparator
{

	/**
	 * Creates a new ReverseComparator instance.
	 * @param c the {@code IComparator} to be reverse.
	 */
	public function ReverseComparator( c:IComparator ) 
	{
		comparator = c ;
	}
	
	/**
	 * The {@code IComparator} instance to reverse.
	 */	
	public var comparator:IComparator ;
	
	/**
	 * Returns an integer value to compare two objects but the value is reverse.
	 * The compare method use the internal compare method of the {@code IComparator} defined in the comparator property or in the constructor of this object.
	 * @param o1 the first object to compare.
	 * @param o2 the second object to compare.
	 * @return <p>
	 * <li> 1 if o1 is "lower" than (less than, before, etc.) o2 ;</li>
	 * <li> -1 if o1 is "higher" than (greater than, after, etc.) o2 ;</li>
	 * <li> 0 if o1 and o2 are equal.</li>
	 * </p>
	 */
	public function compare(o1, o2):Number 
	{
		return comparator.compare(o2, o1) ;
	}

	/**
	 * Returns the singleton instance of a ReverseComparator.
	 * Developers are encouraged to use the comparator returned from this method instead of constructing a new instance to reduce allocation and GC overhead when multiple comparable comparators may be used in the same application.
 	 * @return the singleton instance of a ReverseComparator.
	 */
	static public function getInstance():ReverseComparator
	{
		if (_instance == null)
		{
			_instance = new ReverseComparator() ;
		}
		return _instance ;	
	}

	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent : Number, indentor : String):String 
	{
		return Serializer.getSourceOf(this,[ ISerializable(comparator).toSource() || "null" ] ) ;
	}

	/**
  	 * The internal static singleton of this class.
 	 */
	static private var _instance:ReverseComparator ;

}