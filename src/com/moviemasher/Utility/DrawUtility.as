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



/** Static class provides MovieClip drawing utility functions.
*/

class com.moviemasher.Utility.DrawUtility
{
/**	Constant number that's definitively offscreen */
	static var offStage : Number = 10000;

	
	
	static function blendColor(n, c1, c2)
	{
		c1 = hex2RGB(c1);
		c2 = hex2RGB(c2);
		c1.r = n * c1.r + (1-n)*c2.r;
		c1.g = n * c1.g + (1-n)*c2.g;
		c1.b = n * c1.b + (1-n)*c2.b;
		return __getHex(c1.r, c1.g, c1.b);
	}
	
	
	static function buffedFill(w, h, c, grad, angle, type)
	{
		if (grad) c = {width: w, height: h, type: type, angle: angle, colors: [__adjustColor(c, grad), __adjustColor(c, -grad)]};
		return c;
	}
	
	static function drawFill(clip, a, notFilled)
	{
		var aPoint;
		var last;
		for (var i = 0; i <= a.length; i++)
		{
			if (i == a.length) aPoint = a[0];
			else aPoint = a[i];
			if (! i) clip.moveTo(aPoint.x, aPoint.y);
			else
			{
				if (aPoint.type != 'curve') clip.lineTo(aPoint.x, aPoint.y);
				else
				{
					var x = last.x;
					var y = last.y;
					if (aPoint.x > last.x) y = Math.min(last.y, aPoint.y);
					else y = Math.max(last.y, aPoint.y);
					if (aPoint.y > last.y) x = Math.max(last.x, aPoint.x);
					else x = Math.min(last.x, aPoint.x);
					clip.curveTo(x, y, aPoint.x, aPoint.y);
				}
			}
			last = aPoint;
		}
		if (! notFilled) clip.endFill();
	}
	
	static function fill(mc, w, h, col, a, curve)
	{
		plot(mc, 0, 0, w, h, col, a, curve);
	}
	
	static function getHexStr(r, g, b) 
	{
		if (typeof(r) == 'object')
		{
			g = r.g;
			b = r.b;
			r = r.r;
		}
		return __twoDigit(r.toString(16))+__twoDigit(g.toString(16))+__twoDigit(b.toString(16));
	}
	
	
	static function hex2RGB(HEX) 
	{
		return {r:HEX >> 16, g:(HEX >> 8) & 0xff, b:HEX & 0xff};
	}
	
	static function hexColor(s : String, opacity : String) : Number // first param might actually be a number
	{
		if (s == undefined) s = '000000';
		else s = String(s);
		if (s.length != 6) s = _global.com.moviemasher.Utility.StringUtility.strPad(s, 6, '0');
		if (opacity.length == 2) s = opacity + s;
		s = '0x' + s;
		var n = Number(s);
		if (isNaN(n)) 
		{
			_global.com.moviemasher.Control.Debug.msg('Invalid color ' + s);
			n = 0;
		}
		return n;
	}
	
	static function plot(mc, x, y, w, h, col, a, curve)
	{
		if (w == undefined) w = 1;
		if (h == undefined) h = 1;
		if (typeof(col) == 'object')
		{
			if (! col.width) col.width = w;
			if (! col.height) col.height = h;
			if (! col.x) col.x = x;
			if (! col.y) col.y = y;
		}
		setFill(mc, col, a);
		drawFill(mc, points(x, y, w, h, curve));
		
	}
	
	static function points(x, y, w, h, curve)
	{	
		if (! curve) return [{x: x, y: y}, {x: x + w, y: y}, {x: x + w, y: y + h}, {x: x, y: y + h}];
		
		// make sure curve isn't more than half width or height
		curve = Math.min(curve, Math.round(w / 2));
		curve = Math.min(curve, Math.round(h / 2));
		return [{x: x, y: y + curve}, {x: x + curve, y: y, type: 'curve'}, {x: x + (w - curve), y: y}, {x: x + w, y: y + curve, type: 'curve'}, {x: x + w, y: y + h - curve}, {x: x + w - curve, y: y + h, type: 'curve'}, {x: x + curve, y: y + h}, {x: x, y: y + h - curve, type: 'curve'}];
	}
	

	static function setFill(mc, c, a)
	{
		
		if (a == undefined) a = 100;
		if (typeof(c) == 'object') // {colors: [], alphas: [], type: 'linear', angle: 0, width: 100, height: 100}
		{
			if (! c.alphas)
			{
				c.alphas = [];
				for (var i = 0; i < c.colors.length; i++)
				{
					c.alphas.push(a);	
				}
			}
			if (! c.ratios)
			{
				c.ratios = [];
				var increment = 255 / (c.colors.length - 1);
				for (var i = 0; i < c.colors.length; i++)
				{
					c.ratios.push(Math.round(i * increment));	
				}
			}
			if (! c.angle) c.angle = 0;
			if (! c.type) c.type = 'linear';
			if (c.x == undefined) c.x = 0;
			if (c.y == undefined) c.y = 0;
			if (! c.matrix) c.matrix = {matrixType:"box", x:c.x, y:c.y, w:c.width, h:c.height, r:(c.angle/180)*Math.PI};
			if (! c.spread) c.spread = 'pad';
			mc.beginGradientFill(c.type, c.colors, c.alphas, c.ratios, c.matrix, c.spread);//
		}
		else mc.beginFill(c, a);
	}
	
	
	static function setLine(mc, w, c, a)
	{
		if (! w) w = undefined;
		if (a == undefined) a = 100;
		if (c == undefined) c = 0x000000;
		mc.lineStyle(w, c, a);
	}
	

	
// PRIVATE CLASS METHODS

	private static function __adjustColor(c, n)
	{
		c = hex2RGB(c);
		for (var k in c)
		{
			c[k] = Math.min(255, Math.max(0, c[k] + n));
		}
		c = __getHex(c.r, c.g, c.b);
		return c;
	}	
	
	private static function __getHex(r, g, b) 
	{
		
		return r << 16 | g << 8 | b;
	}
	private static function __twoDigit(str) 
	{
		return str.length == 1 ? "0"+str : str;
	}
	
	
}