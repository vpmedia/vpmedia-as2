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


/** Class representing an instance of a {@link com.moviemasher.Media.Video} media object.
Video clips appear within the main visual timeline track, between Audio and Effect tracks.

*/
class com.moviemasher.Clip.Video extends com.moviemasher.Clip.Clip
{

// PUBLIC INSTANCE PROPERTIES	

	function get length() : Number
	{
		return _global.app.fpsTime(__values.speed * __clipLength(false, __values));
	}

// PUBLIC INSTANCE METHODS
	
	function hasA() : Boolean { return ((__values.speed == 1) ? (media.getValue('audio') ? volumeEnabled : false) : false); }

	function mediaTime(project_time : Number) : Number { return ((project_time  / __values.speed) + __trimTime()); }

	function projectTime(media_time)
	{
		return ((media_time - __trimTime()) + start);
	}
	


// PRIVATE INSTANCE METHODS
	
	private function Video()
	{
	}
	
	private function __initValues()
	{
		__values.volume = '0,70,100,70';
		__values.speed = 1;
		__values.trim = '0,0';
		
	}

}

	