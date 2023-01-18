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
import flash.display.BitmapData;


/** Control symbol allows a {@link com.moviemasher.Media.Media} object to be chosen by drag and drop.

*/
class com.moviemasher.Control.Imagewell extends com.moviemasher.Control.Control
{

	function createChildren() : Void
	{
		createEmptyMovieClip('__back_mc', getNextHighestDepth());
		createEmptyMovieClip('__drag_hi_mc', getNextHighestDepth());
		createEmptyMovieClip('__img_mc', getNextHighestDepth());
		__drag_hi_mc._visible = false;
	}
	
	function dragAccept(x_pos, y_pos, items, x_offset, y_offset)
	{
		dispatchEvent({type: 'propertyChanged', property: __property, value: items[0].media.getValue('id')});
	}

	function dragHilite(tf)
	{
		__drag_hi_mc._visible = tf;
	}
		
	function dragOver(x_pos, y_pos, items, x_offset, y_offset) // GLOBAL x,y! return true if valid drop point
	{
		var ok = false;
		if (items.length == 1)
		{
			switch (items[0].getValue('type'))
			{
				case 'video':
				case 'image':
				case 'theme':
				{
					ok = true;
					break;		
				}	
			}
		}
		return ok;
	}
	
	function onPress()
	{
		var item_ob = _global.com.moviemasher.Clip.Clip.fromMediaID(__mediaID);
		if (! _global.com.moviemasher.Control.Debug.isFalse(item_ob, "Couldn't create item with media ID " + __mediaID))
		{
			com.moviemasher.Utility.DragUtility.begin([item_ob], {_x: Math.min(_xmouse, width - (2 * config.padding)), _y: Math.min(_ymouse, height - (2 * config.padding))});
		}
	}
	
	function propertyChange(event : Object) : Void
	{
		if (__targets[event.property] == event.target) 
		{
			if (__mediaID != event.value)
			{
				__mediaID = event.value;
				__drawBitmap();
			}
		}
	}
	

	function size() : Void
	{
		super.size();
		if (! (width && height)) return;
		__back_mc.clear();
		__drag_hi_mc.clear();
		
		var c = _global.com.moviemasher.Utility.DrawUtility.hexColor(config.color);
		if (config.grad) c = _global.com.moviemasher.Utility.DrawUtility.buffedFill(width, height, c, config.grad, config.angle);
		
		_global.com.moviemasher.Utility.DrawUtility.plot(__back_mc, 0, 0, width, height, c, 100, config.curve);
		_global.com.moviemasher.Utility.DrawUtility.plot(__drag_hi_mc, 0, 0, width, height, 0x000000, 50, config.curve);
		__img_mc._x = __img_mc._y = config.padding;
		__drawBitmap();
	}
	

	
	
// PRIVATE INSTANCE PROPERTIES

	private var __back_mc : MovieClip;
	private var __drag_hi_mc : MovieClip;
	private var __drawInterval = 0;
	private var __img_mc : MovieClip;
	private var __mediaID : String;

	
// PRIVATE INSTANCE METHODS

	
	private function Imagewell()
	{
		if (config.attributes == undefined) config.attributes = 'timeline.media';
		if (config.angle == undefined) config.angle = 270;
		if (config.color == undefined) config.color = 666666;
		if (config.curve == undefined) config.curve = 4;
		if (config.grad == undefined) config.grad = 40;
		if (config.padding == undefined) config.padding = 2;

		com.moviemasher.Utility.DragUtility.addTarget(this); // register for dragOver, dragHilite and dragAccept messages
				
	}
	
	private function __drawBitmap()
	{
		if (__img_mc._visible = (__mediaID != undefined))
		{
			var w = config.width - (2 * config.padding);
			var h = config.height - (2 * config.padding);
			var media = _global.com.moviemasher.Media.Media.fromMediaID(__mediaID);
			var bm = media.posterBitmap(w, h);
			if (! bm)
			{
				if (bm != undefined) 
				{
					bm = media.__loadFrame(media.getValue('poster'));
					if (bm)
					{
						var scaled_bm = new BitmapData(w, h, true, 0x00FFFFFF);//com.moviemasher.Utility.DrawUtility.hexColor(_global.app.options[getValue('type')].color, 'FF'));
						var nMatrix = new Matrix();
					
						var bm_scale = Math.max(w / bm.width, h / bm.height);
				
						nMatrix.tx = Math.round((w - (bm_scale * bm.width))  / 2);
						nMatrix.ty = Math.round((h - (bm_scale * bm.height))  / 2);
						nMatrix.a = nMatrix.d = bm_scale;
						scaled_bm.draw(bm, nMatrix);
						bm = scaled_bm;
					}
				}
			}
			if (__img_mc._visible = Boolean(bm))
			{
				__img_mc.attachBitmap(bm, 100);
				if (__drawInterval)
				{
					clearInterval(__drawInterval);
					__drawInterval = 0;
				}
			}
			else
			{
				if (! __drawInterval) __drawInterval = setInterval(this, '__drawBitmap', 2000);
			}
		}
	}
	
}