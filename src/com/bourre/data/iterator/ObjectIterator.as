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

import com.bourre.data.iterator.Iterator;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.iterator.ObjectIterator 
	implements Iterator
{
	private var _o;
	private var _a : Array;
	private var _i:Number;
	
	public function ObjectIterator( o, sFilter:String )
	{
		_o = o;
		_a = new Array();
		
		var l:Number = sFilter.length;
		if (sFilter)
		{
			for (var p:String in o) 
			{
				if(p.substr(0, l) == sFilter && typeof(o[p]) != "function") _a.push(p);
			}
		} else
		{
			for (var p:String in o) 
			{
				if(typeof(o[p]) != "function") _a.push(p);
			}
		}
		resetIndex();
	}
	
	public function resetIndex() : Void
	{
		_i = -1;
	}
	
	public function hasNext() : Boolean 
	{
		return _i+1 < _a.length;
	}

	public function getIndex() : Number 
	{
		return _i;
	}
	
	private function _next()
	{
		var o:Object = _o[ _a[++_i] ];
		return (typeof(o) == "Function") ? _next() : o;
	}

	public function next() 
	{
		return _o[ _a[++_i] ];
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