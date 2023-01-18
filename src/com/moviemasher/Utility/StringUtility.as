/*
* The contents of this file are subject to the Mozilla Public
* License Version 1.1 (the "License"); you may not use this
* file except in compliance with the License. You may obtain a
* copy of the License at http://www.mozilla.org/MPL/
* 
* Software distributed under the License is distributed on an
* "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express
* or implied. See the License for the specific language
* governing rights and limitations under the License.
* 
* The Original Code is 'Movie Masher'. The Initial Developer
* of the Original Code is Doug Anarino. Portions created by
* Doug Anarino are Copyright (C) 2007 Syntropo.com, Inc. All
* Rights Reserved.
*/


/** Static class provides simple string manipulation functions.
*/

class com.moviemasher.Utility.StringUtility
{
	
	static function homeFromURL(url_string : String) : String
	{
		var a = url_string.split('/');
		a = a.slice(0, 3);
		return a.join('/');
	
	}
	
	
	// http://www.example.com => www.example.com
		
	static function hostFromURL(url_string : String) : String
	{
		var a = url_string.split('/');
		return a[2];
	}
	
	static function timeString(n : Number) : String
	{
		if (n == undefined) n = 0;
		var s : String = '.' + String(Math.round((n % 1) * 10));
		var seconds = Math.floor(n);
		if (seconds)
		{
			if (seconds < 60) s = seconds + s;
			else
			{
				s = String(seconds % 60) + s;
				seconds = Math.floor(seconds / 60);
				if (seconds < 60) s = seconds + ':' + s;
				else
				{
					s = String(seconds % 60) + ':' + s;
					seconds = Math.floor(seconds / 60);
					if (seconds < 60) s = seconds + ':' + s;
					else
					{
						s = String(Math.round(seconds / 60)) + ':' + s;
					}
				}
			}
		}
		else s = '0' + s;
		return s;
	}
	
	static function pathFromURL(url_string : String) : String
	{
		var a = url_string.split('?');
		a = a[0];
		a = a.split('/');
		a.pop();
		return a.join('/') + '/' ;
	
	}
	
	static function repeat(str : String, n : Number) : String
	{
		str = String(str);
		if (! (str.length && n)) return '';
		var rs = '';
		for (var i = 0; i < n; i++)
		{
			rs += str;
		}
		return rs;
	}
	static function replace(str : String, neadle : String, replacer : String) : String
	{
		if (! str.length) return '';
		var pos2 = str.indexOf(neadle);
		if (pos2 < 0) return str;
		var pos1 = 0;
		var rs = '';
		
		while (pos2 > -1)
		{
			rs += str.substr(pos1, pos2 - pos1);
			rs += replacer;
			pos1 = pos2 + neadle.length;
			pos2 = str.indexOf(neadle, pos1);
			
		}
		rs += str.substr(pos1, str.length - pos1);
		return (rs);
	}
	static function safeKey(str : String) : String
	{
		// does not strip out '#'
		return 'id_' + replace(replace(replace(replace(replace(replace(replace(replace(str, '.', '_'), '/', '_'), ':', ''), ' ', '_'), '?', ''), '=', ''), '&', ''), ',', '');
	}
	
	
	static function strPad(input : String, pad_length : Number, pad_string : String) : String
	{
		input = String(input);
		if (pad_string == undefined) pad_string = ' ';
		if ((pad_length - input.length) > 0) input = repeat(pad_string, pad_length - input.length) + input;
		return input;
	}
	
	static function ucwords(str : String) : String
	{
	   var Tstring = '';
	   var this_a = str.split(' ');
	   for(var a = 0; a < this_a.length; a++)
	   {
		  this_a[a] = this_a[a].substring(0,1).toUpperCase() + this_a[a].substring(1, this_a[a].length);
	   }
	   return this_a.join(' ');
	}
	
}