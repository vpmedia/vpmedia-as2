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

import com.bourre.data.collections.RecordSet;
import com.bourre.data.iterator.Iterator;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.iterator.RecordSetIterator 
	implements Iterator
{
	private var _rs : RecordSet;
	private var _n:Number;
	
	public function RecordSetIterator( rs : RecordSet ) 
	{
		_rs = rs;
		_n = -1;
	}
	
	public function hasNext() : Boolean 
	{
		return _n < _rs.getLength() - 1; 
	}

	public function next() 
	{
		return _rs.getItemAt( ++_n );
	}

	public function getIndex() : Number 
	{
		return _n;
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