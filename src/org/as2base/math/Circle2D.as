import org.as2base.math.*;

class org.as2base.math.Circle2D extends Point2D
{
	var r: Number;
	
	function Circle2D( x: Number, y: Number, r: Number )
	{
		super( x , y );
		
		this.r = r || 0;
	}
	
	function draw( mc: MovieClip ):Void
	{
		var segAngle, theta, angle, angleMid, segs, ax, ay, bx, by, cx, cy;
		var arc = Math.PI*2;
		segs = Math.ceil(Math.abs(arc)/(Math.PI/4));
		segAngle = arc/segs;
		theta = segAngle;
		angle = 0;
		ax = x + Math.cos( angle ) * r;
		ay = y + Math.sin( angle ) * r;
		mc.moveTo ( ax ,ay )
		if ( segs > 0 )
		{
			for (var i = 0; i<segs; i++)
			{
				angle += theta;
				angleMid = angle-(theta/2);
				
				mc.curveTo(
				
					x + Math.cos( angleMid ) * ( r / Math.cos( theta / 2 ) ),
					y + Math.sin( angleMid ) * ( r / Math.cos( theta / 2 ) ),
					x+Math.cos(angle)*r,
					y+Math.sin(angle)*r
				)
			}
		}
	}
	
	function toString( Void ): String
	{
		var rx: Number = Math.round ( x * 1000 ) / 1000;
		var ry: Number = Math.round ( y * 1000 ) / 1000;
		
		return '[Circle2D x: ' + rx + ' y: ' + ry + ' r: ' + r + ']';
	}
}