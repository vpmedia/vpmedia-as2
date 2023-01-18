/**
 * com.sekati.draw.Ring
 * @version 1.0.5
 * @author jason m horwitz | sekati.com
 * Copyright (C) 2007  jason m horwitz, Sekat LLC. All Rights Reserved.
 * Released under the MIT License: http://www.opensource.org/licenses/mit-license.php
 */

import com.sekati.geom.Point;

/**
 * Ring drawing utility.
 */
class com.sekati.draw.Ring {

	/**
	 * Draw a Ring in an existing clip.
	 * @param mc (Movie	Clip) target clip to draw in
	 * @param p (Point) center point
	 * @param outerRadius (Number) radius of outer circle
	 * @param innerRadius (Number) radius of inner (cut out) circle
	 * @param fillColor (Number) hex fill [default: 0x000000]
	 * @param fillAlpha (Number) fill alpha transparency [default: 100]
	 * @return Void
	 */
	public static function draw(mc:MovieClip, p:Point, outerRadius:Number, innerRadius:Number, fillColor:Number, fillAlpha:Number):Void {
		var fc:Number = (!fillColor) ? 0x000000 : fillColor;		
		var fa:Number = (isNaN( fillAlpha )) ? 100 : fillAlpha;
		var x:Number = p.x;
		var y:Number = p.y;
		var r1:Number = outerRadius;
		var r2:Number = innerRadius;
		var _rad:Number = Math.PI / 180;
		
		mc.clear( );
		mc.beginFill( fc, fa );
		
		mc.moveTo( 0, 0 );
		mc.lineTo( r1, 0 );

		// draw the 30-degree segments
		var a:Number = 0.268;  
		// tan(15)
		var endx:Number;
		var endy:Number;
		var ax:Number;
		var ay:Number;
		for (var i:Number = 0; i < 12 ; i++) {
			endx = r1 * Math.cos( (i + 1) * 30 * _rad );
			endy = r1 * Math.sin( (i + 1) * 30 * _rad );
			ax = endx + r1 * a * Math.cos( ((i + 1) * 30 - 90) * _rad );
			ay = endy + r1 * a * Math.sin( ((i + 1) * 30 - 90) * _rad );
			mc.curveTo( ax, ay, endx, endy );   
		}		
		
		// cut out middle (go in reverse)
		mc.moveTo( 0, 0 );
		mc.lineTo( r2, 0 );		

		for (var j:Number = 12; j > 0 ; j--) {
			endx = r2 * Math.cos( (j - 1) * 30 * _rad );
			endy = r2 * Math.sin( (j - 1) * 30 * _rad );
			ax = endx + r2 * (0 - a) * Math.cos( ((j - 1) * 30 - 90) * _rad );
			ay = endy + r2 * (0 - a) * Math.sin( ((j - 1) * 30 - 90) * _rad );
			mc.curveTo( ax, ay, endx, endy );   
		}
		mc.endFill( );		
		mc._x = x;
		mc._y = y;		
	}	

	private function Ring() {
	}
}