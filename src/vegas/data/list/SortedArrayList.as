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

import vegas.core.IComparator;
import vegas.data.Collection;
import vegas.data.list.ArrayList;
import vegas.util.serialize.Serializer;

/**
 * A SortedArrayList stores is elements in order with a IComparator object.
 * @author eKameleon
 */
class vegas.data.list.SortedArrayList extends ArrayList 
{
	
	/**
	 * Creates a new SortedArrayList instance. 
	 */
	public function SortedArrayList(o, comp:IComparator, opt:Number) 
	{
		super(o) ;
		setComparator(comp) ;
		setOptions(opt) ;
	}
	
	/**
	 * (read-only) Returns the IComparator instance.
	 */
	public function get comparator():IComparator 
	{
		return getComparator() ;
	}
	
	/**
	 * (read-only) Sets the IComparator instance.
	 */
	public function set comparator(comp:IComparator):Void 
	{
		setComparator(comp) ;
	}
	
	/**
	 * (read-only) Returns the options to sort the elements in the list.
	 */
	public function get options() 
	{
		return getOptions() ;
	}

	/**
	 * (read-only) Sets the options to sort the elements in the list.
	 */
	public function set options(o):Void 
	{
		setOptions(o) ;
	}
	
	/**
	 * Returns a shallow copy of the instance.
	 * @return a shallow copy of the instance.
	 */
	public function clone() 
	{
		return new SortedArrayList(toArray()) ;
	}

	public function insert(o):Boolean 
	{
		var b:Boolean = super.insert(o) ;
		_sort() ;
		return b ;
	}	

	public function insertAll(c:Collection):Boolean 
	{
		var b:Boolean = super.insertAll(c) ;
		_sort() ;
		return b ;
	}
	
	public function insertAt(id /*Number*/ , o):Void 
	{
		insertAt(id, o) ;
		_sort() ;
	}

	public function insertAllAt(id:Number, c:Collection):Boolean 
	{
		var b:Boolean = super.insertAllAt(id, c) ;
		_sort() ;
		return b ;
	}

	/**
	 * Returns the IComparator instance.
	 */
	public function getComparator():IComparator 
	{
		return _comparator ;
	}

	/**
	 * Returns the options to sort the elements in the list.
	 */
	public function getOptions() 
	{
		return _options ;
	}

	/**
	 * Sets the IComparator instance.
	 */
	public function setComparator(comp:IComparator):Void 
	{
		_comparator = comp ;
	}

	/**
	 * Sets the options to sort the elements in the list.
	 */
	public function setOptions(o):Void 
	{
		_options = o ;
	}
	
	/**
	 * Sorts the elements in the list.
	 */
	public function sort( compare , options:Number ):Array  
	{
		if (typeof(compare) != "function") return null ;
		if (options) 
		{
			_options = options ;
		}
		var compareFunc:Function = (compare instanceof IComparator) ? compare.compare : compare ;
		return _a.sort(compareFunc , _options) ;
	}
	
	/**
	 * Sorts the elements in the list according to one or more fields in the array.
	 * @param fieldName A string that identifies a field to be used as the sort value, or an array in which the first element represents the primary sort field, the second represents the secondary sort field, and so on.
	 * @param options One or more numbers or names of defined constants, separated by the bitwise OR (|) operator, that change the sorting behavior. The following values are acceptable for the options parameter:
	 * <p><li>Array.CASEINSENSITIVE or 1</li><li>Array.DESCENDING or 2</li><li>Array.UNIQUESORT or 4</li><li>Array.RETURNINDEXEDARRAY or 8</li><li>Array.NUMERIC or 16</li></p>
     * @return The return value depends on whether you pass any parameters : <p><li>If you specify a value of 4 or Array.UNIQUESORT for the options parameter, and two or more elements being sorted have identical sort fields, a value of 0 is returned and the array is not modified.</li><li>If you specify a value of 8 or Array.RETURNINDEXEDARRAY for the options parameter, an array is returned that reflects the results of the sort and the array is not modified.</li><li>Otherwise, nothing is returned and the array is modified to reflect the sort order.</li></p>
     */
	public function sortOn( fieldName, options ):Array  
	{
		if (options) _options = options ;
		return _a.sortOn(fieldName, options) ;
	}
	
	/*override*/ public function toSource(indent:Number, indentor:String):String 
	{
		var sA:String = Serializer.toSource(toArray()) ;
		var sB:String = Serializer.toSource(_comparator) ;
		var sC:String = Serializer.toSource(_options) ;
		return Serializer.getSourceOf(this, [sA, sB, sC] ) ;
	}
	
	private var _comparator:IComparator ;

	private var _options ;
	
	private function _sort():Void 
	{
		sort( _comparator.compare , _options) ;
	}
	
}