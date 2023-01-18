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
import flash.geom.Matrix;

/** MovieClip symbol used by {@link com.moviemasher.Control.Browser} control to render {@link com.moviemasher.Media.Media} objects.

*/


class com.moviemasher.Control.BrowserPreview extends MovieClip
{

// PUBLIC CLASS METHODS

	static function createClip(clips_mc : MovieClip, media_ob : Object, config: Object, target: com.moviemasher.Control.Browser, w : Number, h : Number) : MovieClip
	{
		var media_ob_name = 'id_' + media_ob.getValue('id');
		clips_mc.attachMovie('BrowserPreview', media_ob_name, clips_mc.getNextHighestDepth());
		var mc = clips_mc[media_ob_name];
		mc.__type = media_ob.getValue('type');
		mc.__target = target;
		mc.__config = config;
		if (w && h) mc.setSize(w, h);
		mc.__item = _global.com.moviemasher.Clip.Clip.fromMediaID(media_ob.getValue('id'));
		
		var label = media_ob.getValue('label'); 
		if (mc.__label_mc._visible = mc.__label_back_mc._visible = Boolean(label.length)) mc.__label_mc.text = label;
		return mc;
	}

	
// PUBLIC INSTANCE PROPERTIES	
	
	function get height() : Number { return __height; }
	function get item() : Object { return __item; }
	function get width() : Number { return __width; }
	


// PUBLIC INSTANCE METHODS	

	function clearPreview() : Void
	{
		
		if (__mash) __mash.clearBuffer();
		if (__previewBitmap) __previewBitmap.dispose();
		__disposeClip(this);
		
	}
	
	function drawPreview() : Boolean // returns true if bitmap couldn't be generated
	{
		var bm = __previewBitmap;
		if (bm) // see if it needs to be cleared
		{
			switch (__type)
			{
				case 'audio':
				case 'image':break;
				//case 'video': 
				default: 
				{
					bm = undefined;
				}	
			
			}
		}
		if (! bm) bm = __generateBitmap(__type);
		var did_draw = Boolean(bm);
		if (did_draw) 
		{
			if (__previewBitmap != bm)
			{
				if (__previewBitmap) __previewBitmap.dispose();
				__previewBitmap = bm;
				__bm_mc.attachBitmap(__previewBitmap, 1);
				
			}
		}
		//else _global.com.moviemasher.Control.Debug.msg('nope');
		return ! did_draw;
	}

	
	function onPress()
	{
		__target.pressedClip(__item, this);
	}
	
	function setSize(in_x, in_y)
	{
		__width = in_x;
		__height = in_y;
		size();
	}
	
	function size() : Void
	{
		if (! (width && height)) return;
		__iconWidth = width - (2 * __config.frameborder);
		if (! __bm_mc) __createChildren();
		var half_w = width / 2;
		var half_h = height / 2;
		var border_y = - half_h;
		var border_h = height;
		__back_mc._x = - half_w;
		__bm_mc._x = (- half_w) + __config.frameborder;
		if (__config.textsize)
		{
			var text_height = __label_mc.textHeight + 4;
			var label_y : Number = border_y + __config.frameborder;
			var label_w : Number = __iconWidth;
			var label_x : Number = (- half_w) + __config.frameborder;
			switch(__config.textvalign)
			{
				case 'below':
				{
					border_h -= text_height;
					label_y += border_h - __config.frameborder;
					label_x -= __config.frameborder;
					label_w = width;
					break;
				}
				case 'above':
				{
					label_x -= __config.frameborder;
					label_w = width;
					label_y = border_y;
					border_h -= text_height;
					border_y += text_height;
					break;
				}
				case 'bottom':
				{
					label_y += border_h - ((2 * __config.frameborder) + text_height);
					break;
				}
				case 'middle':
				case 'center':
				{
					label_y = - text_height / 2;
					break;
				}
				
			}
			__label_mc._x = __label_back_mc._x = label_x;
			__label_mc._y = __label_back_mc._y = label_y;
			__label_mc._width = label_w;
			__label_mc._height = text_height;
			__label_back_mc.clear();
			_global.com.moviemasher.Utility.DrawUtility.fill(__label_back_mc, label_w, text_height, _global.com.moviemasher.Utility.DrawUtility.hexColor(__config.textbackcolor), __config.textbackalpha);
		}
		
		__iconHeight = border_h - (2 * __config.frameborder);
		__bm_mc._y = border_y + __config.frameborder;
	
		half_w += __config.frameborder;
		half_h += __config.frameborder;
		
		__back_mc._y = border_y;
		
		__back_mc.clear();
		_global.com.moviemasher.Utility.DrawUtility.fill(__back_mc, width, border_h, _global.com.moviemasher.Utility.DrawUtility.hexColor(__config.framebordercolor));
	}



// PRIVATE CLASS METHODS
	private static function __disposeClip(mc : BrowserPreview) : Void
	{
		mc.removeMovieClip();
	}


// PRIVATE INSTANCE PROPERTIES

 	
 		
