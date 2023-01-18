
/**
* Patrick Mineault's Cubic Bezier drawing and interpolation code
* 
* This is a copy of Patrick Mineault's Interpolate class and CubicBezier combined,
* but without the dependency on his interpolation point movie clip class.
* 
* The interpolate functions just take an array of flash.geom.Point objects, 
* and return a bigger array of point objects that can be used to draw a smooth curve 
* using the drawBeziers function.
* 
* @author Patrick Mineault
* @author David Knape
*/
class com.bumpslide.util.CubicBezier {

	
	/**
	 * Interpolate a bunch of points using several cubic beziers
	 * 
	 * @author Patrick Mineault
	 */
	static function interpolatePiecewise(points:Array, overshoot:Number):Array
	{
		//Interpolate the points to create a smooth curve
		//for every point which is not the start or end point
		//first look at the slope between the next and previous points
		//Then place the handles at 1/3 the way from the point in the direction of the slope
		var intPoints:Array = [];
		intPoints.push({x:points[0].x, y:points[0].y});
		
		var slopeX = points[1].x - points[0].x;
		var slopeY = points[1].y - points[0].y;
		
		var offsetX = slopeX/3;
		var offsetY = slopeY/3;
		
		intPoints.push({x:points[0].x + offsetX, y:points[0].y + offsetY});
		
		for(var i = 1; i < points.length - 1; i++)
		{
			var point1 = points[i - 1];
			var point2 = points[i];
			var point3 = points[i + 1];
			
			slopeX = point3.x - point1.x;
			slopeY = point3.y - point1.y;
			
			var dist = Math.sqrt(slopeX*slopeX + slopeY*slopeY);
			
			var dist1 = 
					   Math.sqrt(
						Math.pow(point2.x - point1.x, 2) + 
					    Math.pow(point2.y - point1.y, 2)
					   );
			var dist2 = Math.sqrt(
						Math.pow(point2.x - point3.x, 2) + 
					    Math.pow(point2.y - point3.y, 2)
					   );
			
			var ang = Math.atan2(slopeY, slopeX);
			var ang1 = Math.atan2(point2.y - point1.y, point2.x - point1.x);
			var ang2 = Math.atan2(point2.y - point3.y, point2.x - point3.x);
			
			dist1 *= Math.abs(Math.cos(ang1 - ang));
			dist2 *= Math.abs(Math.cos(ang2 - ang));
			
			var cosAng = slopeX/dist;
			var sinAng = slopeY/dist;
			
			var offsetX1 = dist1*cosAng/3;
			var offsetY1 = dist1*sinAng/3;
			
			var offsetX2 = dist2*cosAng/3;
			var offsetY2 = dist2*sinAng/3;
			
			var offset1 = Math.sqrt(offsetX1*offsetX1 + offsetY1*offsetY1); 
			var offset2 = Math.sqrt(offsetX2*offsetX2 + offsetY2*offsetY2);
			
			offsetX1 *= Math.max(offset1, overshoot)/offset1; 
			offsetY1 *= Math.max(offset1, overshoot)/offset1; 

			offsetX2 *= Math.max(offset2, overshoot)/offset2; 
			offsetY2 *= Math.max(offset2, overshoot)/offset2;
			
			intPoints.push({x:point2.x - offsetX1, y:point2.y - offsetY1}); 
			intPoints.push({x:point2.x, y:point2.y}); 
			intPoints.push({x:point2.x + offsetX2, y:point2.y + offsetY2});
		}
		
		slopeY = points[points.length - 1].y - points[points.length - 2].y;
		slopeX = points[points.length - 1].x - points[points.length - 2].x;
		
		offsetX = slopeX/3;
		offsetY = slopeY/3;
		
		intPoints.push({x:points[points.length - 1].x - offsetX, y:points[points.length - 1].y - offsetY});
		intPoints.push({x:points[points.length - 1].x, y:points[points.length - 1].y});
		
		return intPoints;
	}
	
