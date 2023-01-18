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
import vegas.data.queue.LinearQueue;

/**
 * This queue orders elements according to an order specified at construction time, which is specified either according to their natural order or according to a IComparator object.
 * @author eKameleon
 * @see IComparator
 */
class vegas.data.queue.PriorityQueue extends LinearQueue 
{

	/**
	 * Creates a new PriorityQueue instance.
	 * <p><b>Example :</b>
	 * {@code
	 * import vegas.data.queue.PriorityQueue ;
	 * import vegas.util.comparators.StringComparator ;
	 * 
	 * var q:PriorityQueue = new PriorityQueue(null, ["item0", "item1"])  ;
	 * 
	 * trace ("queue size : " + q.size()) ;
	 * trace ("enqueue item4 : " + q.enqueue ("item4")) ;
	 * trace ("enqueue item3 : " + q.enqueue ("item2")) ;
	 * trace ("enqueue item2 : " + q.enqueue ("item3")) ;
	 * trace ("enqueue item2 : " + q.enqueue ("item1")) ;
	 * 
	 * trace("> " + q) ;
	 * 
	 * q.setComparator( new StringComparator() ) ;
	 * 
	 * trace("> " + q) ;
	 * }
	 * </p>
	 * @param comp a IComparator object used in the PriorityQueue to defined the sort model when enqueue or modify the queue.
	 * @param ar an Array with values to fill the queue.
	 * @see IComparator
	 */
	public function PriorityQueue( comp:IComparator , ar:Array ) 
	{
		setComparator(comp) ;
		var l:Number = ar.length ;
		if (l > 0)
		{
			for (var i:Number = 0 ; i<l ; i++)
			{
				enqueue(ar[i]) ;	
			}		
		}
	}

	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		return new PriorityQueue(_comparator);
	}
	
	/**
	 * Returns the internal IComparator reference of this object.
	 * @return the internal IComparator reference of this object.
	 */
	public function comparator():IComparator 
	{
		return _comparator ;
	}
	
	/**
	 * Inserts the specified element into this queue, if possible.
	 */
	public function enqueue(o):Boolean 
	{
		var isEnqueue:Boolean = super.enqueue(o) ;
		if ( isEnqueue && (_comparator != null) ) 
		{
			_a.sort(_comparator.compare) ;
		}
		return isEnqueue ;
	}
	
	/**
	 * Sets the IComparator reference of this object.
	 * @param comp the IComparator reference of this object.
	 */
	public function setComparator( comp:IComparator ):Void
	{
		_comparator = comp ;
		if (_comparator != null)
		{
			_a.sort(_comparator.compare) ;
		}
	}
	
	/**
	 * The internal IComparator reference.
	 */
	private var _comparator:IComparator = null ;
	
}