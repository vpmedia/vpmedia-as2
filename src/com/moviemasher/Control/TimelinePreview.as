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


import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.display.BitmapData;

/** MovieClip symbol used by {@link com.moviemasher.Control.Timeline} control to render {@link com.moviemasher.Clip.Clip} objects.

*/

class com.moviemasher.Control.TimelinePreview extends MovieClip
{


// PUBLIC INSTANCE PROPERTIES

	var height : Number = 0;
	function get item() : Object { return __item; }
	function set item(new_clip : Object) // this is called twice, once with a clip then with undefined just before disposal
	{
		if (__item != new_clip)
		{
			if (__item != undefined) __removeItem();
			__item = new_clip;
			if (__item != undefined) __addItem();
		}
	}
	var target : com.moviemasher.Control.Timeline;

	var width : Number = 0;
	

// PUBLIC INSTANCE METHODS	
	
	

	function action(evt) // only transition clips listen to action messages
	{
		switch(evt.target)
		{
			case _global.app:
			{
				drawPreview();	
				break;
			}
		}
	}
	
	
	
	function change(evt)
	{
		switch (evt.target)
		{
			case __item:
			{
				
				drawPreview();
				break;
			}
		}
	}

	function draw(new_metrics)
	{
		__metrics = _global.com.moviemasher.Utility.ObjectUtility.copy(new_metrics);
		
		_y = __metrics.y;
		_x = __metrics.x;
		width = __metrics.width;
		height = __metrics.height;
		
		__back_mc._x = __metrics.starttrans;
		__frames_mask_mc._x = __metrics.starttrans + __metrics.previewinset;
		__frames_mask_mc._y = __frames_mc._y = __metrics.previewinset;
		__frames_mc._x = Math.max(__frames_mask_mc._x, __metrics.leftcrop);
		
		if (__waveform_mc) 
		{
			__waveform_mc._y = (((__metrics.mode == 'time') && __isMultitrack()) ? target.typeHeight('video') : 0);
		}
		__drawBack();
		//drawPreview();
	}
	
	
	function drawPreview() : Boolean
	{
		var had_a_prob = false;
		if (__metrics.mode == 'time') 
		{
			if (__item.hasA())//__waveform_mc._visible = 
			{
				if (! __waveWidth)
				{
					var bm = __item.media.waveformBitmap;
					if (bm)
					{
						__waveform_mc.pic_mc.attachBitmap(bm, 100);
						__waveWidth = __waveform_mc.pic_mc._width;
						__waveHeight = __waveform_mc.pic_mc._height;
					}
				}
				if (__waveWidth) __adjustWaveform();
				else had_a_prob = true;
			}
		}
		if (! had_a_prob) had_a_prob = __drawAdvancedFrame();
		return had_a_prob;
	}
	
	function selectedChange(evt)
	{
		switch (evt.target)
		{
			case __item:
			{
				//if (__item.index == 0) _global.app.msg('selectedChange ' + __metrics.endtrans);
				__drawBack();
				break;
			}	
		}
	}

	
 	
// PRIVATE INSTANCE PROPERTIES
	
	private var __back_mc : MovieClip; // background for whole clip (will be rounded edge if possible)
	private var __frames_mc : MovieClip; // holds clip graphic
	private var __frames_mask_mc : MovieClip; // holds clip graphic
	private var __highestFrameClip : Number = -1;
	private var __item : Object;
	private var __waveform_mc : MovieClip; // background for whole clip (will be rounded edge if possible)
	private var __waveHeight : Number = 0;
	private var __waveWidth : Number = 0;
	private var __metrics : Object;
	
// PRIVATE INSTANCE METHODS
	
	private function TimelinePreview()
	{
		
	}

