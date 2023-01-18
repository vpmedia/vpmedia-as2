/**
 * com.sekati.draw.Rectangle
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.geom.Point;

/**
 * Rectangle drawing utility.
 */
class com.sekati.draw.Rectangle {

	/**
	 * Draw a rectangle in an existing clip
	 * @param mc (Movie	Clip) target clip to draw in
	 * @param topLeft (Point)
	 * @param bottomRight (Point)
	 * @param fillColor (Number) hex fill, if undefined rectangle will not be filled
	 * @param fillAlpha (Number) fill alpha transparency [default: 100]
	 * @param strokeWeight (Number) border line width, if 0 or undefined no border will be drawn
	 * @param strokeColor (Number) hex border color 
	 * @param strokeAlpha (Number) stroke alpha transparancy [default: 100]
	 * @return Void
	 * {@code Usage:
	 * 	var box:MovieClip = this.createEmptyMovieClip ("box", this.getNextHighestDepth ());
	 * 	Rectangle.draw(box, new Point(50, 50), new Point(100, 100), 0xff00ff, 100, 1, 0x00ffff, 100);
	 * }
	 */
	public static function draw(mc:MovieClip, topLeft:Point, bottomRight:Point, fillColor:Number, fillAlpha:Number, strokeWeight:Number, strokeColor:Number, strokeAlpha:Number):Void {
		var sw:Number = (!strokeWeight) ? undefined : strokeWeight;
		var sc:Number = (isNaN( strokeColor )) ? 0x000000 : strokeColor;
		var sa:Number = (isNaN( strokeAlpha )) ? 100 : strokeAlpha;
		var fa:Number = (isNaN( fillAlpha )) ? 100 : fillAlpha;
				
		var tl:Number = topLeft.x;
		var bl:Number = topLeft.y;
		var tr:Number = bottomRight.x;
		var br:Number = bottomRight.y;
		
		mc.clear( );
		mc.lineStyle( sw, sc, sa, true, "none", "square", "miter", 1.414 );
		if (!isNaN( fillColor )) {
			mc.beginFill( fillColor, fa );
		}
		mc.moveTo( tl, bl );
		mc.lineTo( tr, bl );
		mc.lineTo( tr, br );
		mc.lineTo( tl, br );
		if (!isNaN( fillColor )) {
			mc.endFill( );
		} else {
			mc.lineTo( bl, tl );
		}
	}

	private function Rectangle() {
	}
}