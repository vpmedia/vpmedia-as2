/**
 * PasswordGenerator
 *
 * @author: Felix Raab, E-Mail: f.raab@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.0
 */


class de.betriebsraum.utils.PasswordGenerator {
	
	
	private var _length:Number;
	private var _includeUpperCase:Boolean;
	private var _includeNumbers:Boolean;
	private var _excludeList:String;
	
	private var c:Array;
	private var v:Array;
	private var n:Array;
	
	
	public function PasswordGenerator(length:Number, includeUpperCase:Boolean, includeNumbers:Boolean, excludeList:String) {
		
		_length = length;
		_includeUpperCase = includeUpperCase;
		_includeNumbers = includeNumbers;
		_excludeList = excludeList;
		
		setChars();
		
	}
	
	
	private function setChars():Void {
		
		var excludes:Array = new Array();
		for (var i:Number=0; i<_excludeList.length; i++) {
			var char:String = _excludeList.substr(i, 1);
			excludes.push((char.toLowerCase() == undefined) ? char : char.toLowerCase());
		}
		
		c = arrayDiff(["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"], excludes);
		v = arrayDiff(["a", "e", "i", "o", "u"], excludes);
		n = arrayDiff(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"], excludes);
		
		if (c.length == 0 && v.length != 0) c.push(v[getRnd(0, v.length-1)]);
		if (v.length == 0 && c.length != 0) v.push(c[getRnd(0, c.length-1)]);
	
	}
	
	
	private function arrayDiff(array1:Array, array2:Array):Array {
		
		var diffItems:Array = new Array();
		var found:Boolean;
		
		for (var i:Number = 0; i<array1.length; i++) {
			found = false;
			for (var j:Number = 0; j<array2.length; j++) {
				if (array1[i] == array2[j]) found = true;
			}
			if (!found) diffItems.push(array1[i]);			
		}
		
		return diffItems;
		
	}
	
	
	private function getRnd(min:Number, max:Number):Number {	
		return min + Math.floor(Math.random()*(max+1-min));
	}
	
	
	public function generate():String {
		
		var pChar:String = "";
		var pWord:String = "";
		
		for (var i:Number=0; i<_length; i++) {
			
			if (_includeNumbers && n.length != 0 && (i % getRnd(1, Math.round(_length-1)) == 0 || (c.length == 0 && v.length== 0))) {
				pChar = n[getRnd(0, n.length-1)];
			} else {			
				pChar = (i % 2 == 0) ? c[getRnd(0, c.length-1)] : v[getRnd(0, v.length-1)];
				if (_includeUpperCase && getRnd(0, 1) == 1) pChar = pChar.toUpperCase();
			}		
			
			if (pChar == undefined) pChar = "";
			pWord += pChar;
			
		}		

		return pWord;
		
	}	
	
	
	/***************************************************************************
	// Getter/Setter
	***************************************************************************/
	public function get length():Number {
		return _length;
	}
	
	public function set length(newLength:Number):Void {
		_length = newLength;
	}
	
	
	public function get includeUpperCase():Boolean {
		return _includeUpperCase;
	}
	
	public function set includeUpperCase(mode:Boolean):Void {
		_includeUpperCase = mode;
	}
	
	
	public function get includeNumbers():Boolean {
		return _includeNumbers;
	}
	
	public function set includeNumbers(mode:Boolean):Void {
		_includeNumbers = mode;
	}
	
	
	public function get excludeList():String {
		return _excludeList;
	}
	
	public function set excludeList(newExcludeList:String):Void {
		
		_excludeList = newExcludeList;
		setChars();
		
	}	
			
	
}