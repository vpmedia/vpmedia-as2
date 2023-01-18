import com.bumpslide.util.ArrayUtil;
import com.bumpslide.util.Debug;

class com.bumpslide.util.StringUtil {


	// trim whitespace from beginning and end of a string 
	static function Trim( s:String ) {		
		var TAB   = 9;
		var LINEFEED = 10;
		var CARRIAGE = 13;
		var SPACE = 32;	
		s = ''+s;	
		var i = 0;
		while(s.charCodeAt(i) == SPACE
		  || s.charCodeAt(i) == CARRIAGE
		  || s.charCodeAt(i) == LINEFEED
		  || s.charCodeAt(i) == TAB) {
		  i++;
		}
	
		var j = s.length - 1;
		while(s.charCodeAt(j) == SPACE
		  || s.charCodeAt(j) == CARRIAGE
		  || s.charCodeAt(j) == LINEFEED
		  || s.charCodeAt(j) == TAB) {
		  j--;
		}
	
		return s.substring(i,j+1);		
	}
	
	static function trim(s:String) { return Trim(s); }	
	
	static function removeExtraWhitespace(s:String) {
		s = s.split("\t").join("");
		var a:Array = s.split("  ");
		var n=0;
		while( a.length ) {
			if(++n>10) break;
			s = a.join(" ");
			a = s.split("  ");
		}
		return s;
	}
	
	//static var ENTITY_CHARS  = ['—','–','&','"',String.fromCharCode(161),String.fromCharCode(162),String.fromCharCode(163),String.fromCharCode(164),String.fromCharCode(165),String.fromCharCode(166),String.fromCharCode(167),String.fromCharCode(168),String.fromCharCode(169),String.fromCharCode(170),String.fromCharCode(171),String.fromCharCode(172),String.fromCharCode(173),String.fromCharCode(173),String.fromCharCode(174),String.fromCharCode(175),String.fromCharCode(176),String.fromCharCode(177),String.fromCharCode(178),String.fromCharCode(179),String.fromCharCode(180),String.fromCharCode(181),String.fromCharCode(182),String.fromCharCode(183),String.fromCharCode(184),String.fromCharCode(185),String.fromCharCode(186),String.fromCharCode(187),String.fromCharCode(188),String.fromCharCode(189),String.fromCharCode(190),String.fromCharCode(191),String.fromCharCode(215),String.fromCharCode(247),String.fromCharCode(192),String.fromCharCode(193),String.fromCharCode(194),String.fromCharCode(195),String.fromCharCode(196),String.fromCharCode(197),String.fromCharCode(198),String.fromCharCode(199),String.fromCharCode(200),String.fromCharCode(201),String.fromCharCode(202),String.fromCharCode(203),String.fromCharCode(204),String.fromCharCode(205),String.fromCharCode(206),String.fromCharCode(207),String.fromCharCode(208),String.fromCharCode(209),String.fromCharCode(210),String.fromCharCode(211),String.fromCharCode(212),String.fromCharCode(213),String.fromCharCode(214),String.fromCharCode(216),String.fromCharCode(217),String.fromCharCode(218),String.fromCharCode(219),String.fromCharCode(220),String.fromCharCode(221),String.fromCharCode(222),String.fromCharCode(223),String.fromCharCode(224),String.fromCharCode(225),String.fromCharCode(226),String.fromCharCode(227),String.fromCharCode(228),String.fromCharCode(229),String.fromCharCode(230),String.fromCharCode(231),String.fromCharCode(232),String.fromCharCode(233),String.fromCharCode(234),String.fromCharCode(235),String.fromCharCode(236),String.fromCharCode(237),String.fromCharCode(238),String.fromCharCode(239),String.fromCharCode(240),String.fromCharCode(241),String.fromCharCode(242),String.fromCharCode(243),String.fromCharCode(244),String.fromCharCode(245),String.fromCharCode(246),String.fromCharCode(248),String.fromCharCode(249),String.fromCharCode(250),String.fromCharCode(251),String.fromCharCode(252),String.fromCharCode(253),String.fromCharCode(254),String.fromCharCode(255),String.fromCharCode(338),String.fromCharCode(339),String.fromCharCode(352),String.fromCharCode(353),String.fromCharCode(376),String.fromCharCode(710),String.fromCharCode(8211),String.fromCharCode(8212),String.fromCharCode(8216),String.fromCharCode(8217),String.fromCharCode(8218),String.fromCharCode(8220),String.fromCharCode(8221),String.fromCharCode(8222),String.fromCharCode(8224),String.fromCharCode(8225),String.fromCharCode(8240),String.fromCharCode(8249),String.fromCharCode(8250),String.fromCharCode(8364),String.fromCharCode(8482)];
	