	private var __amountDone : Number = 0;
	private var __back_mc : MovieClip;
	private var __bm_mc : MovieClip;
	private var __config : Object; // it's config attributes
	private var __height = 0;
	private var __iconHeight : Number = 0;
 	private var __iconWidth : Number = 0;
	private var __item;
	private var __label_back_mc : MovieClip;
	private var __label_mc : MovieClip;
	private var __mash;
	private var __previewBitmap;
	private var __target : com.moviemasher.Control.Browser;
 	private var __type : String;
	private var __width = 0;
	
	

// PRIVATE INSTANCE METHODS
	
 	private function BrowserPreview()
	{
		createEmptyMovieClip('__back_mc', getNextHighestDepth());
	
	}


	private function __createChildren() : Void
	{
		
		createEmptyMovieClip('__bm_mc', getNextHighestDepth());
		useHandCursor = false;
		
		createEmptyMovieClip('__label_back_mc', getNextHighestDepth());
		createTextField('__label_mc', getNextHighestDepth(), 0, 0, 100, 100);
		__label_mc.selectable = false;
		
		var tf = _global.com.moviemasher.Manager.FontManager.textFormat(__config.font, __config);
		
		//_global.com.moviemasher.Control.Debug.msg(__config.font + ' = ' + tf.font);
		__label_mc.embedFonts = tf.embedFonts;
		__label_mc.setNewTextFormat(tf);
		__label_mc.text = 'jk';
		
	}
	
	private function __generateBitmap() : BitmapData
	{
		
		var bm : BitmapData = undefined;
	
		switch (__type)
		{
			case 'audio':
			{
				bm = __item.media.waveformBitmap;
				break;
			}
			default: 
			{
				bm = __item.media.posterBitmap(__iconWidth, __iconHeight);
				if ((! bm) && (bm != undefined)) bm = __mashBitmap(__type);
			}
		}


		if (bm && ( ! ((__iconWidth == bm.width) && (__iconHeight == bm.height))))
		{
			var scaled_bm = new BitmapData(__iconWidth, __iconHeight, true, _global.com.moviemasher.Utility.DrawUtility.hexColor(_global.app.options[__type].color, 'FF'));
			var nMatrix = new Matrix();
		
			var bm_scale = Math.max(__iconWidth / bm.width, __iconHeight / bm.height);
	
			nMatrix.tx = Math.round((__iconWidth - (bm_scale * bm.width))  / 2);
			nMatrix.ty = Math.round((__iconHeight - (bm_scale * bm.height))  / 2);
			nMatrix.a = nMatrix.d = bm_scale;
			
			scaled_bm.draw(bm, nMatrix);
			bm = scaled_bm;
		}
		return bm;
	}


