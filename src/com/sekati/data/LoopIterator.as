/**
 * com.sekati.data.LoopIterator
 * @version 1.0.0
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.data.Iterator;
/**
 * Loopable Iterator Class.
 */
class com.sekati.data.LoopIterator extends Iterator {
	/**
	 * LoopIterator Constructor
	 * @param data (Array) data array
	 */
	public function LoopIterator(data:Array) {
		super( data );
	}
	/**
	 * override - LoopIterator always has a next element.
	 * @return Boolean
	 */
	public function hasNext():Boolean {
		return true;
	}
	/**
	 * override - LoopIterator always has a previous element.
	 * @return Boolean
	 */
	public function hasPrevious():Boolean {
		return true;
	}
	/**
	 * override - LoopIterator starts at beginning once loops is complete.
	 * @return Object
	 */
	public function next():Object {
		if(super.hasNext( )) {
			return super.next( );
		} else {
			super.reset( );
			return super.next( );
		}
	}
	/**
	 * override - LoopIterator starts at end once loops is hits the begining.
	 */
	public function previous():Object {
		if(super.hasPrevious( )) {
			return super.previous( );
		} else {
			_i = _data.length - 1;
			return _data[_i];
		}
	}
	/**
	 * Check is Iterator is at 0 index.
	 * @return Boolean
	 */
	public function isAtStart():Boolean {
		return _i == 0;
	}
	/**
	 * Check if Iterator is at last index.
	 * @return Boolean
	 */
	public function isAtEnd():Boolean {
		return _i == _data.length - 1;
	}
}