/**
* Class: f_TEA
*
* Version: v1.0b
* Released: 03 April, 2006
*
* Encrypts and decrypts data using the TEA encryption algorithm developed by Roger Needham and David Wheeler at Cambridge University.
*
* The latest version can be found at:
* http://sourceforge.net/projects/f-tea
* -or-
* http://www.baynewmedia.com/
*
* (C)opyright 2006 Bay New Media.
*
* This library is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* This library is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public
* License along with this library (see "lgpl.txt") ; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*
*	Class/Asset Dependencies
* 		Extends: None
*		Requires: com.bnm.fc.ThreadManager, com.bnm.fc.ThreadMgr.Thread, com.bnm.fc.Extension
*		Required By: None
*		Required Data Sources: None
*		Required Assets:
*			None
*
*
* History:
*
* v0.01 [15/02/06]
* 	- updated comments to NaturalDoc style
* 	- first public version
*	- updated accompanying PHP module
*
* v1.0b [04/03/06]
* 	- Included f_TEA in BNM Foundation Classes
*  - Added asynchronous encryption via ThreadManager for large data structures. All encryption and decryption is now done
*		asynchronously and requires callbacks. Data size limit has been removed.
* 	- Added Extension class for better data type checking
* 	- Added centralized error reporting with Error class
*/
import com.bnm.fc.ThreadManager;
import com.bnm.fc.ThreadMgr.Thread;
import com.bnm.fc.Extension;
import com.bnm.fc.Error;
class com.bnm.fc.f_TEA {
	// __/ PUBLIC VARIABLES \__
	//context (object reference) - The context or scope in which to invoke the asynchronous callback functions _onEncode and _onDecode.
	public var context:Object = undefined;
	// __/ PRIVATE VARIABLES \__
	/**
	* sum (double word): Cyclical counter used during each encryption cycle. 'deltaNum' is added  to sum on each cycle
	*	and then used in bit shifting.
	*/
	private var sum:Number = undefined;
	//deltaNum (double word): The 'magic' number used for encryption during each cycle
	private static var deltaNum:Number = new Number (0x9E3779B9);
	//_onEncode (function reference) -  The function to call once asynchronous encoding is complete. A setter/getter is provided for public access.
	private var _onEncode:Function = undefined;
	//_onDecode (function reference) -  The function to call once asynchronous decoding is complete. A setter/getter is provided for public access.
	private var _onDecode:Function = undefined;
	//_threadMan (ThreadManager) - An instance of ThreadManager used for cycling through large volumes of data (to prevent
	//			Flash crashes)
	private var _threadMan:ThreadManager = undefined;
	//_encodePercent (number) - The percentage of asynchronous encoding completed. A getter is provided for public access.
	private var _encodePercent:Number = undefined;
	//_decodePercent (number) - The percentage of asynchronous decoding completed. A getter is provided for public access.
	private var _decodePercent:Number = undefined;
	// __/ PUBLIC METHODS \__
	/**
	* Method: f_TEA
	*
	* Constructor method for the class.
	*
	* Parameters:
	* 	initObj (object, optional) - Used to initialize the class with reciprocal values. That is, each value in the object will be
	* 			assigned to a like (or new) value within the class.
	*
	* Returns:
	* 	f_TEA instance - The newly created class instance.
	*
	* See also:
	* <init>
	*/
	public function f_TEA (initObj:Object, strict:Boolean) {
		this.setDefaults ();
		if (initObj <> undefined) {
			this.init (initObj, strict);
		}
		// if 
	}
	// constructor
	/**
	* Method: init
	*
	* Initializes the class using reciprocal values passed in the parameter object.
	*
	* Parameters:
	* 	initObj (object, required) - Used to initialize the class with reciprocal values. That is, each value in the object will be
	* 			assigned to a like (or new) value within the class.
	* 	strict (boolean, optional) - If TRUE, strict evaluation will be used when looping through 'iniObj'. That is, only items that
	* 			exist in the class and are of the same type will be set, otherwise they will be ignored. If FALSE, all items will be applied.
	*
	* Returns:
	* 	boolean -TRUE if initObj was set, false otherwise
	*
	* See also:
	* <f_TEA>
	*/
	public function init (initObj:Object, strict:Boolean):Boolean {
		if (initObj == undefined) {
			return (false);
		}
		for (var item in initObj) {
			if (strict) {
				if (Extension.xtypeof (initObj[item]) == Extension.xtypeof (this[item])) {
					this[item] == initObj[item];
				}
				else {
					this.broadcastError (1, 'f_TEA.init: initObj.' + item + ' is of the wrong type or not reciprocal in class instance. ' + Extension.xtypeof (this[item]) + ' expected.');
				}
				// else
			}
			else {
				this[item] = initObj[item];
			}
			// else
		}
		// for
	}
	// init
	/**
	* Method: encrypt
	*
	* Encrypts two double words (64 bits) using the 128 bit key and returns the encrypted 64-bit string as two 32-bit words.
	*
	* Parameters
	* 	data1 - (double word, required) The first double word (32 bits) of the plaintext message
	* 	data2 - (double word, required)  The second  double word (32 bits) of the plaintext message
	* 	eKey1 to eKey3 (double word, required) - Four double words of the 128-bit encryption key
	*
	* Returns:
	*	 array (2 bytes, 0-based) - Element 0 contains the first encrypted word and element 1 contains the second
	*			encrypted word.
	*
	*/
	public function encrypt (data1:Number, data2:Number, eKey1:Number, eKey2:Number, eKey3:Number, eKey4:Number):Array {
		var sum:Number = new Number (0);
		var y:Number = new Number (data1);
		var z:Number = new Number (data2);
		//Encryption cycles may be decreased if desired. However, this weakens the encryption.
		for (var n:Number = 0; n <= 31; n++) {
			sum += deltaNum;
			y += ((z << 4) + eKey1) ^ (z + sum) ^ ((z >>> 5) + eKey2);
			z += ((y << 4) + eKey3) ^ (y + sum) ^ ((y >>> 5) + eKey4);
		}
		// for
		var returnData:Array = new Array ();
		returnData[0] = y;
		returnData[1] = z;
		return (returnData);
	}
	// encrypt
	/**
	* Method: decrypt
	*
	* Decrypts two data bytes using the 128-bit key and returns the decrypted 64-bit string as 2 32-bit words.
	*
	* Parameters:
	* 	data1 (double word, required) - The first double word (32 bits) of the cipher string
	* 	data2 (double word, required) - The second double word (32 bits) of the cipher string
	* 	eKey1 to eKey3 (double word, required) - Four double words of the 128-bit encryption key
	*
	*Returns:
	*	array (2 word, 0-based) - Element 0 contains the first decrypted word and element 1 contains the second
	*			decrypted word. These may be re-assembled into four characters in the plaintext message.
	*
	*/
	public function decrypt (data1:Number, data2:Number, eKey1:Number, eKey2:Number, eKey3:Number, eKey4:Number):Array {
		var y:Number = new Number (data1);
		var z:Number = new Number (data2);
		var sum:Number = new Number (0x0C6EF3720);
		//The number of decryption cycles must match the number of encryption cycles.
		for (var n:Number = 0; n <= 31; n++) {
			z -= ((y << 4) + eKey3) ^ (y + sum) ^ ((y >>> 5) + eKey4);
			y -= ((z << 4) + eKey1) ^ (z + sum) ^ ((z >>> 5) + eKey2);
			sum -= deltaNum;
		}
		// for
		var returnData:Array = new Array ();
		returnData[0] = y;
		returnData[1] = z;
		return (returnData);
	}
	// decrypt
	/**
	* Method: charToDig
	*
	* Converts a standard keyboard character (ASCII decimal values 32 to 126) into a two digit string representation. This is done by subtracting
	* 32 from the value. Therefore, the highest allowable keyboard value is the tilde (~) at 94 (126-32=94). Extra control characeters are translated as follows:
	* 	13 (carriage return) = 95
	* 	10 (line feed) = 96
	* 	9 (tab) = 97
	*
	* This translation is therefore only suitable for use on human-readable data such as plain text, HTML, or XML. Any ASCII values outside of the stated
	* ranges (extended ASCII, for example) will be discarded.
	*
	* Parameters:
	* 	char (one-character string, required) - The input character to be converted.
	*
	* Returns:
	*	string - The two-character string representing a decimal number in the range 00-97.  This may be converted back to it's standard
	* 			ASCII representation by adding 32 to the ordinal value.
	*
	* See also:
	* <digToChar>
	*/
	public function charToDig (char:String):String {
		var inputStr:String = new String (char);
		var numChar:Number = new Number (inputStr.charCodeAt ());
		var outStr:String = new String ();
		var tempChar:Number = new Number ();
		//Includes all valid characters, space starts at 0
		if ((numChar > 31) && (numChar < 127)) {
			tempChar = numChar - 32;
			if (tempChar <= 9) {
				outStr = '0';
			}
			// if 
			outStr += tempChar.toString ();
			return (outStr);
		}
		else if (numChar == 10) {
			return ('95');
		}
		else if (numChar == 13) {
			return ('96');
		}
		else if (numChar == 9) {
			return ('97');
		}
		else {
			return ('');
		}
		// else
	}
	// charToDig
	/**
	* Method: digToChar
	*
	* Reverses the operation of the charToDig  method. This is done simply by adding 32 to values between the range 0 to 94.  Values beyond 94 are
	* translated as follows:
	* 	95 = 13 (carriage return)
	* 	96 = 10 (line feed)
	* 	97 = 9 (tab)
	*
	* Parameters:
	*	dig (Number, required) - Input digit to be converted back to an ASCII characters. Must in the range 0 to 97.
	*
	* Returns:
	* 	string - A one-character string.
	*
	* See also:
	* <charToDig>
	*/
	public function digToChar (dig:Number):String {
		if ((dig > -1) && (dig < 95)) {
			dig += 32;
			return (String.fromCharCode (dig));
		}
		else if (dig == 95) {
			return (chr (10));
		}
		else if (dig == 96) {
			return (chr (13));
		}
		else if (dig == 97) {
			return (chr (9));
		}
		else {
			return ('');
		}
		// else
	}
	// digToChar
	/**
	* Method: stringToWord
	*
	* Creates a double word word value (32 bits) using exactly 4 input characters and an optional 'header'. The input characters must be
	* human-readable (see <charToDig>). Each character is converted into a two-digit value ranging from 0-97 and made into a string.
	* This string is then appended onto the end of previous characters converted forming a string of 8 digits. Since a 32 bit value can range
	* up to 10 decimal digits, an optional 2-digit 'header' value is available for miscelaneous data. This header may only range from 0 to 41.
	*
	* Parameters:
	* 	inputStr (string, required) - The 4-character input string to be converted.
	* 	header (number, optional) - An optional value ranging from 0 to 41 to be used for miscelaneous purposes.
	*
	* Returns:
	* 	number - Long word (32-bit) number
	*
	* See also:
	* <wordToString>
	*/
	public function stringToWord (inputStr:String, header:Number):Number {
		var tempStr:String = new String (inputStr);
		var outStr:String = new String ();
		var outNum:Number = new Number ();
		var strLen:Number = new Number (tempStr.length);
		if (strLen <> 4) {
			return null;
		}
		// if 
		if ((header <> undefined) && (header > -1) && (header < 42)) {
			outStr = String (header);
		}
		else {
			outStr = '';
		}
		// else
		for (var counter:Number = 0; counter <= 3; counter++) {
			outStr += this.charToDig (tempStr.charAt (counter));
		}
		// else
		outNum = Number (outStr);
		return (outNum);
	}
	// stringToWord
	/**
	* Method: wordToString
	*
	*	Converts a 32-bit number (long word) to a 4-character string, reversing the operation of the 'stringToWord' function.
	* 	Any digits above the first 8 are ignored and must be handled externally if required.
	*
	* Parameters:
	*	inWord (number, required) - The 32-bit long word to be converted to a string
	*
	*Returns:
	*
	* string - 4 characters represented by the 32-bit word
	*
	* See also:
	* <stringToWord>
	*/
	public function wordToString (inWord:Number):String {
		var tempNum:Number = new Number (inWord);
		var tempStr:String = new String (tempNum.toString ());
		var strLength:Number = new Number (tempStr.length);
		var remLength:Number = new Number ();
		var parseStr:String = new String ();
		var outStr:String = new String ();
		var tempChar:String = new String ();
		if (strLength > 8) {
			parseStr = tempStr.substr (strLength - 8, strLength);
			remLength = Number (tempStr.substr (0, strLength - 8));
		}
		else {
			parseStr = tempStr;
			remLength = 8;
		}
		//else
		for (var count:Number = 0; count <= 3; count++) {
			//If string is shorter than full four bytes, discard remaining information.
			if (count <= remLength) {
				outStr += this.digToChar (Number (parseStr.substr (count * 2, 2)));
			}
			// if 
		}
		// for
		return (outStr);
	}
	// wordToString
	/**
	* Method: wordToNetEnc
	*
	* Converts a 32-bit word to a network encoded string. This allows the data to be transmitted safely
	* over a network in, for example, an XML object without the overhead of URL encoding. The network encoded
	* string includes upper and lower-case letters and numbers which are translated directly from decimal values.
	* Depending on the original decimal values, this process may actually result in slight data compression.
	*
	*Parameters:
	*	inWord (number, required) - The 32-bit word to be converted.
	*
	*
	*Returns:
	*	string - The network encoded string
	*
	* See also:
	* <netEncToWord>
	*/
	public function wordToNetEnc (inWord:Number):String {
		var tempWord:Number = new Number (inWord);
		var wordStr:String = new String (tempWord.toString ());
		var outStr:String = new String ();
		var strLen:Number = new Number (wordStr.length);
		var tempChar:String = new String ();
		var tempNum:Number = new Number ();
		var tempStr:String = new String ();
		var count:Number = new Number (0);
		var tempCompare:String = new String ();
		//If this is a negative number, remove minus sign and make appropriate change to out string.
		if (tempWord < 0) {
			wordStr = wordStr.substr (1, strLen);
			strLen--;
			outStr = '0';
		}
		else {
			outStr = '1';
		}
		// else
		while (count < strLen) {
			tempStr = wordStr.substr (count, 2);
			if (tempStr <> '') {
				tempNum = Number (tempStr);
				tempCompare = tempNum.toString ();
				//If the number is larger than the maximum representable number, use a single digit only.
				if (tempNum > 62) {
					tempStr = wordStr.substr (count, 1);
					tempNum = Number (tempStr);
					tempCompare = tempNum.toString ();
					count++;
				}
				else {
					count = count + 2;
				}
				// else
				tempChar = '';
				//Test to see if a leading 0 was lost during conversion
				if (tempStr.length <> tempCompare.length) {
					tempChar = '0';
				}
				// if 
				//0-9
				if (tempNum < 10) {
					tempChar += chr (48 + tempNum);
				}
				// if 
				//A-Z
				if ((tempNum > 9) && (tempNum <= 35)) {
					tempChar += chr (55 + tempNum);
				}
				// if 
				//a-z
				if (tempNum > 35) {
					tempChar += chr (61 + tempNum);
				}
				// if 
				outStr += tempChar;
			}
			// if 
		}
		// while
		return (outStr);
	}
	// wordToNetEnc
	/**
	*Method: netEncToWord
	*
	* Converts a network-encoded string back to a decimal representation. This is typically a series of two-digit numbers used to
	* represent letters.
	*
	*Parameters:
	*	inStr (string, required) - The string to be converted.
	*
	*Returns:
	* number - a 32-bit number
	*
	* See also:
	* <wordToNetEnc>
	*/
	public function netEncToWord (inStr:String):Number {
		var encStr:String = new String (inStr);
		var outStr:String = new String ();
		var outNum:Number = new Number ();
		var strLen:Number = new Number ();
		var charOrd:Number = new Number ();
		//We assume that the first character denotes the sign
		strLen = encStr.length - 1;
		if (encStr.charAt (0) == '0') {
			outStr = '-';
		}
		// if 
		for (var count:Number = 1; count <= strLen; count++) {
			charOrd = encStr.charAt (count).charCodeAt ();
			if (charOrd < 58) {
				outNum = charOrd - 48;
			}
			else if ((charOrd > 64) && (charOrd < 91)) {
				outNum = charOrd - 55;
			}
			else if (charOrd > 96) {
				outNum = charOrd - 61;
			}
			else {
				//Discarded
			}
			outStr += outNum.toString ();
		}
		// for
		return (Number (outStr));
	}
	// netEncToWord
	/**
	*Method: encodeString
	*
	*	Creates an encrypted, converted, network encoded string. Be	sure to set the class instance's'onEncode' and optionally 'context' values
	*  as all encryption is asynchronous and requires a callback. Failure to do so will generate an error.
	*
	*Parameters:
	*	inString (string-required) - The stringto be converted. May be any length.
	*	key1 to key4 (double word, required) - The four double word (32-bit) encryption keys to use for the encryption
	*
	*Returns:
	*	boolean - TRUE if encosing started successfully, FALSE otherwise. FALSE is usually returned when 'onEncode' is not set prior
	* 				to calling this method.
	*
	* See also:
	* <decodeString>
	* <startAsynchDecode>
	* <asynchDecode>
	*
	* Notes:
	*
	* 	This method has been updated since version 0.01b and can now handle data structures larger than 50 kB. Any large data structure
	* 	(larger than 30kB) will be encoded using an asynchronous execution thread. To facilitate this change, a callback method must be specified
	* 	prior to calling this method or it will fail.
	*
	*/
	public function encodeString (inString:String, key1:Number, key2:Number, key3:Number, key4:Number):Boolean {
		if ((this.onEncode == undefined) || (Extension.xtypeof (this.onEncode) <> 'function')) {
			this.broadcastError (2, 'f_TEA.encodeString : onEncode callback has not been properly specified priorto encoding.');
			return (false);
		}
		//if 
		if (inString == undefined) {
			var inString:String = new String ();
		}
		// if 
		var realString:String = new String (inString);
		var parseOffset:Number = new Number (0);
		var parseStr:String = new String ();
		var parseLength:Number = new Number ();
		var parseCount:Number = new Number ();
		var encodedString:String = new String ();
		var wordArr:Array = new Array ();
		var encArray:Array = new Array ();
		var word1:Number = new Number ();
		var word2:Number = new Number ();
		//Absolute upper limit for a single execution cycle is 62750. Practically, this limit should never be used because it comes
		//close to locking up Flash. However, future revisions may allow user control over this value for use in their application.
		//Currently, the split value is set to 30000 which should allow comfortable decoding without causing too much playback
		//latency.
		if (realString.length > 30000) {
			var encodeObject:Object = new Object ();
			encodeObject.realString = realString;
			encodeObject.parseOffset = parseOffset;
			encodeObject.encodedString = encodedString;
			encodeObject.key1 = key1;
			encodeObject.key2 = key2;
			encodeObject.key3 = key3;
			encodeObject.key4 = key4;
			this.startAsynchEncode (encodeObject);
		}
		else {
			while (parseOffset <= realString.length) {
				//Run through twice to create two input words (8 bytes)
				for (var wordCount:Number = 0; wordCount <= 1; wordCount++) {
					parseStr = realString.substr (parseOffset, 4);
					parseLength = parseStr.length;
					parseOffset = parseOffset + 4;
					//Ensure that string chunk is always 4 characters, pad when necessary
					if (parseLength < 4) {
						for (var count:Number = 1; count <= (4 - parseLength); count++) {
							parseStr += ' ';
						}
						//for
					}
					//if 
					wordArr[wordCount] = parseStr;
					wordArr[wordCount + 2] = parseLength;
				}
				//for
				word1 = this.stringToWord (wordArr[0], wordArr[2]);
				word2 = this.stringToWord (wordArr[1], wordArr[3]);
				//Encode words against each other
				encArray = this.encrypt (word1, word2, key1, key2, key3, key4);
				//Encode for network transmission, include semicolon as delimiter
				encodedString += this.wordToNetEnc (encArray[0]) + ';';
				encodedString += this.wordToNetEnc (encArray[1]) + ';';
			}
			// while
			if (this.context == undefined) {
				this.onEncode (encodedString);
			}
			else {
				this.onEncode.call (this.context, encodedString);
			}
		}
		//else
		return (true);
	}
	// encodeString
	/**
	*Method: decodeString
	*
	*	Decrypts network-encoded, encrypted data back to plain text. Besure to set the class instance's 'onDecode' and optionally 'context' values
	*  as all encryption is asynchronous and requires a callback. Failure to do so will generate an error.
	*
	*Parameters:
	*	inString (string-required) - The stringto be converted. May be any length.
	*	key1 to key4 (double word, required) - The four double word (32-bit) encryption keys to use for the encryption
	*
	*Returns:
	*	boolean - TRUE if decoding/decryption started successfully, FALSE otherwise. FALSE is usually returned when 'onDecode' is not set prior
	* 				to calling this method.
	*
	* See also:
	* <encodeString>
	*
	* Notes:
	*
	* 	This method has been updated since version 0.01b and can now handle data structures larger than 50 kB. Any large data structure
	* 	(semi-colon delimited units exceeding 7.5 kB) will be encoded using an asynchronous execution thread. To facilitate this change, a
	* 	callback method must be specified prior to calling this method or it will fail.
	*/
	public function decodeString (inString:String, key1:Number, key2:Number, key3:Number, key4:Number):Boolean {
		if ((this.onDecode == undefined) || (Extension.xtypeof (this.onDecode) <> 'function')) {
			this.broadcastError (2, 'f_TEA.encodeString : onDecode callback has not been properly specified prior to encoding.');
			return (false);
		}
		//if 
		var realString:String = new String (inString);
		//subStr (array, string): Array of strings to be converted back into plain text.
		var subStr:Array = new Array ();
		var encWord1:Number = new Number ();
		var encWord2:Number = new Number ();
		var decArray:Array = new Array ();
		var decodedString:String = new String ();
		var str1:String = new String ();
		var str2:String = new String ();
		subStr = realString.split (';');
		//Note that the maximum data length here is significantly smaller (4x smaller) because each array entry actually contains
		//4 bytes of data. This equals 30kB in decoding processor time and is therefore equivalent to the encode function.
		if (subStr.length > 7500) {
			var decodeObject:Object = new Object ();
			decodeObject.subStr = subStr;
			decodeObject.decodedString = decodedString;
			decodeObject.parseOffset = new Number (0);
			decodeObject.key1 = key1;
			decodeObject.key2 = key2;
			decodeObject.key3 = key3;
			decodeObject.key4 = key4;
			this.startAsynchDecode (decodeObject);
		}
		else {
			for (var parseOffset:Number = 0; parseOffset <= (subStr.length - 2); parseOffset = parseOffset + 2) {
				encWord1 = this.netEncToWord (subStr[parseOffset]);
				encWord2 = this.netEncToWord (subStr[parseOffset + 1]);
				decArray = this.decrypt (encWord1, encWord2, key1, key2, key3, key4);
				str1 = this.wordToString (decArray[0]);
				str2 = this.wordToString (decArray[1]);
				if (decArray[1] <> 0) {
					decodedString += str1 + str2;
				}
				else {
					decodedString += str1;
				}
				// else
			}
			// for
			if (this.context == undefined) {
				this.onDecode (decodedString);
			}
			else {
				this.onDecode.call (this.context, decodedString);
			}
			// else
		}
		//else
		return (true);
	}
	//decodeString
	// __/ SETTERS AND GETTERS \__
	/**
	 * Method: set onEncode
	 *
	 * Sets the 'onEncode' callback function for use when encoding completes.
	 *
	 * Parameters:
	 * 	fRef (function reference, required) - The function to be called on encoding completion.
	 *
	 * See also:
	 * 	<get onEncode>
	 */
	public function set onEncode (fRef:Function) {
		if (Extension.xtypeof (fRef) <> 'function') {
			return;
		}
		this._onEncode = fRef;
	}
	//set onEncode
	/**
	 * Method: get onEncode
	 *
	 * Returns the currently set 'onEncode' callback function.
	 *
	 * Returns:
	 * 	function reference - The function that is currently set to be called on encoding completion.
	 *
	 * See also:
	 * 	<set onEncode>
	 */
	public function get onEncode ():Function {
		return (this._onEncode);
	}
	//get onEncode
	/**
	 * Method: set onDecode
	 *
	 * Sets the 'onDecode' callback function for use when decoding completes.
	 *
	 * Parameters:
	 * 	fRef (function reference, required) - The function to be called on decoding completion.
	 *
	 * See also:
	 * 	<get onDecode>
	 */
	public function set onDecode (fRef:Function) {
		if (Extension.xtypeof (fRef) <> 'function') {
			return;
		}
		this._onDecode = fRef;
	}
	//set onDecode
	/**
	 * Method: get onDecode
	 *
	 * Returns the currently set 'onDecode' callback function.
	 *
	 * Returns:
	 * 	function reference - The function that is currently set to be called on decoding completion.
	 *
	 * See also:
	 * 	<set onDecode>
	 */
	public function get onDecode ():Function {
		return (this._onDecode);
	}
	//get onEncode
	/**
	 * Method: get encodePercent
	 *
	 * Returns the current precentage completed in the asynchronous encoding cycle.
	 *
	 * Returns:
	 * 	number - The currently completed precentage of the asynchronous encoding cycle.
	 *
	 */
	public function get encodePercent ():Number {
		return (this._encodePercent);
	}
	//get encodePercent
	/**
	 * Method: get decodePercent
	 *
	 * Returns the current precentage completed in the asynchronous decoding cycle.
	 *
	 * Returns:
	 * 	number - The currently completed precentage of the asynchronous decoding cycle.
	 *
	 */
	public function get decodePercent ():Number {
		return (this._decodePercent);
	}
	//get decodePercent
	// __/ PRIVATE METHODS \__
	/**
	 * Method: startAsynchEncode
	 *
	 * Begins the asynchronous encoding thread for larger data structures.
	 *
	 * Parameters:
	 * 	encodeObj (object, required) - An object containing the encoding parameters required for the operation.
	 * 	These include:
	 * 				realString (string, required) - A proper String object containg the string representation of the data to encode.
	 * 				parseOffset (number, required) - Current offset within the string currently being encoded. This value typically begins at 0.
	 * 				encodedString (string, required) - A proper String object used to store the encoded contents of the operation on each
	 * 							iteration of the thread.
	 * 				key1 to key4 (numbers, required) - The encryption keys to be used for the operation.
	 *
	 * Returns:
	 * 	Nothing
	 */
	private function startAsynchEncode (encodeObj:Object) {
		var threadObject:Object = new Object ();
		threadObject.func = this.asynchEncode;
		threadObject.context = this;
		threadObject.parameters = encodeObj;
		this._threadMan.addThread.call (this._threadMan, threadObject);
		this._threadMan.start ();
	}
	//startAsynchEncode
	/**
	 * Method: asynchEncode
	 *
	 * Method executed on each thread iteration during the asynchronous encoding loop.
	 *
	 * Parameters:
	 * 	encodeObj (object, required) - An object containing the encoding parameters required for the operation.
	 * 		These include:
	 * 				realString (string, required) - A proper String object containg the string representation of the data to encode.
	 * 				parseOffset (number, required) - Current offset within the string currently being encoded. This value typically begins at 0.
	 * 				encodedString (string, required) - A proper String object used to store the encoded contents of the operation on each
	 * 							iteration of the thread.
	 * 				key1 to key4 (numbers, required) - The encryption keys to be used for the operation.
	 * 	threadInstance (Thread, required) - An instance of the Thread class calling the current method. This is passed in as
	 * 			a standard parameter by the Thread handler class.
	 *
	 * Returns:
	 * 	Nothing
	 *
	 * See also:
	 * 	<startAsynchDecode>
	 * 	<asynchDecode>
	*/
	private function asynchEncode (encodeObj:Object, threadInstance:Thread) {
		if (encodeObj.parseOffset >= encodeObj.realString.length) {
			this._threadMan.removeThread (threadInstance);
			if (this.context == undefined) {
				this.onEncode (encodeObj.encodedString);
			}
			else {
				this.onEncode.call (this.context, encodeObj.encodedString);
			}
			//else
			//Encoding should be done at this point so make sure no further processing takes place.
			return;
		}
		// if 
		var subString:String = new String ();
		subString = encodeObj.realString;
		//Encode string by 160 character blocks. Each block must be evenly divisible by 4 since 4 characters are used in
		//each cycle (see 'for' loop below).
		subString = subString.substr (encodeObj.parseOffset, 160);
		if (subString.length < 4) {
			while (subString.length < 4) {
				subString += ' ';
			}
			//while
		}
		//if 
		var parseStr:String = new String ();
		var parseLength:Number = new Number ();
		var internalOffset:Number = new Number (0);
		var word1:Number = new Number ();
		var word2:Number = new Number ();
		var encArray:Array = new Array ();
		var wordArr:Array = new Array ();
		for (var subCount:Number = 1; subCount <= (subString.length / 4); subCount += 4) {
			for (var wordCount:Number = 0; wordCount <= 1; wordCount++) {
				parseStr = subString.substr (internalOffset, 4);
				parseLength = parseStr.length;
				internalOffset += 4;
				encodeObj.parseOffset += 4;
				//Ensure that string chunk is always 4 characters, pad when necessary
				if (parseLength < 4) {
					for (var count:Number = 1; count <= (4 - parseLength); count++) {
						parseStr += ' ';
					}
					//for
				}
				//if 
				wordArr[wordCount] = parseStr;
				wordArr[wordCount + 2] = parseLength;
			}
			//for
			word1 = this.stringToWord (wordArr[0], wordArr[2]);
			word2 = this.stringToWord (wordArr[1], wordArr[3]);
			//Encode words against each other
			encArray = this.encrypt (word1, word2, encodeObj.key1, encodeObj.key2, encodeObj.key3, encodeObj.key4);
			//Encode for network transmission, include semicolon as delimiter
			encodeObj.encodedString += this.wordToNetEnc (encArray[0]) + ';';
			encodeObj.encodedString += this.wordToNetEnc (encArray[1]) + ';';
		}
		// for
		this._encodePercent = Math.round ((encodeObj.parseOffset / encodeObj.realString.length) * 100);
	}
	// asynchEncode
	/**
	* Method: startAsynchDecode
	*
	* Begins the asynchronous decoding thread loop.
	*
	* Parameters:
	* 	decodeObj (object, required) - An object containing the decoding parameters required for the operation.
	* 		These include:
	* 					subStr (array, required) - A numbered array of net-encoded, encrypted values to convert back to plain text.
	* 					parseOffset (number, required) - The current pointer within the encrypted data at which to pick up
	* 								next data during the loop. This typically begins at 0.
	*					decodedString (string, required) - The plain text string to which decrypted data will be appended,
	* 					key1 to key4 (numbers, required) - The encryption keys originally used to encrypt the data.
	*
	* See also:
	* 	<asynchDecode>
	* 	<startAsynchEncode>
	*/
	private function startAsynchDecode (decodeObj:Object) {
		var threadObject:Object = new Object ();
		threadObject.func = this.asynchDecode;
		threadObject.context = this;
		threadObject.parameters = decodeObj;
		this._threadMan.addThread.call (this._threadMan, threadObject);
		this._threadMan.start ();
	}
	//startAsynchDecode
	/**
	 * Method: asynchDecode
	 *
	 * Method called on each iteration of the asynchronous decoding loop.
	 *
	 * Parameters:
	 * decodeObj (object, required) - An object containing the decoding parameters required for the operation.
	 * 		These include:
	 * 					subStr (array, required) - A numbered array of net-encoded, encrypted values to convert back to plain text.
	 * 					parseOffset (number, required) - The current pointer within the encrypted data at which to pick up
	 * 								next data during the loop. This typically begins at 0.
	 *					decodedString (string, required) - The plain text string to which decrypted data will be appended,
	 * 				 key1 to key4 (numbers, required) - The encryption keys originally used to encrypt the data.
	 *
	 * See also:
	 * 	<asynchEncode>
	 * 	<startAsynchDecode>
	*/
	private function asynchDecode (decodeObj:Object, threadInstance:Thread) {
		//This was going beyond the length of the array. Also added a -2 decode limit below.
		//This may not be the best solution.
		if (decodeObj.parseOffset >= (decodeObj.subStr.length - 2)) {
			this._threadMan.removeThread (threadInstance);
			if (this.context == undefined) {
				this.onDecode (decodeObj.decodedString);
			}
			else {
				this.onDecode.call (this.context, decodeObj.decodedString);
			}
			//else
			//Decoding should be done at this point so make sure no further processing takes place.
			return;
		}
		//if 
		var decArray:Array = new Array ();
		var encWord1:Number = new Number ();
		var encWord2:Number = new Number ();
		var decArray:Array = new Array ();
		var str1:String = new String ();
		var str2:String = new String ();
		var decodeLimit:Number = decodeObj.parseOffset + 160;
		if (decodeLimit > decodeObj.subStr.length) {
			decodeLimit = decodeObj.subStr.length - 2;
		}
		//if 
		//Process 40 values per thread iteration. Again, this may be a user setting for a future version.
		for (var decodeCount:Number = decodeObj.parseOffset; decodeCount <= decodeLimit; decodeCount = decodeCount + 2) {
			encWord1 = this.netEncToWord (decodeObj.subStr[decodeCount]);
			encWord2 = this.netEncToWord (decodeObj.subStr[decodeCount + 1]);
			decArray = this.decrypt (encWord1, encWord2, decodeObj.key1, decodeObj.key2, decodeObj.key3, decodeObj.key4);
			decodeObj.parseOffset += 2;
			str1 = this.wordToString (decArray[0]);
			str2 = this.wordToString (decArray[1]);
			//trace (str1+str2);
			if (decArray[1] <> 0) {
				decodeObj.decodedString += str1 + str2;
			}
			else {
				decodeObj.decodedString += str1;
			}
			// else
		}
		// for
		this._decodePercent = Math.round ((decodeObj.parseOffset / decodeObj.subStr.length) * 100);
	}
	// asynchDecode
	/**
	 * Method: broadcastError
	 *
	 * Broadcasts an error message via the Error class for all listeners to pick up.
	 *
	 * Parameters:
	 * 	code (number, required) - The numeric error code to broadcast. See the Error class' 'broadcast' method for valid codes.
	 * 	shortMsg (string, optional) - A brief description of the error. See the Error class' 'broadcast' method for preferred format.
	 * 	longMsg (string, optional) - A detailed explanation of the error message. A remedy should be included if possible.
	 *
	 * Returns:
	 * 	Nothing
	 *
	 * See also:
	 * 	<Error>
	 * 	<Error.broadcast>
	 */
	private function broadcastError (code:Number, shortMsg:String, longMsg:String) {
		var errorObj:Object = new Object ();
		errorObj.sender = this;
		errorObj.code = code;
		errorObj.msg = shortMsg;
		errorObj.msgLong = longMsg;
		Error.broadcast (errorObj);
	}
	// broadcastError
	/**
	* Method: setDefaults
	*
	* Creates and sets any default, non-static values for the class.
	*
	* Parameters:
	*	None
	*
	* Returns:
	* 	Nothing
	*
	* See also:
	* <f_TEA>
	*/
	private function setDefaults () {
		this.sum = new Number (0);
		this._encodePercent = new Number (0);
		this._decodePercent = new Number (0);
		this._threadMan = new ThreadManager ({parentClass:this}, false);
	}
	//setDefaults
}
// f_TEA class