	/**
	 * Interpolate a bunch of points using several cubic beziers, given that 
	 * all the points are roughly equidistant from the next
	 */
	static function interpolatePiecewiseSymmetric(points):Array
	{
		//Interpolate the points to create a smooth curve
		//for every point which is not the start or end point
		//first look at the slope between the next and previous points
		//Then place the handles at 1/3 the way from the point in the direction of the slope
		var intPoints:Array = [];
		intPoints.push({x:points[0].x, y:points[0].y});
		
		var slopeX = points[1].x - points[0].x;
		var slopeY = points[1].y - points[0].y;
		
		var offsetX = slopeX/3;
		var offsetY = slopeY/3;
		
		intPoints.push({x:points[0].x + offsetX, y:points[0].y + offsetY});
		
		for(var i = 1; i < points.length - 1; i++)
		{
			var point1 = points[i - 1];
			var point2 = points[i];
			var point3 = points[i + 1];
			
			slopeX = point3.x - point1.x;
			slopeY = point3.y - point1.y;
			
			var dist = Math.sqrt(slopeX*slopeX + slopeY*slopeY);
			
			var dist1 = Math.sqrt(
						Math.pow(point2.x - point1.x, 2) + 
					    Math.pow(point2.y - point1.y, 2)
					   );
//			var dist2 = Math.sqrt(
//						Math.pow(point2.x - point3.x, 2) + 
//					    Math.pow(point2.y - point3.y, 2)
//					   );
			
			var ang = Math.atan2(slopeY, slopeX);
			var ang1 = Math.atan2(point2.y - point1.y, point2.x - point1.x);
//			var ang2 = Math.atan2(point3.y - point2.y, point3.x - point2.x);
			
			dist1 *= Math.cos(ang1 - ang);
//			dist2 *= Math.cos(ang2 - ang);
			
			var cosAng = slopeX/dist;
			var sinAng = slopeY/dist;
			
			var offsetX1 = dist1*cosAng/3;
			var offsetY1 = dist1*sinAng/3;
			
//			var offsetX2 = dist2*cosAng/3;
//			var offsetY2 = dist2*sinAng/3;
			
			intPoints.push({x:point2.x - offsetX1, y:point2.y - offsetY1}); 
			intPoints.push({x:point2.x, y:point2.y}); 
			intPoints.push({x:point2.x + offsetX1, y:point2.y + offsetY1});
		}
		
		
		//intPoints.push({x:points[0].x, y:points[0].y});
		
		slopeY = points[points.length - 1].y - points[points.length - 2].y;
		slopeX = points[points.length - 1].x - points[points.length - 2].x;
		
		offsetX = slopeX/3;
		offsetY = slopeY/3;
		
		intPoints.push({x:points[points.length - 1].x - offsetX, y:points[points.length - 1].y - offsetY});
		intPoints.push({x:points[points.length - 1].x, y:points[points.length - 1].y});
		
		return intPoints;
	}
	
	
	
	static function drawBeziers(mc, intPoints)
	{
		for(var j = 0; j < (intPoints.length - 1)/3; j++)
		{
			drawBezierMidpoint(mc, intPoints[3*j],intPoints[3*j+1],intPoints[3*j+2],intPoints[3*j+3]); 
		}
	}
	
	/**
	 * Taken from http://www.timotheegroleau.com/Flash/articles/cubic_bezier_in_flash.htm
	 * By Timothee Groleau, with much respect
	 */
	static function drawBezierMidpoint(mc, P0, P1, P2, P3)
	{
		// calculates the useful base points
		var PA = getPointOnSegment(P0, P1, 3/4);
		var PB = getPointOnSegment(P3, P2, 3/4);
		
		// get 1/16 of the [P3, P0] segment
		var dx = (P3.x - P0.x)/16;
		var dy = (P3.y - P0.y)/16;
		
		// calculates control point 1
		var Pc_1 = getPointOnSegment(P0, P1, 3/8);
		
		// calculates control point 2
		var Pc_2 = getPointOnSegment(PA, PB, 3/8);
		Pc_2.x -= dx;
		Pc_2.y -= dy;
		
		// calculates control point 3
		var Pc_3 = getPointOnSegment(PB, PA, 3/8);
		Pc_3.x += dx;
		Pc_3.y += dy;
		
		// calculates control point 4
		var Pc_4 = getPointOnSegment(P3, P2, 3/8);
		
		// calculates the 3 anchor points
		var Pa_1 = getMiddle(Pc_1, Pc_2);
		var Pa_2 = getMiddle(PA, PB);
		var Pa_3 = getMiddle(Pc_3, Pc_4);
	
		// draw the four quadratic subsegments
		mc.curveTo(Pc_1.x, Pc_1.y, Pa_1.x, Pa_1.y);
		mc.curveTo(Pc_2.x, Pc_2.y, Pa_2.x, Pa_2.y);
		mc.curveTo(Pc_3.x, Pc_3.y, Pa_3.x, Pa_3.y);
		mc.curveTo(Pc_4.x, Pc_4.y, P3.x, P3.y);
	}
	
	static function getPointOnSegment(P0, P1, ratio)
	{
		return {x: (P0.x + ((P1.x - P0.x) * ratio)), y: (P0.y + ((P1.y - P0.y) * ratio))};
	}
	
	static function getMiddle(P0, P1)
	{
		return {x: ((P0.x + P1.x) / 2), y: ((P0.y + P1.y) / 2)};
	}
}