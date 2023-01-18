/**
 * com.sekati.draw.Triangle
 * @version 1.0.7
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.geom.Point;

/**
 * Triangle drawing utility.
 */
class com.sekati.draw.Triangle {

	/**
	 * Draw a triangle in an existing clip
	 * @param mc (Movie	Clip) target clip to draw in
	 * @param p1 (Point) first point
	 * @param p2 (Point) second point
	 * @param p3 (Point) third point
	 * @param fillColor (Number) hex fill, if undefined rectangle will not be filled
	 * @param fillAlpha (Number) fill alpha transparency [default: 100]
	 * @param strokeWeight (Number) border line width, if 0 or undefined no border will be drawn
	 * @param strokeColor (Number) hex border color 
	 * @param strokeAlpha (Number) stroke alpha transparancy [default: 100]
	 * @return Void
	 * {@code Usage:
	 * 	var tri:MovieClip = this.createEmptyMovieClip ("tri", this.getNextHighestDepth ());
	 * 	Triangle.draw(tri, new Point(0,30), new Point(30,30), new Point(30,0), 0xff00ff, 100, 1, 0x00ffff, 100);
	 * }
	 */
	public static function draw(mc:MovieClip, p1:Point, p2:Point, p3:Point, fillColor:Number, fillAlpha:Number, strokeWeight:Number, strokeColor:Number, strokeAlpha:Number):Void {
		var sw:Number = (!strokeWeight) ? undefined : strokeWeight;
		var sc:Number = (isNaN( strokeColor )) ? 0x000000 : strokeColor;
		var sa:Number = (isNaN( strokeAlpha )) ? 100 : strokeAlpha;
		var fa:Number = (isNaN( fillAlpha )) ? 100 : fillAlpha;
		
		mc.clear( );
		mc.lineStyle( sw, sc, sa, true, "none", "square", "miter", 1.414 );
		if (!isNaN( fillColor )) {
			mc.beginFill( fillColor, fa );
		}
		mc.moveTo( p1.x, p1.y );
		mc.lineTo( p2.x, p2.y );
		mc.lineTo( p3.x, p3.y );
		mc.lineTo( p1.x, p1.y );
		if (!isNaN( fillColor )) {
			mc.endFill( );
		}
	}

	private function Triangle() {
	}
}