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



/** Abstract base class for all effects, themes and transitions.
*/
class com.moviemasher.Module.Module extends MovieClip
{

	var media : Object; // Media.Base object that is using this module
	var config : Object; // its control tag attributes, plus object arrays at each childNode.nodeName

	var className = 'Module';

	private function Module()
	{
	
	}
	
	private function copyValues(values: Object, keys : Array, values1 : Object, values2 : Object, values3 : Object) : Object
	{
		if (values == undefined) values = {};
		var z = keys.length;
		var k : String;
		for (var i = 0; i < z; i++)
		{
			k = keys[i];
			values[k] = copyValue(k, values1, values2, values3);	
		}
		return values;
	}
	
	
	private function copyValue(property : String, values1 : Object, values2 : Object, values3 : Object) : String
	{
		return ((values1[property] == undefined) ? ((values2[property] == undefined) ? values3[property] : values2[property]) : values1[property]);
	
	}
	
	 
}