

import eka.src.map.* ;
import eka.src.util.* ;

class eka.src.map.HashMap implements Map {

	// ----o Author Properties

	public static var className:String = "HashMap" ;
	public static var classPackage:String = "eka.src.map" ;
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;

	// ----o Construtor
	
	public function HashMap(Void) {
		_keys = new Array ;
		_values = new Array ;
	}
	
	// ----o Public Methods	
	
	public function toString(Void):String {
		return new MapStringifier().execute(this) ;
	}
	
	public function containsKey(key):Boolean {
		return _findKey(key) > -1 ;
	}
	
	public function containsValue( value ):Boolean {
		return _findValue(value) > -1 ;
	}

	public function getKeys(Void):Array {
		return _keys.slice() ;
	}

	public function getValues(Void):Array {
		return _values.slice() ;
	}

	public function get(key) {
		return _values[_findKey(key)] ;
	}

	public function put(key, value) {
		var r ;
		var i:Number = _findKey(key) ;
		if (i<0) {
			_keys.push(key) ;
			_values.push(value) ;
		} else {
			r = _values[i] ;
			_values[i] = value ;
		}
		return r ;
	}
	
	public function putAll(m:Map):Void {
		var aV:Array = m.getValues() ;
		var aK:Array = m.getKeys() ;
		var l:Number = aK.length ;
		for (var i:Number = 0 ; i<l ; i = i - (-1) ) {
			put(aK[i], aV[i]) ;
		}
	}

	public function remove(key) {
		var r ;
		var i:Number = _findKey(key) ;
		if (i > -1) {
			r = _values[i] ;
			_values.splice(i, 1) ;
			_keys.splice(i, 1) ;
		}
		return r ;
	}
	
	public function clear(Void):Void {
		_keys = new Array() ;
		_values = new Array() ;
	}
	
	public function size(Void):Number {
		return _keys.length ;
	}

	public function isEmpty(Void):Boolean {
		return size() < 1 ;
	}

	public function iterator(Void):Iterator {
		return new MapIterator(this) ;
	}
	
	// -----o Private Properties
	
	private var _keys:Array ;
	private var _values:Array ;

	// -----o Private Methods

	private function _findValue(value):Number {
		var l:Number = _values.length ;
		while (_values[--l] != value && l>-1);
		return l ;
	}
	
	private function _findKey(key):Number {
		var l:Number = _keys.length ;
		while (_keys[--l] != key && l>-1);
		return l ;
	}

}
