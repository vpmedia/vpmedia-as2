import am.geom.*;

class am.geom.Circle extends Point
{
	var radius: Number;

	function Circle ( x: Number, y: Number, radius: Number )
	{
		this.x = x;
		this.y = y;
		this.radius = radius;
	}

	function draw( mc: MovieClip ):Void
	{
		var segAngle, theta, angle, angleMid, segs, ax, ay, bx, by, cx, cy;
		var arc = Math.PI*2;
		segs = Math.ceil(Math.abs(arc)/(Math.PI/4));
		segAngle = arc/segs;
		theta = segAngle;
		angle = 0;
		ax = x + Math.cos( angle ) * radius;
		ay = y + Math.sin( angle ) * radius;
		mc.moveTo ( ax ,ay )
		if ( segs > 0 )
		{
			for (var i = 0; i<segs; i++)
			{
				angle += theta;
				angleMid = angle-(theta/2);
				bx = x+Math.cos(angle)*radius;
				by = y+Math.sin(angle)*radius;
				cx = x+Math.cos(angleMid)*(radius/Math.cos(theta/2));
				cy = y+Math.sin(angleMid)*(radius/Math.cos(theta/2));
				mc.curveTo(cx, cy, bx, by);
			}
		}
	}
	function toString(): String
	{
		return "[class 'Circle' x: " + x + " y: " + y + " radius: " + radius + " ]";
	}
}