	static var ENTITY_CODES = [8220,8221,8216,8217,8218,8212,8211,38,34,161,162,163,164,165,166,167,168,169,170,171,172,173,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,215,247,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,248,249,250,251,252,253,254,255,338,339,352,353,376,710,8211,8212,8216,8217,8218,8220,8221,8222,8224,8225,8240,8249,8250,8364,8482];
	static var ENTITY_STRINGS = ['&ldquo;','&rdquo;','&lsquo;','&rsquo;','&sbquo;','&mdash;','&ndash','&amp;','&quot;','&iexcl;','&cent;','&pound;','&curren;','&yen;','&brvbar;','&sect;','&uml;','&copy;','&ordf;','&laquo;','&not;','&shy;','&#173;','&reg;','&macr;','&deg;','&plusmn;','&sup2;','&sup3;','&acute;','&micro;','&para;','&middot;','&cedil;','&sup1;','&ordm;','&raquo;','&frac14;','&frac12;','&frac34;','&iquest;','&times;','&divide;','&Agrave;','&Aacute;','&Acirc;;','&Atilde;','&Auml;','&Aring;','&AElig;','&Ccedil;','&Egrave;','&Eacute;','&Ecirc;','&Euml;','&Igrave;','&Iacute;','&Icirc;','&Iuml;','&ETH;','&Ntilde;','&Ograve;','&Oacute;','&Ocirc;','&Otilde;','&Ouml;','&Oslash;','&Ugrave;','&Uacute;','&Ucirc;','&Uuml;','&Yacute;','&THORN;','&szlig;','&agrave;','&aacute;','&acirc;','&atilde;','&auml;','&aring;','&aelig;','&ccedil;','&egrave;','&eacute;','&ecirc;','&euml;','&igrave;','&iacute;','&icirc;','&iuml;','&eth;','&ntilde;','&ograve;','&oacute;','&ocirc;','&otilde;','&ouml;','&oslash;','&ugrave;','&uacute;','&ucirc;','&uuml;','&yacute;','&thorn;','&yuml;','&#338;','&#339;','&#352;','&#353;','&#376;','&#710;','&#8211;','&#8212;','&#8216;','&#8217;','&#8218;','&#8220;','&#8221;','&#8222;','&#8224;','&#8225;','&#8240;','&#8249;','&#8250;','&#8364;','<sup><small>TM</small></sup>'];

	static function replaceEntities( str : String ) {
		for(var n=0; n<ENTITY_STRINGS.length; ++n) str = str.split(ENTITY_STRINGS[n]).join(String.fromCharCode(ENTITY_CODES[n]));
		return str;	
	}

	static function replaceEmTags( str :String) {		
		return str.split('<em>').join('<i>').split('</em>').join('</i>');		
	}
	
