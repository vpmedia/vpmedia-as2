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



/** Class representing an instance of a {@link com.moviemasher.Media.Theme} media object.
Theme clips appear within the main visual timeline track, between Audio and Effect tracks.
*/

class com.moviemasher.Clip.Theme extends com.moviemasher.Clip.Clip
{

// PUBLIC INSTANCE METHODS

	function backColor() : String
	{
		return media.backColor(__values);
	}
	
// PRIVATE INSTANCE METHODS
	
	private function Theme()
	{
	
	}

	private function __initValues()
	{
		__values.length = 8;
	}

}
