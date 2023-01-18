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



/** Class provides mechanism for supplying a response from an asynchronis process. 

*/

class com.moviemasher.Core.Callback
{
// PUBLIC CLASS METHODS
	
	static function factory(method : String, target, param1, param2) : Callback
	{
		var data = {};
		data.func = method;
		data.ob = target;
		data.param1 = param1;
		data.param2 = param2;
		return new Callback(data);
	}	
	
	
// PUBLIC INSTANCE METHODS
	
	function back(result)
	{
		//_global.com.moviemasher.Control.Debug.msg('back ' + typeof(ob[func]) + ' ' + func);
		return ob[func](result, param1, param2);
	}
	
// PRIVATE INSTANCE PROPERTIES

	private var ob : Object;
	private var func : String;
	private var param1;
	private var param2;
	

// PRIVATE INSTANCE METHODS

	private function Callback(data)
	{
		if (data)
		{
			for (var k in data)
			{
				this[k] = data[k];
			}
		}
	}
}