	private function __addItem()
	{
		__item.addEventListener('selectedChange', this);
		createEmptyMovieClip('__back_mc', getNextHighestDepth());
		__back_mc.onRollOver = function() { this._parent.__doRollOver(); };
		__back_mc.onRollOut = function() { this._parent.__doRollOut(); };
		__back_mc.onPress = function() { this._parent.__doPress(); };
		__back_mc.onReleaseOutside = function() { this._parent.__doReleaseOutside(); };
		__back_mc.onRelease = function() { this._parent.__doRelease(); };
		__back_mc.useHandCursor = false;

		if (__item.type != 'audio') __createFrame();
		if (target.mode == 'time')
		{
			switch (__item.type)
			{
				case 'image':
				case 'effect': break;
				default: __createWaveform();
			}
		}
		if (__item.type == 'transition') _global.app.addEventListener('action', this);

	}

	private function __adjustWaveform()
	{
		var audio_height = target.typeHeight('audio');

		__waveform_mc.pic_mc._x = __metrics.leftcrop;
		
		var bm : BitmapData = new BitmapData(__metrics.widthcrop, audio_height, true, 0x00FF0000);
		var matrix = new Matrix();
		var media_pixels : Number;
		var translate : Number = 0;
		var media_duration = __item.media.getValue('duration');
		
		var item_trimstart = __item.__trimTime();
		
		/*
		__item.getValue('trim');
		item_trimstart = item_trimstart.split(',');
		item_trimstart = parseFloat(item_trimstart[0]);
		item_trimstart = (media_duration * item_trimstart) / 100;
		
		if (! item_trimstart) item_trimstart = 0;
		*/
		media_pixels = target.time2Pixels(media_duration);
		matrix.scale(media_pixels / __waveWidth, audio_height / __waveHeight);
		
		if (item_trimstart) translate -= target.time2Pixels(item_trimstart - __item.start, 'round') + target.time2Pixels(__item.start, 'round'); // remove trimming
		translate -= __metrics.leftcrop;// remove cropping
//		if (translate) _global.app.msg('translate = ' + translate);
		
		matrix.translate(translate, 0);
		var wbm = __item.media.waveformBitmap;
		var ct = new ColorTransform();
		bm.draw(wbm, matrix, ct, 'normal', undefined, true);
		if ((__item.type == 'audio') && (__item.media.getValue('loop')))
		{
			var z = __item.getValue('loops');
			//_global.com.moviemasher.Control.Debug.msg('loops ' + z + ' pixels ' + media_pixels);
			for (var i = 1; i < z; i++)
			{
				matrix.translate(media_pixels, 0);
				bm.draw(wbm, matrix, ct, 'normal', undefined, true);
			}
		}
		__waveform_mc.pic_mc.attachBitmap(bm, 100);
	}

	private function __backColor(selected : Boolean, type: String)
	{
		var over = (selected ? 'over' : '');
		var c;
		var grad : Number;
		var angle : Number;
		
		c = _global.app.options[type][over + 'color'];
		if (c == undefined) c = _global.app.options[type].color;
		c = _global.com.moviemasher.Utility.DrawUtility.hexColor(c);
		grad = _global.app.options[type][over + 'grad'];
		if (grad == undefined) grad = _global.app.options[type].grad;
		if (grad)
		{
			angle = _global.app.options[type][over + 'angle'];
			if (angle == undefined) angle = _global.app.options[type].angle;
			
			c = _global.com.moviemasher.Utility.DrawUtility.buffedFill(width, height, c, grad, angle);
		}
		return c;
	}
	
	private function __createFrame()
	{
		// PICTURE HOLDER
		
		createEmptyMovieClip('__frames_mc', getNextHighestDepth());
		__frames_mc.blendMode = target.getValue('previewmode');
		createEmptyMovieClip('__frames_mask_mc', getNextHighestDepth());
		__frames_mc.setMask(__frames_mask_mc);
		//if (__waveform_mc) __waveform_mc.setMask(__frames_mask_mc);
	//	_global.com.moviemasher.Utility.DrawUtility.fill(__frames_mask_mc, 1, 1, 0x000000, 50);
	
	}
	