	static function removeLinebreaks( str:String ) {
		return str.split('\r').join('').split('\n').join('');
	}
	
	


// Make text fit by cutting it off and adding ellipsis to the end
static function abbreviate ( origStr:String, maxLength:Number, moreIndicator:String, splitChar:String) : String {

	if(maxLength==null) maxLength = 50;
	if(moreIndicator==null) moreIndicator = '...';
	if(splitChar==null) splitChar = ' ';

	
	if(origStr.length<maxLength) {
		return origStr;
	}

	var str:String = '';
	var n = 0;
	var pieces = origStr.split(splitChar);	// split string into pieces
	var charCount = pieces[n].length;			// running total of char count

	// put pieces back together as long as the charCount doesn't exceed the max length
	while(charCount<maxLength && n<pieces.length) {
		str += pieces[n] + splitChar;					// put the space back as we add the piece to our new string
		charCount += pieces[++n].length + splitChar.length ;	    // increase the character count
	}

	// do extra stuff if we now have an abbreviated string
	if(n<pieces.length) {

		//trace('[StringUtil.abbreviate] Shortened string to '+ str.length + 'chars : '+str);

		// remove any chars from the end that are not letters or numbers
		var badChars = ['-', '—', ',', '.', ' ', ':', '?', '!', ';', newline, ' ', String.fromCharCode(10), String.fromCharCode(13)];
		while( ArrayUtil.in_array( str.charAt(str.length-1), badChars)) {
		  // trace("[StringUtil.abbreviate] Chopping bad char before ellipsis: '"+str.charAt(str.length-1)+"'");
		   str = str.slice(0,-1);
		}
		// add an ellipsis to the end
		str = trim(str) + moreIndicator;
	}
	
	// first word is longer than max length...
	if(n==0) {
		str = origStr.slice(0, maxLength)+moreIndicator;
	}
	
	return str;
}

static function forceMaxWordLength( origStr:String, minLength:Number ) {
	
	if(origStr.length==0) return origStr;
	
	if(minLength==null) minLength=25;
	var str:String = '';	
	var word;
	var n=0;
	var pieces = origStr.split(' ');
	while(n<pieces.length) {		
		word = pieces[n];		
		while(word.length) {			
			str += word.slice(0, minLength) + ' ';
			word = word.slice(minLength);
		}
		++n;		
	}	
	return trim( str );	
	
}


static function isValidEmail (str) {
	var ic = "/*|,\"<>[]+{}`'()&$#%";
	for (var i = 0; i<str.length; i++) {
		if (ic.indexOf(str.charAt(i)) != -1) 	return false;
	}
	if (str.length<6) 							return false;
	if (str.split(".").reverse()[0].length<2) 	return false;
	if (str.split("@").length != 2)	 		return false;
	for (var i = 0; i<ic.length; i++) {
		if (str.substr(0, 1) == (ic.substr(i, 1) || "."))
			return false;
	}
	return true;
};


//	Number.number_format
//	---
//	Author: info@sephiroth.it
//	http://www.sephiroth.it
//	2002-04-20 19:58:42
//	Flash 6
//	-------------------------
//  David Knape Modified this function so that it does proper rounding as it formats
//
//	return a formatted string based on the arguments passed to the function
//
//	var_number.number_format([decimals ,thousand separator,decimal separator]);
//	var number: number to format
//	decimals: how many decimal numbers (default value 0);
//	thousand separator: char that define the thousands (default value ,);
//	decimal separator: char the defines the decimals (default value .);
//	-------------------------

	static function formatNumber(num:Number, decimals:Number, thousandsSeparator:String, decimalSeparator:String) 
	{
				
		var temp_str:String = ""
		var i:Number = 0;

		if(decimals < 0 || decimals == undefined) decimals = 0;
		if(thousandsSeparator == undefined) thousandsSeparator = ',';
		if(decimalSeparator == undefined) decimalSeparator = '.';
		if(num == Number.POSITIVE_INFINITY) return "Infinity";
		if(num == Number.NEGATIVE_INFINITY) return "-Infinity";

		// First Round the number to the right decimal places
		var factor = Math.pow(10, decimals);
		num = Math.round(num*factor)/factor;

		//	convert num to string for formatting
		//  we split it at the decimal point first
		var splat:Array = num.toString().split('.');
		var str_begin:String = splat[0];
		var str_after:String = splat[1]!=undefined ? splat[1] : '';
		
		// Add the thousands separator
		while(i<str_begin.length)
		{			
			temp_str += (i%3==0 && i!=0 ) ?
				thousandsSeparator + str_begin.substr(str_begin.length-i,1) :
				str_begin.substr(str_begin.length-i,1);
			i++;
		}

		// Pad with zeroes if necessary
		while(str_after.length<decimals) str_after += '0';

		//	join the two strings
		i = temp_str.length;
		var returned:String = "";
		while(i>0) {
			returned += temp_str.substr(i,1);
			i--;
		}
		if(decimals>0) {
			return (returned + decimalSeparator + str_after);
		}
		return returned;
	}

	
	
	
}