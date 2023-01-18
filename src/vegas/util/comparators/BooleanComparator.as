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
import vegas.errors.NullPointerError;
import vegas.util.serialize.Serializer;
import vegas.util.TypeUtil;

/**
 * A IComparator for {@code Boolean} objects that can sort either {@code true} or {@code false} first.
 * @author eKameleon
 */
class vegas.util.comparators.BooleanComparator extends CoreObject implements IComparator
{

	/**
	 * Creates a BooleanComparator that sorts trueFirst values before !trueFirst values.
	 * Please use the static factories instead whenever possible.
	 * @param trueFirst when true, sort true boolean values before false
	 */
	public function BooleanComparator( trueFirst:Boolean ) 
	{
		this.trueFirst = (trueFirst != null) ? trueFirst : true ;
	}

	/**
	 * When {@code true} sort {@code true} boolean values before {@code false}.
	 */
	public var trueFirst:Boolean ; 

	/**
	 * Returns an integer value to compare two Boolean objects.
	 * @param o1 the first Number object to compare.
	 * @param o2 the second Number object to compare.
	 * @return <p>
	 * <li>-1 if o1 is "lower" than (less than, before, etc.) o2 ;</li>
	 * <li> 1 if o1 is "higher" than (greater than, after, etc.) o2 ;</li>
	 * <li> 0 if o1 and o2 are equal.</li>
	 * </p>
	 * @throws NullPointerError if the first argument is null and not a Boolean object.
	 * @throws ClassCastError when either argument is not Boolean
	 */
	public function compare(o1, o2):Number 
	{
		if (o1 == null)
		{
			throw NullPointerError(this + " compare method failed if the first argument is null.") ;
		}
		if ( TypeUtil.typesMatch(o1, Boolean) && TypeUtil.typesMatch(o2, Boolean)) 
		{
			if( o1 == o2 )
			{
				return 0 ;
			}
			else if( o1 == true && o2 == false )
			{
				return trueFirst ? 1 : -1 ;
			}
			else 
			{
				return trueFirst ? -1 : 1 ;
			}
		}
		else 
		{
			throw new ClassCastError(this + " compare method failed, Arguments number expected") ;
		}
	}

	/**
	 * Returns a BooleanComparator singleton that sorts false values before true values.
	 * Clients are encouraged to use the value returned from this method instead of constructing a new instance to reduce allocation and garbage collection overhead when multiple BooleanComparators may be used in the same application.
	 * @return a BooleanComparator instance that sorts false values before true values.
	 */
	static public function getFalseFirstComparator():BooleanComparator
	{
		if (_falseFirstInstance == null)
		{
			_falseFirstInstance = new BooleanComparator(false) ;	
		}
		return _falseFirstInstance ;
	}

	/**
	 * Returns a BooleanComparator singleton that sorts true values before false values.
	 * Clients are encouraged to use the value returned from this method instead of constructing a new instance to reduce allocation and garbage collection overhead when multiple BooleanComparators may be used in the same application.
	 * @return a BooleanComparator instance that sorts true values before false values.
	 */
	static public function getTrueFirstComparator():BooleanComparator
	{
		if (_trueFirstInstance == null)
		{
			_trueFirstInstance = new BooleanComparator(true) ;	
		}
		return _trueFirstInstance ;
	}

	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent : Number, indentor : String):String 
	{
		var sources:Array = [ Serializer.toSource( trueFirst) ] ;
		return Serializer.getSourceOf(this, sources ) ;
	}
	
	/**
	 * The internal singleton reference who define a BooleanComparator that sorts false values before true values.
	 */
	static private var _falseFirstInstance:BooleanComparator ; 
	
	/**
	 * The internal singleton reference who define a BooleanComparator that sorts true values before false values.
	 */
	static private var _trueFirstInstance:BooleanComparator ; 

}