	private function __createWaveform()
	{
		//WAVEFORM
		createEmptyMovieClip('__waveform_mc', getNextHighestDepth());
		__waveform_mc.createEmptyMovieClip('pic_mc', __waveform_mc.getNextHighestDepth());
	
	}
	
	private function __doPress()
	{
		if (_global.app.dragging) return;
		//_global.com.moviemasher.Control.Debug.msg('__doPress');
//		_global.app.msg('start = ' + __item.start + ' length = ' + __item.length + ' padStart = ' + __item.padStart + ' padEnd = ' + __item.padEnd);
		target.pressedClip(__item, this, __isWithinHandle(__back_mc._xmouse));
		
	}	
	
	private function __doRelease()
	{
		if (_global.app.dragging) return;
		//_global.com.moviemasher.Control.Debug.msg('__doRelease');
		__doRollOver();
	}
	private function __doReleaseOutside()
	{
		if (_global.app.dragging) return;
		//_global.com.moviemasher.Control.Debug.msg('__doReleaseOutside');
		__doRollOut();
	}
	
	private function __doRollOut()
	{
		if (_global.app.dragging) return;
		//_global.com.moviemasher.Control.Debug.msg('__doRollOut');
		target.setCursor();
		__back_mc.onMouseMove = undefined;
	}
	
	private function __doRollOver()
	{
		if (_global.app.dragging) return;
		
		var cursor : Number;// undefined
		
		if (__back_mc.hitTest(_root._xmouse, _root._ymouse))
		{
			cursor = __isWithinHandle(__back_mc._xmouse);
		}
		//_global.com.moviemasher.Control.Debug.msg('__doRollOver ' + cursor);
		
		target.setCursor(cursor);
		__back_mc.onMouseMove = function() { this._parent.__doRollOver(); };
	}
	
	
	
		
	private function __drawAdvancedFrame() : Boolean
	{
		//_global.com.moviemasher.Control.Debug.msg('__drawAdvancedFrame');
			
		var had_a_prob : Boolean = false;
		
		if ((__item.type != 'audio') && __frames_mask_mc._width)
		{
			var dims = __item.mash.dimensions;
			
			var content_height = height - (2 * __metrics.previewinset);	
			
			var content_dims = {width: Math.round(content_height * (dims.width / dims.height)), height: content_height};
			var bm = __item.media.posterBitmap(content_dims.width, content_dims.height);
			if ((! bm) && (bm != undefined)) // false means grab from mash
			{
				var clip_time = (__item.length - (__item.timelineStart() + __item.timelineEnd()));
				if (__item.type == 'transition') clip_time = clip_time / 2;
				else clip_time = (clip_time * target.getValue('previewoffset')) / 100;
				
				bm = __item.mash.time2Bitmap(__item.start + __item.timelineStart() + clip_time, content_dims.width, content_dims.height, __item.getValue('track'));
			}
			if (bm)
			{
				if (! __frames_mc.bm_mc) __frames_mc.createEmptyMovieClip('bm_mc', __frames_mc.getNextHighestDepth());
				__frames_mc.bm_mc.attachBitmap(bm, 101);
			}
			else had_a_prob = true;
		
		}
		else if (__frames_mc.bm_mc) __frames_mc.bm_mc.removeMovieClip();
		return had_a_prob;
	}
			/*
			var frame = 0;
			var cur_time = __item.start + __item.timelineStart();
			var first_time = __firstVisibleTime();
			var start_x_pos = target.time2Pixels(cur_time - first_time);
			var x_pos = start_x_pos;
			var buf = target.getValue('hspace');
				var first_time_pixels = target.time2Pixels(first_time);
				
				cur_time = 0;
			
				while ((x_pos < (content_width )))//+ target.trackWidth
				{
					clip_name = 'clip' + frame;
					
					if (! __bitmapCache[clip_name])
					{
						
						cur_time = Math[cur_time ? 'floor' : 'ceil'](target.pixels2Time(x_pos + first_time_pixels) * _global.app.options.video.fps) / _global.app.options.video.fps;
						if (__item.mash) 
						{
							_global.com.moviemasher.Control.Debug.msg('TimelinePreview calling time2Bitmap ' + cur_time);
							bm = __item.mash.time2Bitmap(cur_time, target.trackWidth, target.trackHeight, __item.getValue('track'));
							
						}
						if (bm) __bitmapCache[clip_name] = bm;
						
					}
					if (! __bitmapCache[clip_name]) found_all = false;
					frame ++;
					x_pos += buf + target.trackWidth;
				}
				
			}
			if (found_all)
			{
				//frame ++;
				_global.com.moviemasher.Control.Debug.msg('FOUND ALL ' + frame);
				x_pos = start_x_pos;
				for (var i = 0; i < frame; i++)
				{
					clip_name = 'clip' + i;
					if (i > __highestFrameClip)
					{
						__highestFrameClip++;
						__frames_mc.createEmptyMovieClip(clip_name, __frames_mc.getNextHighestDepth());
					}
					__frames_mc[clip_name]._x = x_pos;
					__frames_mc[clip_name].attachBitmap(__bitmapCache[clip_name], 101);
					x_pos += buf + target.trackWidth;
				}
				while (__highestFrameClip >= frame)
				{
					clip_name = 'clip' + __highestFrameClip;
					__highestFrameClip --;
					__frames_mc[clip_name].removeMovieClip();
				}
			}
			*/
	
