/**
 * com.sekati.draw.RoundRectangle
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.geom.Point;

/**
 * Rounded rectangle drawing utility.
 */
class com.sekati.draw.RoundRectangle {

	/**
	 * Draw a rectangle in an existing clip
	 * @param mc (Movie	Clip) target clip to draw in
	 * @param topLeft (Point)
	 * @param bottomRight (Point)
	 * @param fillColor (Number) hex fill, if undefined rectangle will not be filled
	 * @param fillAlpha (Number) fill alpha transparency [default: 100]
	 * @param strokeWeight (Number) border line width, if undefined no border will be drawn
	 * @param strokeColor (Number) hex border color 
	 * @param strokeAlpha (Number) stroke alpha transparancy [default: 100]
	 * @return Void
	 * {@code Usage:
	 * 	var box:MovieClip = this.createEmptyMovieClip ("box", this.getNextHighestDepth ());
	 * 	RoundRectangle.draw(rbox, new Point(150, 150), new Point(250, 250), 12, 0xff00ff, 100, 1, 0x00fffff, 100);
	 * }
	 */
	public static function draw(mc:MovieClip, topLeft:Point, bottomRight:Point, cornerRadius:Number, fillColor:Number, fillAlpha:Number, strokeWeight:Number, strokeColor:Number, strokeAlpha:Number):Void {
		var sw:Number = (!strokeWeight) ? undefined : strokeWeight;
		var sc:Number = (isNaN( strokeColor )) ? 0x000000 : strokeColor;
		var sa:Number = (isNaN( strokeAlpha )) ? 100 : strokeAlpha;
		var fa:Number = (isNaN( fillAlpha )) ? 100 : fillAlpha;

		var x:Number = topLeft.x;
		var y:Number = topLeft.y;
		var w:Number = bottomRight.x - topLeft.x;
		var h:Number = bottomRight.y - topLeft.y;

		var theta:Number = Math.PI / 4;  
		// 45 degrees in radians
		var angle:Number = -Math.PI / 2; 
		// 90 degrees in radians
		
		// w + h are larger than 2*cornerRadius
		cornerRadius = (cornerRadius > Math.min( w, h ) / 2) ? cornerRadius = Math.min( w, h ) / 2 : cornerRadius;
		
		mc.clear( );
		mc.lineStyle( sw, sc, sa, true, "none", "round", "round", 8 );
		if (!isNaN( fillColor )) {
			mc.beginFill( fillColor, fa );
		}

		// draw top line
		mc.moveTo( x + cornerRadius, y );
		mc.lineTo( x + w - cornerRadius, y );
		
		for(var i:Number = 0; i < 8 ; i++) {
			var calcul:Number, cx:Number, cy:Number, px:Number, py:Number;
			
			calcul = Math.cos( angle + (theta / 2) ) * cornerRadius / Math.cos( theta / 2 );
			cx = (i == 0 || i == 1 || i == 2 || i == 3) ? x + w - cornerRadius + calcul : x + cornerRadius + calcul;
			
			calcul = Math.sin( angle + (theta / 2) ) * cornerRadius / Math.cos( theta / 2 );
			cy = (i == 0 || i == 1 || i == 6 || i == 7) ? y + cornerRadius + calcul : y + h - cornerRadius + calcul;
			
			calcul = Math.cos( angle + theta ) * cornerRadius;
			px = (i == 0 || i == 1 || i == 2 || i == 3) ? x + w - cornerRadius + calcul : x + cornerRadius + calcul;
			
			calcul = Math.sin( angle + theta ) * cornerRadius;
			py = (i == 0 || i == 1 || i == 6 || i == 7) ? y + cornerRadius + calcul : y + h - cornerRadius + calcul;
			
			mc.curveTo( cx, cy, px, py );
			
			//straight lines
			if(i == 1) mc.lineTo( x + w, y + h - cornerRadius );
			if(i == 3) mc.lineTo( x + cornerRadius, y + h );
			if(i == 5) mc.lineTo( x, y + cornerRadius );
			
			angle += theta;
		}
		if (!isNaN( fillColor )) {
			mc.endFill( );
		}
	}

	private function RoundRectangle() {
	}
}