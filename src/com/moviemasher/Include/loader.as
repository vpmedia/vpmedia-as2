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


/** This code appears on frame 1 of core/loader.fla
*/

stop();

_visible = false;

import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.display.BitmapData;


function loadURL(url, callback_ob, params)
{
	var d = getNextHighestDepth();
	var clip_name = 'clip_' + d;
	createEmptyMovieClip(clip_name, d);
	var mc = this[clip_name]; // take reference, because _name might be key in params
	mc.callback_ob = callback_ob;
	if (params != undefined)
	{
		for (var k in params)
		{
			mc[k] = params[k];
		}
	}
	mc.createEmptyMovieClip('mc', 1);
	var mcl = new MovieClipLoader();
	mcl.addListener(this);
	mcl.loadClip(url, mc.mc);
}

function mcBitmap(safe_url) : BitmapData
{
	var mc = this[safe_url];
	var bm : BitmapData = undefined;
	if (mc._width && mc._height) 
	{
	
		bm = new BitmapData(mc._width, mc._height, true, 0x00FF0000);
		bm.draw(mc);
		mc.removeMovieClip();
	}
	return bm;
}


function mcScaledBitmap(safe_url : String, width : Number, height : Number, anchor : String) : BitmapData
{
	var bm : BitmapData = undefined;
	var mc = this[safe_url];
	
	var scale_x : Number = 1;
	var scale_y : Number = 1;
	var target : MovieClip;
	target = mc.mc;
	if (anchor.length) target.gotoAndStop(anchor);
	
	var hold = {w: mc._width, h: mc._height};
		
	if (hold.w && hold.h) 
	{
		if (width) scale_x = width / hold.w;
		if (height) scale_y = height / hold.h;
		if (! width) scale_x = scale_y;
		if (! height) scale_y = scale_x;
		
		bm = new BitmapData(hold.w * scale_x, hold.h * scale_y, true, 0x00000000);
		
		
		if (target.scale9_mc) target = target.scale9_mc;
		target._width = hold.w * scale_x;
		target._height = hold.h * scale_y;
		if (bm) bm.draw(mc);
		target._width = hold.w;
		target._height = hold.h;
	}
	return bm;
}

function onLoadInit(clip)
{

	clip._parent.callback_ob.back(clip._parent);
}


var domain = this._parent._parent.getDomain();
System.security.allowDomain(domain);
this._parent._parent.loaderDidLoad(this);



