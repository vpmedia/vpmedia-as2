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
import com.bourre.data.iterator.ObjectIterator;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.collections.Map
{
	private var _oK:Object;
	private var _oV:Object;
	private var _nS:Number;
	
	public function Map()
	{
		_init();
	}
	
	private function _init() : Void
	{
		_oK = new Object();
		_oV = new Object();
		_nS = 0;
	}

	public function clear() : Void
	{
		_init();
	}
	
	public function containsKey(k) : Boolean
	{
		return _oK[ _getName(k) ] != undefined;
	}
	
	public function containsValue(v) : Boolean
	{
		return _oV[ _getName(v) ] != undefined;
	}
	
	public function get(k)
	{
		var o = _oK[ _getName(k) ];
		return (o == undefined) ? null : o;
	}
	
	public function isEmpty() : Boolean
	{
		return (_nS == 0);
	}
	
	public function put(k, v)
	{
		if (containsKey(k)) remove(k);
		
		var sKID:String = _getName(k);
		_oK[ sKID ] = v;
		_oV[ _getName(v) ] = k;
		_nS++;
		
		var o = _oK[ sKID ];
		return (o == undefined) ? null : o;
	}
	
	private function _getName(o) : String
	{
		var t:String = typeof(o);
		var s:String = String( HashCodeFactory.getKey(o) );
		
		switch(t)
		{
			case 'number' :
				s = '_N' + String(o);
				break;
				
			case 'string' :
				s = '_S' + o;
				break;
				
			case 'boolean' :
				s = '_B' + o;
				break;
				
			default :
				s = '_O' + s;
		}
		
		return s;
	}
	
	public function remove(k)
	{
		var sKID:String = _getName(k);
		
		if (_oK[ sKID ] != undefined)
		{
			_oV[ _getName(_oK[ sKID ]) ] = undefined;
			_oK[ sKID ] = undefined;
			_nS--;
		}
	}
	
	public function getKeysIterator() : ObjectIterator
	{
		return new ObjectIterator( _oV );
	}
	
	public function getValuesIterator() : ObjectIterator
	{
		return new ObjectIterator( _oK );
	}
	
	public function getSize() : Number
	{
		return _nS;
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