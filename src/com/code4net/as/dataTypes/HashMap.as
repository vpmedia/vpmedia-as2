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
 
import com.code4net.as.iterators.LinearIterator;

class com.code4net.as.dataTypes.HashMap {
	private var _data:Array;
	public var keys:Array;
	
	public function HashMap() {
		clear();
	}
	
	public function put(key:String,value):Object {
		_data[key] = value;
		keys.push(key);
		return _data[key];
	}
	
	public function get(key:String) {
		return _data[key];
	}
	
	public function remove (key:String):Void {
		delete _data[key];
		var i: Number;
		
		for (i = 0; i < keys.length; i++) {
			if (keys[i] == key) {
				keys.splice(i,1);
				break;
			}
		}
	}
	
	public function clear(Void):Void {
		_data = new Array();
		keys = new Array();
	}
	
	public function hasKey(key:String):Boolean {
		var it:String;
		
		for (it in keys) {
			if (keys[it] == key) {
				return true;
			}
		}
		
		return false;
	}
	
	public function get iterator():LinearIterator {
		return new LinearIterator(keys);
	}
	
	public function get length ():Number {
		return keys.length;
	}
	
	public function toString(Void):String {
		var i;
		var str:String = new String();
		str += "HashMap";
		
		for (i = 0; i < keys.length; i++) {
			str += "\n   " + keys[i] + " : " + _data[keys[i]].toString();
		}
		
		return str;
	}
}