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

/** Transition module displays clips on a rotating cube.
*/
class com.moviemasher.Module.Cube extends com.moviemasher.Module.Module
{

	
	function applyTransition(key : String, values: Object, left_item : Object, right_item : Object, mc : MovieClip, done : Number, dimensions : Object) : Object
	{
		var apply_status = {loading: false, changed: true};
		var direction = ((values.direction == undefined) ? ((config.direction == undefined) ? 0 : config.direction) : values.direction);
		var bm_width = dimensions.width / 2;
		var bm_height = dimensions.height / 2;

		var left_x_scale : Number = 1;
		var left_x_translate : Number = 0;
		var right_x_scale : Number = 1;
		var right_x_translate : Number = 0;
		var left_y_scale : Number = 1;
		var left_y_translate : Number = 0;
		var right_y_scale : Number = 1;
		var right_y_translate : Number = 0;
		
		var left_matrix = new Matrix();
		var right_matrix = new Matrix();
		
		var mask_name = 'mask_' + config.id;
		if (! mc[mask_name]) mc.createEmptyMovieClip(mask_name, mc.getNextHighestDepth());
		else mc[mask_name].clear();
		
		var frame = {x: - bm_width, y: - bm_height, w: dimensions.width, h: dimensions.height};
		
		var not_done : Number = 1 - done;
		switch (direction)
		{
			case 0: // LEFT
			{
				left_matrix.scale(not_done, 1);
				left_matrix.translate(bm_width * done, 0);
				right_matrix.scale(done, 1);
				right_matrix.translate(- bm_width * not_done, 0);
				frame.w *= done;
				break;	
			}
			case 1: // RIGHT
			{
				left_matrix.scale(not_done, 1);
				left_matrix.translate(- bm_width * done, 0);
				right_matrix.scale(done, 1);
				right_matrix.translate(bm_width * not_done, 0);
				frame.w *= done;
				frame.x += dimensions.width * not_done;

				break;	
			}
			case 2: // TOP
			{
				left_matrix.scale(1, not_done);
				left_matrix.translate(0, bm_height * done);
				right_matrix.scale(1, done);
				right_matrix.translate(0, - bm_height * not_done);
				frame.h *= done;
				break;	
			}
			case 3: // BOTTOM
			{
				left_matrix.scale(1, not_done);
				left_matrix.translate(0, - bm_height * done);
				right_matrix.scale(1,done);
				right_matrix.translate(0, bm_height * not_done);
				frame.h *= done;
				frame.y += dimensions.height * not_done;
				
				break;	
			}
		}
	
		left_item.trackClip.applyMatrix[key] = left_matrix;
		right_item.trackClip.applyMatrix[key] = right_matrix;
		
		var tl = right_matrix.transformPoint({x: - bm_width, y: - bm_height});
		var br = right_matrix.transformPoint({x: bm_width, y: bm_height});
		
		_global.com.moviemasher.Utility.DrawUtility.plot(mc[mask_name], frame.x, frame.y, frame.w, frame.h, 0xFFFF00);
		right_item.trackClip.applyMask[key] = mc;
		
	
		return apply_status;
			
	}

	
	private function Cube()
	{
	
	}
	
}