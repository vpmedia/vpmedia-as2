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
import com.bourre.log.PixlibStringifier;

class com.bourre.data.collections.IndexedList
	implements IIndexedCollection
{
	private var _o:Object;
	private var _n:Number;
	
	/**
	 * List storing indexed objects<br><br>
	 * <strong>Usage :</strong> <em>var a:IndexedList = new IndexedList();</em>
	 */
	public function IndexedList()
	{
		init();
	}
	
	/**
	 * Clear all list values.<br><br>
	 * <strong>Usage :</strong> <em>var a.init();</em>
	 */
	public function init() : Void
	{
		_o = new Object();
		_n = 0;
	}
	
	/**
	 * Get index number of an object.<br><br>
	 * <strong>Usage :</strong> <em>var n:Number = a.getIndex(o);</em>
	 * @param o Object to check.
	 * @return Number Returns -1 if the object isn't referenced in the list.
	 */
	public function getIndex(o) : Number 
	{
		var n:Number = HashCodeFactory.getKey(o);
		return (_o[n] != undefined) ? n : -1;
	}
	
	/**
	 * Test if one object is referenced in the list.<br><br>
	 * <strong>Usage :</strong> <em>var b:Boolean = a.objectExists(o);</em>
	 * @param o Object to check.
	 * @return Boolean.
	 */
	public function objectExists(o) : Boolean 
	{	
		return getIndex(o) != -1;
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
			var n:Number = HashCodeFactory.getKey(o);
			if (n != undefined) 
			{
				_o[n] = o;
				_n++;
				return true;
			} else return false;
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
		if (objectExists(o)) 
		{
			delete _o[ HashCodeFactory.getKey(o) ];
			_n --;
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
		return _n < 1;
	}
	
	/**
	 * Get array copy of the list content.<br><br>
	 * @return Boolean.
	 */
	public function getElements() : Array
	{
		var a:Array = new Array();
		for (var p:String in _o) a.push(_o[p]);
		return a;
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