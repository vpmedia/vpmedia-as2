/**
 * com.sekati.draw.Curve
 * @version 1.0.3
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.geom.Point;

/**
 * Tweenable Curve Object
 */
class com.sekati.draw.Curve {

	private var _mc:MovieClip;
	public var _p1:Point;
	public var _p2:Point;
	public var _c:Point;
	public var _sw:Number;
	public var _sc:Number;
	public var _sa:Number;

	/**
	 * Curve Constructor
	 * @param mc (MovieClip)
	 * @param p1 (Point) point 1
	 * @param p2 (Point) point 2
	 * @param c (Point) curve point
	 * @param strokeWeight (Number) line width [default: 1]
	 * @param strokeColor (Number) line color [default: 0x000000]
	 * @param strokeAlpha (Number) line alpha transparency [default: 100]
	 * @return Void
	 */
	public function Curve(mc:MovieClip, p1:Point, p2:Point, c:Point, strokeWeight:Number, strokeColor:Number, strokeAlpha:Number) {
		_mc = mc;
		_sw = (!strokeWeight) ? undefined : strokeWeight;
		_sc = (isNaN( strokeColor )) ? 0x000000 : strokeColor;
		_sa = (isNaN( strokeAlpha )) ? 100 : strokeAlpha;
		_p1 = p1;
		_p2 = p2;
		_c = c;
		draw( );
	}

	/**
	 * (Re)Draw Curve with current properties.
	 * @return Void
	 */
	public function draw():Void {
		_mc.clear( );
		_mc.lineStyle( _sw, _sc, _sa, true, "none", "round", "round", 8 );
		_mc.moveTo( _p1.x, _p1.y );
		_mc.curveTo( _c.x, _c.y, _p2.x, _p2.y );
	}	

	public function get p1x():Number {
		return _p1.x;	
	}

	public function set p1x(n:Number):Void {
		_p1.x = n;
		draw( );
	}	

	public function get p1y():Number {
		return _p1.y;	
	}

	public function set p1y(n:Number):Void {
		_p1.y = n;	
		draw( );
	}	

	public function get p2x():Number {
		return _p2.x;	
	}

	public function set p2x(n:Number):Void {
		_p2.x = n;	
		draw( );
	}	

	public function get p2y():Number {
		return _p2.y;	
	}

	public function set p2y(n:Number):Void {
		_p2.y = n;	
		draw( );
	}

	public function get cx():Number {
		return _c.x;	
	}

	public function set cx(n:Number):Void {
		_c.x = n;	
		draw( );
	}

	public function get cy():Number {
		return _c.y;	
	}

	public function set cy(n:Number):Void {
		_c.y = n;	
		draw( );
	}	
}