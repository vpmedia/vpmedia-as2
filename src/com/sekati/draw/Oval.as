/**
 * com.sekati.draw.Oval
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.geom.Point;

/**
 * Oval Object
 */
class com.sekati.draw.Oval {

	private var _mc:MovieClip;
	public var _center:Point;
	public var _radius:Point;
	public var _fc:Number;
	public var _fa:Number;
	public var _sw:Number;
	public var _sc:Number;
	public var _sa:Number;

	/**
	 * Oval Constructor
	 * @param mc (MovieClip)
	 * @param center (Point)
	 * @param radius (Point)
	 * @param fillColor (Number) hex fill, if undefined rectangle will not be filled
	 * @param fillAlpha (Number) fill alpha transparency [default: 100]
	 * @param strokeWeight (Number) line width [default: 1]
	 * @param strokeColor (Number) line color [default: 0x000000]
	 * @param strokeAlpha (Number) line alpha transparency [default: 100]
	 * @return Void
	 */
	public function Oval(mc:MovieClip, center:Point, radius:Point, fillColor:Number, fillAlpha:Number, strokeWeight:Number, strokeColor:Number, strokeAlpha:Number) {
		_mc = mc;
		_fc = fillColor;
		_fa = (isNaN( fillAlpha )) ? 100 : fillAlpha;
		_sw = (!strokeWeight) ? undefined : strokeWeight;
		_sc = (isNaN( strokeColor )) ? 0x000000 : strokeColor;
		_sa = (isNaN( strokeAlpha )) ? 100 : strokeAlpha;
		_center = center;
		_radius = radius;
		draw( );
	}

	/**
	 * (Re)Draw line with current properties.
	 * @return Void
	 */
	public function draw():Void {
		_mc.clear( );
		_mc.lineStyle( _sw, _sc, _sa, true, "none", "round", "round", 8 );
		if (!isNaN( _fc )) {
			_mc.beginFill( _fc, _fa );
		}
		var angleMid:Number, px:Number, py:Number, cx:Number, cy:Number;
		var theta:Number = Math.PI / 4;
		
		// calculate the distance for the control point
		var xrCtrl:Number = _radius.x / Math.cos( theta / 2 );
		var yrCtrl:Number = _radius.y / Math.cos( theta / 2 );
		
		// start on the right side of the circle
		var angle:Number = 0;
		_mc.moveTo( _center.x + _radius.x, _center.y );
		
		// this loop draws the circle in 8 segments
		for (var i:Number = 0; i < 8 ; i++) {
			// increment our angles
			angle += theta;
			angleMid = angle - (theta / 2);
			
			// calculate our control point
			cx = _center.x + Math.cos( angleMid ) * xrCtrl;
			cy = _center.y + Math.sin( angleMid ) * yrCtrl;
			
			// calculate our end point
			px = _center.x + Math.cos( angle ) * _radius.x;
			py = _center.y + Math.sin( angle ) * _radius.y;
			
			// draw the circle segment
			_mc.curveTo( cx, cy, px, py );
		}
		if (!isNaN( _fc )) {	
			_mc.endFill( );
		}	
	}
}