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


import flash.display.BitmapData;

/** Class handles loading of waveform graphic.
See {@com.moviemasher.Control.Player} for loading of actual audio files.
*/

class com.moviemasher.Media.Audio extends com.moviemasher.Media.Media
{
	
	private function Audio()
	{

	}
	
	
	private function __setAttributes()
	{
		if (getValue('loop')) __dataFields.loops = true;
		else __dataFields.trim = true;
	}
	
	private function __loadFrame(frame : Number) : BitmapData
	{
		if (! __frameBitmaps[0])
		{
			var bm = waveformBitmap;
			if (bm) __frameBitmaps[0] = bm;
		}
		return __frameBitmaps[0];
	}
	
	private function __initConfig() : Void
	{
		config.loop = 0;
	}

}