	private function __drawBack()
	{
		
		__back_mc.clear()
		__frames_mask_mc.clear()
		
		var c;
		
		var is_selected = Boolean(__item.getValue('selected'));
		
		var back_width = width - (__metrics.starttrans + __metrics.endtrans);
		//if (__item.index == 0) _global.app.msg('__drawBack ' + __metrics.endtrans);
		var points : Array;
		points = _global.com.moviemasher.Utility.DrawUtility.points(0, 0, back_width, height, __metrics.curve);
		
		c = __backColor(is_selected, __item.type);
		
		_global.com.moviemasher.Utility.DrawUtility.setFill(__back_mc, c);
		_global.com.moviemasher.Utility.DrawUtility.drawFill(__back_mc, points);
		
		if ((__metrics.mode == 'time') && __isMultitrack())
		{
			c = __backColor(is_selected, 'audio');
			c.y = height;
			c.height = target.typeHeight('audio');
			points = _global.com.moviemasher.Utility.DrawUtility.points(0, c.y, back_width, c.height, __metrics.curve);
			//points = __timePoints(0, c.y);
			_global.com.moviemasher.Utility.DrawUtility.setFill(__back_mc, c);
			_global.com.moviemasher.Utility.DrawUtility.drawFill(__back_mc, points);
		}
		back_width -= (2 * __metrics.previewinset);
		if (back_width >= 1)
		{
			points = _global.com.moviemasher.Utility.DrawUtility.points(0, 0, back_width, height - (2 * __metrics.previewinset), __metrics.previewcurve);
			_global.com.moviemasher.Utility.DrawUtility.setFill(__frames_mask_mc, 0x000000);
			_global.com.moviemasher.Utility.DrawUtility.drawFill(__frames_mask_mc, points);
		}
		
	}
	
	/*

	private function __firstVisibleTime() : Number // returns mash time of first frame visible in view
 	{
 		
 		var start_time = __item.start;
 		if (__metrics.mode == 'time')
 		{
 			start_time += __item.timelineStart();
 		}
 		if (__item.mash) start_time = Math.max(start_time, target.firstVisibleTime());
 		return start_time;
 		
 	}
 	*/
	
