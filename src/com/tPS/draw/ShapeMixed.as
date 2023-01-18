import com.tPS.draw.Shape;
import com.tPS.draw.Point;

/**
 * @author tPS
 */
class com.tPS.draw.ShapeMixed extends Shape {
	
	function ShapeMixed($rt : MovieClip, $points : Array, $fs : Object, $ls : Object) {
		super($rt, $points, $fs, $ls);
	}
	
	public function render() : Void {
		_rt.clear();
				
		_rt.lineStyle(lineStyle.thickness,lineStyle.rgb,lineStyle.alpha,lineStyle.pixelHinting,lineStyle.noScale,lineStyle.capsStyle,lineStyle.jointStyle,lineStyle.miterLimit);
		_rt.beginFill(fillStyle.col,fillStyle.alpha);

		trace("[	new Vertex3D(" + points[0][0].x + ", 0, " + points[0][0].y + "),");

		_rt.moveTo(points[0][0].x,points[0][0].y);
		var i:Number = 0;
		var m:Number = points.length;
		var center:Point;
		
		while(++i < m){			
			if(points[i][1]){
				center = points[i][0];
			}else{
				/**
				 * CURVE	CURVE	CURVE	CURVE	CURVE	CURVE	
				 * CURVE	CURVE	CURVE	CURVE	CURVE	CURVE	
				 * CURVE	CURVE	CURVE	CURVE	CURVE	CURVE	
				 */
				if(center != null){
					
					//determine direction
					var ep:Point = points[i][0];
					var sp:Point = points[i-2][0];
					
					var sa:Number = Math.atan2(sp.y - center.y, sp.x - center.x);
					var ea:Number = Math.atan2(ep.y - center.y, ep.x - center.x);
					var radius:Number = Math.abs(ep.x-sp.x);	
					// Init vars
					var segAngle:Number;
					var theta:Number;
					var angle:Number;
					var angleMid:Number;
					var segs:Number;
					var bx:Number;
					var by:Number;
					var cx:Number;
					var cy:Number;
					
					var arc:Number = Math.abs(ea) - Math.abs(sa);
									
					segs = 2;
					// The math requires radians rather than degrees. To convert from degrees
					// use the formula (degrees/180)*Math.PI to get radians.
					theta = (45/180)*Math.PI;
					// convert angle startAngle to radians
					angle = sa;
					// draw the curve in segments no larger than 45 degrees.
					if (segs>0) {
						// Loop for drawing curve segments
						var t:Number = -1;
						while(++t < segs){
							angle += theta;
							angleMid = angle-(theta/2);
							bx = center.x+Math.cos(angle)*radius;
							by = center.y+Math.sin(angle)*radius;
							cx = center.x+Math.cos(angleMid)*(radius/Math.cos(theta/2));
							cy = center.y+Math.sin(angleMid)*(radius/Math.cos(theta/2));
							trace("	new ControlVertex3D(" + bx + ", 0, " + by + "),");
							trace("	new Vertex3D(" + cx + ", 0, " + cy + "),");
							_rt.curveTo(cx, cy, bx, by);
						}	
					}	
					center = null;					
				/**
				 * LINE		LINE		LINE		LINE		LINE		LINE		
				 * LINE		LINE		LINE		LINE		LINE		LINE		
				 * LINE		LINE		LINE		LINE		LINE		LINE		
				 */
				}else{
					trace("	new Vertex3D(" + points[i][0].x + ", 0, " + points[i][0].y + "),");
					_rt.lineTo(points[i][0].x, points[i][0].y);
					center = null;
				}
			}
		}				
		_rt.endFill();
		trace("];");
	}
	
	public function toString() : String {
		return "[ShapeMixed]";
	}

}