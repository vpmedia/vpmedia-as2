/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
/**
 * @author Francis Bourre
 * @version 1.0
 */

import com.bourre.data.iterator.ArrayIterator;
import com.bourre.data.iterator.Iterable;
import com.bourre.data.iterator.Iterator;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.collections.Queue
	implements Iterable
{
	private var _a:Array;

	public function Queue()
	{
		clear();
	}

	/**
	 * Clears the queue.<br><br>
	 */
	public function clear() : Void
	{
		_a = new Array();
	}

	/**
	 * Adds the specified element to the queue.<br><br>
	 * @param o Element to add to the queue.
	 */
	public function enqueue(o) : Void
	{
		_a.push(o);
	}

	/**
	 * Removes and returns the first element added into the queue.<br><br>
	 * @return Object.
	 */     
	public function dequeue() : Object
	{
		return _a.shift();
	}

	/**
	 * Checks if the queue is empty.<br><br>
	 * @return Boolean.
	 */
	public function isEmpty() : Boolean
	{
		return _a.length == 0;
	}

	/**
	 * Returns the first element added into the queue.<br><br>
	 * @return Object.
	 */
	public function peek() : Object
	{
		return _a[0];
	}

	/**
	 * Returns an Array of the elements in the queue.<br><br>
	 * @return Array.
	 */
	public function getElements() : Array
	{
		return _a.concat();
	}
	
	/**
	 * Returns length of the queue
	 * @return Number.
	 */
	public function getLength() : Number
	{
		return _a.length;
	}
	
	public function getIterator() : Iterator
	{
		return new ArrayIterator( _a );
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
}