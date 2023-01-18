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


/** Class handles loading of a single graphic file.
*/

class com.moviemasher.Media.Image extends com.moviemasher.Media.Media
{
		
	private function __frame2URL(n)
	{
		return getValue('url');
	}
	
	private function __time2Frame(atTime : Number, item : Object)
	{
		return 0;
	}

	private function __initConfig() : Void
	{
		config.length = 4;
		config.poster = 0;
	}
	

}