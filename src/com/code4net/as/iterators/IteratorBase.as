/**
 *  Copyright (C) 2006 Xavi Beumala
 *  
 *	This program is free software; you can redistribute it and/or modify 
 *	it under the terms of the GNU General Public License as published by 
 *	the Free Software Foundation; either version 2 of the License, or 
 *	(at your option) any later version.
 *	
 *	This program is distributed in the hope that it will be useful, but 
 *	WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
 *	or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
 *	for more details.
 *	
 *	You should have received a copy of the GNU General Public License along
 *	with this program; if not, write to the Free Software Foundation, Inc., 59 
 *	Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *	
 *  @author Xavi Beumala
 *  @link http://www.code4net.com
 */
 
class com.code4net.as.iterators.IteratorBase {
	private var _currentIndex:Number;
	public var _datum:Array;
		
	public function IteratorBase(datum) { 
		init.apply(this, arguments);
	}
	
	public function get length():Number {
		return _datum.length;
	}
	
	public function init (datum) {
		_datum = datum;
		_currentIndex = new Number(-1);
	}

	public function get(elementNum:Number) {
		return (_datum[elementNum]);
	}
	
	public function get datum():Array {
		return _datum;
	}
	
	public function get currentIndex():Number {
		return _currentIndex;
	}
	
	public function getCurrentElement() {
		return _datum[_currentIndex];
	}
	
	public function toString():String {
		var out:String = "";
		var it:Number;
		
		for (it = 0; it < _datum.length; it++) {
			out += _datum[it] + "\n";
		}
		
		return out;
	}
}