/*
 * @author iceeLyne
 * @version 0.2.0
 * @date Mar. 15, 2005
 * Base64 encode/decode module,
 * also data type extension for Base64 encoded string or byte array.
 * For Base64 encoding, see RFC 1521.
 * Also used in Http Basic Authorization header.
 */
class org.icube.xrf.dataext.Base64 {
	//@ig Base64 alphabet, (encoding table), char index mapping byte value:
	private static var __alphabet:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	//encode from string, only support single-byte text, (char 1 ~ 255),
	//assume input is single-byte, no checking.
	//@param s String to be encoded.
	//@return Base64 encoded String.
	public static function encodeString(s:String):String {
		var alphabet = __alphabet;
		var r:String = "";
		var i:Number = 0, u:Number, slen:Number = s.length, plen:Number;
		while (i+2<slen) {
			u = s.charCodeAt(i) << 16 | s.charCodeAt(i+1) << 8 | s.charCodeAt(i+2);
			r += alphabet.charAt(u >> 18)+alphabet.charAt(u >> 12 & 0x3F)+alphabet.charAt(u >> 6 & 0x3F)+alphabet.charAt(u & 0x3F);
			i += 3;
		}
		plen = slen-i;
		if (plen == 1) {
			u = s.charCodeAt(i);
			r += alphabet.charAt(u >> 2)+alphabet.charAt(u << 4 & 0x3F)+"==";
		} else if (plen == 2) {
			u = s.charCodeAt(i) << 8 | s.charCodeAt(i+1);
			r += alphabet.charAt(u >> 10)+alphabet.charAt(u >> 4 & 0x3F)+alphabet.charAt(u << 2 & 0x3F)+"=";
		}
		return r;
	}
	//encode from byte array, integer 0 ~ 255, over-flow is truncated.
	//@param a Array to be encoded.
	//@return Base64 encoded String.
	public static function encodeArray(a:Array):String {
		var alphabet = __alphabet;
		var r:String = "";
		var i:Number = 0, u:Number, alen:Number = a.length, plen:Number;
		while (i+2<alen) {
			u = (a[i] & 0xFF) << 16 | (a[i+1] & 0xFF) << 8 | (a[i+2] & 0xFF);
			r += alphabet.charAt(u >> 18)+alphabet.charAt(u >> 12 & 0x3F)+alphabet.charAt(u >> 6 & 0x3F)+alphabet.charAt(u & 0x3F);
			i += 3;
		}
		plen = alen-i;
		if (plen == 1) {
			u = a[i];
			r += alphabet.charAt(u >> 2)+alphabet.charAt(u << 4 & 0x3F)+"==";
		} else if (plen == 2) {
			u = (a[i] << 8) | a[i+1];
			r += alphabet.charAt(u >> 10)+alphabet.charAt(u >> 4 & 0x3F)+alphabet.charAt(u << 2 & 0x3F)+"=";
		}
		return r;
	}
	//decode to string.
	//@param s Base64 encoded String.
	//@return decoded String.
	public static function decodeString(s:String):String {
		var alphabet = __alphabet;
		var r:String = "";
		var i:Number = 0, u:Number, smlen:Number, se:String;
		if (s.length%4) {
			return "";
		}
		var p:Number = s.indexOf("=");
		if (p>=s.length-2) {
			smlen = s.length-4;
			p -= smlen;
			se = s.substr(smlen, 4);
		} else if (p<0) {
			smlen = s.length;
		} else {
			return "";
		}
		while (i<smlen) {
			u = alphabet.indexOf(s.charAt(i)) << 18 | alphabet.indexOf(s.charAt(i+1)) << 12 | alphabet.indexOf(s.charAt(i+2)) << 6 | alphabet.indexOf(s.charAt(i+3));
			r += String.fromCharCode(u >> 16, u >> 8 & 0xFF, u & 0xFF);
			i += 4;
		}
		if (p == 2) {
			u = alphabet.indexOf(se.charAt(0)) << 2 | alphabet.indexOf(se.charAt(1)) >> 4;
			r += String.fromCharCode(u);
		} else if (p == 3) {
			u = alphabet.indexOf(se.charAt(0)) << 10 | alphabet.indexOf(se.charAt(1)) << 4 | alphabet.indexOf(se.charAt(2)) >> 2;
			r += String.fromCharCode(u >> 8, u & 0xFF);
		}
		return r;
	}
	//decode to byte array.
	//@param s Base64 encoded String.
	//@return decoded byte Array.
	public static function decodeArray(s:String):Array {
		var alphabet = __alphabet;
		var r:Array = [];
		var i:Number = 0, u:Number, smlen:Number, se:String;
		if (s.length%4) {
			return [];
		}
		var p:Number = s.indexOf("=");
		if (p>=s.length-2) {
			smlen = s.length-4;
			p -= smlen;
			se = s.substr(smlen, 4);
		} else if (p<0) {
			smlen = s.length;
		} else {
			return [];
		}
		while (i<smlen) {
			u = alphabet.indexOf(s.charAt(i)) << 18 | alphabet.indexOf(s.charAt(i+1)) << 12 | alphabet.indexOf(s.charAt(i+2)) << 6 | alphabet.indexOf(s.charAt(i+3));
			r.push(u >> 16, u >> 8 & 0xFF, u & 0xFF);
			i += 4;
		}
		if (p == 2) {
			u = alphabet.indexOf(se.charAt(0)) << 2 | alphabet.indexOf(se.charAt(1)) >> 4;
			r.push(u);
		} else if (p == 3) {
			u = alphabet.indexOf(se.charAt(0)) << 10 | alphabet.indexOf(se.charAt(1)) << 4 | alphabet.indexOf(se.charAt(2)) >> 2;
			r.push(u >> 8, u & 0xFF);
		}
		return r;
	}
	//validate Base64 encoded data.
	//@param d String to be tested.
	//@return true if d pass the Base64 validation, else false.
	public static function validateBase64Data(d:String):Boolean {
		if (d.length%4) {
			return false;
		}
		var alphabet = __alphabet;
		var slen = d.length, srlen = slen-2;
		for (var i = 0; i<srlen; i++) {
			if (alphabet.indexOf(d.charAt(i))<0) {
				return false;
			}
		}
		alphabet += "=";
		for (var i = srlen; i<slen; i++) {
			if (alphabet.indexOf(d.charAt(i))<0) {
				return false;
			}
		}
		return true;
	}
	private var __data:String;
	//get/set encoded data.
	public function get data():String {
		return __data;
	}
	public function set data(d:String) {
		setData(d);
	}
	//same as data=d, but return false if d failed to pass the validation.
	//@param d Base64 data.
	//@return validation result, Boolean.
	public function setData(d:String):Boolean {
		if (validateBase64Data(d)) {
			__data = d;
			return true;
		} else {
			return false;
		}
	}
	//convert string to Base64.
	public function fromString(s:String) {
		__data = encodeString(s);
	}
	//convert byte array to Base64.
	public function fromArray(a:Array) {
		__data = encodeArray(a);
	}
	//convert Base64 to string.
	public function toString():String {
		return decodeString(__data);
	}
	//convert Base64 to byte array.
	public function toArray():Array {
		return decodeArray(__data);
	}
	//constructor, convert data to Base64.
	//@param d data to be encoded, String or Array.
	public function Base64(d) {
		if (typeof d == "string") {
			fromString(d);
		} else if (d instanceof Array) {
			fromArray(d);
		}
	}
}
