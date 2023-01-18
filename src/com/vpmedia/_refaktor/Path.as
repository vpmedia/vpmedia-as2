class com.vpmedia.draw.Path
{
	var _segments:Array;
	var _length:Number;
	var _position:Object;
	var curveToAccuracy:Number = 10;
	//
	public function Path (start_x, start_y)
	{
		init (start_x, start_y);
	}
	//
	public function init (start_x, start_y):Void
	{
		_segments = new Array ();
		_length = 0;
		if (arguments.length)
		{
			moveTo (start_x, start_y);
		}
		else
		{
			moveTo (0, 0);
		}
	}
	//
	public function clear ():Void
	{
		init (0, 0);
	}
	//
	public function moveTo (start_x, start_y):Object
	{
		_segments[_segments.length] = {d:0, start:{_x:_position._x, _y:_position._y}, end:{_x:start_x, _y:start_y}, type:"M"};
		_position = {_x:start_x, _y:start_y};
		return this;
	}
	//
	public function lineTo (end_x, end_y):Object
	{
		var dx = end_x - _position._x;
		var dy = end_y - _position._y;
		var d = Math.sqrt (dx * dx + dy * dy);
		_segments[_segments.length] = {d:d, start:_position, end:{_x:end_x, _y:end_y}, type:"L"};
		_length += d;
		_position = {_x:end_x, _y:end_y};
		return this;
	}
	//
	public function circleTo (end_x, end_y, arc, dir):Object
	{
		if (dir == undefined)
		{
			dir = "CW";
		}
		if (arc == undefined)
		{
			arc = .5;
		}
		if (arc > 1)
		{
			arc = 1;
		}
		else if (arc <= 0)
		{
			return lineTo (end_x, end_y);
		}
		if (dir == "CCW")
		{
			arc = 1 - arc;
		}
		var o:Object = {_x:(_position._x + end_x) / 2, _y:(_position._y + end_y) / 2};
		var dx:Number = end_x - _position._x;
		var dy:Number = end_y - _position._y;
		var d:Number = Math.sqrt (dx * dx + dy * dy);
		var mr:Number = d / 2;
		var opp:Number = mr / Math.tan (arc * Math.PI);
		var rad:Number = mr / Math.sin (arc * Math.PI);
		var a:Number = Math.atan2 (dy, dx) + Math.PI / 2;
		o._x += Math.cos (a) * opp;
		o._y += Math.sin (a) * opp;
		var a1:Object = Math.atan2 (_position._y - o._y, _position._x - o._x);
		var a2:Object = Math.atan2 (end_y - o._y, end_x - o._x);
		if (dir == "CW")
		{
			if (a2 < a1)
			{
				a2 += Math.PI * 2;
			}
		}
		else
		{
			if (a1 < a2)
			{
				a1 += Math.PI * 2;
			}
		}
		var d:Number = rad * Math.abs (a2 - a1);
		this._segments[this._segments.length] = {d:d, r:rad, a1:a1, a2:a2, o:o, dir:dir, type:"C"};
		this._length += d;
		this._position = {_x:end_x, _y:end_y};
		return this;
	}
	//
	public function circleCWTo (end_x, end_y, arc):Object
	{
		return circleTo (end_x, end_y, arc, "CW");
	}
	//
	public function circleCCWTo (end_x, end_y, arc):Object
	{
		return circleTo (end_x, end_y, arc, "CCW");
	}
	//
	public function curveTo (con_x, con_y, end_x, end_y):Object
	{
		var segs:Object = divideBezier (_position._x, _position._y, con_x, con_y, end_x, end_y);
		_segments[_segments.length] = {d:segs.d, start:_position, con:{_x:con_x, _y:con_y}, end:{_x:end_x, _y:end_y}, segs:segs, type:"B"};
		_length += segs.d;
		_position = {_x:end_x, _y:end_y};
		return this;
	}
	//
	private function divideBezier (x1, y1, x2, y2, x3, y3):Object
	{
		var t:Number;
		var ax:Number;
		var ay:Number;
		var dx:Number;
		var dy:Number;
		var sx:Number;
		var sy:Number;
		var x:Number;
		var y:Number;
		var d:Number;
		var s:Array = new Array ();
		var p:Object = {_x:x1, _y:y1};
		var dx1:Number = x2 - x1;
		var dy1:Number = y2 - y1;
		var dx2:Number = x3 - x2;
		var dy2:Number = y3 - y2;
		var MA:Function = Math.atan2;
		var MS:Function = Math.sqrt;
		var td:Number = 0;
		var ad:Number;
		var da:Number;
		var a1:Number;
		var a:Number = MA (dy1, dx1);
		for (var i = 1; i < curveToAccuracy; ++i)
		{
			t = i / curveToAccuracy;
			dx = x2 + dx2 * t - (ax = x1 + dx1 * t);
			dy = y2 + dy2 * t - (ay = y1 + dy1 * t);
			x = ax + dx * t;
			y = ay + dy * t;
			sx = x - p._x;
			sy = y - p._y;
			td += (d = MS (sx * sx + sy * sy));
			a1 = MA (dy, dx);
			da = a1 - a;
			if (da > Math.PI)
			{
				da -= Math.PI * 2;
			}
			else if (da < -Math.PI)
			{
				da += Math.PI * 2;
			}
			s[s.length] = {d:d, start:p, end:{_x:x, _y:y}, a:{base:a, d:da}};
			a = a1;
			p = {_x:x, _y:y};
		}
		sx = x3 - p._x;
		sy = y3 - p._y;
		td += (d = MS (sx * sx + sy * sy));
		a1 = MA (dy2, dx2);
		s[s.length] = {d:d, start:p, end:{_x:x3, _y:y3}, a:{base:a, d:a1 - a}};
		s.d = td;
		return s;
	}
	//
	private function setInBezier (obj, t, segments, orient, extra)
	{
		if (t < 0)
		{
			t = 0;
		}
		else if (t > 1)
		{
			t = 1;
		}
		var seg:Object = segments[0];
		var currt:Number = segments.d * t;
		var currd:Number = 0;
		var num:Number = 0;
		var L:Number = segments.length + 1;
		for (var i = 1; i < L; ++i)
		{
			seg = segments[(num = i - 1)];
			if (i == L || (currd + seg.d) >= currt)
			{
				break;
			}
			currd += seg.d;
		}
		if (!seg.d)
		{
			t = 0;
		}
		else
		{
			t = (currt - currd) / seg.d;
		}
		var dx = seg.end._x - seg.start._x;
		var dy = seg.end._y - seg.start._y;
		obj._x = seg.start._x + dx * t;
		obj._y = seg.start._y + dy * t;
		if (extra)
		{
			obj.t = t;
			obj.n = num;
			obj.divs = segments.length;
		}
		if (orient)
		{
			obj._rotation = (seg.a.base + seg.a.d * t) * 180 / Math.PI;
		}
	}
	public function reverse ():Object
	{
		var s:Array = _segments;
		var i:Number = s.length;
		var p:Object = new Path (s[i - 1].end._x, s[i - 1].end._y);
		while (i--)
		{
			if (s[i].type == "M")
			{
				p._segments[p._segments.length] = {d:0, start:{_x:s[i].end._x, _y:s[i].end._y}, end:{_x:s[i].start._x, _y:s[i].start._y}, type:"M"};
			}
			else if (s[i].type == "L")
			{
				p._segments[p._segments.length] = {d:s[i].d, start:{_x:s[i].end._x, _y:s[i].end._y}, end:{_x:s[i].start._x, _y:s[i].start._y}, type:"L"};
			}
			else if (s[i].type == "C")
			{
				p._segments[p._segments.length] = {d:s[i].d, r:s[i].r, a1:s[i].a2, a2:s[i].a1, o:{_x:s[i].o._x, _y:s[i].o._y}, dir:(s[i].dir == "CW" ? "CCW" : "CW"), type:"C"};
			}
			else if (s[i].type == "B")
			{
				var segs:Object = divideBezier (s[i].end._x, s[i].end._y, s[i].con._x, s[i].con._y, s[i].start._x, s[i].start._y);
				p._segments[p._segments.length] = {d:s[i].d, start:{_x:s[i].end._x, _y:s[i].end._y}, con:{_x:s[i].con._x, _y:s[i].con._y}, end:{_x:s[i].start._x, _y:s[i].start._y}, segs:segs, type:"B"};
			}
		}
		p._length = this._length;
		if (this.hasOwnProperty ("curveToAccuracy"))
		{
			p.curveToAccuracy = this.curveToAccuracy;
		}
		return p;
	}
	//
	public function traverse (obj, t, orient, wrap):Object
	{
		if (wrap == undefined || wrap == true)
		{
			if (t < 0 || t > 1)
			{
				t -= Math.floor (t);
			}
		}
		else
		{
			if (t < 0)
			{
				t = 0;
			}
			else if (t > 1)
			{
				t = 1;
			}
		}
		var seg = _segments[0];
		var currt = _length * t;
		var currd = 0;
		var num = 0;
		var L = _segments.length + 1;
		for (var i = 1; i < L; ++i)
		{
			seg = _segments[(num = i - 1)];
			if (i == L || (currd + seg.d) >= currt)
			{
				break;
			}
			else
			{
				currd += seg.d;
			}
		}
		while (seg.type == "M")
		{
			seg = this._segments[++num];
		}
		if (!seg.d)
		{
			t = 0;
		}
		else
		{
			t = (currt - currd) / seg.d;
		}
		if (seg.type == "L")
		{
			// line
			var dx = seg.end._x - seg.start._x;
			var dy = seg.end._y - seg.start._y;
			obj._x = seg.start._x + dx * t;
			obj._y = seg.start._y + dy * t;
			if (orient)
			{
				obj._rotation = Math.atan2 (dy, dx) * 180 / Math.PI;
			}
		}
		else if (seg.type == "C")
		{
			var a1 = seg.a1, a2 = seg.a2;
			var a = a1 + (a2 - a1) * t;
			obj._x = seg.o._x + Math.cos (a) * seg.r;
			obj._y = seg.o._y + Math.sin (a) * seg.r;
			if (orient)
			{
				obj._rotation = (seg.dir == "CW") ? a * 180 / Math.PI + 90 : a * 180 / Math.PI - 90;
			}
		}
		else if (seg.type == "B")
		{
			setInBezier (obj, t, seg.segs, orient);
		}
		return this;
	}
	//
	private function mcCircleTo (cen_x, cen_y, a1, a2, r, dir):Object
	{
		dir = (dir == "CCW") ? -1 : 1;
		var MC:Function = Math.cos;
		var MS:Function = Math.sin;
		var diff:Number = Math.abs (a2 - a1);
		var divs:Number = Math.floor (diff / (Math.PI / 4)) + 1;
		var span:Number = dir * diff / (2 * divs);
		var rc:Number = r / MC (span);
		for (var i = 0; i < divs; ++i)
		{
			a2 = a1 + span;
			a1 = a2 + span;
			curveTo (cen_x + MC (a2) * rc, cen_y + MS (a2) * rc, cen_x + MC (a1) * r, cen_y + MS (a1) * r);
		}
		return this;
	}
	private function draw (mc, n)
	{
		var s:Array = _segments;
		if (n == undefined)
		{
			n = s.length;
		}
		for (var i = 0; i < n; ++i)
		{
			if (s[i].type == "M")
			{
				mc.moveTo (s[i].end._x, s[i].end._y);
			}
			else if (s[i].type == "L")
			{
				mc.lineTo (s[i].end._x, s[i].end._y);
			}
			else if (s[i].type == "C")
			{
				mcCircleTo.call (mc, s[i].o._x, s[i].o._y, s[i].a1, s[i].a2, s[i].r, s[i].dir);
			}
			else if (s[i].type == "B")
			{
				mc.curveTo (s[i].con._x, s[i].con._y, s[i].end._x, s[i].end._y);
			}
		}
		return this;
	}
	public function drawUpTo (mc, t, wrap):Object
	{
		if (wrap == undefined || wrap == true)
		{
			if (t < 0 || t > 1)
			{
				t -= Math.floor (t);
			}
			else
			{
				if (t < 0)
				{
					t = 0;
				}
				else if (t > 1)
				{
					t = 1;
				}
			}
		}
		var seg:Object = _segments[0];
		var currt:Number = _length * t;
		var currd:Number = 0;
		var num:Number = 0;
		var L:Number = _segments.length + 1;
		for (var i = 1; i < L; ++i)
		{
			seg = _segments[(num = i - 1)];
			if (i == L || (currd + seg.d) >= currt)
			{
				break;
			}
			else
			{
				currd += seg.d;
			}
		}
		if (!seg.d)
		{
			t = 0;
		}
		else
		{
			t = (currt - currd) / seg.d;
		}
		draw (mc, num);
		if (seg.type == "M")
		{
			mc.moveTo (seg.end._x, seg.end._y);
		}
		else if (seg.type == "L")
		{
			mc.lineTo (seg.start._x + (seg.end._x - seg.start._x) * t, seg.start._y + (seg.end._y - seg.start._y) * t);
		}
		else if (seg.type == "C")
		{
			mcCircleTo.call (mc, seg.o._x, seg.o._y, seg.a1, seg.a1 + (seg.a2 - seg.a1) * t, seg.r, seg.dir);
		}
		else if (seg.type == "B")
		{
			var obj:Object = new Object ();
			setInBezier (obj, t, seg.segs, false, true);
			var p = (obj.n / obj.divs) + (obj.t / obj.divs);
			mc.curveTo (seg.start._x + (seg.con._x - seg.start._x) * p, seg.start._y + (seg.con._y - seg.start._y) * p, obj._x, obj._y);
		}
		return this;
	}
}
