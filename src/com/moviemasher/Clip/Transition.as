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

/** Class representing an instance of a {@link com.moviemasher.Media.Transition} media object.
Transition clips appear within the main visual timeline track, between Audio and Effect tracks.

*/


class com.moviemasher.Clip.Transition extends com.moviemasher.Clip.Clip
{

// PUBLIC INSTANCE METHODS

	function bitmapping(is_done : Boolean, leftclip : com.moviemasher.Clip.Clip, rightclip: com.moviemasher.Clip.Clip)
	{
		
		if ((__trackClip._visible = (! is_done)))
		{
			if (leftclip.trackClip.depth > rightclip.trackClip.depth)
			{
				var depth = leftclip.trackClip.depth;
				leftclip.trackClip.depth = rightclip.trackClip.depth;
				rightclip.trackClip.depth = depth;
				rightclip.trackClip._parent.swapDepths(leftclip.trackClip._parent);
			}
			var track_mc = __trackClip._parent._parent;
			var id_name = __clipKey();
			var filter_clip;
			var matrix_apply;
			var filter_apply;
			var transform_apply;
			var track_value;
			var target_clip : MovieClip;
			var dims = __mash.dimensions;
			
			var clips = [];
			if (leftclip) clips.push(leftclip);
			if (rightclip) clips.push(rightclip);
			
			var y : Number = clips.length;
			if (y)
			{
				for (var j = 0; j < y; j++)
				{
					filter_clip = clips[j].trackClip;
					if (! filter_clip._visible) continue;
					matrix_apply = filter_clip.applyMatrix[id_name];
					transform_apply = undefined;
					filter_apply = filter_clip.applyFilter[id_name];
					if (filter_apply)
					{
						target_clip = filter_clip;
						if (filter_apply.mapPoint)
						{
							filter_apply = filter_apply.clone();
						
							var pt;
							if (track_mc.matrixApplied)
							{
								var bot_pt = {x: - dims.width / 2, y: dims.height / 2};
								var right_pt = {x: dims.width / 2, y: - dims.height / 2};
								pt = {x: - dims.width / 2, y: - dims.height / 2};
								
								bot_pt = target_clip.transform.matrix.transformPoint(bot_pt);
								right_pt = target_clip.transform.matrix.transformPoint(right_pt);
								pt = target_clip.transform.matrix.transformPoint(pt);
								
								pt.x = Math.min(bot_pt.x, pt.x);
								pt.y = Math.min(right_pt.y, pt.y);
								pt = {x: (-pt.x) - (dims.width / 2), y: (-pt.y) - (dims.height / 2)};
							}
							else
							{
								var bounds = target_clip.transform.pixelBounds;
								pt = {x: (-bounds.x) - (dims.width / 2), y: (-bounds.y) - (dims.height / 2)};
							}
							filter_apply.mapPoint = pt;
						}
						track_value = target_clip.filters;
						track_value.push(filter_apply);
						target_clip.filters = track_value;
					}
					if (matrix_apply)
					{
						track_mc.matrixApplied = true;
						track_value = filter_clip.transform.matrix;
						track_value.concat(matrix_apply);
						filter_clip.transform.matrix = track_value;
					}
					if (transform_apply = filter_clip.applyTransform[id_name])
					{
						track_value = filter_clip.transform.colorTransform;
						track_value.concat(transform_apply);
						filter_clip.transform.colorTransform = track_value;
					}
					if (transform_apply = filter_clip.applyMask[id_name])
					{
						//_global.com.moviemasher.Control.Debug.msg('mask ' + id_name);
						filter_clip._parent.setMask(transform_apply);
					}
					//else filter_clip._parent.setMask(null);
				}
			}
		}
		else 
		{
			leftclip.trackClip._parent.setMask(null);
			rightclip.trackClip._parent.setMask(null);
		}
	}
	function needsLoad(project_time : Number, size : Object, leftclip : com.moviemasher.Clip.Clip, rightclip: com.moviemasher.Clip.Clip) : Boolean
	{
		var done = Math.min(1, Math.max(0, (project_time - start) / length));
		var apply_status = media.applyTransition(__clipKey(), __values, leftclip, rightclip, trackClip, done, size);		
		if (apply_status == undefined) apply_status = {loading: 1};
		
		if (! apply_status.loading)
		{
			var d = new Date();
			__lastDisplayTime = d.getTime();
			__activeInstances['id_' + id] = this;
		}
	//	else _global.com.moviemasher.Control.Debug.msg('Transition.needsLoad ' + media.getValue('id') + ' ' + apply_status.loading);

		return apply_status.loading;
	}	

	function timelineEnd() : Number // transition items are never transitioned
	{
		return 0;
	}
	function timelineStart() : Number // transition items are never transitioned
	{
		return 0;
	}

	
	
// PRIVATE INSTANCE METHODS

	private function Transition()
	{
	
	}
	
	private function __initValues()
	{
		__values.length = 2;
		__values.freezestart = 0;
		__values.freezeend = 0;
	}
}			
