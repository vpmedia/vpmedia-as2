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


import flash.geom.Point;

/** Class representing an instance of an {@link com.moviemasher.Media.Effect} media object.
Effect clips appear in multiple effect timeline tracks, just above the main visual track. 
*/


class com.moviemasher.Clip.Effect extends com.moviemasher.Clip.Clip
{
	
// PUBLIC INSTANCE METHODS

	function bitmapping(is_done : Boolean)
	{
		
		if ((__trackClip._visible = (! is_done)))
		{
			__trackClip._parent._parent.filterClips.push(__trackClip);

			var id_name = __clipKey();
			
			if (__trackClip.applyMatrix[id_name] || __trackClip.applyTransform[id_name] || __trackClip.applyFilter[id_name])
			{
			
				var matrix_apply;
				var filter_apply;
				var transform_apply;
				var track_value;
				var mash_clip = _global.app.mashClip(__mash);
				var track_name : String;
				var dims = __mash.dimensions;
				var y : Number;
				var target_clip : MovieClip;
				var track_mc : MovieClip;
				var filter_clip;
				for (var i = 0; i <= track; i++)
				{
					track_name = 'track_' + i;
					track_mc = mash_clip[track_name];
					if (! track_mc) continue;
					y = track_mc.filterClips.length;
					if (! y) continue;
					for (var j = 0; j < y; j++)
					{
						filter_clip = track_mc.filterClips[j];
						if (! filter_clip._visible) continue;
						if (! (filter_clip._width && filter_clip._height)) continue;
						matrix_apply = __trackClip.applyMatrix[id_name];
						filter_apply = undefined;
						transform_apply = undefined;
						filter_apply = __trackClip.applyFilter[id_name];
						if (filter_apply)
						{
							target_clip = filter_clip;
							if (filter_apply.mapPoint)
							{
								track_mc.filterApplied = true;
								filter_apply = filter_apply.clone();
							
								var pt;
								if (track_mc.matrixApplied)
								{
									var media_dims = {width: filter_clip.clip.media.width, height: filter_clip.clip.media.height}; 
									var bot_pt = {x: - media_dims.width / 2, y: media_dims.height / 2};
									var right_pt = {x: media_dims.width / 2, y: - media_dims.height / 2};
									pt = {x: - media_dims.width / 2, y: - media_dims.height / 2};
									
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
								pt.y += com.moviemasher.Utility.DrawUtility.offStage;
								filter_apply.mapPoint = pt;
							}
							track_value = target_clip.filters;
							track_value.push(filter_apply);
							target_clip.filters = track_value;
						}
						if (matrix_apply)
						{
							// !! can't get display filter to transform properly :(
							
							track_mc.matrixApplied = true;
							target_clip = filter_clip;
							
							track_value = target_clip.transform.matrix;
							track_value.concat(matrix_apply);
							target_clip.transform.matrix = track_value;
							
							
						}
						if (transform_apply = __trackClip.applyTransform[id_name])
						{
							track_value = filter_clip.transform.colorTransform;
							track_value.concat(transform_apply);
							filter_clip.transform.colorTransform = track_value;
						}
					}		
				}
				
			}
		}
	}
	function needsLoad(project_time : Number, dimensions : Object) : Boolean
	{
		var needs_load_reason = undefined;
		
		var done = Math.min(1, Math.max(0, (project_time - start) / length));
		var apply_status : Object = media.applyEffect(__clipKey(), __values, trackClip, done, dimensions);		
		if (apply_status == undefined) needs_load_reason = 'undefined media.applyEffect';
		else if (! apply_status.loading)
		{
			var d = new Date();
			__lastDisplayTime = d.getTime();
			__activeInstances['id_' + id] = this;
		}
		else needs_load_reason = apply_status.loading;
		
	//	else _global.com.moviemasher.Control.Debug.msg('Effect.needsLoad ' + ' ' + media.getValue('id') + ' ' + apply_status.loading);

		return needs_load_reason;
	}	

	function setValue(property : String, n : Number, dont_send : Boolean) : Boolean
	{
		if (! dont_send)
		{
			switch (property)
			{
				case 'length':
				{
					//n = Math.max(_global.app.options.frametime, _global.app.fpsTime(n));
					var my_start = start;
				
					var tracks = __mash.timeRangeTrackItems(my_start, n, [this], track, 1, 'effect');
					if (tracks.length) // hit something
					{
						n = tracks[0].start - my_start;
						for (var i = 1; i < tracks.length; i++)
						{
							n = Math.min(n, tracks[i].start - my_start);
						
						}
					}
				}
			}
		}
		
		var tf = super.setValue(property, n);
		switch (property)
		{
			case 'track':
			{
				__clearClipBuffer();
				// intentional fallthrough to 'start'
			}
			case 'start':
			{
				this[property] = __values[property];
				break;
			}
		}
		return tf;
	}
	
	
// PRIVATE INSTANCE METHODS

	private function Effect()
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
		__values.length = 4;
		__values.start = 0;
		__values.track = 1;
	}
	
	
	
	function timelineEnd() : Number // effect items are never transitioned
	{
		return 0;
	}
	function timelineStart() : Number // effect items are never transitioned
	{
		return 0;
	}

}
