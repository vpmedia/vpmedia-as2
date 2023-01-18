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

import com.bourre.core.HashCodeFactory;
import com.bourre.data.collections.IIndexedCollection;
import com.bourre.data.iterator.ArrayIterator;
import com.bourre.data.iterator.Iterable;
import com.bourre.data.iterator.Iterator;
import com.bourre.log.PixlibStringifier;
import com.bourre.utils.ClassUtils;

class com.bourre.data.collections.IndexedArray extends Array
	implements IIndexedCollection, Iterable
{
	/**
	 * Array storing indexed objects<br><br>
	 * <strong>Usage :</strong> <em>var a:IndexedArray = new IndexedArray();</em>
	 */
	public function IndexedArray()
	{
		splice.apply(this, [0, 0].concat(arguments));
	}
	
	public static function buildInstance( a : Array ) : IndexedArray
	{
		return HashCodeFactory.buildInstance( ClassUtils.getFullyQualifiedClassName(new IndexedArray()), a );
	}
	
	/**
	 * Clear all list values.<br><br>
	 * <strong>Usage :</strong> <em>var a.init();</em>
	 */
	public function init() : Void
	{
		splice(0, this.length);
	}
	
	/**
	 * Get index number of an object.<br><br>
	 * <strong>Usage :</strong> <em>var n:Number = a.getIndex(o);</em>
	 * @param o Object to check.
	 * @return Number Returns -1 if the object isn't referenced in the array.
	 */
	public function getIndex(o) : Number 
	{
		var l:Number = this.length;
		while ( --l > -1 ) if (this[l] == o) return l; 
		return -1;
	}
	
	/**
	 * Test if one object is referenced in the array.<br><br>
	 * <strong>Usage :</strong> <em>var b:Boolean = a.objectExists(o);</em>
	 * @param o Object to check.
	 * @return Boolean.
	 */
	public function objectExists(o) : Boolean 
	{
		return (getIndex(o) != -1);
	}
	
	/**
	 * Add object.<br><br>
	 * <strong>Usage :</strong> <em>a.push(o);</em>
	 * @param o Object to add.
	 * @return Boolean that indicates if the object has been successfully added == wasn't already there.
	 */
	public function push(o) : Boolean
	{
		if (!objectExists(o)) 
		{
			super.push(o);
			return true;
		} else return false;
	}

	/**
	 * Remove object.<br><br>
	 * <strong>Usage :</strong> <em>a.remove(o);</em>
	 * @param o Object to remove.
	 * @return Boolean that indicates if the object has been found and was removed.
	 */
	public function remove(o) : Boolean 
	{
		var i:Number = getIndex(o);
		if (i != -1) 
		{
			splice(i, 1);
			return true;
		} else return false;
	}
	
	/**
	 * Check if Array's empty.<br><br>
	 * <strong>Usage :</strong> <em>var b:Boolean = a.isEmpty();</em>
	 * @return Boolean.
	 */
	public function isEmpty() : Boolean
	{
		return this.length < 1;
	}
	
	public function getIterator() : Iterator
	{
		return new ArrayIterator( this );
	}
	
	public function getElements() : Array
	{
		return this.concat();
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