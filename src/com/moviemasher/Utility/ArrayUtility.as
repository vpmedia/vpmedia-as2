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


/** Static class provides simple array utility functions.
*/
class com.moviemasher.Utility.ArrayUtility
{
	static function arrayIndex(val, a)
	{
		
		var z = a.length;
							
		for (var i = 0; i < z; i++)
		{
			if (val == a[i]) return i;
		}
		return undefined;
	}
	
	static function copy(a1)
	{
		var a2 = [];
		for (var k = 0; k < a1.length; k++)
		{ 
			a2[k] = a1[k]; 
		}
		return a2;
	}
	static function equals(a1, a2)
	{
		var z = a1.length;
		for (var i = 0; i < z; i++)
		{ 
			if (typeof(a1[i]) == 'object') // it can only be an array
			{
				if (! equals(a1[i], a2[i])) return false;
			}
			else if (a1[i] != a2[i]) return false;
		}
		return true;
	}


	
	static function indexOf(a, val, aKey)
	{
		
		var z = a.length;
							
		for (var i = 0; i < z; i++)
		{
			if (aKey.length) 
			{
				if (a[i][aKey] == val) return i;	
			}
			else if (val == a[i]) return i;
		}
		return -1;
	}
	
	
	static function sum(a, aKey)
	{
		
		var z = a.length;
		var n = 0;		
		for (var i = 0; i < z; i++)
		{
			if (aKey.length) 
			{
				n += a[i][aKey];	
			}
			else n += a[i];
		}
		return n;
	}
	
	
}