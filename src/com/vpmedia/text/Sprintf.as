/*
USAGE:
Sprintf.format(format, [args...])
implementation of c-style string formatting
Sprintf.trace(format, [args...])
shortcut to trace a formatted string

ERRORS:
By default all errors are silently ignored (since that's what makes sense to me).
To see error messages in trace output, use this line:
Sprintf.TRACE = true;
To see error messages in the result output, use this line:
Sprintf.DEBUG = true;

*/
class com.vpmedia.text.Sprintf
{
	// -=-=-=-=-=-=-=-=-=-=-=-=-=-
	// "constants"
	// -=-=-=-=-=-=-=-=-=-=-=-=-=-
	static var kPAD_ZEROES = 0x01;
	static var kLEFT_ALIGN = 0x02;
	static var kSHOW_SIGN = 0x04;
	static var kPAD_POS = 0x08;
	static var kALT_FORM = 0x10;
	static var kLONG_VALUE = 0x20;
	static var kUSE_SEPARATOR = 0x40;
	static var DEBUG:Boolean = false;
	static var TRACE:Boolean = false;
	static function trace ():Void
	{
		trace (Sprintf.format.apply (null, arguments));
	}
	static function format (format:String):String
	{
		if (format == null)
		{
			return '';
		}
		var destString = '';
		var argIndex = 0;
		// our place in arguments[] 
		var formatIndex = 0;
		// our place in the format string
		var percentIndex;
		// the location of the next '%' delimiter
		var ch;
		// -=-=-=-=-=-=-=-=-=-=-=-=-=- vars for dealing with each field
		var value, length, precision;
		var properties;
		// options: left justified, zero padding, etc...
		var fieldCount;
		// tracks number of sections in field 
		var fieldOutcome;
		// when set to true, field parsed successfully
		// when set to a string, error resulted
		while (formatIndex < format.length)
		{
			percentIndex = format.indexOf ('%', formatIndex);
			if (percentIndex == -1)
			{
				destString += format.substr (formatIndex);
				formatIndex = format.length;
			}
			else
			{
				destString += format.substring (formatIndex, percentIndex);
				fieldOutcome = '** sprintf: invalid format at ' + argIndex + ' **';
				length = properties = fieldCount = 0;
				precision = -1;
				formatIndex = percentIndex + 1;
				value = arguments[++argIndex];
				while (fieldOutcome != true && (formatIndex < format.length))
				{
					ch = format.charAt (formatIndex++);
					switch (ch)
					{
						// -=-=-=-=-=-=-=-=-=-=-=-=-=-
						// pre-processing items
						// -=-=-=-=-=-=-=-=-=-=-=-=-=-
					case '#' :
						if (fieldCount == 0)
						{
							properties |= kALT_FORM;
						}
						else
						{
							fieldOutcome = '** sprintf: "#" came too late **';
						}
						break;
					case '-' :
						if (fieldCount == 0)
						{
							properties |= kLEFT_ALIGN;
						}
						else
						{
							fieldOutcome = '** sprintf: "-" came too late **';
						}
						break;
					case '+' :
						if (fieldCount == 0)
						{
							properties |= kSHOW_SIGN;
						}
						else
						{
							fieldOutcome = '** sprintf: "+" came too late **';
						}
						break;
					case ' ' :
						if (fieldCount == 0)
						{
							properties |= kPAD_POS;
						}
						else
						{
							fieldOutcome = '** sprintf: " " came too late **';
						}
						break;
					case '.' :
						if (fieldCount < 2)
						{
							fieldCount = 2;
							precision = 0;
						}
						else
						{
							fieldOutcome = '** sprintf: "." came too late **';
						}
						break;
						/*
						case 'h': 
						if (fieldCount < 3) {
						fieldCount = 3;
						} else {
						fieldOutcome = '** sprintf: must have only one of h,l,L **';
						}
						break;
						case 'l':
						case 'L': 
						if (fieldCount < 3) {
						fieldCount = 3;
						properties |= kLONG_VALUE;
						} else {
						fieldOutcome = '** sprintf: must have only one of h,l,L **';
						}
						break;
						*/
					case '0' :
						if (fieldCount == 0)
						{
							properties |= kPAD_ZEROES;
							break;
						}
					case '1' :
					case '2' :
					case '3' :
					case '4' :
					case '5' :
					case '6' :
					case '7' :
					case '8' :
					case '9' :
						if (fieldCount == 3)
						{
							fieldOutcome = '** sprintf: shouldn\'t have a digit after h,l,L **';
						}
						else if (fieldCount < 2)
						{
							fieldCount = 1;
							length = (length * 10) + Number (ch);
						}
						else
						{
							precision = (precision * 10) + Number (ch);
						}
						break;
						// -=-=-=-=-=-=-=-=-=-=-=-=-=-
						// conversion specifiers
						// -=-=-=-=-=-=-=-=-=-=-=-=-=-
					case 'd' :
					case 'i' :
						fieldOutcome = true;
						destString += Sprintf.formatD (value, properties, length, precision);
						break;
					case 'o' :
						fieldOutcome = true;
						destString += Sprintf.formatO (value, properties, length, precision);
						break;
					case 'x' :
					case 'X' :
						fieldOutcome = true;
						destString += Sprintf.formatX (value, properties, length, precision, (ch == 'X'));
						break;
					case 'e' :
					case 'E' :
						fieldOutcome = true;
						destString += Sprintf.formatE (value, properties, length, precision, (ch == 'E'));
						break;
					case 'f' :
						fieldOutcome = true;
						destString += Sprintf.formatF (value, properties, length, precision);
						break;
					case 'g' :
					case 'G' :
						fieldOutcome = true;
						destString += Sprintf.formatG (value, properties, length, precision, (ch == 'G'));
						break;
					case 'c' :
					case 'C' :
						precision = 1;
					case 's' :
					case 'S' :
						fieldOutcome = true;
						destString += Sprintf.formatS (value, properties, length, precision);
						break;
					case '%' :
						fieldOutcome = true;
						destString += '%';
						// we don't need a value for this, so back up
						argIndex--;
						break;
					default :
						fieldOutcome = '** sprintf: ' + ch + ' not supported **';
						break;
					}
				}
				if (fieldOutcome != true)
				{
					if (Sprintf.DEBUG)
					{
						destString += fieldOutcome;
					}
					if (Sprintf.TRACE)
					{
						trace (fieldOutcome);
					}
				}
			}
		}
		return destString;
	}
	// -=-=-=-=-=-=-=-=-=-=-=-=-=-
	// formatting functions
	// -=-=-=-=-=-=-=-=-=-=-=-=-=-
	static function finish (output, value, properties, length, precision, prefix)
	{
		if (prefix == null)
		{
			prefix = '';
		}
		// add sign to prefix 
		if (value < 0)
		{
			prefix = '-' + prefix;
		}
		else if (properties & kSHOW_SIGN)
		{
			prefix = '+' + prefix;
		}
		else if (properties & kPAD_POS)
		{
			prefix = ' ' + prefix;
		}
		if ((length == 0) && (precision > -1))
		{
			length = precision;
			properties |= kPAD_ZEROES;
		}
		// add padding 
		while (output.length + prefix.length < length)
		{
			if (properties & kLEFT_ALIGN)
			{
				output = output + ' ';
			}
			else if (properties & kPAD_ZEROES)
			{
				output = '0' + output;
			}
			else
			{
				prefix = ' ' + prefix;
			}
		}
		return prefix + output;
	}
	// integer
	static function formatD (value, properties, length, precision)
	{
		var output = '';
		value = Number (value);
		if ((precision != 0) || (value != 0))
		{
			output = String (Math.floor (Math.abs (value)));
		}
		while (output.length < precision)
		{
			output = '0' + output;
		}
		return Sprintf.finish (output, value, properties, length, precision);
	}
	// octal
	static function formatO (value, properties, length, precision)
	{
		var output = '';
		var prefix = '';
		value = Number (value);
		if ((precision != 0) && (value != 0))
		{
			output = value.toString (8);
		}
		if (properties & kALT_FORM)
		{
			prefix = '0';
		}
		while (output.length < precision)
		{
			output = '0' + output;
		}
		return Sprintf.finish (output, value, properties, length, precision, prefix);
	}
	// hexidecimal
	static function formatX (value, properties, length, precision, upper)
	{
		var output = '';
		var prefix = '';
		value = Number (value);
		if ((precision != 0) && (value != 0))
		{
			output = value.toString (16);
		}
		if (properties & kALT_FORM)
		{
			prefix = '0x';
		}
		while (output.length < precision)
		{
			output = '0' + output;
		}
		if (upper)
		{
			prefix = prefix.toUpperCase ();
			output = output.toUpperCase ();
		}
		else
		{
			output = output.toLowerCase ();
			// Flash documentation isn't clear about what case the Number.toString() method uses
		}
		return Sprintf.finish (output, value, properties, length, precision, prefix);
	}
	// scientific notation
	static function formatE (value, properties, length, precision, upper)
	{
		var output = '';
		var expCount = 0;
		value = Number (value);
		if (Math.abs (value) > 1)
		{
			while (Math.abs (value) > 10)
			{
				value /= 10;
				expCount++;
			}
		}
		else
		{
			while (Math.abs (value) < 1)
			{
				value *= 10;
				expCount--;
			}
		}
		expCount = Sprintf.format ('%c%+.2d', (upper ? 'E' : 'e'), expCount);
		if (properties & kLEFT_ALIGN)
		{
			// give small length
			output = Sprintf.formatF (value, properties, 1, precision) + expCount;
			while (output.length < length)
			{
				output += ' ';
			}
		}
		else
		{
			output = Sprintf.formatF (value, properties, Math.max (length - expCount.length, 0), precision) + expCount;
		}
		return output;
	}
	// float (or real)
	static function formatF (value, properties, length, precision)
	{
		var output:String = '';
		var intPortion:String = '';
		var decPortion:String = '';
		// unspecified precision defaults to 6
		if (precision == -1)
		{
			precision = 6;
		}
		value = new String (value);
		if (value.indexOf ('.') == -1)
		{
			intPortion = (Math.abs (Number (value))).toString ();
			decPortion = "0";
		}
		else
		{
			intPortion = (Math.abs (Number (value.substring (0, value.indexOf ('.'))))).toString ();
			decPortion = value.substr (value.indexOf ('.') + 1);
		}
		// create decimal portion
		if (Number (decPortion) == 0)
		{
			decPortion = new String ();
			while (decPortion.length < precision)
			{
				decPortion += '0';
			}
		}
		else
		{
			if (decPortion.length > precision)
			{
				var dec = Math.round (Math.pow (10, precision) * Number ('0.' + decPortion));
				if (((String (dec)).length > precision) && (dec != 0))
				{
					decPortion = '0';
					intPortion = ((Math.abs (Number (intPortion)) + 1) * (Number (intPortion) >= 0 ? 1 : -1)).toString ();
				}
				else
				{
					decPortion = new String (dec);
				}
			}
			if (decPortion.length < precision)
			{
				decPortion = new String (decPortion);
				while (decPortion.length < precision)
				{
					decPortion += '0';
				}
			}
		}
		// combine pieces
		if (precision == 0)
		{
			output = intPortion;
			if (properties & kALT_FORM)
			{
				output += '.';
			}
		}
		else
		{
			output = intPortion + '.' + decPortion;
		}
		return Sprintf.finish (output, value, properties, length, precision, '');
	}
	// shorter of float or scientific
	static function formatG (value, properties, length, precision, upper)
	{
		// use 1 as the length for the test because the 
		// padded value will be the same -> not useful
		var out1 = Sprintf.formatE (value, properties, 1, precision, upper);
		var out2 = Sprintf.formatF (value, properties, 1, precision);
		if (out1.length < out2.length)
		{
			return Sprintf.formatE (value, properties, length, precision, upper);
		}
		else
		{
			return Sprintf.formatF (value, properties, length, precision);
		}
	}
	// string
	static function formatS (value, properties, length, precision)
	{
		var output = new String (value);
		if ((precision > 0) && (precision < output.length))
		{
			output = output.substring (0, precision);
		}
		// ignore unneeded flags 
		properties &= ~(kPAD_ZEROES | kSHOW_SIGN | kPAD_POS | kALT_FORM);
		return Sprintf.finish (output, value, properties, length, precision, '');
	}
}
