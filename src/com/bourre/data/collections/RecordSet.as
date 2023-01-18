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
import com.bourre.data.iterator.RecordSetIterator;
import com.bourre.log.PixlibDebug;
import com.bourre.log.PixlibStringifier;

class com.bourre.data.collections.RecordSet 
	implements Iterable
{	private var _aColumNames : Array;
	private var _aItems : Array;
	
	public function RecordSet( rawData )
	{
		parseRawData( rawData );
	}
	
	public function clear() : Void
	{
		_init();
	}
	
	public function parseRawData( rawData ) : Void
	{
		clear();
		
		_aColumNames = rawData.serverInfo.columnNames;

		var aItems : Array = rawData.serverInfo.initialData;
		var i : Iterator = new ArrayIterator( aItems );
		while( i.hasNext()) 
		{
			var item : Object = new Object();
			var aProperties = i.next();
			
			var j : Iterator = new ArrayIterator( aProperties );
			while( j.hasNext()) 
			{
				var propertyValue = j.next();
				var propertyName : String = _aColumNames[ j.getIndex() ];
				
				item[ propertyName ] = propertyValue;
			}
			
			_aItems.push( item );
		}
	}
	
	public function getColumnNames(): Array 
	{
		return _aColumNames;
	}
	
	public function getItems() : Array
	{
		return _aItems;
	}
	
	public function getItemAt( n : Number )
	{
		if (isEmpty())
		{
			PixlibDebug.WARN( this + ".getItemAt(" + n + ") can't retrieve data, collection is empty." );
			return null;
		} else if ( n < 0 || n >= getLength() ) 
		{
			PixlibDebug.ERROR( 	this + ".getItemAt() was used with invalid value :'" + n + 
								"', " + this + ".getLength() equals '" + getLength() + "'" );
			return null;
		} else
		{
			return _aItems[ n ];
		}
	}
	
	public function isEmpty() : Boolean
	{
		return _aItems.length == 0;
	}
	
	public function getIterator() : Iterator
	{
		return new RecordSetIterator( this );
	}
	
	public function getLength() : Number
	{
		return _aItems.length;
	}
	
	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance
	 */
	public function toString() : String 
	{
		return PixlibStringifier.stringify( this );
	}
	
	/*
	 * 
	 */
	private function _init() : Void
	{
		_aColumNames = new Array();
		_aItems = new Array();
	}
}