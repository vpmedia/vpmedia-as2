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


import flash.geom.Matrix;
import flash.geom.ColorTransform;
import flash.display.BitmapData;

/** Transition module simply fades second clip over first.
*/
class com.moviemasher.Module.Crossfade extends com.moviemasher.Module.Module
{

	function applyTransition(key : String, values : Object, left_item : Object, right_item : Object, mc : MovieClip, done : Number, dimensions : Object) : Object
	{
		var apply_status = {loading: false, changed: true};
	
		var transform = new ColorTransform();
		transform.alphaMultiplier = done;
		right_item.trackClip.applyTransform[key] = transform;
		
		return apply_status;
	}
	
	private function Crossfade()
	{
	
	}
	
}