	private function __isMultitrack() : Boolean 
	{ 
		var is_multitrack = false;
		switch(__item.type)
		{
			case 'video': 
			{
				is_multitrack = __item.hasA();
				break;
			}
			case 'transition': // THIS REQUIRES THAT TRANSITIONS NOT BE ADJASCENT TO EACH OTHER!!!
			{
				if (! ((__item.getValue('freezestart') && __item.getValue('freezeend')))) 
				{
					var index = -1;
					if (__item.mash) index = _global.com.moviemasher.Utility.ArrayUtility.indexOf(__item.mash.tracks.video, __item);
					if (index > -1)
					{
						if (index && __item.mash.tracks.video[index - 1].hasA()) is_multitrack = true;
						else if ((index < __item.mash.tracks.video.length) && __item.mash.tracks.video[index + 1].hasA()) is_multitrack = true;
					}
				}
				break;
			}
		}
		return is_multitrack; 
	}
	
	private function __isWithinHandle(x_pos : Number) : Number 
	{ 
		var is_within : Number = 0;
		if (__metrics.mode == 'time')
		{
			if (! ((__item.type == 'audio') && (__item.media.getValue('loop'))))
			{
				var handle_width = target.getValue('handlewidth');
				handle_width = Math.round(Math.min(handle_width, width / 4));
				if (handle_width)
				{
					if (x_pos < handle_width) is_within = -1;
					else if (x_pos > (__back_mc._width - handle_width)) is_within = 1;
				}
			}
		}
		return is_within;
	}
	/*
 	private function __lastVisibleTime() : Number // returns mash time of last frame visible in view
 	{
 		var end_time = __item.start + __item.length;
 		if (__metrics.mode == 'time')
 		{
 			end_time -= __item.timelineEnd();
 		}
 		if (__item.mash) end_time = Math.min(end_time, target.lastVisibleTime());
 		return end_time;
 	
 	}
*/
	private function __removeItem()
	{
		//__item.media.removeEventListener('waveformLoaded', this); // in case i was loading the waveform
		__item.removeEventListener('selectedChange', this);
		if (__item.type == 'transition') _global.app.removeEventListener('action', this);
	}
	
	/*
	

	private function __timePoints(x_pos, y_pos): Array
	{
		if (! x_pos) x_pos = 0;
		if (! y_pos) y_pos = 0;
		
		var points = [];
		var w_val = Math.max(1, width);
		var curve = Math.min(__metrics.curve, Math.round(w_val / 2));
		var h_val = (y_pos ? target.typeHeight('audio', true) : height);
		
		var last_item_time = __item.start + item.length - __item.timelineEnd();
		var first_visible_time = (__item.mash ? target.firstVisibleTime() : 0);
		var last_visible_time = (__item.mash ? target.lastVisibleTime() : last_item_time);
		
		if (((__item.start + __item.timelineStart()) < first_visible_time))
		{
			points.push({x: x_pos, y: y_pos + h_val});
			points.push({x: x_pos, y: y_pos});
		}
		else
		{
			points.push({x: x_pos + curve, y: y_pos + h_val});
			points.push({x: x_pos, y: y_pos + h_val - curve, type: 'curve'});
			points.push({x: x_pos, y: y_pos + curve});
			points.push({x: x_pos + curve, y: y_pos, type: 'curve'});
		}
		if ((last_item_time > last_visible_time))
		{
			points.push({x: x_pos + w_val, y: y_pos});
			points.push({x: x_pos + w_val, y: y_pos + h_val});			
		}
		else
		{
			points.push({x: x_pos + w_val - curve, y: y_pos});
			points.push({x: x_pos + w_val, y: y_pos + curve, type: 'curve'});			
			points.push({x: x_pos + w_val, y: y_pos + h_val - curve});
			points.push({x: x_pos + w_val - curve, y: y_pos + h_val, type: 'curve'});
		}
		return points;
	}
	*/
	
	
}