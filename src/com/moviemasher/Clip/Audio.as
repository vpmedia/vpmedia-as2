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


/** Class representing an instance of an {@link com.moviemasher.Media.Audio} media object.
Audio clips appear in multiple audio timeline tracks, just below the main visual track. 
*/

class com.moviemasher.Clip.Audio extends com.moviemasher.Clip.Clip
{

// PUBLIC INSTANCE PROPERTIES

	function get length() : Number
	{
		return _global.app.fpsTime(__clipLength(media.getValue('loop'), __values));
	}
	
// PUBLIC INSTANCE METHODS

	
	
	function backColor() : String // used to color inspector preview
	{
		return _global.app.options.audio.color;
	}
	
	function hasA() : Boolean { return volumeEnabled; }
	
	function hasV() : Boolean { return false; }
	
	function mediaTime(project_time : Number) : Number 
	{ 
		if (media.getValue('loop')) return super.mediaTime(project_time);
		return ((project_time + __trimTime())); 
	}
	

	function projectTime(media_time)
	{
		return ((media_time - (media.getValue('loop') ? 0 : __trimTime())) + __values.start);
	}
	
	
	function setValue(property : String, n : Number) : Boolean
	{
		
		switch (property)
		{
			case 'loops':
			{
				n = Math.round(n);
				// intentional fallthrough to 'trim'
			}
			case 'trim':
			{
				var new_values = com.moviemasher.Utility.ObjectUtility.copy(__values);
				new_values[property] = n;
				
				var new_length = _global.app.fpsTime(__clipLength(media.getValue('loop'), new_values));
				
				var tracks = __mash.timeRangeTrackItems(new_values.start, new_length, [this], new_values.track, 1, 'audio');
				if (tracks.length) // hit something
				{
					_global.com.moviemasher.Control.Debug.msg('Audio clip trim collision');
					if (property == 'loops')
					{
						n = Math.floor((tracks[0].start - new_values.start) / media.getValue('duration'));
					}
					else n += (new_values.start + new_length) - tracks[0].start;
				}
				break;
			}
		}
		var tf = super.setValue(property, n);
		switch (property)
		{
			case 'track':
			case 'start':
			{
				this[property] = __values[property];
				break;
			}
		}
		return tf;
	}
	
	function timelineEnd() : Number // audio items are never transitioned
	{
		return 0;
	}
	function timelineStart() : Number // audio items are never transitioned
	{
		return 0;
	}
	
// PRIVATE INSTANCE METHODS

	private function Audio()
	{
	}
	
	private function __fromAttributes(attributes : Object) : Void
	{
		super.__fromAttributes(attributes);
		start = __values.start;
		track = __values.track;
	}
	private function __initValues()
	{
		__values.volume = '0,70,100,70';
		__values.length = 4;
		__values.start = 0;
		__values.track = 0;
		if (media.getValue('loop')) __values.loops = 1;
		else __values.trim = '0,0';		
	}
	
	private function __trimTime(trim_end : Boolean) : Number
	{
		return (media.getValue('loop') ? 0 : super.__trimTime(trim_end));

	}	

	
	
}