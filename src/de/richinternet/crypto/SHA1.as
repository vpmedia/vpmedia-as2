/*
 * Class:		de.richinternet.crypto.SHA1
 * Description:	An ActionScript implementation of the Secure Hash Algorithm (SHA-1)
 *				as defined in FIPS PUB 180-1
 * Usage:		This class is meant to be used as a static class and cannot
 *				be instantiated (trying to do so will lead to a compiler error).
 *				Simply add the class to your global class path to use it
 *
 *				import de.richinternet.cyrpto.SHA1;	// not necessary but easier to read
 *				SHA1.upperCaseHex = true;			// force upper case output for hex chars
 *				var digest:String = SHA1.encode("Any input string");	// compute hex digest
 *				trace(digest);
 *				--> 79F2ABCA6D13602083ECCAE83DACEE825120B65A
 *
 * Version 1.0, Rewriten for ActionScript 2.0 by Dirk Eismann
 *
 * Original code: 
 * Copyright Paul Johnston 2000 - 2002.
 * Other contributors: Greg Holt, Andrew Kepert, Ydnar, Lostinet
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification, are 
 * permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of 
 * conditions and the following disclaimer. Redistributions in binary form must reproduce 
 * the above copyright notice, this list of conditions and the following disclaimer in the 
 * documentation and/or other materials provided with the distribution.
 *
 * Neither the name of the author nor the names of its contributors may be used to endorse 
 * or promote products derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND 
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (
 * INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

class de.richinternet.crypto.SHA1 {
	
	/*
	 * Configurable variables. You may need to tweak these to be compatible with
	 * the server-side, but the defaults work in most cases.
	 *
	 * For ActionScript 2.0 these are set to be private class variable. 
	 * Use the public getter/setter functions to adjust their value:
 	 */
 	
	private static var HEX_CASE = 0;  	// hex output format. 0 - lowercase; 1 - uppercase
	private static var B64_PAD  = ""; 	// base-64 pad character. "=" for strict RFC compliance
	private static var CHRSZ = 8;  		// bits per input character. 8 - ASCII; 16 - Unicode


	// PUBLIC methods
	
	public static function encode(s:String):String {
		// convenience method, uses hex_sha1 to encode a String
		return hex_sha1(s);
	}
	
	public static function test():Boolean {
		// unit test, returns true if the VM work correctly
		return sha1_vm_test();
	}
	
	public static function hex_sha1(s:String):String {
		return binb2hex(core_sha1(str2binb(s),s.length * CHRSZ));
	}
	
	public static function b64_sha1(s:String):String {
		return binb2b64(core_sha1(str2binb(s),s.length * CHRSZ));
	}
	
	public static function str_sha1(s:String):String {
		return binb2str(core_sha1(str2binb(s),s.length * CHRSZ));
	}
	
	public static function hex_hmac_sha1(key:String, data:String):String {
		return binb2hex(core_hmac_sha1(key, data));
	}
	
	public static function b64_hmac_sha1(key:String, data:String):String {
		return binb2b64(core_hmac_sha1(key, data));
	}
	
	public static function str_hmac_sha1(key:String, data:String):String {
		return binb2str(core_hmac_sha1(key, data));
	}

	// implicit getters/setters
	
	public static function get upperCaseHex():Boolean {
		return (HEX_CASE == 1);
	}
	
	public static function set upperCaseHex(b:Boolean):Void {
		HEX_CASE = b ? 1 : 0;
	}

	public static function get b64PadCharacter():String {
		return B64_PAD;
	}
		
	public static function set b64PadCharacter(s:String):Void {
		if (s == "" || s == "=") B64_PAD = s;
	}

	public static function get bitsPerChar():Number {
		return CHRSZ;
	}
			
	public static function set bitsPerChar(n:Number):Void {
		if (n == 8 || n == 16) CHRSZ = n;
	}


	// PRIVATE methods
	
	private function SHA1() {
		// protect from instantiation
	}
	
	/*
	 * Perform a simple self-test to see if the VM is working
 	*/
	private static function sha1_vm_test():Boolean
	{
	  // force lower case on the returning String so this fits to the right side
	  return hex_sha1("abc").toLowerCase() == "a9993e364706816aba3e25717850c26c9cd0d89d";
	}
	
	/*
	 * Calculate the SHA-1 of an array of big-endian words, and a bit length
 	*/
	private static function core_sha1(x:Array, len:Number):Array
	{  
	  x[len >> 5] |= 0x80 << (24 - len % 32);
	  x[((len + 64 >> 9) << 4) + 15] = len;
	
	  var w = Array(80);
	  var a =  1732584193;
	  var b = -271733879;
	  var c = -1732584194;
	  var d =  271733878;
	  var e = -1009589776;
	
	  for(var i = 0; i < x.length; i += 16)
	  {
		var olda = a;
		var oldb = b;
		var oldc = c;
		var oldd = d;
		var olde = e;
	
		for(var j = 0; j < 80; j++)
		{
		  if(j < 16) w[j] = x[i + j];
		  else w[j] = rol(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1);
		  var t = safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)), 
						   safe_add(safe_add(e, w[j]), sha1_kt(j)));
		  e = d;
		  d = c;
		  c = rol(b, 30);
		  b = a;
		  a = t;
		}
	
		a = safe_add(a, olda);
		b = safe_add(b, oldb);
		c = safe_add(c, oldc);
		d = safe_add(d, oldd);
		e = safe_add(e, olde);
	  }
	  return Array(a, b, c, d, e);
	  
	}
	
	/*
	 * Perform the appropriate triplet combination function for the current
	 * iteration
 	*/
	private static function sha1_ft(t:Number, b:Number, c:Number, d:Number):Number
	{
	  if(t < 20) return (b & c) | ((~b) & d);
	  if(t < 40) return b ^ c ^ d;
	  if(t < 60) return (b & c) | (b & d) | (c & d);
	  return b ^ c ^ d;
	}
	
	/*
	 * Determine the appropriate additive constant for the current iteration
 	*/
	private static function sha1_kt(t:Number):Number
	{
	  return (t < 20) ?  1518500249 : (t < 40) ?  1859775393 :
			 (t < 60) ? -1894007588 : -899497514;
	}  
	
	/*
	 * Calculate the HMAC-SHA1 of a key and some data
 	*/
	private static function core_hmac_sha1(key:String, data:String):Array
	{
	  var bkey = str2binb(key);
	  if(bkey.length > 16) bkey = core_sha1(bkey, key.length * CHRSZ);
	
	  var ipad = Array(16), opad = Array(16);
	  for(var i = 0; i < 16; i++) 
	  {
		ipad[i] = bkey[i] ^ 0x36363636;
		opad[i] = bkey[i] ^ 0x5C5C5C5C;
	  }
	
	  var hash = core_sha1(ipad.concat(str2binb(data)), 512 + data.length * CHRSZ);
	  return core_sha1(opad.concat(hash), 512 + 160);
	}
	
	/*
	 * Add integers, wrapping at 2^32. This uses 16-bit operations internally
	 * to work around bugs in some JS interpreters.
 	*/
	private static function safe_add(x:Number, y:Number):Number
	{
	  var lsw = (x & 0xFFFF) + (y & 0xFFFF);
	  var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
	  return (msw << 16) | (lsw & 0xFFFF);
	}
	
	/*
	 * Bitwise rotate a 32-bit number to the left.
 	*/
	private static function rol(num:Number, cnt:Number):Number
	{
	  return (num << cnt) | (num >>> (32 - cnt));
	}
	
	/*
	 * Convert an 8-bit or 16-bit string to an array of big-endian words
	 * In 8-bit function, characters >255 have their hi-byte silently ignored.
 	*/
	private static function str2binb(str:String):Array
	{
	  var bin = Array();
	  var mask = (1 << CHRSZ) - 1;
	  for(var i = 0; i < str.length * CHRSZ; i += CHRSZ)
		bin[i>>5] |= (str.charCodeAt(i / CHRSZ) & mask) << (24 - i%32);
	  return bin;
	}
	
	/*
	 * Convert an array of big-endian words to a string
 	*/
	private static function binb2str(bin:Array):String
	{
	  var str = "";
	  var mask = (1 << CHRSZ) - 1;
	  for(var i = 0; i < bin.length * 32; i += CHRSZ)
		str += String.fromCharCode((bin[i>>5] >>> (24 - i%32)) & mask);
	  return str;
	}
	
	/*
	 * Convert an array of big-endian words to a hex string.
 	*/
	private static function binb2hex(binarray:Array):String
	{
	  var hex_tab = HEX_CASE ? "0123456789ABCDEF" : "0123456789abcdef";
	  var str = "";
	  for(var i = 0; i < binarray.length * 4; i++)
	  {
		str += hex_tab.charAt((binarray[i>>2] >> ((3 - i%4)*8+4)) & 0xF) +
			   hex_tab.charAt((binarray[i>>2] >> ((3 - i%4)*8  )) & 0xF);
	  }
	  return str;
	}
	
	/*
	 * Convert an array of big-endian words to a base-64 string
 	*/
	private static function binb2b64(binarray:Array):String
	{
	  var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	  var str = "";
	  for(var i = 0; i < binarray.length * 4; i += 3)
	  {
		var triplet = (((binarray[i   >> 2] >> 8 * (3 -  i   %4)) & 0xFF) << 16)
					| (((binarray[i+1 >> 2] >> 8 * (3 - (i+1)%4)) & 0xFF) << 8 )
					|  ((binarray[i+2 >> 2] >> 8 * (3 - (i+2)%4)) & 0xFF);
		for(var j = 0; j < 4; j++)
		{
		  if(i * 8 + j * 6 > binarray.length * 32) str += B64_PAD;
		  else str += tab.charAt((triplet >> 6*(3-j)) & 0x3F);
		}
	  }
	  return str;
	}

}