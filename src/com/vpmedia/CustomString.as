/**
 * CustomString
 * Copyright © 2006 András Csizmadia
 * Copyright © 2006 VPmedia
 * http://www.vpmedia.hu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 * 
 * Project: CustomString
 * File: CustomString.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.CustomString extends String implements IFramework {
	// START CLASS
	/**
	 * <p>Description: Decl.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public var className:String = "CustomString";
	public var classPackage:String = "com.vpmedia";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	// constructor
	function CustomString () {
	}
	private static var b64pad:String = new String ("");
	private static var chrsz:Number = new Number (8);
	function purgeHunCharsLowercase (__str:String):String {
		//trace("** purgeHunCharsLowercase **");
		var __resStr = __str.toLowerCase ();
		__resStr = __resStr.split ("ő").join ("o");
		__resStr = __resStr.split ("ö").join ("o");
		__resStr = __resStr.split ("ó").join ("o");
		__resStr = __resStr.split ("é").join ("e");
		__resStr = __resStr.split ("á").join ("a");
		__resStr = __resStr.split ("ű").join ("u");
		__resStr = __resStr.split ("ú").join ("u");
		__resStr = __resStr.split ("ü").join ("u");
		__resStr = __resStr.split ("í").join ("i");
		return (__resStr);
	}
	/**
	  * static public method, trace all public methods with theyr options
	  * @param        String  string to parse
	  * @return       String  parsed string
	  */
	public static function methodsList ():Void {
		trace ("trim( s:String ):String");
		trace ("rtrim( s:String ):String");
		trace ("ltrim( s:String ):String");
		trace ("rpos( s:String, src:String ):Object");
		trace ("ripos( s:String, src:String ):Object");
		trace ("pos( s:String, src:String [, ofs:Number ] ):Object");
		trace ("ipos( s:String, src:String [, ofs:Number ] ):Object");
		trace ("nl2br( s:String ):String");
		trace ("replace( src:String, rpl:String, s:String ):String");
		trace ("ireplace( src:String, rpl:String, s:String ):String");
		trace ("word_count( s:String ):Array");
		trace ("pad( s:String, p:Number [, toAd:String [, t:String ] ] ):String");
		trace ("repeat( s:String, many:Number ):String");
		trace ("addslashes( s:String ):String");
		trace ("stripslashes( s:String ):String");
		trace ("ucfirst( s:String ):String");
		trace ("ucwords( s:String ):String");
		trace ("md5( s:String [, CustomString.b64pad:String [, CustomString.chrsz:Number ] ] ):String");
		trace ("strip_tags( s:String [, allow:Object ] ):String");
		trace ("random(s)");
		trace ("createID(len)");
		trace ("shuffle(s)");
		trace ("convertEntities(s,a)");
		trace ("isEmail2(s)");
		trace ("isEmail()");
		trace ("compareTo(s,a,m)");
		trace ("isLegal(a,p)");
		trace ("parseVars(s)");
		trace ("isEmpty(s)");
		trace ("toArray(t,l,s)");
		trace ("getReversed (s:String)");
		trace ("getReplaced (s, r, w)");
		trace ("beginsWith (t:String, s:String)");
		trace ("endsWith (t:String, s:String)");
		trace ("randomSuffle (s:String)");
		trace ("reverseChars (s:String)");
		trace ("reverseWords (s:String)");
	}
	//
	public static function reverseChars (s:String):String {
		var niceString, j;
		j = s.length - 1;
		while (j >= 0) {
			niceString += s.charAt (j);
			j--;
		}
		return niceString;
	}
	//
	public static function reverseWords (s:String):String {
		var niceString;
		var niceArray = s.split (' ');
		var j = 0;
		while (j < niceArray.length) {
			var k = niceArray[j].length - 1;
			while (k >= 0) {
				niceString += niceArray[j].charAt (k);
				k--;
			}
			if (j < niceArray.length - 1)
			{
				niceString += ' ';
			}
			j++;
		}
		return niceString;
	}
	// Suffles the string and returns the suffled string.
	public static function randomSuffle (s:String) {
		var a = new Array ();
		for (var i = 0; i < s.length; i++)
		{
			a.push (s.substr (i, 1));
		}
		var n = new Array ();
		while (a.length > 0) {
			var r = Math.floor (Math.random () * a.length);
			n.push (a[r]);
			for (var i = r; i < a.length; i++)
			{
				a[i] = a[i + 1];
			}
			a.pop ();
		}
		for (var i = 0; i < n.length; i++)
		{
			a.splice (0, 0, n[i]);
		}
		return a.join ("");
	}
	// Returns true if the string starts with the given string. Or else returns false.
	public static function beginsWith (t:String, s:String) {
		if (s == t.substr (0, s.length))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	// Returns true if the string ends with the given string. Or else returns false.
	public static function endsWith (t:String, s:String) {
		if (s == t.substr (-s.length, s.length))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	// Replaces all [r]'s with [w]'s and returns the string. r = replace / w = with this
	public static function getReplaced (s, r, w) {
		var a = s.split (r);
		s = "";
		for (var i = 0; i < a.length; i++)
		{
			if (i == a.length - 1)
			{
				s += a[i];
			}
			else
			{
				s += a[i] + w;
			}
		}
		return s;
	}
	// Reverses the string and returns it.
	public static function getReversed (s:String) {
		var o:String = "";
		for (var i = 0; i > (-s.length); i--)
		{
			o += s.substr (i - 1, 1);
		}
		return o;
	}
	// Splits the string to an array with the arguments and returns the array.
	public static function toArray (t, l, s:String) {
		var a;
		if (l == null || l == "" || typeof l != "number")
		{
			l = 1;
		}
		else
		{
			l = Math.round (l);
		}
		if (s == null)
		{
			a = new Array ();
			for (var i = 0; i < t.length / l; i++)
			{
				a.push (t.substr (i * l, l));
			}
			return a;
		}
		else
		{
			a = t.split (s);
		}
		return a;
	}
	// Parses the name and value pairs from the string to an array and returns it.
	public static function parseVars (s:String) {
		var i = new Array ();
		var a = s.split ("&");
		for (var j = 0; j < a.length; j++)
		{
			var c = a[j].split ("=");
			i[c[0]] = c[1];
		}
		return i;
	}
	// Checks that is the string empty and returns either true or false.
	public static function isEmpty (s:String) {
		var h = 0;
		for (var i = 0; i < s.length; i++)
		{
			if (s.substr (i, 1) != " " && s.substr (i, 1) != "\t" && s.substr (i, 1) != "\n" && s.substr (i, 1) != "\r")
			{
				h++;
			}
		}
		if (h > 0)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	// Checks that the string is legal with [p]'s. If [p] is empty it will check that the string has only numbers. p = allowed marks in a array. - returns true or false.
	public static function isLegal (s:String, p) {
		var a;
		if (p == null)
		{
			a = new Array ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".");
		}
		else
		{
			a = p;
		}
		var c = 0;
		for (var j = 0; j < s.length; j++)
		{
			for (var i = 0; i < a.length; i++)
			{
				if (s.substr (j, 1) == a[i] || s.substr (j, 1) == a[i].toUpperCase ())
				{
					c++;
				}
			}
		}
		if (c == s.length)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	// Compares the two strings. Method definition : true = percents / false = hits
	public static function compareTo (s, a, m) {
		var j = a;
		var c = 0;
		var p = 0;
		if (s.length != j.length)
		{
			return false;
		}
		for (var i = 0; i < s.length; i++)
		{
			if (s.substr (i, 1) == j.substr (i, 1))
			{
				c++;
			}
		}
		p += Math.round (c / s.length * 100);
		if (!m)
		{
			return c;
		}
		else
		{
			return p;
		}
	}
	// Returns true if the string is a valid email address. Else returns false.
	public static function isEmail2 (s) {
		var ic = "/*|,\":<>[]+{}`';()&$#% ";
		for (var i = 0; i < s.length; i++)
		{
			if (ic.indexOf (s.charAt (i)) != -1)
			{
				return false;
			}
		}
		if (s.split (".").reverse ()[0].length < 2)
		{
			return false;
		}
		if (s.length < 6)
		{
			return false;
		}
		if (s.split ("@").length != 2)
		{
			return false;
		}
		for (var i = 0; i < ic.length; i++)
		{
			if (s.substr (0, 1) == (ic.substr (i, 1) || "."))
			{
				return false;
			}
		}
		return true;
	}
	// Converts the string to/from flash htmlentities and returns it.
	public static function convertEntities (s:String, a:Boolean) {
		var ra;
		var ca;
		if (a)
		{
			ca = new Array ("&", "<", ">", "\"", "'");
			ra = new Array ("&amp;", "&lt;", "&gt;", "&quot;", "&apos;");
		}
		else
		{
			ra = new Array ("&", "<", ">", "\"", "'");
			ca = new Array ("&amp;", "&lt;", "&gt;", "&quot;", "&apos;");
		}
		for (var j = 0; j < ra.length; j++)
		{
			var st = s.split (ra[j]);
			s = "";
			for (var i = 0; i < st.length; i++)
			{
				if (i == st.length - 1)
				{
					s += st[i];
				}
				else
				{
					s += st[i] + ca[j];
				}
			}
		}
		return s;
	}
	// Shuffle our words by kingdavid: www.adora.it - info@adora.it
	/*public static function shuffle (s:String):String {
	var myArray = new Array ();
	for (var i = 0; i < s.length; i++)
	{
	var control = true;
	while (control) {
	var j = int (random (s.length));
	if (myArray[j] == undefined)
	{
	myArray[j] = s.substr (i, 1);
	control = false;
	}
	}
	}
	var str;
	for (var i = 0; i < s.length; i++)
	{
	str += myArray[i];
	}
	return str;
	}*/
	public static function random (s:String):String {
		var _this = s.split ("");
		var str = "";
		for (var c = 0, r; _this.length; )
		{
			str += _this[r = Math.floor (Math.random () * _this.length)];
			_this.splice (r, 1);
		}
		return str;
	}
	/*public static function createID (len:Number):String {
	var d = new Date ();
	var r, hex = d.getTime ().toString ();
	for (var j = hex.length, id = ""; j--; )
	{
	r = Math.floor ((Math.random () * 36)).toString (36);
	if (Math.random () > 0.5)
	{
	r = r.toUpperCase ();
	}
	id += hex.charAt (j) + r;
	}
	id = random (id);
	while (id.length < len) {
	r = Math.floor ((Math.random () * 36)).toString (36);
	id += (Math.random () > 0.5) ? r.toUpperCase () : r;
	}
	while (id.length > len) {
	id = id.substr (0, -1);
	}
	return id;
	}*/
	/**
	        * static public method, remove spaces from right
	        * @param        String  string to parse
	        * @return       String  parsed string
	        */
	public static function rtrim (s:String):String {
		var a:Number = new Number (s.length);
		while (s.substr (a--, 1) == " ") {
		}
		return s.substr (0, (a + 1));
	}
	/**
	        * static public method, remove spaces from left
	        * @param        String  string to parse
	        * @return       String  parsed string
	        */
	public static function ltrim (s:String):String {
		var a:Number = 0;
		while (s.substr (a++, 1) == " ") {
		}
		return s.substr ((a - 1), (s.length));
	}
	/**
	        * static public method, remove spaces from left and right
	        * @param        String  string to parse
	        * @return       String  parsed string
	        */
	public static function trim (s:String):String {
		return com.vpmedia.CustomString.ltrim (CustomString.rtrim (s));
	}
	/**
	        * static private method, called from rpos and ripos
	        * @param        String  string to parse
	        * @param        String  string to search
	        * @param        Boolean sensitive or insensitive case [ false / true ]
	        * @return       Object  Boolean false value if no match or Number position
	        */
	private static function __rpos (s:String, src:String, ci:Boolean):Object {
		var found:Boolean = new Boolean (false);
		var position:Number = new Number ();
		if (ci == true)
		{
			s = s.toUpperCase ();
			src = src.toUpperCase ();
		}
		for (var a:Number = s.length - 1; a >= 0; a--)
		{
			if (s.substr (a, src.length) == src)
			{
				found = true;
				position = a;
				break;
			}
		}
		if (found == true)
		{
			return position;
		}
		return found;
	}
	/**
	        * static public method, found last position of a string
	        * @param        String  string to parse
	        * @param        String  string to search
	        * @return       Object  Boolean false value if no match or Number position
	        */
	public static function rpos (s:String, src:String):Object {
		return com.vpmedia.CustomString.__rpos (s, src, false);
	}
	/**
	        * static public method, found last position of a string in case insensitive mode
	        * @param        String  string to parse
	        * @param        String  string to search
	        * @return       Object  Boolean false value if no match or Number position
	        */
	public static function ripos (s:String, src:String):Object {
		return com.vpmedia.CustomString.__rpos (s, src, true);
	}
	/**
	        * static private method, called from pos and ipos
	        * @param        String  string to parse
	        * @param        String  string to search
	        * @param        Number  offset of occurrence
	        * @param        Boolean sensitive or insensitive case [ false / true ]
	        * @return       Object  Boolean false value if no match or Number position
	        */
	private static function __pos (s:String, src:String, ofs:Number, ci:Boolean):Object {
		var found:Boolean = new Boolean (false);
		var position:Number = new Number ();
		var foundOfs:Number = 0;
		ofs = ofs == undefined ? 0 : ofs;
		if (ci == true)
		{
			s = s.toUpperCase ();
			src = src.toUpperCase ();
		}
		for (var a:Number = 0; a < s.length; a++)
		{
			if (s.substr (a, src.length) == src)
			{
				if (foundOfs == ofs)
				{
					found = true;
					position = a;
					break;
				}
				foundOfs++;
			}
		}
		if (found == true)
		{
			return position;
		}
		return found;
	}
	/**
	        * static public method, found first position of a string
	        * @param        String  string to parse
	        * @param        String  string to search
	        * @return       Object  Boolean false value if no match or Number position
	        */
	public static function pos (s:String, src:String, ofs:Number):Object {
		return com.vpmedia.CustomString.__pos (s, src, ofs, false);
	}
	/**
	        * static public method, found first position of a string in case insensitive mode
	        * @param        String  string to parse
	        * @param        String  string to search
	        * @return       Object  Boolean false value if no match or Number position
	        */
	public static function ipos (s:String, src:String, ofs:Number):Object {
		return com.vpmedia.CustomString.__pos (s, src, ofs, true);
	}
	/**
	        * static public method, remove \n & \r and add <br />
	        * @param        String  string to parse
	        * @return       String  parsed string
	        */
	public static function nl2br (s:String):String {
		var a:String = "<br />";
		return s.split ("\n").join (a).split ("\r").join (a).split (a + a).join (a);
	}
	/**
	        * static public method, replace a string with new value
	        * @param        String  string to search
	        * @param        String  string to replace
	        * @param        String  string to parse
	        * @return       String  parsed string
	        */
	public static function replace (src:String, rpl:String, s:String):String {
		return s.split (src).join (rpl);
	}
	/**
	        * static public method, replace a string with new value in case insensitive mode
	        * @param        String  string to search
	        * @param        String  string to replace
	        * @param        String  string to parse
	        * @return       String  parsed string
	        */
	public static function ireplace (src:String, rpl:String, s:String):String {
		var sClone:String = s.toUpperCase ();
		var srcClone:String = src.toUpperCase ();
		var remPosition:Array = new Array ();
		for (var a:Number = 0; a < (sClone.length - src.length + 2); a++)
		{
			if (sClone.substr (a, src.length) == srcClone)
			{
				remPosition.push (a);
			}
		}
		for (var a:Number = 0; a < remPosition.length; a++)
		{
			s = s.substr (0, remPosition[a]) + rpl + s.substr (remPosition[a] + src.length, s.length);
		}
		return s;
	}
	/**
	        * static public method, count all words in a string
	        * @param        String  string to parse
	        * @return       Array   array with all words
	        */
	public static function word_count (s:String):Array {
		var tWords:Array = new Array ();
		var sNew:Array = s.split (" ");
		for (var a:Number = 0; a < sNew.length; a++)
		{
			var nowS:String = com.vpmedia.CustomString.trim (sNew[a]);
			if (nowS != "")
			{
				tWords.push (sNew[a]);
			}
		}
		return tWords;
	}
	/**
	        * static public method, add something to a string
	        * @param        String  string to parse
	        * @param        Number  max length to add chosed string
	        * @param        String  string to empty spasces less than p:Number
	        * @param        String  type of parsing ( "PAD_RIGHT", "PAD_LEFT", "PAD_BOTH" ) default "PAD_RIGHT"
	        * @return       String  parsed string
	        */
	public static function pad (s:String, p:Number, toAd:String, t:String):String {
		if (s.length < p)
		{
			t = t == undefined ? "PAD_RIGHT" : t.toUpperCase ();
			toAd = toAd == undefined ? " " : toAd;
			if ((toAd.length + s.length) > p)
			{
				toAd = toAd.substr (0, (p - s.length));
			}
			var repeated:String = com.vpmedia.CustomString.repeat (toAd, Math.ceil (p / toAd.length));
			if (t == "PAD_RIGHT")
			{
				s = s + repeated.substr (s.length, p);
			}
			else if (t == "PAD_LEFT")
			{
				s = repeated.substr (0, (repeated.length - s.length)) + s;
			}
			else if (t == "PAD_BOTH")
			{
				var toStart:Number = repeated.length - Math.ceil (repeated.length / 2) - Math.ceil (s.length / 2);
				var toEnd:Number = toStart + s.length;
				s = repeated.substr (0, toStart) + s + repeated.substr (toEnd, p);
			}
		}
		return s.substr (0, p);
	}
	/**
	        * static public method, repeat a string for many times
	        * @param        String  string to parse
	        * @param        Number  how many times to repeat
	        * @return       String  parsed string
	        */
	public static function repeat (s:String, many:Number):String {
		var sNew:String = new String ("");
		for (var a:Number = 0; a < many; a++)
		{
			sNew += s;
		}
		return sNew;
	}
	/**
	        * static public method, add slashes in a string
	        * @param        String  string to parse
	        * @return       String  parsed string
	        */
	public static function addslashes (s:String):String {
		return s.split ('"').join ('\\"').split ("'").join ("\\'");
	}
	/**
	        * static public method, remove slashes in a string
	        * @param        String  string to parse
	        * @return       String  parsed string
	        */
	public static function stripslashes (s:String):String {
		return s.split ('\\').join ('');
	}
	/**
	        * static public method, change to upper case first char of a string
	        * @param        String  string to parse
	        * @return       String  parsed string
	        */
	public static function ucfirst (s:String):String {
		return s.substr (0, 1).toUpperCase () + s.substr (1, s.length);
	}
	/**
	        * static public method, switch to Upper Case all words in a string
	        * @param        String  string to parse
	        * @return       String  parsed string
	        */
	public static function ucwords (s:String):String {
		var sNew:Array = s.split (" ");
		for (var a:Number = 0; a < sNew.length; a++)
		{
			sNew[a] = com.vpmedia.CustomString.ucfirst (sNew[a]);
		}
		return sNew.join (" ");
	}
	/** EXPERIMENTAL ::
	        * static public method, remove html tags from a string
	        * @param        String  string to parse
	        * @param        Object  string or array tags to leave
	        * @return       String  parsed string
	        */
	/*public static function strip_tags (s:String, allow:Object):String {
	var allowable:Array;
	if (typeof (allow) == "string")
	{
	allowable = new Array (allow);
	}
	else if (typeof (allow) == "array")
	{
	allowable = Array (allow);
	}
	if (allowable.length != undefined)
	{
	var newAllowable:Array = new Array ();
	for (var a:Number = 0; a < allowable.length; a++)
	{
	var closeTag:String = "</" + allowable[a].substr (1, allowable[a].length);
	newAllowable.push (closeTag);
	}
	allowable = allowable.concat (newAllowable);
	}
	var in_array:Function = function (who:Array, what:String):Object {
	// andr3a [ 25 / 03 / 2004 ]
	// riadapted on 08/07/2004
	// check if a value is inside an array
	// EXAMPLE:
	//      var myArray = new Array( "hello", "world", Array("one", "two") );
	//      trace( myArray.in_array( "hello" ) ); // true
	//      trace( myArray.in_array( "hi" ) ); // false
	//      trace( myArray.in_array( "two" ) ); // true
	for (var a = 0; a < who.length; a++)
	{
	if (who[a] == what)
	{
	return true;
	}
	else if (who[a] instanceof Array)
	{
	return in_array (who[a], what);
	}
	}
	return false;
	};
	var removeTags:Function = function (s:String, allowable:Array, allow:Object):String {
	var sNew:Array = s.split ("<");
	var modified:Boolean = new Boolean (false);
	for (var a:Number = 0; a < sNew.length; a++)
	{
	if (CustomString.pos (sNew[a], ">") !== false)
	{
	var htmlTag:String = "<" + sNew[a].substr (0, com.vpmedia.CustomString.pos (sNew[a], ">")) + ">";
	if (htmlTag != "<>")
	{
	if ((allowable.length != undefined && in_array (allowable, htmlTag) == false) || allow == undefined)
	{
	sNew[a] = sNew[a].substr (CustomString.pos (sNew[a], ">") + 1, sNew[a].length);
	modified = true;
	}
	else
	{
	sNew[a] = "<" + sNew[a];
	}
	}
	}
	}
	s = sNew.join ("");
	if (modified == true)
	{
	return removeTags (s, allowable, allow);
	}
	return s;
	};
	return removeTags (s, allowable, allow);
	}*/
	
	public function isEmail ():Boolean {
		var ref = arguments.callee;
		if (this.indexOf ("@") == -1)
		{
			return false;
		}
		if (!isNaN (this.charAt (0)))
		{
			return false;
		}
		var email, user, domain, user_dots, domain_dots;
		if ((email = this.split ("@")).length == 2)
		{
			if ((domain = email[1]).split (".").pop ().length > 3)
			{
				return false;
			}
			if ((user = email[0]).indexOf (".") && domain.indexOf ("."))
			{
				if (domain.lastIndexOf (".") > domain.length - 3)
				{
					return false;
				}
				for (var c, t, i = (user_dots = user.split (".")).length; i--; )
				{
					c = user_dots[i];
					t = !ref.$_text.call (c, "-", ".", "_");
					if (t || !isNaN (c))
					{
						return false;
					}
				}
				for (var c, t, i = (domain_dots = domain.split (".")).length; i--; )
				{
					c = domain_dots[i];
					t = !ref.$_text.call (c, "-", ".");
					if (t || !isNaN (c))
					{
						return false;
					}
				}
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
		return true;
	}
	private function $_punctuation ():Boolean {
		if (this == "")
		{
			return false;
		}
		for (var i = arguments.length; i--; )
		{
			if (this.indexOf (arguments[i]) == 0)
			{
				return false;
			}
			if (this.indexOf (arguments[i]) == this.length - 1)
			{
				return false;
			}
		}
		return true;
	}
	private function i$_text ():Boolean {
		var ref = arguments.caller;
		if (!ref.$_punctuation.apply (this, arguments))
		{
			return false;
		}
		var others = arguments;
		var checkOthers = function (str) {
			for (var i = others.length; i--; )
			{
				if (str == others[i])
				{
					return true;
				}
			}
			return false;
		};
		for (var c, alpha, num, i = this.length; i--; )
		{
			c = this.charAt (i).toLowerCase ();
			alpha = (c <= "z") && (c >= "a");
			num = (c <= "9") && (c >= "0");
			if (!alpha && !num && !checkOthers (c))
			{
				return false;
			}
		}
		return true;
	}
	/*
	
	
	public static function count (s:String):Array
	{
	var result = new Array ();
	var found = false;
	for (var r = 0; r < s.length; r++)
	{
	for (var t = 0; t <= result.length; t++)
	{
	if (result[t].char == s.charAt (r))
	{
	result[t].val++;
	found = true;
	break;
	}
	}
	if (!found)
	{
	result.push ({char:s.charAt (r), val:1});
	}
	found = false;
	}
	return result;
	}
	
	public static function wordCount (s:String):Object
	{
	var niceArray, tot, obj, a;
	obj = {};
	niceArray = s.split (' ');
	obj.totalWords = niceArray.length;
	obj.charsWithSpaces = s.length;
	for (a = 0; a < niceArray.length; a++)
	{
	tot += niceArray[a].length;
	}
	obj.charsWithoutSpaces = tot;
	return obj;
	}
	
	
	public static function ucFirst (s:String):String
	{
	return s.substring (0, 1).toUpperCase () + s.substring (1, s.length);
	}
	public static function ucWords (t:String):String
	{
	var Tstring;
	var s:Array = t.split (' ');
	for (var a = 0; a < s.length; a++)
	{
	Tstring += s[a].substring (0, 1).toUpperCase () + s[a].substring (1, s[a].length) + ' ';
	}
	return Tstring;
	}
	public static function trimAll (t:String, p:String)
	{
	var s = "";
	if (p == null)
	{
	p = " ";
	}
	if (t.substr (0, 1) == p)
	{
	s = t.substr (1, t.length);
	}
	else
	{
	return t;
	}
	if (s.substr (-1, 1) == p)
	{
	s = s.substr (0, s.length - 1);
	}
	return s;
	}
	public static function toUpper (s:String)
	{
	var a = s.split (".");
	if (a[a.length - 1] == null || a[a.length - 1] == "")
	{
	a.pop ();
	}
	var s = "";
	for (var i = 0; i < a.length; i++)
	{
	if (a[i].substr (0, 1) != " ")
	{
	s += a[i].substr (0, 1).toUpperCase () + a[i].substr (1) + ". ";
	}
	else
	{
	s += a[i].substr (1, 1).toUpperCase () + a[i].substr (2) + ". ";
	}
	}
	return s;
	}
	
	*/
	/**
	 * <p>Description: Get Class version</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getVersion ():String {
		//trace ("%%" + "getVersion" + "%%");
		var __version = this.version;
		return __version;
	}
	/**
	 * <p>Description: Get Class name</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function toString ():String {
		return ("[" + className + "]");
	}
	// END CLASS
	// END CLASS
}
