/**
 * com.sekati.data.Iterator
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.core.CoreObject;

/**
 * Data Array Iterator Class.
 */
class com.sekati.data.Iterator extends CoreObject {

	private var _data:Array;
	private var _i:Number;

	/**
	 * Iterator Constructor
	 * @param data (Array) data array
	 * @throws Error on missing data arg.
	 */
	public function Iterator(data:Array) {
		super( );
		if(!data) {
			throw new Error( "@@@ " + this.toString( ) + " Error: instance constructor expects data:Array argument." );
			return;	
		} else {
			_data = data;
			reset( );
		}
	}

	/**
	 * Returns the next element (or null if none)
	 * @return Object
	 */
	public function next():Object {
		return hasNext( ) ? _data[_i++] : null;
	}

	/**
	 * Return the previous element (or null if none)
	 * @return Object
	 */
	public function previous():Object {
		return hasPrevious( ) ? _data[_i--] : null;
	}

	/**
	 * Return the current element
	 * @return Object
	 */
	public function current():Object {
		return _data[_i];
	}

	/**
	 * Reset the Iterator index.
	 * @return Void
	 */
	public function reset():Void {
		_i = -1;
	}

	/**
	 * Check if iterator has a next element
	 * @return Boolean
	 */
	public function hasNext():Boolean {
		return _i + 1 < _data.length;
	}

	/**
	 * Check if iterator has a previous element
	 * @return Boolean
	 */
	public function hasPrevious():Boolean {
		return _i - 1 >= 0;
	}

	/**
	 * Return the next index if available.
	 * @return Number
	 */
	public function nextIndex():Number {
		return Math.min( _i + 1, _data.length );
	}

	/**
	 * Return the previous index if available.
	 * @return Number
	 */
	public function previousIndex():Number {
		return Math.max( _i - 1, -1 );
	}

	/**
	 * Return the current index.
	 * @return Number
	 */
	public function currentIndex():Number {
		return _i;
	}

	/**
	 * Setter - overwrite the Iterator data array with new data.
	 * @param data (Array)
	 * @return Void
	 */
	public function set data(data:Array):Void {
		_data = data;
	}

	/**
	 * getter - return the Iterator data array.
	 * @return Array
	 */
	public function get data():Array {
		return _data;
	}
}