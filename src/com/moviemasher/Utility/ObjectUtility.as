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


/** Static class provides simple hash utility functions.
*/
class com.moviemasher.Utility.ObjectUtility
{
	
	static function copy(a1, a2)  : Object
	{
		if (a2 == undefined) a2 = {};
		for (var k in a1)
		{ 
			a2[k] = a1[k]; 
		}
		return a2;
	}
	static function copyKeys(a1, copy_keys) : Object
	{
		var a2 = {};
	
		var z = copy_keys.length;
		var k;
		for (var i = 0; i < z; i++)
		{
			k = copy_keys[i];
			a2[k] = a1[k]; 
		}
		return a2;
	}
	
	static function equals(a1, a2) : Boolean
	{
		if (a1 == a2) return true; // same object
		for (var k in a1)
		{ 
			if (typeof(a1[k]) == 'object') // it can only be an array
			{
				if (! com.moviemasher.Utility.ArrayUtility.equals(a1[k], a2[k])) return false;
			}
			else if (a1[k] != a2[k]) return false;
		}
		return true;
	}
	
	static function keys(a1) : Array
	{
		var a2 = [];
		for (var k in a1)
		{ 
			a2.push(k); 
		}
		return a2;
	}
	static function values(a1) : Array
	{
		var a2 = [];
		for (var k in a1)
		{ 
			a2.push(a1[k]); 
		}
		return a2;
	}
	

}