	private function __generateMash() : Object // called for all types except audio and image
	{
		var mash_ob = new _global.com.moviemasher.Mash.Mash();
		mash_ob.setValue('id', _global.com.meychi.MD5.newID());
		
		__item.mash = mash_ob;
		if (__type == 'effect') 
		{
			__item.setValue('track', 1);
			
			mash_ob.tracks.effect.push(__item);
			
			
			mash_ob.invalidateLength('effect');
			var dims = __target.mash.dimensions;
			//
			var w = dims.width;//__iconWidth;//_global.com.moviemasher.Core.Panel.controls.player.config.width;
			var h = dims.height;//__iconHeight;//_global.com.moviemasher.Core.Panel.controls.player.config.height;
			var mash_clip = _global.app.mashClip(mash_ob);
			
			mash_ob.setValue('width', w);
			mash_ob.setValue('height', h);


			mash_clip.createEmptyMovieClip('track_0', mash_clip.getNextHighestDepth());
			mash_clip.track_0.createEmptyMovieClip('bm', mash_clip.track_0.getNextHighestDepth());
			mash_clip.track_0.bm._x = - w / 2;
			mash_clip.track_0.bm._y = - h / 2;
			
			
		}
		else 
		{

			mash_ob.tracks.video.push(false);
			mash_ob.tracks.video.push(__item);
			mash_ob.tracks.video.push(false);
			if (__type == 'video') __amountDone =  __item.media.getValue('poster') / (__item.length * __item.media.getValue('fps'));
		}
		return mash_ob;
	}
	private function __mashBitmap() : BitmapData // called for all types except audio and image
	{
		var bm : BitmapData = undefined;
		if (! __mash) __mash = __generateMash(__type);
		switch (__type)
		{
			case 'transition':
			case 'effect': 
			{
				__updateMash();
				break;
			}
		}
		bm = __mash.time2Bitmap(__item.start + (__item.length * __amountDone), __iconWidth, __iconHeight, 1);
		//if (! bm) _global.com.moviemasher.Control.Debug.msg('BrowserPreview time2Bitmap ' + __amountDone);
		if (bm)
		{
			__amountDone += .1;
			if (__amountDone >= .9) __amountDone = 0;
		}
				
		return bm;
	}
	
	
	private function __updateMash() : Void // called for effects and transitions
	{
		
		if (__type == 'effect') 
		{
			var mash_clip = _global.app.mashClip(__mash);	//_global.com.moviemasher.Core.Panel.controls.player.bitmap		
			mash_clip._xscale = mash_clip._yscale = 100;
			var dims = __target.mash.dimensions;
			mash_clip.track_0.bm.attachBitmap(__target.mash.time2Bitmap(__target.mash.getValue('location'), dims.width, dims.height, __target.mash.highest.effect), 1);
			mash_clip._width = __iconWidth;
			mash_clip._height = __iconHeight;
			
		}
		else // type == transition
		{
			
			var trans_clips = __target.mash.transitionClips();
			var trans_id0 = trans_clips[0].media.getValue('id');
			var trans_id1 = trans_clips[1].media.getValue('id');
			if ( ! ((trans_id0 == __mash.tracks.video[0].media.getValue('id')) && (trans_id1 == __mash.tracks.video[2].media.getValue('id'))))
			{
				var new_length : Number = 0;
				if (trans_clips[0]) 
				{
					__mash.tracks.video[0] = _global.com.moviemasher.Clip.Clip.fromMediaID(trans_id0);
					new_length += __mash.tracks.video[0].length / 2;
					__mash.tracks.video[0].mash = __mash;
				}
				if (trans_clips[1]) 
				{
					__mash.tracks.video[2] = _global.com.moviemasher.Clip.Clip.fromMediaID(trans_id1);
					new_length += __mash.tracks.video[2].length / 2;
					__mash.tracks.video[2].mash = __mash;
				}
				__item.setValue('length', new_length);
				__mash.invalidateLength('video');
			}
		}
	}
	

}