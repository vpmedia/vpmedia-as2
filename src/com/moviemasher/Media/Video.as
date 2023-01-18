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



/** Class handles loading of sequential graphic files.
*/

class com.moviemasher.Media.Video extends com.moviemasher.Media.Media
{
	
	private function __frame2URL(frame : Number)
	{
		var pattern : String = getValue('pattern');
		var zeropadding : Number =  getValue('zeropadding');
		var begin : Number =  getValue('begin');
		var n : Number = frame * getValue('increment');
		n += begin;
		if (zeropadding) n = _global.com.moviemasher.Utility.StringUtility.strPad(String(n), zeropadding, '0');
		if (pattern.length) n = _global.com.moviemasher.Utility.StringUtility.replace(pattern, '%', n);
		return getValue('url') + n;
	}
	private function __setAttributes()
	{
		if (getValue('audio')) __dataFields.volume = true;
	}
	
	private function __initConfig() : Void
	{
		config.pattern = '%.jpg';
		config.zeropadding = 0;
		config.begin = 1;
		config.increment = 1;
		config.poster = 0;
	}
}